//
//  ViewController.m
//  DemoNetwork
//
//  Created by user on 15/5/12.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "ViewController.h"
#import "RefreshTableView.h"
#import "LayoutMacro.h"
#import "DemoCell.h"
#import "PageModel.h"
#import "DemoRequest.h"
#import "BGBatchRequest.h"
#import <objc/runtime.h>

static const char *BGNetworkRequestMethodNameKey = "BGNetworkRequestMethodNameKey";
@interface ViewController ()<RefreshTableViewDelegate>{
    RefreshTableView *_tableView;
    NSMutableArray *_dataArr;
    NSInteger _pageSize;
    NSInteger _page;
}

@end

@implementation ViewController
- (void)dealloc {
//    NSLog(@"%@ delloc", NSStringFromClass(self.class));
}

- (void)setAssociateValue:(NSString *)value {
    objc_setAssociatedObject([self class], BGNetworkRequestMethodNameKey, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)getAssociateValue {
    return objc_getAssociatedObject([self class], BGNetworkRequestMethodNameKey);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAssociateValue:@"my name is"];
    NSLog(@"%@", [self getAssociateValue]);
    
    [self setupViews];
    [self setupData];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setupData{
    _page = 0;
    _pageSize = 10;
    _dataArr = [NSMutableArray array];
    [self requestData];
}

- (void)requestData{
    DemoRequest *request = [[DemoRequest alloc] initPage:_page pageSize:_pageSize];
    [request sendRequestWithSuccess:^(BGNetworkRequest *request, id response) {
        [self request:request successWithResponse:response];
    } businessFailure:^(BGNetworkRequest *request, id response) {
        [self request:request businessFailureWithResponse:response];
    } networkFailure:^(BGNetworkRequest *request, NSError *error) {
        [self request:request failureWithNetworkError:error];
    }];
}

- (void)setupViews{
    _tableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight-64.0) withRefreshHeadView:YES withRefreshFootView:YES];
    _tableView.delegate = self;
    _tableView.isCompleted = NO;
    _tableView.isRemoveFootViewWhenLoadMoreCompleted = NO;
    [self.view addSubview:_tableView];
}

#pragma mark RefreshTableViewDelegate method
- (NSInteger)numberOfSectionsInRefreshTableView:(RefreshTableView *)tableView{
    return 1;
}

- (NSInteger)refreshTableView:(RefreshTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (CGFloat)refreshTableView:(RefreshTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (UITableViewCell *)refreshTableView:(RefreshTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DemoCell *cell = [tableView dequeueReusableCellWithIdentifier:[DemoCell cellIdentifier]];
    if(cell == nil){
        cell = [DemoCell loadFromXib];
    }
    [cell fillCellWithObject:_dataArr[indexPath.row]];
    return cell;
}

- (void)refreshTableView:(RefreshTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView stopPullDownRefresh];
}

//下拉刷新
- (void)pullDownRefreshTableView:(RefreshTableView *)tableView{
    _page = 0;
    [self requestData];
}

//上拉加载
- (void)pullUpRefreshTableView:(RefreshTableView *)tableView{
    _page ++;
    [self requestData];
}

#pragma mark - BGNetworkRequestDelegate method
- (void)request:(BGNetworkRequest *)request successWithResponse:(id)response{
    if(![response isKindOfClass:[PageModel class]]){
        return;
    }
    PageModel *resultModel = response;
    //下拉刷新
    if(_page == 0){
        [_dataArr removeAllObjects];
        [_dataArr addObjectsFromArray:resultModel.list];
    }
    else{
        [_dataArr addObjectsFromArray:resultModel.list];
    }
    //加载完成，改变tableView状态
    if((_page+1)*_pageSize >= resultModel.count){
        _tableView.isCompleted = YES;
    }
    else{
        _tableView.isCompleted = NO;
    }
    [_tableView reloadData];
}

- (void)request:(BGNetworkRequest *)request failureWithNetworkError:(NSError *)error {
    NSLog(@"网络失败：%@", error);
}

- (void)request:(BGNetworkRequest *)request businessFailureWithResponse:(id)response {
    NSLog(@"业务失败：%@", response);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
