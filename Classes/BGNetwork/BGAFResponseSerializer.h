//
//  BGAFReponseSerializer.h
//  BGNetwork
//
//  Created by user on 15/8/20.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "AFURLResponseSerialization.h"

@protocol BGAFResponseSerializerDelegate;

@interface BGAFResponseSerializer : AFHTTPResponseSerializer
@property (nonatomic, weak) id<BGAFResponseSerializerDelegate> delegate;
@end

@protocol BGAFResponseSerializerDelegate <NSObject>
@required

- (id)responseSerializer:(BGAFResponseSerializer *)responseSerializer response:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error;

@end