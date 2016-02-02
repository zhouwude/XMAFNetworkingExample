//
//  XMAFURLResponse.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFURLResponse.h"

#import "NSObject+XMAFNetworkingMethods.h"
#import "NSString+XMAFNetworkingMethods.h"
#import "NSURLRequest+XMAFNetworkingMethods.h"

@interface XMAFURLResponse ()

@property (nonatomic, assign, readwrite) XMAFURLResponseStatus status;

@property (nonatomic, copy, readwrite) NSURLRequest *request;
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (nonatomic, assign, readwrite) BOOL isCache;

@property (nonatomic, copy, readwrite) NSString *responseString;
@property (nonatomic, copy, readwrite) NSData *responseData;
@property (copy, nonatomic, readwrite) id responseObject;

@end

@implementation XMAFURLResponse

#pragma mark - Life Cycle

- (instancetype)initWithResponse:(id)response requestId:(NSNumber *)requestId request:(NSURLRequest *)request error:(NSError *)error {
    if ([super init]) {
        
        self.requestId = [requestId integerValue];
        self.request = request;
        self.requestParams = request.requestParams;
        self.status = [self responseStatusWithError:error];
        
        if ([response isKindOfClass:[NSData class]]) {
            self.responseData = response;
            if (self.responseData) {
                self.responseObject = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:NULL];
            }
        }else {
            self.responseObject = response;
            if (self.responseObject) {
                self.responseData = [NSJSONSerialization dataWithJSONObject:self.responseObject options:NSJSONWritingPrettyPrinted error:NULL];
            }
        }
        self.responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
        
        self.isCache = NO;
    }
    return self;
}


- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        
        self.status = XMAFURLResponseStatusSuccess;
        self.requestId = 0;
        self.request = nil;
        
        self.responseData = [data copy];
        self.responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        
        self.isCache = YES;
    }
    return self;
}

#pragma mark - Private Methods

- (XMAFURLResponseStatus)responseStatusWithError:(NSError *)error
{
    XMAFURLResponseStatus responseStatus;
    if (error) {
        // 除了超时以外，所有错误都当成是无网络
        responseStatus = error.code == NSURLErrorTimedOut ? XMAFURLResponseStatusErrorTimeout : XMAFURLResponseStatusErrorNoNetwork;
    } else {
        responseStatus = XMAFURLResponseStatusSuccess;
    }
    return responseStatus;
}

@end
