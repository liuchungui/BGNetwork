//
//  DemoRequest.m
//  BGNetworkDemo
//
//  Created by user on 15/9/4.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "DemoRequest.h"
#import "PageModel.h"

@implementation DemoRequest

#pragma mark - BGNetworkRequest method
- (id)processResponseObject:(id)responseObject{
    PageModel *model = [[PageModel alloc] initWithDictionary:responseObject[@"result"]];
    return model;
}

#pragma mark - 
- (instancetype)initPage:(NSInteger)page pageSize:(NSInteger)pageSize{
    if(self = [super init]){
        self.methodName = @"demo.php";
        self.httpMethod = BGNetworkRequestHTTPPost;
        self.cachePolicy = BGNetworkRquestCacheNone;
        //设置参数
        [self setValue:@"1196689" forParamKey:@"orderNo"];
        [self setIntegerValue:page forParamKey:@"page"];
        [self setIntegerValue:pageSize forParamKey:@"pageSize"];
        [self setValue:@"test" forParamKey:@"test.demo"];
    }
    return self;
}
@end
