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
 *  @param fileName 文件名
 *
 *  @return 返回文件路径
 */
- (NSString * _Nonnull)defaultCachePathForFileName:(NSString * _Nonnull)fileName;

#pragma mark - cache file with fileName
/**
 *  归档存储对象
 *
 *  @param object 对象
 *  @param key    key值
 */
- (void)storeObject:(id<NSCoding> _Nonnull)object forFileName:(NSString * _Nonnull)fileName;

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
