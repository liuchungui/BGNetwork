//
//  BGNetworkManager.m
//  BGNetwork
//
//  Created by user on 15/8/14.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "BGNetworkManager.h"
#import "BGUtilFunction.h"

static inline NSString *BGURLStringFromBaseURLAndMethod(NSURL *baseURL, NSString *methodName) {
    return [[NSURL URLWithString:methodName relativeToURL:baseURL] absoluteString];
}

static inline NSString *BGKeyFromRequestAndBaseURL(BGNetworkRequest *request, NSURL *baseURL) {
    return BGKeyFromParamsAndURLString(request.parametersDic, BGURLStringFromBaseURLAndMethod(baseURL, request.methodName));
}

static inline id BGParseJsonData(id jsonData){
    /**
     *  解析json对象
     */
    NSError *error;
    id jsonResult = nil;
    if([NSJSONSerialization isValidJSONObject:jsonData]){
        return jsonData;
    }
    //NSData
    if (jsonData && [jsonData isKindOfClass:[NSData class]]){
        jsonResult = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    }
    if (jsonResult != nil && error == nil){
        return jsonResult;
    }
    else{
        // 解析错误
        return nil;
    }
}

static BGNetworkManager *_manager = nil;
@interface BGNetworkManager ()<BGNetworkConnectorDelegate>
@property (nonatomic, strong) BGNetworkConnector *connector;
@property (nonatomic, strong) BGNetworkCache *cache;
@property (nonatomic, strong) dispatch_queue_t workQueue;
@property (nonatomic, strong) dispatch_queue_t dataHandleQueue;
/**
 *  临时储存请求的字典
 */
@property (nonatomic, strong) NSMutableDictionary *tempRequestDic;
/**
 *  下载任务的字典
 */
@property (nonatomic, strong) NSMutableDictionary *tempDownloadTaskDic;
/**
 *  网络配置
 */
@property (nonatomic, strong) BGNetworkConfiguration *configuration;
@property (nonatomic, strong) NSURL *baseURL;
@end

@implementation BGNetworkManager
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[BGNetworkManager alloc] init];
    });
    return _manager;
}

- (instancetype)init{
    if(self = [super init]){
        //缓存
        _cache = [BGNetworkCache sharedCache];
        
        //工作队列
        _workQueue = dispatch_queue_create("com.BGNetworkManager.workQueue", DISPATCH_QUEUE_SERIAL);
        
        //数据处理队列
        _dataHandleQueue = dispatch_queue_create("com.BGNEtworkManager.dataHandle", DISPATCH_QUEUE_CONCURRENT);
        
        dispatch_async(_workQueue, ^{
            self.tempRequestDic = [NSMutableDictionary dictionary];
            self.tempDownloadTaskDic = [NSMutableDictionary dictionary];
        });
    }
    return self;
}


#pragma makr - download request
- (void)sendDownloadRequest:(BGDownloadRequest *)request
                   progress:(void (^)(NSProgress * _Nonnull))downloadProgressBlock
                    success:(void (^)(BGDownloadRequest * _Nonnull, NSURL * _Nullable))successCompletionBlock
                    failure:(void (^)(BGDownloadRequest * _Nonnull, NSError * _Nullable))failureCompletionBlock {
    dispatch_async(self.workQueue, ^{
        NSString *requestURLString = [[NSURL URLWithString:request.methodName relativeToURL:self.baseURL] absoluteString];
        NSString *pathExtension = [request.methodName pathExtension];
        NSString *cacheKey = BGKeyFromParamsAndURLString(request.parametersDic, BGURLStringFromBaseURLAndMethod(self.baseURL, request.methodName));
        NSString *fileName = [cacheKey stringByAppendingPathExtension:pathExtension];
        [self.cache queryDiskCacheForFileName:fileName completion:^(id  _Nullable object) {
            dispatch_async(self.workQueue, ^{
                //有缓存，则直接返回
                if([object isKindOfClass:[NSData class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSURL *filePath = [NSURL fileURLWithPath:[self.cache defaultCachePathForFileName:fileName]];
                        //保存文件
                        if(successCompletionBlock) {
                            successCompletionBlock(request, filePath);
                        }
                    });
                }
                else {
                    [self downloadDataWithRequest:request requestURL:requestURLString fileName:fileName progress:downloadProgressBlock success:successCompletionBlock failure:failureCompletionBlock];
                }
            });
        }];
    });
}

- (void)downloadDataWithRequest:(BGDownloadRequest *)request
                     requestURL:(NSString *)requestURLString
                       fileName:(NSString *)fileName
                       progress:(void (^)(NSProgress * _Nonnull))downloadProgressBlock
                        success:(void (^)(BGDownloadRequest * _Nonnull, NSURL * _Nullable))successCompletionBlock
                        failure:(void (^)(BGDownloadRequest * _Nonnull, NSError * _Nullable))failureCompletionBlock {
    
    NSString *resumeDataFileName = [NSString stringWithFormat:@"%@_resume", fileName];
    [self.cache queryDiskCacheForFileName:resumeDataFileName completion:^(id  _Nullable object) {
        //有数据，断点续传
        if([object isKindOfClass:[NSData class]]) {
            NSURLSessionDownloadTask *task = [self.connector downloadTaskWithResumeData:object progress:downloadProgressBlock destination:^NSURL * _Nullable(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                return [NSURL fileURLWithPath:[self.cache defaultCachePathForFileName:fileName]];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                [self downloadResultWithRequest:request filePath:filePath error:error success:successCompletionBlock failure:failureCompletionBlock];
            }];
            //save
            self.tempDownloadTaskDic[requestURLString] = task;
        }
        else {
            //无缓存，则重新下载
            NSMutableURLRequest *httpRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestURLString]];
            NSURLSessionDownloadTask *task = [self.connector downloadTaskWithRequest:httpRequest progress:downloadProgressBlock destination:^NSURL * _Nullable(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//                return [NSURL fileURLWithPath:[self.cache defaultCachePathForFileName:fileName]];
                return targetPath;
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                [self downloadResultWithRequest:request filePath:filePath error:error success:successCompletionBlock failure:failureCompletionBlock];
            }];
            //save
            self.tempDownloadTaskDic[requestURLString] = task;
        }
    }];
}

- (void)downloadResultWithRequest:(BGDownloadRequest *)request
                         filePath:(NSURL *)filePath
                            error:(NSError *)error
                          success:(void (^)(BGDownloadRequest * _Nonnull, NSURL * _Nullable))successCompletionBlock
                          failure:(void (^)(BGDownloadRequest * _Nonnull, NSError * _Nullable))failureCompletionBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(error) {
            if(failureCompletionBlock) {
                failureCompletionBlock(request, error);
            }
        }
        else {
            if(successCompletionBlock) {
                successCompletionBlock(request, filePath);
            }
        }
    });
}



#pragma mark - upload request
- (void)sendUploadRequest:(BGUploadRequest *)request
                 progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                  success:(BGSuccessCompletionBlock)successCompletionBlock
          businessFailure:(BGBusinessFailureBlock)businessFailureBlock
           networkFailure:(BGNetworkFailureBlock)networkFailureBlock {
    dispatch_async(self.workQueue, ^{
        [self.connector POST:request.methodName parameters:request.parametersDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:request.fileData name:request.uploadKey fileName:request.fileName mimeType:request.mimeType];
        } progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            dispatch_async(self.workQueue, ^{
                [self networkSuccess:request task:task responseData:responseObject success:successCompletionBlock businessFailure:businessFailureBlock];
            });
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nullable error) {
            dispatch_async(self.workQueue, ^{
                [self networkFailure:request error:error completion:networkFailureBlock];
            });
        }];
    });
}

- (void)sendRequest:(BGNetworkRequest *)request
            success:(BGSuccessCompletionBlock)successCompletionBlock
    businessFailure:(BGBusinessFailureBlock)businessFailureBlock
     networkFailure:(BGNetworkFailureBlock)networkFailureBlock {
    NSParameterAssert(self.connector);
    dispatch_async(self.workQueue, ^{
        //发送网络之前，先进行一下预处理
        [self.configuration preProcessingRequest:request];
        
        switch (request.cachePolicy) {
            case BGNetworkRquestCacheNone:
                //请求网络数据
                [self loadNetworkDataWithRequest:request success:successCompletionBlock businessFailure:businessFailureBlock networkFailure:networkFailureBlock];
                break;
            case BGNetworkRequestCacheDataAndReadCacheOnly:
            case BGNetworkRequestCacheDataAndReadCacheLoadData:
                //读取缓存并且请求数据
                [self readCacheWithRequest:request completion:^(BGNetworkRequest *request, id responseObject) {
                    if(responseObject){
                        /*
                         缓存策略
                         BGNetworkRequestCacheDataAndReadCacheOnly：获取缓存数据直接调回，不再请求
                         BGNetworkRequestCacheDataAndReadCacheLoadData：缓存数据成功调回并且重新请求网络
                         */
                        [self success:request responseObject:responseObject completion:successCompletionBlock];
                        
                        if(request.cachePolicy == BGNetworkRequestCacheDataAndReadCacheLoadData){
                            [self loadNetworkDataWithRequest:request success:successCompletionBlock businessFailure:businessFailureBlock networkFailure:networkFailureBlock];
                        }
                    }
                    else{
                        //无缓存数据，则还需要再请求网络
                        [self loadNetworkDataWithRequest:request success:successCompletionBlock businessFailure:businessFailureBlock networkFailure:networkFailureBlock];
                    }
                }];
        }
    });
}

- (void)loadNetworkDataWithRequest:(BGNetworkRequest *)request
                           success:(BGSuccessCompletionBlock)successCompletionBlock
                   businessFailure:(BGBusinessFailureBlock)businessFailureBlock
                    networkFailure:(BGNetworkFailureBlock)networkFailureBlock{
    //临时保存请求
    NSString *requestKey = [[NSURL URLWithString:request.methodName relativeToURL:self.baseURL] absoluteString];
    self.tempRequestDic[requestKey] = request;
    
    //发送请求
    __weak BGNetworkManager *weakManager = self;
    switch (request.httpMethod) {
        case BGNetworkRequestHTTPGet:{
            [self.connector sendGETRequest:request.methodName parameters:request.parametersDic success:^(NSURLSessionDataTask *task, NSData *responseData) {
                [weakManager networkSuccess:request task:task responseData:responseData success:successCompletionBlock businessFailure:businessFailureBlock];
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [weakManager networkFailure:request error:error completion:networkFailureBlock];
            }];
        }
            break;
        case BGNetworkRequestHTTPPost:{
            [self.connector sendPOSTRequest:request.methodName parameters:request.parametersDic success:^(NSURLSessionDataTask *task, NSData *responseData) {
                [weakManager networkSuccess:request task:task responseData:responseData success:successCompletionBlock businessFailure:businessFailureBlock];
            } failed:^(NSURLSessionDataTask *task, NSError *error) {
                [weakManager networkFailure:request error:error completion:networkFailureBlock];
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - cache method
- (void)readCacheWithRequest:(BGNetworkRequest *)request completion:(void (^)(BGNetworkRequest *request, id responseObject))completionBlock{
    __weak BGNetworkManager *weakManager = self;
    NSString *cacheKey = BGKeyFromRequestAndBaseURL(request, self.baseURL);
    [self.cache queryCacheForKey:cacheKey completion:^(NSData *data) {
        dispatch_async(weakManager.dataHandleQueue, ^{
            //解析数据
            id responseObject = BGParseJsonData(data);
            dispatch_async(weakManager.workQueue, ^{
                if(completionBlock) {
                    completionBlock(request, responseObject);
                }
            });
        });
    }];
}

- (void)cacheResponseData:(NSData *)responseData request:(BGNetworkRequest *)request{
    //缓存数据
    [self.cache storeData:responseData forKey:BGKeyFromRequestAndBaseURL(request, self.baseURL)];
}

#pragma mark - set method
- (void)setNetworkConfiguration:(BGNetworkConfiguration *)configuration{
    NSParameterAssert(configuration);
    NSParameterAssert(configuration.baseURLString);
    self.connector = [[BGNetworkConnector alloc] initWithBaseURL:configuration.baseURLString delegate:self];
    self.baseURL = [NSURL URLWithString:configuration.baseURLString];
    _configuration = configuration;
}

#pragma mark - 网络请求回来调用的方法
- (void)networkSuccess:(BGNetworkRequest *)request
                  task:(NSURLSessionDataTask *)task
          responseData:(NSData *)responseData
               success:(BGSuccessCompletionBlock)successCompletionBlock
       businessFailure:(BGBusinessFailureBlock)businessFailureBlock{
    //remove temp request
    [self removeTempRequest:request];
    
    dispatch_async(self.dataHandleQueue, ^{
        //对数据进行解密
        NSData *decryptData = [self.configuration decryptResponseData:responseData response:task.response request:request];
        //解析数据
        id responseObject = BGParseJsonData(decryptData);
        dispatch_async(self.workQueue, ^{
            if(responseObject && [self.configuration shouldBusinessSuccessWithResponseData:responseObject task:task request:request]) {
                if([self.configuration shouldCacheResponseData:responseObject task:task request:request]) {
                    //缓存解密之后的数据
                    [self cacheResponseData:decryptData request:request];
                }
                //成功回调
                [self success:request responseObject:responseObject completion:successCompletionBlock];
            }
            else {
                [self businessFailure:request response:responseObject completion:businessFailureBlock];
            }
        });
    });
    
}

- (void)success:(BGNetworkRequest *)request
 responseObject:(id)responseObject
     completion:(BGSuccessCompletionBlock)successCompletionBlock{
    dispatch_async(self.dataHandleQueue, ^{
        id resultObject = nil;
        @try {
            //调用request方法中的数据处理，将数据处理成想要的model
            resultObject = [request processResponseObject:responseObject];
        }
        @catch (NSException *exception) {
            //崩溃则删除对应的缓存数据
            [self.cache removeCacheForKey:BGKeyFromRequestAndBaseURL(request, self.baseURL)];
        }
        @finally {
        }
        //成功回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if(successCompletionBlock) {
                successCompletionBlock(request, resultObject);
            }
        });
    });
}

/**
 *  网络成功，业务失败
 */
- (void)businessFailure:(BGNetworkRequest *)request response:(id)response completion:(BGNetworkFailureBlock)businessFailureBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(businessFailureBlock) {
            businessFailureBlock(request, response);
        }
    });
}

/**
 *  网络失败
 */
- (void)networkFailure:(BGNetworkRequest *)request error:(NSError *)error completion:(BGNetworkFailureBlock)networkFailureBlock{
    //remove temp request
    [self removeTempRequest:request];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(networkFailureBlock) {
            networkFailureBlock(request, error);
        }
    });
}

#pragma mark - private method
/**
 *  删除临时存储的请求
 */
- (void)removeTempRequest:(BGNetworkRequest *)request {
    dispatch_async(self.workQueue, ^{
        NSString *requestKey = [[NSURL URLWithString:request.methodName relativeToURL:self.baseURL] absoluteString];
        [self.tempRequestDic removeObjectForKey:requestKey];
    });
}

#pragma mark - cancel request
- (void)cancelRequestWithUrl:(NSString *)url{
    [self.connector cancelRequest:url];
}

- (void)cancelDownloadRequest:(BGDownloadRequest *)request {
    dispatch_async(self.workQueue, ^{
        NSString *requestURLString = [[NSURL URLWithString:request.methodName relativeToURL:self.baseURL] absoluteString];
        NSURLSessionDownloadTask *task = self.tempDownloadTaskDic[requestURLString];
        [task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            NSString *pathExtension = [request.methodName pathExtension];
            NSString *cacheKey = BGKeyFromParamsAndURLString(request.parametersDic, BGURLStringFromBaseURLAndMethod(self.baseURL, request.methodName));
            NSString *fileName = [cacheKey stringByAppendingPathExtension:pathExtension];
            NSString *resumeDataFile = [NSString stringWithFormat:@"%@_resume", fileName];
            //缓存，以用来断点续传
            [self.cache storeData:resumeData forFileName:resumeDataFile];
            //不保存
            self.tempDownloadTaskDic[requestURLString] = nil;
        }];
    });
    
}

#pragma mark - BGNetworkConnectorDelegate
- (NSDictionary *)allHTTPHeaderFieldsWithNetworkConnector:(BGNetworkConnector *)connector request:(NSURLRequest *)request{
    //取出请求
    BGNetworkRequest *networkRequest = self.tempRequestDic[request.URL.absoluteString];
    return [self.configuration requestHTTPHeaderFields:networkRequest];
}

- (NSString *)queryStringForURLWithNetworkConnector:(BGNetworkConnector *)connector parameters:(NSDictionary *)paramters request:(NSURLRequest *)request{
    //取出请求
    BGNetworkRequest *networkRequest = self.tempRequestDic[request.URL.absoluteString];
    return [self.configuration queryStringForURLWithRequest:networkRequest];
}

- (NSData *)dataOfHTTPBodyWithNetworkConnector:(BGNetworkConnector *)connector parameters:(NSDictionary *)paramters request:(NSURLRequest *)request error:(NSError *__autoreleasing *)error{
    BGNetworkRequest *networkRequest = self.tempRequestDic[request.URL.absoluteString];
    return [self.configuration httpBodyDataWithRequest:networkRequest];
}
@end
