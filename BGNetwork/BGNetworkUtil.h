//
//  BGNetworkUtil.h
//  BGNetwork
//
//  Created by user on 15/8/21.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  工具类
 */
@interface BGNetworkUtil : NSObject
+ (NSString *)md5:(NSString *)value;
/**
 *  将json数据解析成一个对象
 *
 *  @param jsonData data数据
 *
 *  @return 返回对象
 */
+ (id)parseJsonData:(id)jsonData;

/**
 *  通过参数字典、方法名、baseURL生成一个的键值
 *
 *  @param paramDic   参数字典
 *  @param methodName 方法名
 *  @param baseURL    基础地址
 *
 *  @return 返回一个md5字符串
 */
+ (NSString *)keyFromParamDic:(NSDictionary *)paramDic methodName:(NSString *)methodName baseURL:(NSString *)baseURL;


/**
 *  由paramDic生成queryString
 *
 *  @param paramDic 参数字典
 *
 *  @return 返回queryString格式的字符串
 */
+ (NSString *)queryStringFromParamDic:(NSDictionary *)paramDic;

@end
