 //
//  BGDownloadRequestController.m
//  BGNetworkDemo
//
//  Created by user on 15/12/12.
//  Copyright © 2015年 BGNetwork https://github.com/liuchungui/BGNetwork/tree/dev. All rights reserved.
//

#import "BGDownloadRequestController.h"
#import "AFNetworking.h"
#import "DownloadFileRequest.h"

#define PATH_AT_CACHEDIR(name)		[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] 

@interface BGDownloadRequestController ()
@property (nonatomic, strong) NSData *tmpData;
@property (nonatomic, assign) BOOL isResumeDownload;
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@end

@implementation BGDownloadRequestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)downLoadButtonAction:(id)sender {
    self.isResumeDownload = NO;
    /**
     *  AF下载
     */
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost/app/BGNetwork/download/Command_Line_Tools_OS_X_10.10_for_Xcode_7.1.dmg"]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%f", downloadProgress.fractionCompleted);
        if(downloadProgress.fractionCompleted > 0.5) {
            //don't imp [self.task cancel];
            //取消任务，并且获取临时的数据，以便以后恢复下载
            [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                self.tmpData = resumeData;
            }];
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return targetPath;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
    }];
    
    [task resume];
    
    self.task = task;
}

- (IBAction)resumeDownloadButtonAction:(id)sender {
    self.isResumeDownload = YES;
    
    //拿取以前请求的数据进行重新请求，实现断点续传的效果
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSURLSessionDownloadTask *task = [manger downloadTaskWithResumeData:self.tmpData progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%f", downloadProgress.fractionCompleted);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return targetPath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if(error == nil) {
            NSLog(@"resume download success!");
        }
        else {
            NSLog(@"resume download failure");
        }
    }];
    
    [task resume];
    self.task = task;
}

////observe method
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    NSLog(@"%@", change);
//    CGFloat progress = [change[@"new"] floatValue];
//    if(!self.isResumeDownload) {
//        if(progress > 0.5) {
//            //don't imp [self.task cancel];
//            //取消任务，并且获取临时的数据，以便以后恢复下载
//            [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
//                self.tmpData = resumeData;
//            }];
//        }
//    }
//}

- (IBAction)downloadFileAction:(id)sender {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost/app/BGNetwork/download/Command_Line_Tools_OS_X_10.10_for_Xcode_7.1.dmg"]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://localhost/app/BGNetwork/download/Command_Line_Tools_OS_X_10.10_for_Xcode_7.1.dmg" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%f", downloadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure!");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
