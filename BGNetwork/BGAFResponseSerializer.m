//
//  BGAFReponseSerializer.m
//  BGNetwork
//
//  Created by user on 15/8/20.
//  Copyright © 2015年 BGNetwork https://github.com/liuchungui/BGNetwork/tree/dev. All rights reserved.
//

#import "BGAFResponseSerializer.h"

@implementation BGAFResponseSerializer
- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
    
    return self;
}
@end
