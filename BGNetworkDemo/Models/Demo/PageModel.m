//
//  PageModel.m
//  DemoNetwork
//
//  Created by user on 15/5/13.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "PageModel.h"
#import "DemoModel.h"

@implementation PageModel
+ (Class)list_class{
    return [DemoModel class];
}

@end
