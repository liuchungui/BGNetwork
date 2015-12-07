//
//  InfoRequest.m
//  BGNetworkDemo
//
//  Created by user on 15/12/7.
//  Copyright © 2015年 lcg. All rights reserved.
//

#import "InfoRequest.h"

@implementation InfoRequest

- (instancetype)initWithId:(NSInteger)infoId {
    if(self = [super init]) {
        self.methodName = @"info.php";
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setIntegerValue:infoId forParamKey:@"infoId"];
    }
    return self;
}
@end
