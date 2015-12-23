//
//  BGNetworkCache.m
//  BGNetwork
//
//  Created by user on 15/8/21.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "BGNetworkCache.h"
#import <CommonCrypto/CommonDigest.h>

static inline NSString *cache_md5(NSString *value) {
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

@interface BGNetworkCache ()
@property (nonatomic, strong) dispatch_queue_t workQueue;
@property (nonatomic, strong) NSString *diskCachePath;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSCache *memoryCache;
@end
@implementation BGNetworkCache
+ (instancetype)sharedCache{
    static BGNetworkCache *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init{
    return [self initWithNamespace:@"BGNetworkCache"];
}

- (instancetype)initWithNamespace:(NSString *)nameSpace{
    if(self = [super init]){
        //创建工作队列
        _workQueue = dispatch_queue_create("com.BGNetworkCache.workQueue", DISPATCH_QUEUE_SERIAL);
        
        //缓存路径
        _diskCachePath = [self makeDiskCachePath:nameSpace];
        
        //内存缓存
        _memoryCache = [[NSCache alloc] init];
        _memoryCache.name = nameSpace;
        
        //文件管理
        dispatch_async(self.workQueue, ^{
            _fileManager = [NSFileManager defaultManager];
            if (![_fileManager fileExistsAtPath:_diskCachePath]) {
                [_fileManager createDirectoryAtPath:_diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
            }
        });
    }
    return self;
}

#pragma mark - cache data for key
- (void)storeData:(NSData *)data forKey:(NSString *)key{
    [self storeData:data forFileName:cache_md5(key)];
}

- (NSData *)queryCacheForKey:(NSString *)key{
    return [self queryCacheForFileName:cache_md5(key)];
}

- (void)queryCacheForKey:(NSString *)key completion:(BGNetworkQueryCacheCompletionBlock _Nonnull)block{
    [self queryCacheForFileName:cache_md5(key) completion:block];
}

- (void)removeCacheForKey:(NSString *)key{
    [self removeCacheForFileName:cache_md5(key)];
}

#pragma mark - cache data for fileName
- (void)storeData:(NSData *)data forFileName:(NSString *)fileName completion:(BGNetworkCacheCompletionBlock _Nullable)comletionBlock{
    if(!data | !fileName){
        return;
    }
    
    //缓存到内存
    NSString *key = cache_md5(fileName);
    [self.memoryCache setObject:data forKey:key cost:data.length];
    
    //缓存到本地
    dispatch_async(self.workQueue, ^{
        // get cache Path for data key
        NSString *cachePathForKey = [self defaultCachePathForFileName:fileName];
        [_fileManager createFileAtPath:cachePathForKey contents:data attributes:nil];
        //缓存成功之后，从内存中删除
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.memoryCache removeObjectForKey:key];
        });
        if(comletionBlock) {
            comletionBlock();
        }
    });
}

- (void)storeData:(NSData *)data forFileName:(NSString *)fileName {
    [self storeData:data forFileName:fileName completion:NULL];
}

- (NSData *)queryCacheForFileName:(NSString *)fileName {
    if(!fileName){
        return nil;
    }
    
    //query memory data
    NSString *key = cache_md5(fileName);
    NSData *data = [self.memoryCache objectForKey:key];
    
    if(data == nil){
        NSString *cachePathForKey = [self defaultCachePathForFileName:fileName];
        data = [[NSData alloc] initWithContentsOfFile:cachePathForKey];
    }
    
    return data;
}

- (void)queryCacheForFileName:(NSString *)fileName completion:(BGNetworkQueryCacheCompletionBlock)comletionBlock {
    if(!fileName){
        return;
    }
    
    //query memory data
    NSString *key = cache_md5(fileName);
    NSData *data = [self.memoryCache objectForKey:key];
    
    if(data == nil){
        [self queryDiskCacheForFileName:fileName completion:comletionBlock];
    }
    else{
        comletionBlock(data);
    }
}

- (void)queryDiskCacheForFileName:(NSString *)fileName completion:(BGNetworkQueryCacheCompletionBlock)comletionBlock {
    if(!fileName){
        return;
    }
    
    dispatch_async(self.workQueue, ^{
        NSString *cachePath = [self defaultCachePathForKey:fileName];
        NSData *diskData = [[NSData alloc] initWithContentsOfFile:cachePath];
        dispatch_async(dispatch_get_main_queue(), ^{
            comletionBlock(diskData);
        });
    });
}

- (void)removeCacheForFileName:(NSString *)fileName {
    //remove memory data
    NSString *key = cache_md5(fileName);
    [self.memoryCache removeObjectForKey:key];
    
    //remove disk data
    dispatch_async(self.workQueue, ^{
        NSString *cachePathForKey = [self defaultCachePathForFileName:fileName];
        [_fileManager removeItemAtPath:cachePathForKey error:nil];
    });
}

#pragma mark - cache object method
- (void)storeObject:(id<NSCoding>)object forKey:(NSString *)key{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [self storeData:data forKey:key];
}

- (id)queryObjectForKey:(NSString *)key{
    NSData *data = [self queryCacheForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)queryObjectForKey:(NSString *)key completion:(BGNetworkQueryCacheCompletionBlock _Nonnull)block{
    if(!key || !block){
        return;
    }
    [self queryCacheForKey:key completion:^(NSData *data) {
        id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        block(object);
    }];
}

// Init the disk cache
-(NSString *)makeDiskCachePath:(NSString*)fullNamespace{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:fullNamespace];
}

- (NSString *)cachePathForFileName:(NSString *)fileName inPath:(NSString *)path {
    return [path stringByAppendingPathComponent:fileName];
}

- (NSString *)defaultCachePathForKey:(NSString *)key {
    NSString *fileName = cache_md5(key);
    return [self defaultCachePathForFileName:fileName];
}

- (NSString *)defaultCachePathForFileName:(NSString *)fileName {
    return [self cachePathForFileName:fileName inPath:self.diskCachePath];
}
@end
