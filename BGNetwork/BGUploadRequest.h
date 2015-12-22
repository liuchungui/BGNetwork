//
//  BGUploadRequest.h
//  BGNetworkDemo
//
//  Created by user on 15/12/22.
//  Copyright © 2015年 BGNetwork https://github.com/liuchungui/BGNetwork/tree/dev. All rights reserved.
//

#import "BGNetworkRequest.h"
#import "AFNetworking.h"

@interface BGUploadRequest : BGNetworkRequest
/**
 *  初始化请求
 *
 *  @param fileData 文件数据
 *
 *  @return 返回请求对象
 */
- (instancetype _Nonnull)initWithData:(NSData * _Nonnull)fileData;

/**
 *  文件数据
 */
@property (nonatomic, strong, readonly) NSData * _Nonnull fileData;

/**
 *  上传数据的键值，默认为"fileUpload"，不能为空
 */
@property (nonatomic, strong) NSString * _Nonnull uploadKey;

/**
 *  文件名，默认为"upload"
 */
@property (nonatomic, strong) NSString * _Nonnull fileName;

/**
 *  文件类型，默认为"application/octet-stream"
 */
@property (nonatomic, strong) NSString * _Nonnull mimeType;

- (void)sendRequestWithProgress:(nullable void (^)(NSProgress * _Nonnull uploadProgress)) uploadProgress
                        success:(BGSuccessCompletionBlock _Nullable)successCompletionBlock
                businessFailure:(BGBusinessFailureBlock _Nullable)businessFailureBlock
                 networkFailure:(BGNetworkFailureBlock _Nullable)networkFailureBlock;

@end
