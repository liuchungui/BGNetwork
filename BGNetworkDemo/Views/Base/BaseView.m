//
//  BaseView.m
//  Hands-Seller
//
//  Created by guobo on 14-4-18.
//  Copyright (c) 2014年 李 家伟. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView
+(id)loadFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
}

- (void)fillViewWithObject:(id)object{
    
}


@end
