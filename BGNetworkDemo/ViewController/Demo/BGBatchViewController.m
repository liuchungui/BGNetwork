//
//  BGBatchViewController.m
//  BGNetworkDemo
//
//  Created by user on 15/12/7.
//  Copyright © 2015年 lcg. All rights reserved.
//

#import "BGBatchViewController.h"
#import "InfoRequest.h"
#import "AdvertInfoRequest.h"
#import "BGBatchRequest.h"

@interface BGBatchViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation BGBatchViewController
- (void)dealloc {
    NSLog(@"%@ delloc", NSStringFromClass(self.class));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendRequestAction:(id)sender {
    //clear
    self.textLabel.text = @"";
    
    //create request
    InfoRequest *infoRequest = [[InfoRequest alloc] initWithId:13];
    AdvertInfoRequest *advertRequest = [[AdvertInfoRequest alloc] init];
    
    BGBatchRequest *batchRequest = [[BGBatchRequest alloc] initWithRequests:@[infoRequest, advertRequest]];
    batchRequest.continueLoadWhenRequestFailure = YES;
    
    //set failure block
    [batchRequest setBusinessFailure:^(BGNetworkRequest *request, id response) {
        self.textLabel.text = [NSString stringWithFormat:@"%@\n\n%@:%@", self.textLabel.text, NSStringFromClass(request.class), response];
    } networkFailure:^(BGNetworkRequest *request, NSError *error) {
        self.textLabel.text = [NSString stringWithFormat:@"%@\n\n%@:%@", self.textLabel.text, NSStringFromClass(request.class), error];
    }];
    
    //send request
    [batchRequest sendRequestSuccess:^(BGNetworkRequest *request, id response) {
        self.textLabel.text = [NSString stringWithFormat:@"%@\n\n%@:%@", self.textLabel.text, NSStringFromClass(request.class), response];
    } completion:^(BGBatchRequest *batchRequest, BOOL isSuccess) {
        NSString *finishTip = @"";
        if(isSuccess) {
            finishTip = @"Success!";
        }
        else {
            finishTip = @"Failure!";
        }
        self.textLabel.text = [NSString stringWithFormat:@"%@\n\n%@", self.textLabel.text, finishTip];
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
