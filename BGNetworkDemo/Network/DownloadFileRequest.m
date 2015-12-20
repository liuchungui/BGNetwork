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
        self.methodName = @"http://localhost/app/BGNetwork/download/Command_Line_Tools_OS_X_10.10_for_Xcode_7.1.dmg";
    }
    return self;
}

@end
