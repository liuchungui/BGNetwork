//
//  BGNetworkCache.h
//  BGNetwork
//
//  Created by user on 15/8/21.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BGNetworkCacheQueryCompletedBlock)(id _Nullable object);
@interface BGNetworkCache : NSObject
/**
 *  返回一个单例对象
 */
+ (instancetype _Nonnull)sharedCache;

/**
 *  初始化对象
 *
 *  @param nameSpace 设置缓存空间
 *
 */
- (instancetype _Nonnull)initWithNamespace:(NSString * _Nonnull)nameSpace;

/**
 *  默认缓存路径
 *
 *  @param key 缓存的文件名
 *
 *  @return 返回文件路径
 */
- (NSString *)defaultCachePathForKey:(NSString *)key;

#pragma mark - 缓存
/**
 *  换存数据
 *
 *  @param data 缓存的数据
 *  @param key  缓存的Key值
 */
- (void)storeData:(NSData * _Nonnull)data forKey:(NSString * _Nonnull)key;

/**
 *  查询缓存数据
 *
 *  @param key 查询缓存数据的key
 *
 *  @return 返回查询到的缓存数据
 */
- (NSData * _Nullable)queryCacheForKey:(NSString * _Nonnull)key;

/**
 *  查询缓存数据
 *
 *  @param key   查询缓存数据的key
 *  @param block 查询完之后的回调block
 */
- (void)queryCacheForKey:(NSString * _Nonnull)key completed:(BGNetworkCacheQueryCompletedBlock _Nonnull)block;

/**
 *  删除数据
 *
 *  @param key 缓存数据对应的key
 */
- (void)removeCacheForKey:(NSString * _Nonnull)key;

#pragma mark - 存储对象
/**
 *  归档存储对象
 *
 *  @param object 对象
 *  @param key    key值
 */
- (void)storeObject:(id<NSCoding> _Nonnull)object forKey:(NSString * _Nonnull)key;
/**
 *  查询对象
 *
 *  @param key key值
 *
 *  @return 返回一个查询的对象
 */
- (id _Nullable)queryObjectForKey:(NSString * _Nonnull)key;
/**
 *  查询对象
 *
 *  @param key   key值
 *  @param block 回调一个查询好的对象
 */
- (void)queryObjectForKey:(NSString * _Nonnull)key completed:(BGNetworkCacheQueryCompletedBlock _Nonnull)block;
@end
