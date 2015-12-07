//
//  AdvertInfoRequest.m
//  BGNetworkDemo
//
//  Created by user on 15/12/7.
//  Copyright © 2015年 lcg. All rights reserved.
//

#import "AdvertInfoRequest.h"

@implementation AdvertInfoRequest
- (instancetype)init {
    if(self = [super init]) {
        self.methodName = @"advert.php";
        self.httpMethod = BGNetworkRequestHTTPGet;
    }
    return self;
}
@end
