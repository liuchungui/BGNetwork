//
//  BGNetworkConfiguration.m
//  BGNetwork
//
//  Created by user on 15/8/18.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "BGNetworkConfiguration.h"
#import "BGNetworkUtil.h"

@interface BGNetworkConfiguration ()
@end

@implementation BGNetworkConfiguration

+ (instancetype)configuration{
    BGNetworkConfiguration *configuration = [[self alloc] init];
    return configuration;
}

#pragma mark - BGNetworkConfiguration
- (NSString *)baseURLString{
    [NSException exceptionWithName:@"子类必须覆写baseURL方法" reason:nil userInfo:nil];
    return nil;
}

- (void)preProcessingRequest:(BGNetworkRequest *)request {
}

- (NSDictionary *)requestHTTPHeaderFields:(BGNetworkRequest *)request {
    NSMutableDictionary *allHTTPHeaderFileds = [@{
                                                  @"Content-Type":@"application/x-www-form-urlencoded;charset=utf-8",
                                                  @"User-Agent":@"iPhone"
                                                  } mutableCopy];
    [request.requestHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        allHTTPHeaderFileds[key] = obj;
    }];
    return allHTTPHeaderFileds;
}

- (NSString *)queryStringForURLWithRequest:(BGNetworkRequest *)request{
    if(request.httpMethod == BGNetworkRequestHTTPGet){
        return [BGNetworkUtil queryStringFromParamDic:request.parametersDic];
    }
    else{
        return nil;
    }
}

- (NSData *)httpBodyDataWithRequest:(BGNetworkRequest *)request{
    if(!request.parametersDic.count){
        return nil;
    }
    NSError *error = nil;
    NSData *httpBody = [NSJSONSerialization dataWithJSONObject:request.parametersDic options: (NSJSONWritingOptions)0 error:&error];
    if(error){
        return nil;
    }
    return httpBody;
}

- (NSData *)decryptResponseData:(NSData *)responseData response:(NSURLResponse *)response request:(BGNetworkRequest *)request{
    return responseData;
}

- (BOOL)shouldCacheResponseData:(id)responseData task:(NSURLSessionDataTask *)task request:(BGNetworkRequest *)request{
    if(request.cachePolicy == BGNetworkRequestCacheDataAndReadCacheOnly || request.cachePolicy == BGNetworkRequestCacheDataAndReadCacheLoadData) {
        return YES;
    }
    return NO;
}

- (BOOL)shouldBusinessSuccessWithResponseData:(id)responseData task:(NSURLSessionDataTask *)task request:(BGNetworkRequest *)request {
    return YES;
}
@end
