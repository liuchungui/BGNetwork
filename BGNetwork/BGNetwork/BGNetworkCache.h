//
//  BGNetworkCache.h
//  BGNetwork
//
//  Created by user on 15/8/21.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BGNetworkCacheQueryCompletedBlock)(id object);
@interface BGNetworkCache : NSObject
/**
 *  返回一个单例对象
 */
+ (instancetype)sharedCache;

/**
 *  初始化对象
 *
 *  @param nameSpace 设置缓存空间
 *
 */
- (instancetype)initWithNamespace:(NSString *)nameSpace;
/**
 *  换存数据
 *
 *  @param data 缓存的数据
 *  @param key  缓存的Key值
 */
- (void)storeData:(NSData *)data forKey:(NSString *)key;

/**
 *  查询缓存数据
 *
 *  @param key 查询缓存数据的key
 *
 *  @return 返回查询到的缓存数据
 */
- (NSData *)queryCacheForKey:(NSString *)key;

/**
 *  查询缓存数据
 *
 *  @param key   查询缓存数据的key
 *  @param block 查询完之后的回调block
 */
- (void)queryCacheForKey:(NSString *)key completed:(BGNetworkCacheQueryCompletedBlock)block;

/**
 *  删除数据
 *
 *  @param key 缓存数据对应的key
 */
- (void)removeCacheForKey:(NSString *)key;

#pragma mark - 存储对象
/**
 *  归档存储对象
 *
 *  @param object 对象
 *  @param key    key值
 */
- (void)storeObject:(id<NSCoding>)object forKey:(NSString *)key;
/**
 *  查询对象
 *
 *  @param key key值
 *
 *  @return 返回一个查询的对象
 */
- (id)queryObjectForKey:(NSString *)key;
/**
 *  查询对象
 *
 *  @param key   key值
 *  @param block 回调一个查询好的对象
 */
- (void)queryObjectForKey:(NSString *)key completed:(BGNetworkCacheQueryCompletedBlock)block;
@end
