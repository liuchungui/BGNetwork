//
//  RefreshTableFooterView.m
//
//  Created by verne on 15/5/8.
//  Copyright (c) 2015年 家伟 李. All rights reserved.
//


#import "RefreshTableFooterView.h"


@interface RefreshTableFooterView()
{
    int             _angle;
    BOOL            _isStop;
}
@property (weak, nonatomic) IBOutlet UIImageView*activityImageView;
@property (weak, nonatomic) IBOutlet UIButton *loadMoreBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation RefreshTableFooterView

-(void)dealloc
{
    [_activityImageView.layer removeAllAnimations];
}
+(id)loadFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    _angle = 0;
    [self viewLayoutWithStype:RefreshTableView_FOOT_VIEW_LOADING];
    [self startAnimation];
}

-(void)viewLayoutWithStype:(RefreshTableView_FOOT_VIEW_STATE)type
{
    UIImage *rotateImg = [UIImage imageNamed:@"refresh_rotate.png"];
    if(!rotateImg)
    {
        rotateImg = [UIImage imageNamed:@"_refresh_rotate.png"];
    }
    
    [_activityImageView setImage:rotateImg];
    float width = self.superview.frame.size.width;
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    if (type==RefreshTableView_FOOT_VIEW_NO_MORE)
    {
        [self stopAnimating];
        _activityImageView.hidden = YES;
        [_statusLabel setText:@"已显示全部"];
        [_statusLabel sizeToFit];
        _statusLabel.center = CGPointMake(self.frame.size.width/2, _statusLabel.center.y);
    }
    else
    {
        _activityImageView.hidden = NO;
        [_statusLabel setText:@"加载中..."];
        [_statusLabel sizeToFit];
        _statusLabel.center = CGPointMake(self.frame.size.width/2, _statusLabel.center.y);
        CGRect activityFrame = _activityImageView.frame;
        activityFrame.origin.x = width/2-60;
        _activityImageView.frame = activityFrame;
        self.alpha = 1;
        frame.size.height = 48;
    }
    self.frame = frame;
}
- (void)startAnimation
{
    if (_activityImageView.layer.animationKeys) {
        return;
    }
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: (-1*M_PI * 2.0) ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = 0.5f;
    rotationAnimation.repeatCount = MAXFLOAT;//你可以设置到最大的整数值
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeBackwards;
    [_activityImageView.layer addAnimation:rotationAnimation forKey:@"Rotation"];
}
-(void)endAnimation
{
    _angle -= 90;
    _angle = _angle%360;
}
-(void)stopAnimating
{
    //    _isStop = YES;
}

@end
