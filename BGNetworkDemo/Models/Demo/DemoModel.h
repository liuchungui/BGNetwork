//
//  DemoModel.h
//  DemoNetwork
//
//  Created by user on 15/5/13.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "BaseModel.h"

@interface DemoModel : BaseModel
@property (nonatomic, copy) NSString *name; //人名
@property (nonatomic, assign) NSInteger age; //年龄
@property (nonatomic, assign) NSInteger sex; //性别，0：未知 1：男 2：女
@end
