//
//  BGSerialRequest.h
//  BGNetworkDemo
//
//  Created by user on 15/12/7.
//  Copyright © 2015年 lcg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BGNetworkRequest;
/**
 *  一连串请求，给一个请求数组，只有请求成功前面的，才会去请求后面的，只有全部请求成功才会调用成功回调的代理
 */
@interface BGSerialRequest : NSObject
/**
 *  init method
 *  @param requestArray 一组BGNetworkRequest
 */
- (instancetype)initWithRequests:(NSArray *)requestArray;

@property (nonatomic, readonly) NSArray *requestArray;

/**
 *  设置每个请求失败回调
 *
 *  @param businessFailureBlock 业务失败
 *  @param networkFailureBlock  网络失败
 */
- (void)setBusinessFailure:(void (^)(BGNetworkRequest *request, id response))businessFailureBlock
            networkFailure:(void (^)(BGNetworkRequest *request, NSError *error))networkFailureBlock;

/**
 *  发送请求
 *
 *  @param successBlock    成功回调的block
 *  @param completionBlock 全部成功回调
 */
- (void)sendRequestSuccess:(void (^)(BGNetworkRequest *request, id response))successBlock
                completion:(void (^)(BGSerialRequest *searialRequest, BOOL isSuccess))completionBlock;

@end
