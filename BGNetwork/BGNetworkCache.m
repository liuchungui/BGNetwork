//
//  BGNetworkCache.m
//  BGNetwork
//
//  Created by user on 15/8/21.
//  Copyright © 2015年 BGNetwork https://github.com/liuchungui/BGNetwork/tree/dev. All rights reserved.
//

#import "BGNetworkCache.h"
#import "BGUtilFunction.h"

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

#pragma mark - cache data for fileName
- (void)storeObject:(id<NSCoding> _Nonnull)object forFileName:(NSString * _Nonnull)fileName {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [self storeData:data forFileName:fileName];
}

- (void)storeData:(NSData *)data forFileName:(NSString *)fileName completion:(BGNetworkCacheCompletionBlock _Nullable)comletionBlock{
    if(!data | !fileName){
        return;
    }
    
    //缓存到内存
    NSString *key = BG_MD5(fileName);
    [self.memoryCache setObject:data forKey:key cost:data.length];
    
    //缓存到本地
    dispatch_async(self.workQueue, ^{
        // get cache Path for data key
        NSString *cachePathForKey = [self defaultCachePathForFileName:key];
        if([_fileManager fileExistsAtPath:cachePathForKey isDirectory:nil]) {
            [_fileManager removeItemAtPath:cachePathForKey error:nil];
        }
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
    NSString *key = BG_MD5(fileName);
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
    NSString *key = BG_MD5(fileName);
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
        NSString *cachePath = [self defaultCachePathForFileName:fileName];
        NSData *diskData = [[NSData alloc] initWithContentsOfFile:cachePath];
        dispatch_async(dispatch_get_main_queue(), ^{
            comletionBlock(diskData);
        });
    });
}

- (void)removeCacheForFileName:(NSString *)fileName {
    //remove memory data
    NSString *key = BG_MD5(fileName);
    [self.memoryCache removeObjectForKey:key];
    
    //remove disk data
    dispatch_async(self.workQueue, ^{
        NSString *cachePathForKey = [self defaultCachePathForFileName:fileName];
        [_fileManager removeItemAtPath:cachePathForKey error:nil];
    });
}

// Init the disk cache
-(NSString *)makeDiskCachePath:(NSString*)fullNamespace{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:fullNamespace];
}

- (NSString *)cachePathForFileName:(NSString *)fileName inPath:(NSString *)path {
    return [path stringByAppendingPathComponent:fileName];
}

- (NSString *)defaultCachePathForFileName:(NSString *)fileName {
    return [self cachePathForFileName:fileName inPath:self.diskCachePath];
}
@end
