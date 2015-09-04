//
//  BGAFRequestSerializer.m
//  BGNetwork
//
//  Created by user on 15/8/20.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "BGAFRequestSerializer.h"

@implementation BGAFRequestSerializer
- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request withParameters:(id)parameters error:(NSError *__autoreleasing *)error{
    if(_delegate == nil){
        return [super requestBySerializingRequest:request withParameters:parameters error:error];
    }
    return [_delegate requestSerializer:self request:request withParameters:parameters error:error];
}
@end
