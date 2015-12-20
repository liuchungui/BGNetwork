//
//  BGNetworkConnector.h
//  BGNetwork
//
//  Created by user on 15/8/18.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGNetworkConfiguration.h"
#import "BGAFRequestSerializer.h"
#import "BGAFResponseSerializer.h"

@protocol BGNetworkConnectorDelegate;

/**
 *  网络连接者，主要跟第三方网络框架打交道
 */
@interface BGNetworkConnector : NSObject

- (instancetype _Nonnull)initWithBaseURL:(NSString * _Nonnull)baseURL;
- (instancetype _Nonnull)initWithBaseURL:(NSString * _Nonnull)baseURL delegate:(id<BGNetworkConnectorDelegate> _Nullable)delegate;


@property (nonatomic, weak, readonly) id<BGNetworkConnectorDelegate> delegate;

/**
 *  发送GET请求
 *
 *  @param methodName   请求方法名
 *  @param paramters    请求参数
 *  @param successBlock 请求成功调回
 *  @param failedBlock  请求失败调回
 */
- (NSURLSessionDataTask * _Nonnull)sendGETRequest:(NSString * _Nonnull)methodName parameters:(NSDictionary * _Nullable)paramters success:( void (^ _Nullable )(NSURLSessionDataTask  * _Nonnull task, NSData  * _Nonnull responseData))successBlock failed:( void (^ _Nullable )(NSURLSessionDataTask  * _Nonnull task, NSError  * _Nonnull error))failedBlock;

/**
 *  发送POST请求
 *
 *  @param methodName   请求方法名
 *  @param paramters    请求参数
 *  @param successBlock 请求成功调回
 *  @param failedBlock  请求失败调回
 */
- (NSURLSessionDataTask * _Nonnull)sendPOSTRequest:(NSString * _Nonnull)methodName parameters:(NSDictionary * _Nullable)paramters success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, NSData * _Nullable responseData))successBlock failed:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, NSError * _Nullable error))failedBlock;

/**
 *  下载
 */
- (NSURLSessionDownloadTask * _Nonnull)downloadTaskWithRequest:(NSURLRequest * _Nonnull)request
                                             progress:(nullable void (^)(NSProgress * _Nonnull downloadProgress)) downloadProgressBlock
                                          destination:(NSURL * _Nullable (^ _Nullable)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination
                                    completionHandler:(nullable void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

/**
 *  断点续传
 */
- (NSURLSessionDownloadTask * _Nonnull)downloadTaskWithResumeData:(NSData * _Nonnull)resumeData
                                                progress:(nullable void (^)(NSProgress * _Nonnull downloadProgress)) downloadProgressBlock
                                             destination:(NSURL * _Nullable (^ _Nullable)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination
                                       completionHandler:(nullable void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;


/**
 *  取消请求
 *
 *  @param url url
 */
- (void)cancelRequest:(NSString  * _Nonnull )url;
@end

@protocol BGNetworkConnectorDelegate <NSObject>
@required
/**
 *  代理方法获取请求的请求头
 *
 *  @param connector 网络连接器
 *  @param request   请求
 *
 *  @return 返回一个http请求头
 */
- (NSDictionary * _Nonnull)allHTTPHeaderFieldsWithNetworkConnector:(BGNetworkConnector * _Nonnull)connector request:(NSURLRequest * _Nonnull)request;

/**
 *  代理方法获取请求url的queryString部分
 *
 *  @param connector 网络连接器
 *  @param paramters 参数字典
 *  @param request   请求
 *
 *  @return 返回url的queryString部分
 */
- (NSString * _Nullable)queryStringForURLWithNetworkConnector:(BGNetworkConnector * _Nonnull)connector parameters:(NSDictionary * _Nullable)paramters request:(NSURLRequest * _Nonnull)request;

/**
 *  代理方法获取请求体
 *
 *  @param connector 网络连接器
 *  @param paramters 参数字典
 *  @param request   请求
 *
 *  @return 返回请求体
 */
- (NSData * _Nullable)dataOfHTTPBodyWithNetworkConnector:(BGNetworkConnector * _Nonnull)connector parameters:(NSDictionary * _Nullable)paramters request:(NSURLRequest * _Nonnull)request error:(NSError *  _Nullable __autoreleasing * _Nullable)error;
@end
