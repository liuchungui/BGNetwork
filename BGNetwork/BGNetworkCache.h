//
//  BGNetworkCache.h
//  BGNetwork
//
//  Created by user on 15/8/21.
//  Copyright © 2015年 BGNetwork https://github.com/liuchungui/BGNetwork/tree/dev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BGNetworkQueryCacheCompletionBlock)(id _Nullable object);
typedef void(^BGNetworkCacheCompletionBlock)(void);

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
 *  @param key 文件名为mdf(key)
 *
 *  @return 返回文件路径
 */
- (NSString * _Nonnull)defaultCachePathForKey:(NSString * _Nonnull)key;

/**
 *  默认缓存路径
 *
 *  @param fileName 文件名
 *
 *  @return 返回文件路径
 */
- (NSString * _Nonnull)defaultCachePathForFileName:(NSString * _Nonnull)fileName;

#pragma mark - cache file with key
/**
 *  缓存数据
 *
 *  @param data 缓存的数据
 *  @param key  缓存的Key值，内部会以此值md5一下成为文件名
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
- (void)queryCacheForKey:(NSString * _Nonnull)key completion:(BGNetworkQueryCacheCompletionBlock _Nonnull)block;

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
- (void)queryObjectForKey:(NSString * _Nonnull)key completion:(BGNetworkQueryCacheCompletionBlock _Nonnull)block;

#pragma mark - cache file with fileName
/**
 *  缓存数据
 */
- (void)storeData:(NSData * _Nonnull)data forFileName:(NSString * _Nonnull)fileName;

/**
 *  缓存数据
 */
- (void)storeData:(NSData * _Nonnull)data forFileName:(NSString * _Nonnull)fileName completion:(BGNetworkCacheCompletionBlock _Nullable)comletionBlock;

/**
 *  查询缓存数据
 *  @return 返回查询到的缓存数据
 */
- (NSData * _Nullable)queryCacheForFileName:(NSString * _Nonnull)fileName;

/**
 *  查询缓存数据
 */
- (void)queryCacheForFileName:(NSString * _Nonnull)fileName completion:(BGNetworkQueryCacheCompletionBlock _Nonnull)comletionBlock;

/**
 *  查询磁盘中缓存数据
 */
- (void)queryDiskCacheForFileName:(NSString * _Nonnull)fileName completion:(BGNetworkQueryCacheCompletionBlock _Nonnull)comletionBlock;

/**
 *  删除数据
 */
- (void)removeCacheForFileName:(NSString * _Nonnull)fileName;
@end
