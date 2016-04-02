//
//  BGAFHTTPClient.m
//  BGNetwork
//
//  Created by user on 15/8/19.
//  Copyright © 2015年 BGNetwork https://github.com/liuchungui/BGNetwork/tree/dev. All rights reserved.
//

#import "BGAFHTTPClient.h"

@implementation BGAFHTTPClient
- (id)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    return self;
}

- (BOOL)isHttpQueueFinished:(NSArray *)httpUrlArray{
    if(self.tasks.count == 0){
        return YES;
    }
    
    //add filter urlString.length==0
    NSMutableArray* urlArray = [NSMutableArray array];
    for (NSString* currentUrl in httpUrlArray) {
        if (currentUrl.length != 0) {
            [urlArray addObject:currentUrl];
        }
    }
    
    //urlArray is empty
    if(urlArray.count == 0){
        return YES;
    }
    
    for (NSURLSessionTask *task in self.tasks) {
        NSString *taskUrl = task.currentRequest.URL.absoluteString;
        for (NSString *baseUrl in urlArray) {
            if([taskUrl rangeOfString:baseUrl].location != NSNotFound){
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)cancelTasksWithUrl:(NSString *)url{
    for (NSURLSessionTask *task in self.tasks) {
        NSString *taskUrl = task.currentRequest.URL.absoluteString;
        if([taskUrl rangeOfString:url].location != NSNotFound){
            [task cancel];
        }
    }
}
@end
