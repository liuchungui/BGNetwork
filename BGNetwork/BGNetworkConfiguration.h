//
//  BGNetworkConfiguration.h
//  BGNetwork
//
//  Created by user on 15/8/18.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGNetworkRequest.h"

@protocol BGNetworkConfiguration;

@protocol BGNetworkConfiguration <NSObject>

@required
/**
 *  基础地址字符串
 */
@property (nonatomic, strong, readonly) NSString *baseURLString;


@optional
/**
 *  对request当中的HTTP Header进行处理，可以在此方法内部加入公共的请求头内容
 *
 *  @param request 请求
 *
 *  @return 返回一个处理好的请求头给AF，默认加公共的Content-Type和User-Agent
 */
- (NSDictionary *)requestHTTPHeaderFields:(BGNetworkRequest *)request;

/**
 *  组装url的query部分，其中默认GET请求会将参数全部用&连接，但POST请求返回nil
 *
 *  @param request    请求，内部带有参数字典
 *
 *  @return 返回一个字符串
 */
- (NSString *)queryStringForURLWithRequest:(BGNetworkRequest *)request;

/**
 *  组装http请求体，默认GET请求返回nil,POST请求返回一个json对象
 *
 *  @param request    请求，内部带有参数字典
 *
 *  @return 返回一个NSData数据类型
 *
 *  @note 若是默认满足不了需求，请实现此方法；并且，若是需要加密，则可以在此请求当中处理
 */
- (NSData *)httpBodyDataWithRequest:(BGNetworkRequest *)request;

/**
 *  解密请求返回的数据，默认不解密，如果需要解密，实现此方法
 *
 *  @param responseData 返回的数据
 *  @param response     response
 *  @param request      请求
 *
 *  @return 解密后的数据
 */
- (NSData *)decryptResponseData:(NSData *)responseData response:(NSURLResponse *)response request:(BGNetworkRequest *)request;

/**
 *  是否应该缓存当前的数据，里面根据request.cachePolicy来进行判断。若是根据服务器返回的一个字段来判断是否应该返回数据，子类覆写此方法
 *
 *  @param responseData 请求到的数据，此数据已经经过json解析之后的数据
 *  @param task         task
 *  @param request      请求
 *
 *  @return 根据request.cachePolicy来判断
 *  @code
    if(request.cachePolicy == BGNetworkRequestCacheDataAndReadCacheOnly || request.cachePolicy == BGNetworkRequestCacheDataAndReadCacheLoadData) {
    return YES;
    }
    return NO;
 */
- (BOOL)shouldCacheResponseData:(id)responseData task:(NSURLSessionDataTask *)task request:(BGNetworkRequest *)request;

@end

/**
 *  网络配置，默认内部不进行加密解密，如果要加密解密，请子类化一个网络配置类，并且实现BGNetworkDataHandleProtocol协议 
 */
@interface BGNetworkConfiguration : NSObject<BGNetworkConfiguration>
+ (instancetype)configuration;
@end
