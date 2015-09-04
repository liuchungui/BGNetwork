//
//  BaseLineView.m
//  TCGroupLeader
//
//  Created by user on 15/5/18.
//  Copyright (c) 2015年 www.tuanche.com. All rights reserved.
//

#import "BaseLineView.h"
/**
 *  线的宽度
 */
const CGFloat BaseLineViewLineWidth = 0.5;

@interface BaseLineView (){
    UIColor *_lineBackgroundColor;
}

@end
@implementation BaseLineView

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _lineBackgroundColor = backgroundColor;
    [self setNeedsDisplay];
}

- (UIColor *)backgroundColor{
    return _lineBackgroundColor;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if(!self.lineColor){
        //        self.lineColor = UIColorFromRGB(0xd9d9d9);
        self.lineColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
    }
    /**
     *  将背景色和contentView背景色改成透明
     */
    [super setBackgroundColor:[UIColor clearColor]];
    
    /**
     *  画背景色
     */
    UIColor *bgColor = _lineBackgroundColor;
    if(bgColor){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, bgColor.CGColor);
        CGContextAddRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height-BaseLineViewLineWidth/2.0));
        CGContextDrawPath(context, kCGPathFill);
        CGContextRestoreGState(context);
    }
    
    /**
     *  底部画一条线
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, BaseLineViewLineWidth);
    CGContextMoveToPoint(context, 0, rect.size.height-BaseLineViewLineWidth/2.0);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height-BaseLineViewLineWidth/2.0);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
