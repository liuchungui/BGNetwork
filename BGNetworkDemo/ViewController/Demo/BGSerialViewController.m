//
//  BGSerialViewController.m
//  BGNetworkDemo
//
//  Created by user on 15/12/7.
//  Copyright © 2015年 lcg. All rights reserved.
//

#import "BGSerialViewController.h"
#import "InfoRequest.h"
#import "AdvertInfoRequest.h"
#import "BGSerialRequest.h"

@interface BGSerialViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation BGSerialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendRequestAction:(id)sender {
    InfoRequest *infoRequest = [[InfoRequest alloc] initWithId:13];
    AdvertInfoRequest *advertRequest = [[AdvertInfoRequest alloc] init];
    
    BGSerialRequest *serialRequest = [[BGSerialRequest alloc] initWithRequests:@[infoRequest, advertRequest]];
    
    //失败的
    [serialRequest setBusinessFailure:^(BGNetworkRequest *request, id response) {
        self.textLabel.text = [NSString stringWithFormat:@"%@\n%@", self.textLabel.text, response];
    } networkFailure:^(BGNetworkRequest *request, NSError *error) {
        self.textLabel.text = [NSString stringWithFormat:@"%@\n%@", self.textLabel.text, error];
    }];
    
    [serialRequest sendRequestSuccess:^(BGNetworkRequest *request, id response) {
        self.textLabel.text = [NSString stringWithFormat:@"%@\n%@", self.textLabel.text, response];
    } completion:^(BGSerialRequest *serialRequest, BOOL isSuccess) {
        self.textLabel.text = [NSString stringWithFormat:@"%@\n\nFinish!", self.textLabel.text];
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
