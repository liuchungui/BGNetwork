//
//  RefreshTableView.m
//
//  Created by verne on 15/5/8.
//  Copyright (c) 2015年 家伟 李. All rights reserved.
//

#import "RefreshTableView.h"
#import "RefreshTableHeaderView.h"
#import "RefreshTableFooterView.h"

@interface RefreshTableView()<UITableViewDataSource,UITableViewDelegate,RefreshTableHeaderDelegate,UIScrollViewDelegate>
{
    UITableView*                            _pullTableView;
    RefreshTableHeaderView*              _refreshHeadView;
    RefreshTableFooterView*              _refreshFootView;
    BOOL                                    _isHeadRefreshViewLoading;
    BOOL                                    _isFootRefreshViewLoading;
    /**
     *  点击了外部按钮来刷新
     */
    BOOL                                    _isOutRefreshViewLoading;
    BOOL                                    _isHeadRefreshViewExsit;
    BOOL                                    _isFootRefreshViewExsit;
}

@end

@implementation RefreshTableView

#pragma mark lifecycle method
-(void)dealloc
{
    _delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [[[self class]alloc]initWithFrame:frame withRefreshHeadView:NO withRefreshFootView:NO];
    return self;
}

- (id)initWithFrame:(CGRect)frame withRefreshHeadView:(BOOL)isHeadRefreshViewExsit withRefreshFootView:(BOOL)isFootRefreshViewExsit
{
    self = [super initWithFrame:frame];
    _loadMorePostion = 200;
    
    if (self)
    {
        _pullTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        
        _pullTableView.delegate = self;
        _pullTableView.dataSource = self;
        
        [self addSubview:_pullTableView];
        
        self.autoresizingMask = _pullTableView.autoresizingMask;
        
        _pullTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        
        _pullTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        [self showHeadRefreshView:isHeadRefreshViewExsit];
        [self showFootRefreshView:isFootRefreshViewExsit];
        if(_refreshHeadView)
        {
            [_refreshHeadView refreshLastUpdatedDate];
        }
    }
    return self;
}

- (CGFloat)getOffsetY
{
    return _pullTableView.contentOffset.y;
}


#pragma mark public method
-(UITableView*)getTableView
{
    return _pullTableView;
}

-(void)showHeadRefreshView:(BOOL)isExist
{
    _isHeadRefreshViewExsit = isExist;
    if (_isHeadRefreshViewExsit)
    {
        _refreshHeadView = [[RefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        _refreshHeadView.delegate = self;
        [_pullTableView addSubview:_refreshHeadView];
    }
}

-(void)showFootRefreshView:(BOOL)isExist
{
    _isFootRefreshViewExsit = isExist;
    if (_isFootRefreshViewExsit)
    {
        _refreshFootView = [RefreshTableFooterView loadFromXib];
        _pullTableView.tableFooterView = _refreshFootView;
        _pullTableView.tableFooterView.alpha = 0;
    }
}

-(void)refreshView
{
    [UIView animateWithDuration:0.3 animations:^{
        _pullTableView.contentInset = UIEdgeInsetsMake(65, 0, 0, 0);
    }completion:^(BOOL finished) {
        if ([self getOffsetY]<=0 && _refreshHeadView)
        {
            return [_refreshHeadView refreshScrollViewDidEndDragging:_pullTableView];
        }
    }];
}

-(void)reloadData
{
    if (_isHeadRefreshViewLoading)
    {
        [_pullTableView reloadData];
        [_refreshHeadView refreshScrollViewDataSourceDidFinishedLoading:_pullTableView];
    }
    else
    {
        [_pullTableView reloadData];
    }
    _isHeadRefreshViewLoading = NO;
    _isFootRefreshViewLoading = NO;
    _isOutRefreshViewLoading = NO;
}
-(void)stopPullDownRefresh
{
    if (_isHeadRefreshViewLoading)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_refreshHeadView refreshScrollViewDataSourceDidFinishedLoading:_pullTableView];
        });
    }
    
    _isHeadRefreshViewLoading = NO;
    _isFootRefreshViewLoading = NO;
    _isOutRefreshViewLoading = NO;
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    return [_pullTableView dequeueReusableCellWithIdentifier:identifier];
}

-(void)setSeperatorLine:(UITableViewCellSeparatorStyle)style
{
    _pullTableView.separatorStyle = style;
}

-(void)setTableHeadView:(UIView*)headView
{
    _pullTableView.tableHeaderView = headView;
    [_pullTableView bringSubviewToFront:_refreshHeadView];
}

-(void)setTableFootView:(UIView*)footView
{
    _pullTableView.tableFooterView = footView;
}

-(void)refreshData
{
    _isFootRefreshViewLoading = NO;
    _isHeadRefreshViewLoading = NO;
    _isOutRefreshViewLoading = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(manualRefreshTableView:)]) {
        [_delegate manualRefreshTableView:self];
    }
}
#pragma mark UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"isheader:%zd,isfooter:%zd",_isHeadRefreshViewLoading,_isFootRefreshViewLoading);
    //  是否有外部按钮刷
    if (_isOutRefreshViewLoading)
    {
        return;
    }
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_delegate scrollViewDidScroll:_pullTableView];
    }
    //  下拉
    if ([self getOffsetY]<=0 && _refreshHeadView)
    {
        [_refreshHeadView refreshScrollViewDidScroll:scrollView];
    }
    //  上拉，且还有没加载的数据
    else if(_isFootRefreshViewExsit)
    {
        // load more
        if(!_isCompleted && [self getOffsetY] + _pullTableView.frame.size.height + _loadMorePostion >= _pullTableView.contentSize.height)
        {
            if (!_isFootRefreshViewLoading && !_isHeadRefreshViewLoading)
            {
                if (_delegate && [_delegate respondsToSelector:@selector(pullUpRefreshTableView:)])
                {
                    if (_pullTableView.contentSize.height>_pullTableView.frame.size.height)
                    {
                        _isFootRefreshViewLoading = YES;
                        _pullTableView.tableFooterView = _refreshFootView;
                        _pullTableView.tableFooterView.alpha = 1;
                        [_delegate pullUpRefreshTableView:self];
                    }
                }
            }
        }
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y<=0 && _refreshHeadView)
    {
        return [_refreshHeadView refreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark UITableViewDelegate & UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_delegate refreshTableView:self cellForRowAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_delegate refreshTableView:self heightForRowAtIndexPath:indexPath];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_pullTableView.numberOfSections == section + 1)
    {
        if (_refreshFootView)
        {
            if (!_isCompleted)
            {
                [_refreshFootView viewLayoutWithStype:RefreshTableView_FOOT_VIEW_LOADING];
            }
            else
            {
                if(!_isRemoveFootViewWhenLoadMoreCompleted)
                {
                    [_refreshFootView viewLayoutWithStype:RefreshTableView_FOOT_VIEW_NO_MORE];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        _pullTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
                    });
                }
            }
        }
    }
    return [_delegate refreshTableView:self numberOfRowsInSection:section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfSectionsInRefreshTableView:)])
    {
        return [_delegate numberOfSectionsInRefreshTableView:self];
    }
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(refreshTableView:didSelectRowAtIndexPath:)])
    {
        [_delegate refreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_delegate && [_delegate respondsToSelector:@selector(refreshTableView:heightForHeaderInSection:)])
    {
        return [_delegate refreshTableView:self heightForHeaderInSection:section];
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_delegate && [_delegate respondsToSelector:@selector(refreshTableView:viewForHeaderInSection:)])
    {
        return [_delegate refreshTableView:self viewForHeaderInSection:section];
    }
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_delegate && [_delegate respondsToSelector:@selector(refreshTableView:viewForFooterInSection:)])
    {
        return [_delegate refreshTableView:self viewForFooterInSection:section];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_delegate && [_delegate respondsToSelector:@selector(refreshTableView:heightForFooterInSection:)])
    {
        return [_delegate refreshTableView:self heightForFooterInSection:section];
    }
    return 0;
}

/*
 *删除 编辑
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(refreshTableView:canEditRowAtIndexPath:)])
    {
        return [_delegate refreshTableView:self canEditRowAtIndexPath:indexPath];
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(refreshTableView:editingStyleForRowAtIndexPath:)])
    {
        return [_delegate refreshTableView:self editingStyleForRowAtIndexPath:indexPath];
    }
    return UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(refreshTableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)])
    {
        return [_delegate refreshTableView:self titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (void)tableView:(RefreshTableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(refreshTableView:commitEditingStyle:forRowAtIndexPath:)])
    {
        [_delegate refreshTableView:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(refreshTableView:didDeselectRowAtIndexPath:)])
    {
        [_delegate refreshTableView:self didDeselectRowAtIndexPath:indexPath];
    }
}

-(void)reloadSections:(NSIndexPath*)indexPath
{
    [_pullTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark RefreshTableHeaderDelegate
- (void)refreshTableHeaderDidTriggerRefresh:(RefreshTableHeaderView*)view
{
    _isHeadRefreshViewLoading = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(pullDownRefreshTableView:)])
    {
        [_delegate pullDownRefreshTableView:self];
    }
}
- (BOOL)refreshTableHeaderDataSourceIsLoading:(RefreshTableHeaderView*)view
{
    return _isHeadRefreshViewLoading;
}

- (NSDate*)refreshTableHeaderDataSourceLastUpdated:(RefreshTableHeaderView*)view
{
    return [NSDate date];
}


#pragma mark private method


@end
