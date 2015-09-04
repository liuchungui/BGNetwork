//
//  BaseCollectionViewCell.m
//  TCGroupLeader
//
//  Created by vernepung on 15/5/22.
//  Copyright (c) 2015年 www.tuanche.com. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell


+(id)loadFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
}

- (void)awakeFromNib
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    // Initialization code
}

+(NSString*)cellIdentifier
{
    return NSStringFromClass(self);
}

@end
