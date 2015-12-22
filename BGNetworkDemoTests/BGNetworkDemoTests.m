//
//  BGNetworkDemoTests.m
//  BGNetworkDemoTests
//
//  Created by user on 15/9/4.
//  Copyright (c) 2015年 lcg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DemoNetworkConfiguration.h"
#import "BGNetworkManager.h"
#import "DemoRequest.h"
#import "BGUploadRequest.h"

@interface BGNetworkDemoTests : XCTestCase
@end

@implementation BGNetworkDemoTests

- (void)setUp {
    [super setUp];
    //set network configuration
    [[BGNetworkManager sharedManager] setNetworkConfiguration:[DemoNetworkConfiguration configuration]];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testThatRequestSuccess {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    __block BOOL requestSuccess = NO;
    __block id blockResponseObject = nil;
    DemoRequest *request = [[DemoRequest alloc] initPage:0 pageSize:10];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        requestSuccess = YES;
        blockResponseObject = response;
        [expectation fulfill];
    } businessFailure:NULL networkFailure:NULL];
    [self waitForExpectationsWithTimeout:10.0 handler:NULL];
    
    XCTAssertTrue(requestSuccess);
    XCTAssertNotNil(blockResponseObject);
}

- (void)testThatUploadRequestSuccess {
    XCTestExpectation *expectation = [self expectationWithDescription:@"UploadRequest should succeed"];
    __block BOOL requestSuccess = NO;
    __block id blockResponseObject = nil;
    UIImage *image = [UIImage imageNamed:@"icon_shanchu.png"];
    BGUploadRequest *request = [[BGUploadRequest alloc] initWithData:UIImageJPEGRepresentation(image, 1.0)];
    request.methodName = @"upload.php";
    [request sendRequestWithProgress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%f", uploadProgress.fractionCompleted);
    } success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        requestSuccess = YES;
        blockResponseObject = response;
        [expectation fulfill];
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        NSLog(@"%@", response);
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        NSLog(@"%@", error);
    }];
    
    [self waitForExpectationsWithTimeout:20.0 handler:NULL];
    
    XCTAssertTrue(requestSuccess);
    XCTAssertNotNil(blockResponseObject);
}

@end
