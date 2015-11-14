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
 *  由服务器返回的某种规则来确定此数据是否缓存，默认位YES
 *
 *  @param responseObject 请求到的数据
 *
 *  @return 默认返回YES
 *
 */
- (BOOL)isCacheResponseData:(id)responseObject response:(NSURLResponse *)response;

/**
 *  当网络成功请求到数据并且json解析化之后，可以定义一种规则来判断什么是成功。默认返回YES，即网络能通走成功。
 *
 *  @param responseObject json解析化之后的对象
 *  @param response       原始的response
 *
 *  @return 默认返回YES，
 */
- (BOOL)isSuccessWithResponseData:(id)responseObject response:(NSURLResponse *)response;

@end

/**
 *  网络配置，默认内部不进行加密解密，如果要加密解密，请子类化一个网络配置类，并且实现BGNetworkDataHandleProtocol协议 
 */
@interface BGNetworkConfiguration : NSObject<BGNetworkConfiguration>
+ (instancetype)configuration;
@end
