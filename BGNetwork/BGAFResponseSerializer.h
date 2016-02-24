//
//  BGAFReponseSerializer.h
//  BGNetwork
//
//  Created by user on 15/8/20.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import "AFURLResponseSerialization.h"

//@protocol BGAFResponseSerializerDelegate;

@interface BGAFResponseSerializer : AFHTTPResponseSerializer
//@property (nonatomic, weak) id<BGAFResponseSerializerDelegate> delegate;
@end

//@protocol BGAFResponseSerializerDelegate <NSObject>
//@required
//
//- (id _Nonnull)responseSerializer:(BGAFResponseSerializer * _Nonnull)responseSerializer response:(NSURLResponse * _Nonnull)response data:(NSData * _Nullable)data error:(NSError * _Nullable __autoreleasing * _Nullable)error;
//
//@end