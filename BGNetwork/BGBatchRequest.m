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
@property (nonatomic, copy) void (^businessFailureBlock)(BGNetworkRequest *, id);
@property (nonatomic, copy) void (^networkFailureBlock)(BGNetworkRequest *, NSError *);
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

- (void)clearRequestBlock {
    self.businessFailureBlock = nil;
    self.networkFailureBlock = nil;
}

- (void)setBusinessFailure:(void (^)(BGNetworkRequest *, id))businessFailureBlock networkFailure:(void (^)(BGNetworkRequest *, NSError *))networkFailureBlock {
    self.businessFailureBlock = businessFailureBlock;
    self.networkFailureBlock = networkFailureBlock;
}

- (void)sendRequestSuccess:(void (^)(BGNetworkRequest *, id))successBlock
                completion:(void (^)(BGBatchRequest *, BOOL))completionBlock {
    
    NSInteger requestCount = self.requestArray.count;
    __block NSInteger successCount = 0;
    
    for (BGNetworkRequest *request in self.requestArray) {
        [request sendRequestWithSuccess:^(BGNetworkRequest *request, id response) {
            successCount ++;
            if(successBlock) {
                successBlock(request, response);
            }
            if(successCount == requestCount) {
                [self clearRequestBlock];
                if(completionBlock) {
                    completionBlock(self, YES);
                }
            }
        } businessFailure:^(BGNetworkRequest *request, id response) {
            if(self.businessFailureBlock) {
                self.businessFailureBlock(request, response);
            }
            if(!self.continueLoadWhenRequestFailure) {
                [self clearRequestBlock];
                [self cancelAllRequest];
                if(completionBlock) {
                    completionBlock(self, NO);
                }
            }
        } networkFailure:^(BGNetworkRequest *request, NSError *error) {
            if(self.networkFailureBlock) {
                self.networkFailureBlock(request, error);
            }
            if(!self.continueLoadWhenRequestFailure) {
                [self clearRequestBlock];
                [self cancelAllRequest];
                if(completionBlock) {
                    completionBlock(self, NO);
                }
            }
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
