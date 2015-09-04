//
//  BaseView.h
//  Hands-Seller
//
//  Created by guobo on 14-4-18.
//  Copyright (c) 2014年 李 家伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView
/**
 *  @brief 以对应的类名来加载xib文件
 *
 *  @return 返回对应的视图对象
 */
+ (id)loadFromXib;

/**
 *  @brief 通过object来填充视图
 *
 *  @param object 数据对象
 */
- (void)fillViewWithObject:(id)object;


/**
 *  @brief 通过数据对象来确定当前视图的尺寸和位置
 *
 *  @param object 数据对象
 *
 *  @return 当前视图的frame
 */
- (CGRect)frameForObject:(id)object;

@end
