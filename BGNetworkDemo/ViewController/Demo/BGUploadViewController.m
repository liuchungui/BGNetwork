//
//  BGUploadViewController.m
//  BGNetworkDemo
//
//  Created by user on 15/12/22.
//  Copyright © 2015年 BGNetwork https://github.com/liuchungui/BGNetwork/tree/dev. All rights reserved.
//

#import "BGUploadViewController.h"
#import "AFHTTPSessionManager.h"
#import "BGUploadRequest.h"

@interface BGUploadViewController ()

@end

@implementation BGUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uploadAction:(id)sender {
    NSString *serverStr = @"upload.php";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://casetree.cn/web/test/"]];
    
    //请求的serializer
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = serializer;
    
    //response的serializer
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    UIImage *image = [UIImage imageNamed:@"icon_shanchu.png"];
    NSURLSessionDataTask *task = [manager POST:serverStr parameters:@{@"test":@"hello"} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
          [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0) name:@"fileUpload" fileName:@"IMG_20150617_105877.jpg" mimeType:@"application/octet-stream"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%f", uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", string);
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@", resultDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    [task resume];
}

- (IBAction)bgUploadAction:(id)sender {
    UIImage *image = [UIImage imageNamed:@"icon_shanchu.png"];
    BGUploadRequest *request = [[BGUploadRequest alloc] initWithData:UIImageJPEGRepresentation(image, 1.0)];
    request.methodName = @"upload.php";
    [request sendRequestWithProgress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%f", uploadProgress.fractionCompleted);
    } success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        NSLog(@"%@", response);
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        NSLog(@"%@", response);
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
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
