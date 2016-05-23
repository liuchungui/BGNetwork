//
//  BGNetworkConfiguration.m
//  BGNetwork
//
//  Created by user on 15/8/18.
//  Copyright © 2015年 BGNetwork https://github.com/liuchungui/BGNetwork/tree/dev. All rights reserved.
//

#import "BGNetworkConfiguration.h"
#import "BGUtilFunction.h"

@interface BGNetworkConfiguration ()
@property(nonatomic, strong) NSString *baseURLString;
@end

@implementation BGNetworkConfiguration

+ (instancetype)configuration{
    return [self configurationWithBaseURL: @""];
}

+ (instancetype _Nonnull)configurationWithBaseURL:(NSString *)baseURL {
    BGNetworkConfiguration *configuration = [[self alloc] init];
    configuration.baseURLString = baseURL;
    return configuration;
}

#pragma mark - BGNetworkConfiguration
- (NSString *)baseURLString {
    return _baseURLString;
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
        return BGQueryStringFromParamDictionary(request.parametersDic);
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
