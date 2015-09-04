//
//  BGNetworkRequest.h
//  BGNetwork
//
//  Created by user on 15/8/18.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BGNetworkRequestHTTPMethod){
    /**
     *  GET请求
     */
    BGNetworkRequestHTTPGet,
    /**
     *  POST请求
     */
    BGNetworkRequestHTTPPost,
};
@protocol BGNetworkRequestDelegate;
@protocol BGNetworkRequest <NSObject>
/**
 *  方法名
 */
@property (nonatomic, copy, readonly) NSString *methodName;

/**
 *  HTTP请求的方法，默认GET，现支持GET和POST
 */
@property (nonatomic, assign, readonly) BGNetworkRequestHTTPMethod httpMethod;

/**
 *  是否需要缓存，默认为NO
 */
@property (nonatomic, assign, readonly) BOOL isNeedCache;

/**
 *  是否加密
 */
@property (nonatomic, assign, readonly) BOOL isEncrypt;

/**
 *  处理请求到的数据，父类默认不处理直接返回，子类覆写此方法进行处理
 *
 *  @param responseObject 请求到的数据
 *
 *  @return 处理之后的数据
 */
- (id)processResponseObject:(id)responseObject;

@end

#pragma mark - BGNetworkRequest
/**
 *  请求类，覆写父类的方法请参照BGNetworkRequest协议进行覆写
 *  @code
 *  BGNetworkRequest *request = [[BGNetworkRequest alloc] init];
 *  [request sendRequestWithDelegate:self];
 */
@interface BGNetworkRequest : NSObject <NSCopying, BGNetworkRequest>

/**
 *  代理
 */
@property (nonatomic, weak, readonly) id<BGNetworkRequestDelegate> delegate;

/**
 *  参数字典
 */
@property (nonatomic, copy, readonly) NSDictionary *parametersDic;

/**
 *  请求头
 */
@property (readonly, copy) NSDictionary *requestHTTPHeaderFields;


#pragma mark - public request method
/**
 *  取消请求
 */
+ (void)cancelRequest;

#pragma mark - 设置或获取请求头的内容
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
- (NSString *)valueForHTTPHeaderField:(NSString *)field;

#pragma mark - 设置参数
- (void)setIntegerValue:(NSInteger)value forParamKey:(NSString *)key;
- (void)setDoubleValue:(double)value forParamKey:(NSString *)key;
- (void)setLongLongValue:(long long)value forParamKey:(NSString *)key;
- (void)setBOOLValue:(BOOL)value forParamKey:(NSString *)key;
- (void)setValue:(id)value forParamKey:(NSString *)key;
@end

#pragma mark - BGNetworkRequest(BGNetworkManager)
@interface BGNetworkRequest (BGNetworkManager)
/**
 *  发送请求
 */
- (void)sendRequestWithDelegate:(id<BGNetworkRequestDelegate>)delegate;
@end

#pragma mark - BGNetworkRequestDelegate method
@protocol BGNetworkRequestDelegate <NSObject>
@required
/**
 *  网络成功调回的代理
 *
 *  @param request  请求
 *  @param response 请求返回的数据
 */
- (void)request:(BGNetworkRequest *)request successWithResponse:(id)response;
/**
 *  网络失败调回代理
 *
 *  @param request 请求
 *  @param error   失败的错误
 */
- (void)request:(BGNetworkRequest *)request failWithError:(NSError *)error;
@end
