//
//  BGNetworkConfiguration.h
//  BGNetwork
//
//  Created by user on 15/8/18.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGNetworkRequest.h"

/**
 *  读取缓存策略
 */
typedef NS_ENUM(NSInteger, BGNetworkReadCachePolicy){
    /**
     *  缓存存在，则仅仅读取缓存，不再请求网络
     */
    BGNetworkReadCacheOnly,
    /**
     *  读取缓存的同时也请求网络
     */
    BGNetworkReadCacheAndLoadData,
};

/**
 *  写缓存策略
 */
typedef NS_ENUM(NSInteger, BGNetworkWriteCachePolicy){
    /**
     *  用新的数据覆盖老的数据
     */
    BGNetworkOverOldCacheData,
    /**
     *  忽略缓存，不做任何事情
     */
    BGNetworkIgnoreCache,
    /**
     *  清空老的数据，不写入新的数据
     */
    BGNetworkClenOldCacheData,
};

@protocol BGNetworkConfiguration;

@protocol BGNetworkConfiguration <NSObject>

@required
/**
 *  基础地址
 */
@property (nonatomic, strong, readonly) NSString *baseURL;


@optional
/**
 *  读取缓存的策略
 */
@property (nonatomic, assign, readonly) BGNetworkReadCachePolicy readCachePolicy;


/**
 *  返回公共的参数
 *
 *  @return 字典
 */
- (NSDictionary *)requestCommonParamters;

/**
 *  返回公共的请求头
 *
 *  @return 字典
 */
- (NSDictionary *)requestCommonHTTPHeaderFields;

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
 *  当请求需要缓存数据时，以何种策略缓存数据，是直接使用新数据覆盖老数据，还是忽略，什么都不做。此方法主要用来配合服务器做数据缓存。
 *
 *  @param responseObject 请求到的数据
 *
 *  @return 默认返回BGNetworkOverOldCacheData
 *
 */
- (BGNetworkWriteCachePolicy)cachePolicyFromResponseData:(id)responseObject response:(NSURLResponse *)response;

@end

/**
 *  网络配置，默认内部不进行加密解密，如果要加密解密，请子类化一个网络配置类，并且实现BGNetworkDataHandleProtocol协议 
 */
@interface BGNetworkConfiguration : NSObject<BGNetworkConfiguration>
+ (instancetype)configuration;
@end
