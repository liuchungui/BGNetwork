//
//  BGUtilFunction.h
//  BGNetworkDemo
//
//  Created by user on 15/12/24.
//  Copyright © 2015年 BGNetwork https://github.com/liuchungui/BGNetwork/tree/dev. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  生成MD5
 */
FOUNDATION_EXPORT NSString * const _Nonnull BG_MD5(NSString * _Nonnull value);

/**
 *  生成queryString
 */
FOUNDATION_EXPORT NSString * const _Nonnull BGQueryStringFromParamDictionary(NSDictionary * _Nonnull paramDic);

/**
 *  由参数、方法名、URL生成一个唯一的key
 */
FOUNDATION_EXPORT NSString * const _Nonnull BGKeyFromParamsAndURLString(NSDictionary * _Nullable paramDic, NSString * _Nonnull URLString);
