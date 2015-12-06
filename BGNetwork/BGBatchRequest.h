//
//  BGBatchRequest.h
//  BGNetworkDemo
//
//  Created by user on 15/11/28.
//  Copyright © 2015年 lcg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGNetworkRequest.h"
#import "BGNetworkResponse.h"

/**
 *  批量发送请求
 */
@interface BGBatchRequest : NSObject
- (instancetype)initWithRequests:(NSArray *)requestArray;
@property (nonatomic, readonly) NSArray *requestArray;
/**
 *  发送批量请求
 *
 *  @param success 全部请求成功回调
 *  @param failure 失败回调，这里只要有一个请求失败，则立马回调，失败的信息在errorResponse中的error当中
 */
- (void)sendRequestCompletionWithSuccess:(void (^)(BGBatchRequest *batchRequest, NSArray *responseArray))successBlock failure:(void (^)(BGBatchRequest *batchRequest, BGNetworkResponse *errorResponse))failureBlock;

/**
 *  发送批量请求
 *
 *  @param progress 进度条
 *  @param success  全部请求成功回调
 *  @param failure  失败回调，这里只要有一个请求失败，则立马回调，失败的信息在errorResponse中的error当中
 */
- (void)sendRequestProgress:(void (^)(BGBatchRequest *batchRequest, NSInteger progress, NSInteger totalNum))progressBlock completionWithSuccess:(void (^)(BGBatchRequest *batchRequest, NSArray *responseArray))successBlock failure:(void (^)(BGBatchRequest *batchRequest, BGNetworkResponse *errorResponse))failureBlock;
@end
