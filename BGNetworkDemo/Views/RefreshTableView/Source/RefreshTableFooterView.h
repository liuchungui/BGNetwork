//
//  RefreshTableFooterView.h
//
//  Created by verne on 15/5/8.
//  Copyright (c) 2015年 家伟 李. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    RefreshTableView_FOOT_VIEW_LOADING=0,
    RefreshTableView_FOOT_VIEW_NO_MORE
}RefreshTableView_FOOT_VIEW_STATE;
@interface RefreshTableFooterView : UIView

-(void)viewLayoutWithStype:(RefreshTableView_FOOT_VIEW_STATE)type;
+(id)loadFromXib;
@end
