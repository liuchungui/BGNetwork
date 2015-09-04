//
//  BGNetworkCache.m
//  BGNetwork
//
//  Created by user on 15/8/21.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "BGNetworkCache.h"
#import "BGNetworkUtil.h"

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
        });
    }
    return self;
}

- (void)storeData:(NSData *)data forKey:(NSString *)key{
    if(!data | !key){
        return;
    }
    //缓存到内存
    [self.memoryCache setObject:data forKey:key cost:data.length];
    //缓存到本地
    dispatch_async(self.workQueue, ^{
        if (![_fileManager fileExistsAtPath:_diskCachePath]) {
            [_fileManager createDirectoryAtPath:_diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        
        // get cache Path for data key
        NSString *cachePathForKey = [self defaultCachePathForKey:key];
        [_fileManager createFileAtPath:cachePathForKey contents:data attributes:nil];
        //缓存成功之后，从内存中删除
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.memoryCache removeObjectForKey:key];
        });
    });
}

- (NSData *)queryCacheForKey:(NSString *)key{
    if(!key){
        return nil;
    }
    NSData *data = [self.memoryCache objectForKey:key];
    if(data == nil){
        NSString *cachePathForKey = [self defaultCachePathForKey:key];
        data = [[NSData alloc] initWithContentsOfFile:cachePathForKey];
    }
    return data;
}

- (void)queryCacheForKey:(NSString *)key completed:(BGNetworkCacheQueryCompletedBlock)block{
    if(!key || !block){
        return;
    }
    NSData *data = [self.memoryCache objectForKey:key];
    if(data == nil){
        dispatch_async(self.workQueue, ^{
            NSString *cachePathForKey = [self defaultCachePathForKey:key];
            NSData *diskData = [[NSData alloc] initWithContentsOfFile:cachePathForKey];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(diskData);
            });
        });
    }
    else{
        block(data);
    }
}

- (void)removeCacheForKey:(NSString *)key{
    dispatch_async(self.workQueue, ^{
        NSString *cachePathForKey = [self defaultCachePathForKey:key];
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

- (void)queryObjectForKey:(NSString *)key completed:(BGNetworkCacheQueryCompletedBlock)block{
    if(!key || !block){
        return;
    }
    [self queryCacheForKey:key completed:^(NSData *data) {
        id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        block(object);
    }];
}

// Init the disk cache
-(NSString *)makeDiskCachePath:(NSString*)fullNamespace{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:fullNamespace];
}

- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path {
    NSString *filename = [BGNetworkUtil md5:key];
    return [path stringByAppendingPathComponent:filename];
}

- (NSString *)defaultCachePathForKey:(NSString *)key {
    return [self cachePathForKey:key inPath:self.diskCachePath];
}
@end
