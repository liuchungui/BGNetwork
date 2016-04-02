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
@property (nonatomic, weak) _Nullable id<BGAFRequestSerializerDelegate> delegate;
@end

@protocol BGAFRequestSerializerDelegate <NSObject>

@required
- ( NSURLRequest * _Nonnull )requestSerializer:( BGAFRequestSerializer * _Nonnull )requestSerializer request:( NSURLRequest * _Nonnull )request withParameters:(id _Nullable)parameters error:(NSError *  _Nullable __autoreleasing * _Nullable)error;

@end
