//
//  BGBatchRequest.h
//  BGNetworkDemo
//
//  Created by user on 15/11/28.
//  Copyright © 2015年 lcg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGNetworkRequest.h"

/**
 *  批量发送请求
 */
@interface BGBatchRequest : NSObject
/**
 *  init method
 *  @param requestArray 一组BGNetworkRequest
 */
- (instancetype _Nonnull)initWithRequests:(NSArray * _Nullable)requestArray;

@property (nonatomic, readonly) NSArray * _Nonnull requestArray;

/**
 *  当某个请求失败后，是否还继续加载其它请求，默认YES
 */
@property (nonatomic, assign) BOOL continueLoadWhenRequestFailure;

/**
 *  设置每个请求失败回调
 *
 *  @param businessFailureBlock BGNetworkRequest请求业务失败
 *  @param networkFailureBlock  BGNetworkRequest请求网络失败
 */
- (void)setBusinessFailure:(void (^ _Nullable)(BGNetworkRequest * _Nonnull request, id _Nullable response))businessFailureBlock
            networkFailure:(void (^ _Nullable)(BGNetworkRequest * _Nonnull request, NSError * _Nullable error))networkFailureBlock;

/**
 *  批量发送请求
 *
 *  @param successBlock    每个BGNetworkRequest请求成功回调
 *  @param completionBlock 所有BGNetworkRequest请求完成后回调
 */
- (void)sendRequestSuccess:(void (^ _Nullable)(BGNetworkRequest * _Nonnull request, id _Nullable response))successBlock
                completion:(void (^ _Nullable)(BGBatchRequest * _Nonnull batchRequest, BOOL isAllSuccess))completionBlock;
@end
