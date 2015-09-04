//
//  BGAFRequestSerializer.h
//  BGNetwork
//
//  Created by user on 15/8/20.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "AFURLRequestSerialization.h"
@protocol BGAFRequestSerializerDelegate;

@interface BGAFRequestSerializer : AFHTTPRequestSerializer
@property (nonatomic, weak) id<BGAFRequestSerializerDelegate> delegate;
@end

@protocol BGAFRequestSerializerDelegate <NSObject>

@required
- (NSURLRequest *)requestSerializer:(BGAFRequestSerializer *)requestSerializer request:(NSURLRequest *)request withParameters:(id)parameters error:(NSError *__autoreleasing *)error;

@end
