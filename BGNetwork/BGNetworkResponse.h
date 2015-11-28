//
//  BGNetworkResponse.h
//  BGNetworkDemo
//
//  Created by user on 15/11/28.
//  Copyright © 2015年 lcg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGNetworkRequest.h"

@interface BGNetworkResponse : NSObject
- (instancetype)initWithResponse:(id)response request:(BGNetworkRequest *)request;
- (instancetype)initWithError:(NSError *)error request:(BGNetworkRequest *)request;
@property (nonatomic, readonly) BGNetworkRequest *request;
@property (nonatomic, readonly) id response;
@property (nonatomic, readonly) NSError *error;
@end
