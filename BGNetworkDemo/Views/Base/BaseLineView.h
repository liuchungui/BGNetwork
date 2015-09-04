//
//  BaseLineView.h
//  TCGroupLeader
//
//  Created by user on 15/5/18.
//  Copyright (c) 2015年 www.tuanche.com. All rights reserved.
//

#import "BaseView.h"
/**
 *  线的宽度
 */
UIKIT_EXTERN const CGFloat BaseLineViewLineWidth;
/** 底部有下划线的view */
@interface BaseLineView : BaseView
/**
 *  画线的颜色
 */
@property (nonatomic, strong) UIColor *lineColor;
@end
