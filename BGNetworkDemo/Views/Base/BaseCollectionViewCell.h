//
//  BaseCollectionViewCell.h
//  TCGroupLeader
//
//  Created by vernepung on 15/5/22.
//  Copyright (c) 2015年 www.tuanche.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewCell : UICollectionViewCell
/**
 *  用xib创建Cell
 *
 *  @return self;
 */
+(id)loadFromXib;

/**
 *  用代码创建Cell时候设置的cellIdentifier
 *
 *  @return cellIdentifier;
 */
+(NSString*)cellIdentifier;

/**
 *  填充cell的对象
 *  子类去实现
 */
- (void)fillCellWithObject:(id)object;
/**
 *  获取size
 *
 *  @param object object description
 *
 *  @return return value description
 */
+ (CGSize)sizeForObject:(id)object;
@end
