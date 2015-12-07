//
//  UIView+Extra.m
//  CropAvatarImgDemo
//
//  Created by 杨社兵 on 15/8/23.
//  Copyright (c) 2015年 FAL. All rights reserved.
//

#import "UIView+Extra.h"

@implementation UIView (Extra)

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)point
{
    CGRect tempFrame = self.frame;
    tempFrame.origin = point;
    self.frame = tempFrame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)tempSize
{
    CGRect tempFrame = self.frame;
    tempFrame.size = tempSize;
    self.frame = tempFrame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)tempHeight
{
    CGRect tempFrame = self.frame;
    tempFrame.size.height = tempHeight;
    self.frame = tempFrame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)tempWidth
{
    CGRect tempFrame = self.frame;
    tempFrame.size.width = tempWidth;
    self.frame = tempFrame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)tempTop
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = tempTop;
    self.frame = tempFrame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)tempLeft
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = tempLeft;
    self.frame = tempFrame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)tempBottom
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.y = tempBottom - self.frame.size.height;
    self.frame = tempFrame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)tempRight
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = tempRight - tempFrame.size.width ;
    self.frame = tempFrame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

@end
