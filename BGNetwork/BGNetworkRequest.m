//
//  BGNetworkRequest.m
//  BGNetwork
//
//  Created by user on 15/8/18.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "BGNetworkRequest.h"
#import "BGNetworkManager.h"
#import <objc/runtime.h>

static const char *BGNetworkRequestMethodNameKey = "BGNetworkRequestMethodNameKey";
@interface BGNetworkRequest (){
    NSString *_methodName;
}
@property (nonatomic, strong) NSMutableDictionary *mutableParametersDic;
@property (nonatomic, copy) NSMutableDictionary *requestHTTPHeaderFields;
/**
 *  代理
 */
@property (nonatomic, weak) id<BGNetworkRequestDelegate> delegate;

@end
@implementation BGNetworkRequest
- (instancetype)init{
    if(self = [super init]){
        _requestHTTPHeaderFields = [[NSMutableDictionary alloc] init];
        _mutableParametersDic = [[NSMutableDictionary alloc] init];
        self.httpMethod = BGNetworkRequestHTTPGet;
        self.cachePolicy = BGNetworkRquestCacheNone;
    }
    return self;
}

#pragma mark - set or get method
- (void)setMethodName:(NSString *)methodName{
    _methodName = methodName;
    [[self class] setRequestMethodName:methodName];
}

- (NSDictionary *)parametersDic{
    return [_mutableParametersDic copy];
}

- (NSDictionary *)requestHTTPHeaderFields {
    return [_requestHTTPHeaderFields copy];
}

#pragma mark - BGNetworkRequest method
- (id)processResponseObject:(id)data{
    return data;
}

#pragma mark - 设置或获取请求头
- (NSString *)valueForHTTPHeaderField:(NSString *)field{
    if(!field){
        return @"";
    }
    return self.requestHTTPHeaderFields[field];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field{
    if(!field || !value){
        return;
    }
    [self.requestHTTPHeaderFields setValue:value forKey:field];
}

#pragma mark - 设置参数
- (void)setIntegerValue:(NSInteger)value forParamKey:(NSString *)key{
    [self setValue:[NSNumber numberWithInteger:value] forParamKey:key];
}

- (void)setDoubleValue:(double)value forParamKey:(NSString *)key{
    [self setValue:[NSNumber numberWithDouble:value] forParamKey:key];
}

- (void)setLongLongValue:(long long)value forParamKey:(NSString *)key{
    [self setValue:[NSNumber numberWithLongLong:value] forParamKey:key];
}

- (void)setBOOLValue:(BOOL)value forParamKey:(NSString *)key{
    [self setValue:[NSNumber numberWithBool:value] forParamKey:key];
}

- (void)setValue:(id)value forParamKey:(NSString *)key{
    if(!key){
        return;
    }
    if(!value){
        value = @"";
    }
    _mutableParametersDic[key] = value;
}

#pragma mark - NSCopying method
- (id)copyWithZone:(NSZone *)zone{
    BGNetworkRequest *request = [[[self class] allocWithZone:zone] init];
    request.requestHTTPHeaderFields = self.requestHTTPHeaderFields;
    request.mutableParametersDic = self.mutableParametersDic;
    return request;
}

/**
 *  用户初始化后，此url才有效。
 */
+ (NSString*)getRequestMethodName{
    NSString* methodName =  objc_getAssociatedObject([self class], BGNetworkRequestMethodNameKey);
    //为了外面使用isHttpQueueFinished的方便，不返回nil。
    if(!methodName){
        methodName = @"";
    }
    return methodName;
}

+ (void)setRequestMethodName:(NSString *)methodName{
    objc_setAssociatedObject([self class], BGNetworkRequestMethodNameKey, methodName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


#pragma mark - description
- (NSString *)description{
    NSString *className = NSStringFromClass([self class]);
    NSString *desStr = [NSString stringWithFormat:@"%@\nmthodName:%@\nparam:\n%@", className, self.methodName, self.parametersDic];
    return desStr;
}
@end

@implementation BGNetworkRequest (BGNetworkManager)
#pragma mark - class method
+ (void)cancelRequest{
    [[BGNetworkManager sharedManager] cancelRequestWithUrl:[self getRequestMethodName]];
}

- (void)sendRequestWithDelegate:(id<BGNetworkRequestDelegate>)delegate{
    self.delegate = delegate;
    [[BGNetworkManager sharedManager] managerSendRequest:self];
}
@end
