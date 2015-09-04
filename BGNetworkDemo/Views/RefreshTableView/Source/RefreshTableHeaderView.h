//
//  RefreshTableHeaderView.h
//
//  Created by verne on 15/5/8.
//  Copyright (c) 2015年 家伟 李. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RefreshConstant.h"
#import "RefreshTimeHelper.h"


@protocol RefreshTableHeaderDelegate;
@interface RefreshTableHeaderView : UIView {
    
    __unsafe_unretained id _delegate;
    PullRefreshState _state;
    /**
     *  时间label
     */
    UILabel *_lastUpdatedLabel;
    /**
     *  状态label
     */
    UILabel *_statusLabel;
    /**
     *  箭头图标
     */
    CALayer *_arrowImage;
    /**
     *  loading图
     */
    UIActivityIndicatorView *_activityView;
    /**
     *  Description
     */
    UIImageView           *_statusImageView;
    
}

@property(nonatomic,assign) id <RefreshTableHeaderDelegate> delegate;

- (id)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor arrowImageName:(NSString *)arrow rotateImageName:(NSString *)rotate;

- (void)refreshLastUpdatedDate;
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
@protocol RefreshTableHeaderDelegate
- (void)refreshTableHeaderDidTriggerRefresh:(RefreshTableHeaderView*)view;
- (BOOL)refreshTableHeaderDataSourceIsLoading:(RefreshTableHeaderView*)view;
@optional
- (NSDate*)refreshTableHeaderDataSourceLastUpdated:(RefreshTableHeaderView*)view;
@end
