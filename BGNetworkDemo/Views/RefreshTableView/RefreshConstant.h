//
//  RefreshConstant.h
//
//  Created by verne on 15/5/8.
//  Copyright (c) 2015年 家伟 李. All rights reserved.
//


#ifndef PublicProject_RefreshConstant_h
#define PublicProject_RefreshConstant_h
#define TEXT_PULL_UP_TITLE @"下拉刷新"
#define TEXT_PULL_UP_RELEX @"松开即可刷新"
#define TEXT_PULL_LOADING @"加载中..."

typedef enum{
    /**
     *  正在拉动
     */
	PullRefreshPulling = 0,
    /**
     *  已经超出刷新offsetY的临界值
     */
	PullRefreshNormal,
    /**
     *  正在执行动画
     */
	PullRefreshLoading,
} PullRefreshState;

#endif
