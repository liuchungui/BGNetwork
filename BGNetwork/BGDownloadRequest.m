//
//  BGDownloadRequest.m
//  BGNetworkDemo
//
//  Created by user on 15/12/21.
//  Copyright © 2015年 BGNetwork https://github.com/liuchungui/BGNetwork/tree/dev. All rights reserved.
//

#import "BGDownloadRequest.h"
#import "BGNetworkManager.h"

static NSUInteger _requestIdentifier = 0;
@implementation BGDownloadRequest

- (instancetype)init{
    if(self = [super init]){
        _requestIdentifier += 1;
    }
    return self;
}

#pragma mark - set or get method
- (NSUInteger)requestIdentifier {
    return _requestIdentifier;
}

- (NSDictionary *)parametersDic{
    return [NSDictionary dictionary];
}

- (NSDictionary *)requestHTTPHeaderFields {
    return [NSDictionary dictionary];
}

@end

@implementation BGDownloadRequest (BGNetworkManager)
- (void)sendRequestWithProgress:(void (^)(NSProgress * _Nonnull))downloadProgressBlock success:(void (^)(NSURLResponse * _Nonnull, NSURL * _Nullable))successCompletionBlock failure:(void (^)(NSError * _Nullable))failureCompletionBlock {
    [[BGNetworkManager sharedManager] sendRequest:self progress:downloadProgressBlock success:successCompletionBlock failure:failureCompletionBlock];
}

/**
 *  取消请求
 */
- (void)cancelRequest {
    [[BGNetworkManager sharedManager] cancelDownloadRequest:self];
}

@end
