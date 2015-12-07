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
@property (nonatomic, strong) NSMutableArray *responseArray;
@property (nonatomic, copy) void (^successBlock)(BGBatchRequest *batchRequest, NSArray *responseArray);
@property (nonatomic, copy) void (^failureBlock)(BGBatchRequest *batchRequest, BGNetworkResponse *errorResponse);
@property (nonatomic, copy) void (^progressBlock)(BGBatchRequest *batchRequest, NSInteger progress, NSInteger totalNum);

@end
@implementation BGBatchRequest
- (instancetype)init {
    return [self initWithRequests:nil];
}
- (instancetype)initWithRequests:(NSArray *)requestArray {
    if(self = [super init]) {
        self.requestArray = requestArray;
        self.responseArray = [NSMutableArray array];
    }
    return self;
}

- (void)sendRequestCompletionWithSuccess:(void (^)(BGBatchRequest *, NSArray *))successBlock failure:(void (^)(BGBatchRequest *, BGNetworkResponse *))failureBlock {
    [self sendRequestProgress:NULL completionWithSuccess:successBlock failure:failureBlock];
}

- (void)sendRequestProgress:(void (^)(BGBatchRequest *, NSInteger progress, NSInteger totalCount))progressBlock completionWithSuccess:(void (^)(BGBatchRequest *, NSArray *))successBlock failure:(void (^)(BGBatchRequest *, BGNetworkResponse *))failureBlock {
    self.progressBlock = progressBlock;
    self.successBlock = successBlock;
    self.failureBlock = failureBlock;
    
    NSInteger requestCount = self.requestArray.count;
    __block NSInteger successRequestCount = 0;
    for (BGNetworkRequest *request in self.requestArray) {
        [request sendRequestWithSuccess:^(BGNetworkRequest *request, id response) {
            successRequestCount ++;
            if(successRequestCount == requestCount) {
                if(successBlock) {
#warning 此处未写完
                    successBlock(self, nil);
                }
                else {
                    if(progressBlock) {
                        progressBlock(self, successRequestCount, requestCount);
                    }
                }
            }
        } businessFailure:^(BGNetworkRequest *request, id response) {
            if(failureBlock) {
#warning 此处未写完
                failureBlock(self, nil);
            }
        } networkFailure:^(BGNetworkRequest *request, NSError *error) {
            if(failureBlock) {
#warning 此处未写完
                failureBlock(self, nil);
            }
        }];
    }
}

@end
