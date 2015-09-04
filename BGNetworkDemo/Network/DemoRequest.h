//
//  DemoRequest.h
//  BGNetworkDemo
//
//  Created by user on 15/9/4.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "BGNetworkRequest.h"

@interface DemoRequest : BGNetworkRequest
- (instancetype)initPage:(NSInteger)page pageSize:(NSInteger)pageSize;
@end
