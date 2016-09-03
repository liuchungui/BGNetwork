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
#import "InfoRequest.h"
#import "AdvertInfoRequest.h"
#import "BGBatchRequest.h"
#import "BGNetworkCache.h"

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

- (void)testThatBatchRequestSuccess {
    XCTestExpectation *expectation = [self expectationWithDescription:@"BatchRequest should succeed"];
    __block NSInteger successNum = 0;
    __block id blockFirstResponseObject = nil;
    __block id blockSecondResponseObject = nil;
    
    //create request
    InfoRequest *infoRequest = [[InfoRequest alloc] initWithId:13];
    AdvertInfoRequest *advertRequest = [[AdvertInfoRequest alloc] init];
    
    BGBatchRequest *batchRequest = [[BGBatchRequest alloc] initWithRequests:@[infoRequest, advertRequest]];
    batchRequest.continueLoadWhenRequestFailure = YES;
    
    //set failure block
    [batchRequest setBusinessFailure:^(BGNetworkRequest *request, id response) {
    } networkFailure:^(BGNetworkRequest *request, NSError *error) {
    }];
    
    //send request
    [batchRequest sendRequestSuccess:^(BGNetworkRequest *request, id response) {
        if(request == infoRequest) {
            blockFirstResponseObject = response;
        }
        else if(request == advertRequest) {
            blockSecondResponseObject = response;
        }
        successNum ++;
        if(successNum == 2) {
            [expectation fulfill];
        }
    } completion:^(BGBatchRequest *batchRequest, BOOL isSuccess) {
    }];
    
    [self waitForExpectationsWithTimeout:20 handler:NULL];
    
    XCTAssertEqual(successNum, 2);
    XCTAssertNotNil(blockFirstResponseObject);
    XCTAssertNotNil(blockSecondResponseObject);
}

- (void)testThatRequestCancel {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should cancel"];
    __block BOOL cancelSuccess = NO;
    DemoRequest *request = [[DemoRequest alloc] initPage:0 pageSize:10];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        if(error.code == kCFURLErrorCancelled) {
            cancelSuccess = YES;
        }
        [expectation fulfill];
    }];
    
    //取消请求
    [DemoRequest cancelRequest];
    
    [self waitForExpectationsWithTimeout:10.0 handler:NULL];
    
    XCTAssertTrue(cancelSuccess);
}

- (void)testThatRequestCacheData1 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request shoud cache"];
    __block BOOL queryDataSuccess = NO;
    
    BGNetworkCache *cache = [BGNetworkCache sharedCache];
    
    //test
    NSString *fileName = @"BGNetworkRequestCacheData.test1";
    NSString *str = @"com.BGNetworkRequestCacheData.test1";
    NSData *storeData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    //store data
    [cache storeData:storeData forFileName:fileName];
    
    //query data
    NSData *queryData = [cache queryDataCacheForFileName:fileName];
    if(![queryData isEqualToData:storeData]) {
        [expectation fulfill];
    }
    
    //query data
    [cache queryDataCacheForFileName:fileName completion:^(NSData *data) {
        if([queryData isEqualToData:data]) {
            queryDataSuccess = YES;
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:NULL];
    
    XCTAssertTrue(queryDataSuccess);
}

- (void)testThatRequestCacheData2 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request shoud cache"];
    __block BOOL storeObjectSuccess = NO;
    __block BOOL queryDataSuccess = NO;
    
    BGNetworkCache *cache = [BGNetworkCache sharedCache];
    
    //test
    NSString *fileName = @"BGNetworkRequestCacheData.test2";
    NSString *str = @"com.BGNetworkRequestCacheData.test2";
    NSData *storeData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    //store data
    [cache storeData:storeData forFileName:fileName completion:^(BOOL isCacheSuccess) {
        if(!isCacheSuccess) {
            [expectation fulfill];
        }
        storeObjectSuccess = YES;
        
        //query data
        NSData *queryData = [cache queryDataCacheForFileName:fileName];
        if(![queryData isEqualToData:storeData]) {
            [expectation fulfill];
        }
        
        //query data
        [cache queryDataCacheForFileName:fileName completion:^(NSData *data) {
            if([queryData isEqualToData:data]) {
                queryDataSuccess = YES;
            }
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:NULL];
    
    XCTAssertTrue(storeObjectSuccess && queryDataSuccess);
}

- (void)testThatRequestCacheObject1 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request shoud cache"];
    __block BOOL storeObjectSuccess = NO;
    __block BOOL queryObjectSuccess = NO;
    
    BGNetworkCache *cache = [BGNetworkCache sharedCache];
    
    //test
    NSString *fileName = @"BGNetworkRequestCacheObject.test1";
    NSString *str = @"com.BGNetworkRequestCacheObject.test1";
    [cache storeObject:str forFileName:fileName completion:^(BOOL isCacheSuccess) {
        if(!isCacheSuccess) {
            [expectation fulfill];
        }
        storeObjectSuccess = YES;
        NSString *queryStr = [cache queryObjectCacheForFileName:fileName];
        if(![str isEqualToString:queryStr]) {
            [expectation fulfill];
        }
        [cache queryObjectCacheForFileName:fileName completion:^(NSString* _Nullable object) {
            if([str isEqualToString:object]) {
                queryObjectSuccess = YES;
            }
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:NULL];
    
    XCTAssertTrue(storeObjectSuccess && queryObjectSuccess);
}

- (void)testThatRequestCacheObject2 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request shoud cache"];
    __block BOOL queryObjectSuccess = NO;
    
    BGNetworkCache *cache = [BGNetworkCache sharedCache];
    
    //test
    NSString *fileName = @"BGNetworkRequestCacheObject.test2";
    NSString *str = @"com.BGNetworkRequestCacheObject.test2";
    
    //store object
    [cache storeObject:str forFileName:fileName];
    
    //query object
    NSString *queryStr = [cache queryObjectCacheForFileName:fileName];
    if(![str isEqualToString:queryStr]) {
        [expectation fulfill];
    }
    [cache queryObjectCacheForFileName:fileName completion:^(NSString* _Nullable object) {
        if([str isEqualToString:object]) {
            queryObjectSuccess = YES;
        }
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:NULL];
    
    XCTAssertTrue(queryObjectSuccess);
}

- (void)testThatRequestRemoveCache {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request shoud remove cache"];
    __block BOOL removeCacheSuccess = NO;
    
    BGNetworkCache *cache = [BGNetworkCache sharedCache];
    
    //test
    NSString *fileName = @"BGNetworkRequestRemoveCache.test";
    NSString *str = @"com.BGNetworkRequestRemove.test";
    
    //store object
    [cache storeObject:str forFileName:fileName];
    
    //query object
    NSString *queryStr = [cache queryObjectCacheForFileName:fileName];
    if(![str isEqualToString:queryStr]) {
        [expectation fulfill];
    }
    
    //remove cache
    [cache removeCacheForFileName:fileName];
    queryStr = [cache queryObjectCacheForFileName:fileName];
    if(queryStr == NULL) {
        removeCacheSuccess = YES;
    }
    
    [expectation fulfill];
    [self waitForExpectationsWithTimeout:10.0 handler:NULL];
    
    XCTAssertTrue(removeCacheSuccess);
}

@end
