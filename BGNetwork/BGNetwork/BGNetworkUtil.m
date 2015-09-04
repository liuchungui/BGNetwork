//
//  BGNetworkUtil.m
//  BGNetwork
//
//  Created by user on 15/8/21.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "BGNetworkUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation BGNetworkUtil
+ (NSString *)md5:(NSString *)value {
    const char *str = [value UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *md5Str = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return md5Str;
}

+ (id)parseJsonData:(id)jsonData{
    /**
     *  解析json对象
     */
    NSError *error;
    id jsonResult = nil;
    if([NSJSONSerialization isValidJSONObject:jsonData]){
        return jsonData;
    }
    //NSData
    if (jsonData && [jsonData isKindOfClass:[NSData class]]){
        jsonResult = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    }
    if (jsonResult != nil && error == nil){
        return jsonResult;
    }
    else{
        // 解析错误
        return nil;
    }
}

+ (NSString *)keyFromParamDic:(NSDictionary *)paramDic methodName:(NSString *)methodName baseURL:(NSString *)baseURL{
    NSParameterAssert(paramDic);
    NSParameterAssert(methodName);
    NSParameterAssert(baseURL);
    
    //先进行排序
    NSArray *keys = [paramDic allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //组装字符串
    NSMutableString *keyMutableString = [NSMutableString string];
    for (NSInteger index = 0; index < sortedArray.count; index++) {
        NSString *key = [sortedArray objectAtIndex:index];
        NSString *value = [paramDic objectForKey:key];
        if (index == 0) {
            [keyMutableString appendFormat:@"%@=%@",key,value];
        } else {
            [keyMutableString appendFormat:@"|%@=%@",key,value];
        }
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",baseURL,methodName];
    [keyMutableString appendString:url];
    
    return [BGNetworkUtil md5:keyMutableString];
}

+ (NSString *)queryStringFromParamDic:(NSDictionary *)paramDic{
    NSMutableArray *array = [NSMutableArray array];
    [paramDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        [array addObjectsFromArray:[self queryStringFromKey:key value:obj]];
    }];
    return [array componentsJoinedByString:@"&"];
}

+ (NSArray *)queryStringFromKey:(NSString *)key value:(id)value{
    NSMutableArray *array = [NSMutableArray array];
    if([value isKindOfClass:[NSDictionary class]]){
        [(NSDictionary *)value enumerateKeysAndObjectsUsingBlock:^(NSString *dicKey, id obj, BOOL *stop) {
            NSString *resultKey = [NSString stringWithFormat:@"%@[%@]", key, dicKey];
            [array addObjectsFromArray:[self queryStringFromKey:resultKey value:obj]];
        }];
    }
    else if([value isKindOfClass:[NSArray class]]){
        [(NSArray *)value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *resultKey = [NSString stringWithFormat:@"%@[]", key];
            [array addObjectsFromArray:[self queryStringFromKey:resultKey value:obj]];
        }];
    }
    else if([value isKindOfClass:[NSSet class]]){
        [(NSSet *)value enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            NSString *resultKey = [NSString stringWithFormat:@"%@[]", key];
            [array addObjectsFromArray:[self queryStringFromKey:resultKey value:obj]];
        }];
    }
    else{
        [array addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    return array;
}


@end
