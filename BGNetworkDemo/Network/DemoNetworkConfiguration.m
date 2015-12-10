//
//  DemoNetworkConfiguration.m
//  BGNetworkDemo
//
//  Created by user on 15/9/4.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "DemoNetworkConfiguration.h"

@implementation DemoNetworkConfiguration
- (NSString *)baseURLString{
    return @"http://casetree.cn/web/test/";
//    return @"https://casetree.cn/web/test/";
}

- (void)preProcessingRequest:(BGNetworkRequest *)request {
//    request.methodName = [NSString stringWithFormat:@"%@%@", @"http://baidu.com/", request.methodName];方法
}

- (NSData *)httpBodyDataWithRequest:(BGNetworkRequest *)request {
    if(!request.parametersDic.count){
        return nil;
    }
    NSMutableDictionary *requestParametersDic = [NSMutableDictionary dictionary];
    requestParametersDic[@"params"] = request.parametersDic;
    NSError *error = nil;
    NSData *httpBody = [NSJSONSerialization dataWithJSONObject:requestParametersDic options: (NSJSONWritingOptions)0 error:&error];
    if(error){
        return nil;
    }
    return httpBody;
}
@end
