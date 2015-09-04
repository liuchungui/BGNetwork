//
//  BaseLineCell.m
//  I500user
//
//  Created by user on 15/4/10.
//  Copyright (c) 2015年 家伟 李. All rights reserved.
//

#import "BaseLineCell.h"

/**
 *  线的宽度
 */
static const CGFloat kLineWidth = 0.5;
@interface BaseLineCell (){
}

@end
@implementation BaseLineCell
- (void)awakeFromNib{
    [super awakeFromNib];
    self.customBackgroundColor = [UIColor whiteColor];
    //ios7下，需要将这两个背景色更改成clearColor
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setCustomBackgroundColor:(UIColor *)customBackgroundColor{
    /**
     *  将背景色和contentView背景色改成透明
     */
    [super setBackgroundColor:[UIColor clearColor]];
    self.contentView.backgroundColor = [UIColor clearColor];
    _customBackgroundColor = customBackgroundColor;
    [self setNeedsDisplay];
}

- (UIColor *)backgroundColor{
    return _customBackgroundColor;
}

- (void)setLineMargin:(CGFloat)lineMargin{
    _lineMargin = lineMargin;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if(!self.lineColor){
        self.lineColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
//        self.lineColor = UIColorFromRGB(0xd9d9d9);
    }
    
    /**
     *  画背景色，若是没有设置背景色，则默认用白色
     */
    UIColor *bgColor = self.customBackgroundColor;
    if(bgColor == nil){
        [super setBackgroundColor:[UIColor clearColor]];
        self.contentView.backgroundColor = [UIColor clearColor];
        _customBackgroundColor = [UIColor whiteColor];
        bgColor = [UIColor whiteColor];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextAddRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);
    
    /**
     *  底部画一条线
     */
//    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat margin = _lineMargin;
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetLineWidth(context, kLineWidth);
    CGContextMoveToPoint(context, margin, rect.size.height-kLineWidth/2.0);
    CGContextAddLineToPoint(context, rect.size.width-2*margin, rect.size.height-kLineWidth/2.0);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
