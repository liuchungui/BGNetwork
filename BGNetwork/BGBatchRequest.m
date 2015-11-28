//
//  BGBatchRequest.m
//  BGNetworkDemo
//
//  Created by user on 15/11/28.
//  Copyright © 2015年 lcg. All rights reserved.
//

#import "BGBatchRequest.h"

@interface BGBatchRequest ()<BGNetworkRequestDelegate>
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

- (void)sendRequestProgress:(void (^)(BGBatchRequest *, NSInteger, NSInteger))progressBlock completionWithSuccess:(void (^)(BGBatchRequest *, NSArray *))successBlock failure:(void (^)(BGBatchRequest *, BGNetworkResponse *))failureBlock {
    self.progressBlock = progressBlock;
    self.successBlock = successBlock;
    self.failureBlock = failureBlock;
    
    //start
    [self startSendRequest];
}

- (void)startSendRequest {
    for (BGNetworkRequest *request in self.requestArray) {
        [request sendRequestWithDelegate:self];
    }
}

- (void)clearAllBlock {
    self.progressBlock = nil;
    self.successBlock = nil;
    self.failureBlock = nil;
}

#pragma mark - BGNetworkRequestDelegate method
- (void)request:(BGNetworkRequest *)request successWithResponse:(id)response {
    BGNetworkResponse *networkResponse = [[BGNetworkResponse alloc] initWithResponse:response request:request];
    [self.responseArray addObject:networkResponse];
    if(self.responseArray.count == self.requestArray.count) {
        //call back
        if(self.successBlock) {
            self.successBlock(self, self.responseArray);
        }
        [self clearAllBlock];
    }
    else {
        if(self.progressBlock) {
            self.progressBlock(self, self.responseArray.count, self.requestArray.count);
        }
    }
}

- (void)request:(BGNetworkRequest *)request businessFailureWithResponse:(id)response {
    BGNetworkResponse *networkResponse = [[BGNetworkResponse alloc] initWithResponse:response request:request];
    self.failureBlock(self, networkResponse);
    [self clearAllBlock];
}

- (void)request:(BGNetworkRequest *)request failureWithNetworkError:(NSError *)error {
    BGNetworkResponse *networkResponse = [[BGNetworkResponse alloc] initWithError:error request:request];
    self.failureBlock(self, networkResponse);
    [self clearAllBlock];
}
@end
