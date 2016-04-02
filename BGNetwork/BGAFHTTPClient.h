//
//  BGAFHTTPClient.h
//  BGNetwork
//
//  Created by user on 15/8/19.
//  Copyright © 2015年 BGNetwork https://github.com/liuchungui/BGNetwork/tree/dev. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface BGAFHTTPClient : AFHTTPSessionManager
/** 判断一组请求是否已经请求完成 */
- (BOOL)isHttpQueueFinished:( NSArray * _Nonnull )httpUrlArray;

/** 取消请求 */
- (void)cancelTasksWithUrl:( NSString * _Nonnull )url;
@end
