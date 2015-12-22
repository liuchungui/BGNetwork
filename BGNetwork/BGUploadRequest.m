//
//  BGUploadRequest.m
//  BGNetworkDemo
//
//  Created by user on 15/12/22.
//  Copyright © 2015年 BGNetwork https://github.com/liuchungui/BGNetwork/tree/dev. All rights reserved.
//

#import "BGUploadRequest.h"
#import "BGNetworkManager.h"

@interface BGUploadRequest ()
@property (nonatomic, strong) NSData *fileData;
@end
@implementation BGUploadRequest

- (instancetype)initWithData:(NSData *)fileData {
    if(self = [super init]) {
        self.fileData = fileData;
        self.uploadKey = @"fileUpload";
        self.fileName = @"upload";
        self.mimeType = @"application/octet-stream";
    }
    return self;
}

- (void)sendRequestWithSuccess:(BGSuccessCompletionBlock)successCompletionBlock businessFailure:(BGBusinessFailureBlock)businessFailureBlock networkFailure:(BGNetworkFailureBlock)networkFailureBlock {
    return [self sendRequestWithProgress:NULL success:successCompletionBlock businessFailure:businessFailureBlock networkFailure:networkFailureBlock];
}

- (void)sendRequestWithProgress:(void (^)(NSProgress * _Nonnull))uploadProgress success:(BGSuccessCompletionBlock)successCompletionBlock businessFailure:(BGBusinessFailureBlock)businessFailureBlock networkFailure:(BGNetworkFailureBlock)networkFailureBlock {
    [[BGNetworkManager sharedManager] sendUploadRequest:self progress:uploadProgress success:successCompletionBlock businessFailure:businessFailureBlock networkFailure:networkFailureBlock];
}
@end
