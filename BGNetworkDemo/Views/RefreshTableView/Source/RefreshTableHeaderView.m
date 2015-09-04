//
//  RefreshTableHeaderView.m
//
//  Created by verne on 15/5/8.
//  Copyright (c) 2015年 家伟 李. All rights reserved.
//


#import "RefreshTableHeaderView.h"

const CGFloat kMaxOffsetYToFrefresh = 65.0f;

@interface RefreshTableHeaderView (Private)
- (void)setState:(PullRefreshState)aState;
@end

@implementation RefreshTableHeaderView
@synthesize delegate=_delegate;


- (id)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor arrowImageName:(NSString *)arrow rotateImageName:(NSString *)rotate
{
    if((self = [super initWithFrame:frame]))
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = textColor;
        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.hidden = YES;
        [self addSubview:label];
        _lastUpdatedLabel=label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 36.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor lightGrayColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel=label;
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(self.frame.size.width/2-65, frame.size.height - 32.25f, 9, 12.5);
        layer.contentsGravity = kCAGravityResizeAspect;
        UIImage *arrowImg = [UIImage imageNamed:arrow];
        if(!arrowImg)
        {
            arrowImg = [UIImage imageNamed:@"_refresh_arrow.png"];
        }
        layer.contents = (id)arrowImg.CGImage;
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            layer.contentsScale = [[UIScreen mainScreen] scale];
        }
#endif
        
        [[self layer] addSublayer:layer];
        _arrowImage=layer;
        
        [self setState:PullRefreshNormal];
        UIImage *rotateImg = [UIImage imageNamed:rotate];
        if(!rotateImg)
        {
            rotateImg = [UIImage imageNamed:@"_refresh_rotate.png"];
        }
        _statusImageView = [[UIImageView alloc]initWithImage:rotateImg];
        [self addSubview:_statusImageView];
        _statusImageView.frame = CGRectMake(self.frame.size.width/2-65, frame.size.height - 33.0f, 14, 14);
        _statusImageView.hidden = YES;
        [self startImageViewAnimation];
    }
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame textColor:[UIColor lightGrayColor] arrowImageName:@"refresh_arrow.png" rotateImageName:@"refresh_rotate.png"];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate
{
    
    if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceLastUpdated:)]) {
        
        NSDate *date = [_delegate refreshTableHeaderDataSourceLastUpdated:self];
        
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        _lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", [RefreshTimeHelper  formatTime:date]];
        [[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"RefreshTableView_LastRefresh"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else
    {
        _lastUpdatedLabel.text = nil;
    }
    
}

- (void)setState:(PullRefreshState)aState
{
    switch (aState)
    {
        case PullRefreshPulling:
            _statusLabel.text = TEXT_PULL_UP_RELEX;
            _arrowImage.hidden = NO;
            _statusImageView.hidden = YES;
            break;
        case PullRefreshNormal:
            _arrowImage.hidden = NO;
            _statusImageView.hidden = YES;
            [_activityView stopAnimating];
            _statusLabel.text = TEXT_PULL_UP_TITLE;
            [self refreshLastUpdatedDate];
            break;
        case PullRefreshLoading:
            _statusImageView.hidden = NO;
            _statusLabel.text = TEXT_PULL_LOADING;
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImage.hidden = YES;
            [CATransaction commit];
            // 让剪头朝下
            _arrowImage.transform = CATransform3DMakeRotation(0, 0, 0, 1);
            break;
    }
    _state = aState;
}

- (void)startImageViewAnimation
{
    if (_statusImageView.layer.animationKeys) {
        return;
    }
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: (-1 * M_PI * 2.0) ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = .5f;
    rotationAnimation.repeatCount = MAXFLOAT;//你可以设置到最大的整数值
    rotationAnimation.cumulative = YES;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeBackwards;
    [_statusImageView.layer addAnimation:rotationAnimation forKey:@"Rotation"];
}

- (void)stopAnimatingView:(UIView*)animatingView
{
    [animatingView.layer removeAllAnimations];
    animatingView.hidden = YES;
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (_state == PullRefreshLoading)
    {
        CGFloat offset = MAX(offsetY * -1, 0);
        offset = MIN(offset, kMaxOffsetYToFrefresh);
        // 正在刷新的时候，把Scrollview固定
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
    }
    else if (scrollView.isDragging)
    {
        BOOL _loading = NO;
        if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
            _loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
        }
        
        if (_state == PullRefreshPulling && offsetY > -kMaxOffsetYToFrefresh && offsetY < 0.0f && !_loading)
        {
            [self setState:PullRefreshNormal];
        }
        else if (_state == PullRefreshNormal && offsetY < -kMaxOffsetYToFrefresh && !_loading)
        {
            [self setState:PullRefreshPulling];
        }
        if(!_loading)
        {
            _arrowImage.hidden = NO;
            offsetY = MAX(-kMaxOffsetYToFrefresh, offsetY);
            _arrowImage.transform = CATransform3DMakeRotation(offsetY / kMaxOffsetYToFrefresh * M_PI, 0, 0, 1);
        }
        
        if (scrollView.contentInset.top != 0)
        {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
    
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView
{
    
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(refreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate refreshTableHeaderDataSourceIsLoading:self];
    }
    
    if (scrollView.contentOffset.y <= -kMaxOffsetYToFrefresh && !_loading)
    {
        [self setState:PullRefreshLoading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                [scrollView setContentOffset:CGPointMake(0, -kMaxOffsetYToFrefresh) animated:NO];
            }completion:^(BOOL finished) {
                if ([_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
                    [_delegate refreshTableHeaderDidTriggerRefresh:self];
                }
            }];
        });
        
    }
    
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];
    [self setState:PullRefreshNormal];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
    _delegate=nil;
    _activityView = nil;
    _statusLabel = nil;
    _arrowImage = nil;
    _lastUpdatedLabel = nil;
}
@end
