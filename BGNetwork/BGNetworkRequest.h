//
//  BGNetworkRequest.h
//  BGNetwork
//
//  Created by user on 15/8/18.
//  Copyright © 2015年 BGNetwork https://github.com/liuchungui/BGNetwork/tree/dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BGNetworkRequest;

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

/**
 *  网络请求缓存策略
 */
typedef NS_ENUM(NSInteger, BGNetworkRequestCachePolicy){
    /**
     *  不进行缓存
     */
    BGNetworkRquestCacheNone,
    /**
     *  请求到数据后缓存数据，读取缓存时如果有缓存则仅仅读取缓存，不再请求网络
     */
    BGNetworkRequestCacheDataAndReadCacheOnly,
    /**
     *  请求到数据后缓存数据，读取到缓存后请求网络
     */
    BGNetworkRequestCacheDataAndReadCacheLoadData,
};


#pragma mark - completion block
typedef void(^BGSuccessCompletionBlock)(BGNetworkRequest  * _Nonnull request, id  _Nullable response);
typedef void(^BGBusinessFailureBlock)(BGNetworkRequest * _Nonnull request, id _Nullable response);
typedef void(^BGNetworkFailureBlock)(BGNetworkRequest * _Nonnull request, NSError *_Nullable error);

@protocol BGNetworkRequestDelegate;
@protocol BGNetworkRequest <NSObject>
/**
 *  处理请求到的数据，父类默认不处理直接返回，子类覆写此方法进行处理
 *
 *  @param responseObject 请求到的数据
 *
 *  @return 处理之后的数据
 */
- (id _Nullable)processResponseObject:(id _Nonnull)responseObject;

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
 *  请求标识码，每个请求都拥有唯一的标示
 */
@property (nonatomic, assign, readonly) NSUInteger requestIdentifier;
/**
 *  方法名
 */
@property (nonatomic, strong) NSString * _Nonnull methodName;

/**
 *  HTTP请求的方法，默认GET，现支持GET和POST
 */
@property (nonatomic, assign) BGNetworkRequestHTTPMethod httpMethod;

/**
 *  缓存策略，默认为BGNetworkRquestCacheNone
 */
@property (nonatomic, assign) BGNetworkRequestCachePolicy cachePolicy;

/**
 *  参数字典
 */
@property (nonatomic, copy, readonly) NSDictionary * _Nonnull parametersDic;

/**
 *  请求头
 */
@property (nonatomic, copy, readonly) NSDictionary * _Nonnull requestHTTPHeaderFields;


#pragma mark - 设置或获取请求头的内容
- (void)setValue:(NSString * _Nonnull)value forHTTPHeaderField:(NSString * _Nonnull)field;
- (NSString * _Nonnull)valueForHTTPHeaderField:(NSString * _Nonnull)field;

#pragma mark - 设置参数
- (void)setIntegerValue:(NSInteger)value forParamKey:(NSString * _Nonnull)key;
- (void)setDoubleValue:(double)value forParamKey:(NSString * _Nonnull)key;
- (void)setLongLongValue:(long long)value forParamKey:(NSString * _Nonnull)key;
- (void)setBOOLValue:(BOOL)value forParamKey:(NSString * _Nonnull)key;
- (void)setValue:(id _Nonnull)value forParamKey:(NSString * _Nonnull)key;
@end

#pragma mark - BGNetworkRequest(BGNetworkManager)
@interface BGNetworkRequest (BGNetworkManager)
/**
 *  取消请求
 */
+ (void)cancelRequest;

/**
 *  发送网络请求
 *
 *  @param successCompletionBlock 成功回调
 *  @param businessFailureBlock   业务失败回调
 *  @param networkFailureBlock    网络失败回调
 */
- (void)sendRequestWithSuccess:(BGSuccessCompletionBlock _Nullable)successCompletionBlock
               businessFailure:(BGBusinessFailureBlock _Nullable)businessFailureBlock
                networkFailure:(BGNetworkFailureBlock _Nullable)networkFailureBlock;
@end
