//
//  BGNetworkManager.h
//  BGNetwork
//
//  Created by user on 15/8/14.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGNetworkConnector.h"
#import "BGNetworkConfiguration.h"
#import "BGNetworkRequest.h"
#import "BGNetworkCache.h"

/**
 *  网络管理内，是一个单例，需要创建一个网络配置给此类使用
 */
@interface BGNetworkManager : NSObject
+ (instancetype)sharedManager;
/**
 *  网络连接者
 */
@property (nonatomic, strong, readonly) BGNetworkConnector *connector;

/**
 *  网络缓存
 */
@property (nonatomic, strong, readonly) BGNetworkCache *cache;

/**
 *  设置网络配置
 */
@property (nonatomic, strong, readonly) BGNetworkConfiguration *configuration;

/**
 *  设置网络配置
 *
 *  @param configuration 网络配置
 */
- (void)setNetworkConfiguration:(BGNetworkConfiguration *)configuration;

/**
 *  发送请求
 *
 *  @param request 请求
 */
- (void)managerSendRequest:(BGNetworkRequest *)request;

/**
 *  取消请求
 *
 *  @param url 取消请求的url
 */
- (void)cancelRequestWithUrl:(NSString *)url;
@end
