//
//  DownloadFileRequest.m
//  BGNetworkDemo
//
//  Created by user on 15/12/20.
//  Copyright © 2015年 BGNetwork https://github.com/liuchungui/BGNetwork/tree/dev. All rights reserved.
//

#import "DownloadFileRequest.h"

@implementation DownloadFileRequest
- (instancetype)init {
    if(self = [super init]) {
        self.methodName = @"download/CollectionViewPGforIOS.pdf?test=100";
        self.fileName = @"test.pdf";
    }
    return self;
}

@end
