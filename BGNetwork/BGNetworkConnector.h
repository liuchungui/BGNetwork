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

- (instancetype)initWithBaseURL:(NSString *)baseURL;
- (instancetype)initWithBaseURL:(NSString *)baseURL delegate:(id<BGNetworkConnectorDelegate>)delegate;


@property (nonatomic, weak, readonly) id<BGNetworkConnectorDelegate> delegate;

/**
 *  发送GET请求
 *
 *  @param methodName   请求方法名
 *  @param paramters    请求参数
 *  @param successBlock 请求成功调回
 *  @param failedBlock  请求失败调回
 */
- (NSURLSessionDataTask *)sendGETRequest:(NSString *)methodName parameters:(NSDictionary *)paramters success:(void (^)(NSURLSessionDataTask *task, NSData *responseData))successBlock failed:(void (^)(NSURLSessionDataTask *task, NSError *error))failedBlock;

/**
 *  发送POST请求
 *
 *  @param methodName   请求方法名
 *  @param paramters    请求参数
 *  @param successBlock 请求成功调回
 *  @param failedBlock  请求失败调回
 */
- (NSURLSessionDataTask *)sendPOSTRequest:(NSString *)methodName parameters:(NSDictionary *)paramters success:(void (^)(NSURLSessionDataTask *task, NSData *responseData))successBlock failed:(void (^)(NSURLSessionDataTask *task, NSError *error))failedBlock;


/**
 *  取消请求
 *
 *  @param url url
 */
- (void)cancelRequest:(NSString *)url;
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
- (NSDictionary *)allHTTPHeaderFieldsWithNetworkConnector:(BGNetworkConnector *)connector request:(NSURLRequest *)request;

/**
 *  代理方法获取请求url的queryString部分
 *
 *  @param connector 网络连接器
 *  @param paramters 参数字典
 *  @param request   请求
 *
 *  @return 返回url的queryString部分
 */
- (NSString *)queryStringForURLWithNetworkConnector:(BGNetworkConnector *)connector parameters:(NSDictionary *)paramters request:(NSURLRequest *)request;

/**
 *  代理方法获取请求体
 *
 *  @param connector 网络连接器
 *  @param paramters 参数字典
 *  @param request   请求
 *
 *  @return 返回请求体
 */
- (NSData *)dataOfHTTPBodyWithNetworkConnector:(BGNetworkConnector *)connector parameters:(NSDictionary *)paramters request:(NSURLRequest *)request error:(NSError *__autoreleasing *)error;
@end
