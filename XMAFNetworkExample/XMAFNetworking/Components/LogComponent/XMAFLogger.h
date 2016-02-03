//
//  XMAFLogger.h
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMAFLoggerConfiguration.h"
#import "XMAFURLResponse.h"

@class XMAFService;
@interface XMAFLogger : NSObject

@property (nonatomic, strong, readonly) XMAFLoggerConfiguration *configParams;


+ (instancetype)sharedInstance;


- (void)setConfiguration:(XMAFLoggerConfiguration *)configuration;

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(XMAFService *)service requestParams:(id)requestParams httpMethod:(NSString *)httpMethod;
+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response resposeString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;
+ (void)logDebugInfoWithCachedResponse:(XMAFURLResponse *)response methodName:(NSString *)methodName serviceIdentifier:(XMAFService *)service;

@end
