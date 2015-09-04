//
//  RefreshTableView.h
//
//  在EgoRefresh上进行的简易封装，项目原因直接改名为RefreshTableView
//
//
//  刷新需要用到的图片名称为：(参见Resource下图片
//      @"refresh_arrow.png" @"refresh_rotate.png";
//
//  Created by verne on 15/5/8.
//  Copyright (c) 2015年 家伟 李. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshConstant.h"

@protocol RefreshTableViewDelegate;
/**
 *  下拉刷新TableView
 *
 *  刷新需要用到的图片名称为，使用时需要在项目下加入：
 *      @"refresh_arrow.png" @"refresh_rotate.png"];
 *      默认为_refresh_arrow.png,_refresh_rotate.png
 */
@interface RefreshTableView : UIView

@property (weak,nonatomic) id<RefreshTableViewDelegate> delegate;

/**
 *  y到达多少之后开始加载更多
 *  默认：200
 */
@property (assign,nonatomic) NSInteger loadMorePostion;

/**
 *  是否没有更多
 */
@property (assign,nonatomic) BOOL isCompleted;
/**
 *  加载全部完成后是否移除底部View
 */
@property (assign,nonatomic) BOOL isRemoveFootViewWhenLoadMoreCompleted;

- (id)initWithFrame:(CGRect)frame withRefreshHeadView:(BOOL)isHeadRefreshViewExsit withRefreshFootView:(BOOL)isFootRefreshViewExsit;
/**
 *  获取当前View中的UITableView
 *
 *  @return UITableView
 */
-(UITableView*)getTableView;
/**
 *  设置下拉刷新是否存在
 *
 *  @param isExist
 */
-(void)showHeadRefreshView:(BOOL)isExist;
/**
 *  设置上拉刷新是否存在
 *
 *  @param isExist
 */
-(void)showFootRefreshView:(BOOL)isExist;
/**
 *  刷新UITableView的数据（注：不能直接使用UITableview的reloadData直接去刷新数据）
 */
-(void)reloadData;

/**
 *  重用Cell
 *
 *  @param identifier cell的标志
 *
 *  @return cell
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
/**
 *  设置分割线
 *
 *  @param style UITableViewCellSeparatorStyle
 */
-(void)setSeperatorLine:(UITableViewCellSeparatorStyle)style;

-(void)setTableHeadView:(UIView*)headView;
-(void)setTableFootView:(UIView*)footView;
/**
 *  手动点击刷新按钮时调用
 */
-(void)refreshData;
/**
 *  第一次加载网络请求时调用
 */
-(void)refreshView;
/*
 *@note 当数据加载失败时候，使用此方法使下拉界面恢复原状。不必调用reloadData。
 */
-(void)stopPullDownRefresh;
@end

@protocol RefreshTableViewDelegate <NSObject>
@required

-(UITableViewCell *)refreshTableView:(RefreshTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(CGFloat)refreshTableView:(RefreshTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NSInteger)refreshTableView:(RefreshTableView *)tableView numberOfRowsInSection:(NSInteger)section;
@optional
-(void)refreshTableView:(RefreshTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(CGFloat)refreshTableView:(RefreshTableView *)tableView heightForHeaderInSection:(NSInteger)section;
-(UIView*)refreshTableView:(RefreshTableView *)tableView viewForHeaderInSection:(NSInteger)section;
-(CGFloat)refreshTableView:(RefreshTableView *)tableView heightForFooterInSection:(NSInteger)section;
-(UIView*)refreshTableView:(RefreshTableView *)tableView viewForFooterInSection:(NSInteger)section;
-(NSInteger)numberOfSectionsInRefreshTableView:(RefreshTableView *)tableView;
/*
 *删除 编辑
 */
- (BOOL)refreshTableView:(RefreshTableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCellEditingStyle)refreshTableView:(RefreshTableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)refreshTableView:(RefreshTableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)refreshTableView:(RefreshTableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)refreshTableView:(RefreshTableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)scrollViewDidScroll:(UITableView*)tableView;
-(void)reloadSections:(NSIndexPath*)indexPath;
/**
 *  下拉刷新数据代理方法
 */
-(void)pullDownRefreshTableView:(RefreshTableView *)tableView;
/**
 *  上拉刷新数据代理方法
 */
-(void)pullUpRefreshTableView:(RefreshTableView *)tableView;
/**
 *  手动点击刷新按钮的代理方法
 *
 */
-(void)manualRefreshTableView:(RefreshTableView *)tableView;
-(void)autoLoadMoreRefreshTableView:(RefreshTableView *)tableView;

@end