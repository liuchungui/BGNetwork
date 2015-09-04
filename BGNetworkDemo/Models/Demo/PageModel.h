//
//  PageModel.h
//  DemoNetwork
//
//  Created by user on 15/5/13.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "BaseModel.h"

@interface PageModel : BaseModel
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSArray *list;
@end
