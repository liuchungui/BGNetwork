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
#import "BGNetwork.h"
#import "M13ProgressViewRing.h"

NSString *EncodingURL(NSString * string) {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (CFStringRef)string,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                 kCFStringEncodingUTF8));
}

#define PATH_AT_CACHEDIR(name)		[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] 

@interface BGDownloadRequestController ()
@property (weak, nonatomic) IBOutlet M13ProgressViewRing *progressViewRing;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) BGDownloadRequest *request;
@end

@implementation BGDownloadRequestController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.progressViewRing setProgress:0 animated:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.request cancelRequest];
}

- (IBAction)downloadFileAction:(id)sender {
    BGDownloadRequest *request = [[BGDownloadRequest alloc] init];
    request.methodName = @"http://casetree.cn/web/test/download/CollectionViewPGforIOS.pdf?test=100";
    request.fileName = @"test.pdf";
    [request sendRequestWithProgress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressViewRing setProgress:downloadProgress.fractionCompleted animated:YES];
            NSLog(@"%f", downloadProgress.fractionCompleted);
        });
    } success:^(BGDownloadRequest * _Nonnull request, NSURL * _Nullable filePath) {
        NSLog(@"%@", filePath);
        self.progressViewRing.hidden = YES;
        [self.webView loadRequest:[NSURLRequest requestWithURL:filePath]];
    } failure:^(BGDownloadRequest * _Nonnull request, NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
    self.request = request;
}

- (IBAction)pauseAction:(id)sender {
    [self.request cancelRequest];
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
