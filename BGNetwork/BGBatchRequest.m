//
//  BGBatchRequest.m
//  BGNetworkDemo
//
//  Created by user on 15/11/28.
//  Copyright © 2015年 lcg. All rights reserved.
//

#import "BGBatchRequest.h"

@interface BGBatchRequest ()
@property (nonatomic, strong) NSArray *requestArray;
@end

@implementation BGBatchRequest
- (instancetype)init {
    return [self initWithRequests:nil];
}
- (instancetype)initWithRequests:(NSArray *)requestArray {
    if(self = [super init]) {
        self.requestArray = requestArray;
    }
    return self;
}

- (void)sendRequestSuccess:(void (^)(BGNetworkRequest *, id))successBlock
                   failure:(void (^)(BGNetworkRequest *, id))failureBlock
                completion:(void (^)(BGBatchRequest *))completionBlock {
    
    NSInteger requestCount = self.requestArray.count;
    __block NSInteger successCount = 0;
    
    //成功回调
    void (^ batchSuccessCallBack)(BGNetworkRequest *request, id response) = ^(BGNetworkRequest *request, id response) {
        successCount ++;
        if(successBlock) {
            successBlock(request, response);
        }
        if(successCount == requestCount) {
            if(completionBlock) {
                completionBlock(self);
            }
        }
    };
    
    //失败回调
    void (^ batchFailureCallBack)(BGNetworkRequest *request, id response) = ^(BGNetworkRequest *request, id response){
        if(failureBlock) {
            failureBlock(request, response);
        }
        if(!self.continueLoadWhenRequestFailure) {
            [self cancelAllRequest];
            if(completionBlock) {
                completionBlock(self);
            }
        }
    };
    
    for (BGNetworkRequest *request in self.requestArray) {
        [request sendRequestWithSuccess:^(BGNetworkRequest *request, id response) {
            batchSuccessCallBack(request, response);
        } businessFailure:^(BGNetworkRequest *request, id response) {
            batchFailureCallBack(request, response);
        } networkFailure:^(BGNetworkRequest *request, NSError *error) {
            batchFailureCallBack(request, error);
        }];
    }
}

- (void)cancelAllRequest {
    for (BGNetworkRequest *request in self.requestArray) {
#warning 取消请求是否用类方法取消？
        [[request class] cancelRequest];
    }
}
@end
