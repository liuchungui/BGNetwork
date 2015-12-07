//
//  UIView+Extra.h
//  CropAvatarImgDemo
//
//  Created by 杨社兵 on 15/8/23.
//  Copyright (c) 2015年 FAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extra)

/**
 *  Sets the current view of "origin" attribute directly
 *  Mean view.frame.origin = origin;
 */
@property CGPoint origin;

/**
 *  Sets the current view of "size" attribute directly
 *  Means view.frame.size = size;
 */
@property CGSize size;

/**
 *  Sets the current view of "height" attribute directly
 *  Means view.frame.size.height = height;
 */
@property CGFloat height;

/**
 *  Sets the current view of "width" attribute directly
 *  Means view.frame.size.width = width;
 */
@property CGFloat width;

/**
 *  Sets the current view of "top" attribute directly
 *  Means view.frame.origin.y = top;
 */
@property CGFloat top;

/**
 *  Sets the current view of "left" attribute directly
 *  Means view.frame.origin.x = left;
 */
@property CGFloat left;

/**
 *  Sets the current view of "bottom" attribute directly
 *  Means view.frame.origin.y + view.frame.size.height = bottom;
 */
@property CGFloat bottom;

/**
 *  Sets the current view of "right" attribute directly
 *  Means view.frame.origin.x + view.frame.size.width = right;
 */
@property CGFloat right;

/**
 *  Sets the current view of "centerX" attribute directly
 *  Means view.center.x = centerX;
 */

@property (nonatomic) CGFloat centerX;

/**
 *  Sets the current view of "centerY" attribute directly
 *  Means view.center.y = centerY;
 */
@property (nonatomic) CGFloat centerY;

@end
