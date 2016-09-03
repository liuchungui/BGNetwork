//
//  BGNetworkCache.h
//  BGNetwork
//
//  Created by user on 15/8/21.
//  Copyright © 2015年 BGNetwork https://github.com/liuchungui/BGNetwork/tree/dev. All rights reserved.
//

#import <Foundation/Foundation.h>

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

#pragma mark - store
/**
 *  缓存数据
 */
- (void)storeData:(NSData * _Nonnull)data forFileName:(NSString * _Nonnull)fileName;

/**
 *  缓存数据
 */
- (void)storeData:(NSData * _Nonnull)data forFileName:(NSString * _Nonnull)fileName completion:(void (^ _Nullable)(BOOL isCacheSuccess))completionBlock;

/**
 *  归档存储对象
 *
 *  @param object 对象
 *  @param key    key值
 */
- (void)storeObject:(id<NSCoding> _Nonnull)object forFileName:(NSString * _Nonnull)fileName completion:(void (^ _Nullable)(BOOL isCacheSuccess))completionBlock;

/**
 *  归档存储对象
 *
 *  @param object 对象
 *  @param key    key值
 */
- (void)storeObject:(id<NSCoding> _Nonnull)object forFileName:(NSString * _Nonnull)fileName;


#pragma mark - query
/**
 *  查询缓存数据
 *  @return 返回查询到的缓存数据
 */
- (NSData * _Nullable)queryDataCacheForFileName:(NSString * _Nonnull)fileName;

/**
 *  查询缓存数据
 */
- (void)queryDataCacheForFileName:(NSString * _Nonnull)fileName completion:(void (^ _Nullable)(NSData* _Nullable data))completionBlock;

/**
 *  查询缓存数据
 *  @return 返回对象
 */
- (id _Nullable)queryObjectCacheForFileName:(NSString * _Nonnull)fileName;

/**
 *  查询缓存数据
 *  @return 返回的对象
 */
- (void)queryObjectCacheForFileName:(NSString * _Nonnull)fileName completion:(void (^ _Nullable)(id _Nullable object))completionBlock;


#pragma mark - remove
/**
 *  删除数据
 */
- (void)removeCacheForFileName:(NSString * _Nonnull)fileName;
@end
