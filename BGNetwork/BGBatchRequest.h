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
/**
 *  init method
 *  @param requestArray 一组BGNetworkRequest
 */
- (instancetype)initWithRequests:(NSArray *)requestArray;

@property (nonatomic, readonly) NSArray *requestArray;

/**
 *  当某个请求失败后，是否还继续加载其它请求，默认YES
 */
@property (nonatomic, assign) BOOL continueLoadWhenRequestFailure;

/**
 *  批量发送请求
 *
 *  @param successBlock    请求成功回调
 *  @param failureBlock    请求失败回调
 *  @param completionBlock 所有请求完成后回调
 */
- (void)sendRequestSuccess:(void (^)(BGNetworkRequest *request, id response))successBlock
                   failure:(void (^)(BGNetworkRequest *request, id response))failureBlock
                completion:(void (^)(BGBatchRequest *batchRequest))completionBlock;
@end
