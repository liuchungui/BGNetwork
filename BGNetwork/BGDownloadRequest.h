//
//  BGDownloadRequest.h
//  BGNetworkDemo
//
//  Created by user on 15/12/21.
//  Copyright © 2015年 BGNetwork https://github.com/liuchungui/BGNetwork/tree/dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGNetworkRequest.h"

@interface BGDownloadRequest : NSObject
/**
 *  请求标识码，每个请求都拥有唯一的标示
 */
@property (nonatomic, assign, readonly) NSUInteger requestIdentifier;

/**
 *  方法名
 */
@property (nonatomic, strong) NSString * _Nonnull methodName;

/**
 *  参数字典
 */
@property (nonatomic, copy, readonly) NSDictionary * _Nonnull parametersDic;

/**
 *  请求头
 */
@property (nonatomic, copy, readonly) NSDictionary * _Nonnull requestHTTPHeaderFields;

@end

#pragma mark - BGNetworkRequest(BGNetworkManager)
@interface BGDownloadRequest (BGNetworkManager)
/**
 *  取消请求
 */
- (void)cancelRequest;

- (void)sendRequestWithProgress:(nullable void (^)(NSProgress * _Nonnull downloadProgress)) downloadProgressBlock
                        success:(nullable void (^)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath))successCompletionBlock
                        failure:(nullable void (^)(NSError * _Nullable error))failureCompletionBlock;
@end


