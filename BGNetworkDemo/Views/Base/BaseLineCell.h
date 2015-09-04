//
//  BaseLineCell.h
//  I500user
//
//  Created by user on 15/4/10.
//  Copyright (c) 2015年 家伟 李. All rights reserved.
//

#import "BaseCell.h"

/** 底部带线的cell */
@interface BaseLineCell : BaseCell
/** 下划线的颜色 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 *  请使用customBackgroundColor代替
 */
@property (nonatomic, strong) UIColor *backgroundColor NS_DEPRECATED_IOS(2_0, 2_1);

/**
 *  设置背景色
 */
@property (nonatomic, strong) UIColor *customBackgroundColor;

/**
 *  线距离左右的空白，默认为0
 */
@property (nonatomic, assign) CGFloat lineMargin;
@end
