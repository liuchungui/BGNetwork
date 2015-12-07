//
//  BGSerialRequest.m
//  BGNetworkDemo
//
//  Created by user on 15/12/7.
//  Copyright © 2015年 lcg. All rights reserved.
//

#import "BGSerialRequest.h"
#import "BGNetworkRequest.h"

@interface BGSerialRequest ()
@property (nonatomic, strong) NSArray *requestArray;
@property (nonatomic, copy) void (^successBlock)(BGNetworkRequest *, id);
@property (nonatomic, copy) void (^businessFailureBlock)(BGNetworkRequest *, id);
@property (nonatomic, copy) void (^networkFailureBlock)(BGNetworkRequest *, NSError *);
@property (nonatomic, copy) void (^completionBlock)(BGSerialRequest *, BOOL);
@property (nonatomic, assign) NSInteger requestIndex;
@end

@implementation BGSerialRequest

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
    self.successBlock = nil;
    self.businessFailureBlock = nil;
    self.networkFailureBlock = nil;
    self.completionBlock = nil;
}

- (void)setBusinessFailure:(void (^)(BGNetworkRequest *, id))businessFailureBlock networkFailure:(void (^)(BGNetworkRequest *, NSError *))networkFailureBlock {
    self.businessFailureBlock = businessFailureBlock;
    self.networkFailureBlock = networkFailureBlock;
}

- (void)sendRequestSuccess:(void (^)(BGNetworkRequest *, id))successBlock
                completion:(void (^)(BGSerialRequest *, BOOL))completionBlock{
    
    self.successBlock = successBlock;
    
    __weak BGSerialRequest *weakSelf = self;
    self.completionBlock = ^(BGSerialRequest *request, BOOL isSuccess) {
        //完成回调
        if(completionBlock) {
            completionBlock(request, isSuccess);
        }
        //清空block
        [weakSelf clearRequestBlock];
    };
    
    //发送请求
    self.requestIndex = 0;
    if(self.requestIndex < self.requestArray.count) {
        [self sendNetworkRequest:self.requestArray.firstObject];
    }
}

- (void)sendNetworkRequest:(BGNetworkRequest *)request {
    
    [request sendRequestWithSuccess:^(BGNetworkRequest *request, id response) {
        self.requestIndex ++;
        if(self.successBlock) {
            self.successBlock(request, response);
        }
        
        /**
         *  全部请求成功，则所有回调；否则执行下一个请求
         */
        if(self.requestIndex == self.requestArray.count) {
            self.completionBlock(self, YES);
        }
        else {
            BGNetworkRequest *nextRequest = self.requestArray[self.requestIndex];
            [self sendNetworkRequest:nextRequest];
        }
        
    } businessFailure:^(BGNetworkRequest *request, id response) {
        if(self.businessFailureBlock) {
            self.businessFailureBlock(request, response);
        }
        //回调完成
        self.completionBlock(self, NO);
    } networkFailure:^(BGNetworkRequest *request, NSError *error) {
        if(self.networkFailureBlock) {
            self.networkFailureBlock(request, error);
        }
        self.completionBlock(self, NO);
    }];
    
}


@end
