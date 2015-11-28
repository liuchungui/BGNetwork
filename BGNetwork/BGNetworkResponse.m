//
//  BGNetworkResponse.m
//  BGNetworkDemo
//
//  Created by user on 15/11/28.
//  Copyright © 2015年 lcg. All rights reserved.
//

#import "BGNetworkResponse.h"

@interface BGNetworkResponse ()
@property (nonatomic, strong) BGNetworkRequest *request;
@property (nonatomic, strong) id response;
@property (nonatomic, strong) NSError *error;
@end

@implementation BGNetworkResponse
- (instancetype)initWithResponse:(id)response request:(BGNetworkRequest *)request {
    return [self initWithResponse:response error:nil request:request];
}

- (instancetype)initWithError:(NSError *)error request:(BGNetworkRequest *)request {
    return [self initWithResponse:nil error:error request:request];
}

- (instancetype)initWithResponse:(id)response error:(NSError *)error request:(BGNetworkRequest *)request {
    if(self = [super init]) {
        self.response = response;
        self.error = error;
        self.request = request;
    }
    return self;
}
@end
