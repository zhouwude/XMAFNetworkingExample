//
//  XMAFLogger.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFLogger.h"

#import "XMAFService.h"
#import "XMAFAPPContext.h"

#import "NSObject+XMAFNetworkingMethods.h"
#import "NSMutableString+XMAFNetworkingMethods.h"

@interface XMAFLogger ()

@property (strong, nonatomic) XMAFLoggerConfiguration *configParams;

@end

@implementation XMAFLogger

#pragma mark - Life Cycle
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.configParams = [XMAFLoggerConfiguration configurationWithAppKey:@"demo" logEnable:YES];
    }
    return self;
}


#pragma mark - Setters

- (void)setConfiguration:(XMAFLoggerConfiguration *)configuration {
    self.configParams = configuration;
}


#pragma mark - Class Methods

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(XMAFService *)service requestParams:(id)requestParams httpMethod:(NSString *)httpMethod {
    if ([XMAFLogger sharedInstance].configParams.logEnable) {
        NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"];
        
        [logString appendFormat:@"API Name:\t\t%@\n", [apiName XMAF_defaultValue:@"N/A"]];
        [logString appendFormat:@"Method:\t\t\t%@\n", [httpMethod XMAF_defaultValue:@"N/A"]];
        [logString appendFormat:@"Version:\t\t%@\n", [service.apiVersion XMAF_defaultValue:@"N/A"]];
        [logString appendFormat:@"Service:\t\t%@\n", [service class]];
        [logString appendFormat:@"Status:\t\t\t%@\n", service.serviceStatus];
        [logString appendFormat:@"Public Key:\t%@\n", [service.publicKey XMAF_defaultValue:@"N/A"]];
        [logString appendFormat:@"Private Key:\t%@\n", [service.privateKey XMAF_defaultValue:@"N/A"]];
        [logString appendFormat:@"Params:\n%@", requestParams];
        
        [logString appendURLRequest:request];
        
        [logString appendFormat:@"\n\n**************************************************************\n*                         Request End                        *\n**************************************************************\n\n\n\n"];
        NSLog(@"%@", logString);
    }
}


+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response resposeString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error {
    if ([XMAFLogger sharedInstance].configParams.logEnable) {
        BOOL shouldLogError = error ? YES : NO;
        
        NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response                        =\n==============================================================\n\n"];
        
        [logString appendFormat:@"Status:\t%ld\t(%@)\n\n", (long)response.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]];
        [logString appendFormat:@"Content:\n\t%@\n\n", responseString];
        if (shouldLogError) {
            [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
            [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
            [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
            [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
            [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
        }
        
        [logString appendString:@"\n---------------  Related Request Content  --------------\n"];
        
        [logString appendURLRequest:request];
        
        [logString appendFormat:@"\n\n==============================================================\n=                  API   Response End                        =\n==============================================================\n\n\n\n"];
        
        NSLog(@"%@", logString);
    }
}


+ (void)logDebugInfoWithCachedResponse:(XMAFURLResponse *)response methodName:(NSString *)methodName serviceIdentifier:(XMAFService *)service {
    if ([XMAFLogger sharedInstance].configParams.logEnable) {
        NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                      Cached Response                       =\n==============================================================\n\n"];
        
        [logString appendFormat:@"API Name:\t\t%@\n", [methodName XMAF_defaultValue:@"N/A"]];
        [logString appendFormat:@"Version:\t\t%@\n", [service.apiVersion XMAF_defaultValue:@"N/A"]];
        [logString appendFormat:@"Service:\t\t%@\n", [service class]];
        [logString appendFormat:@"Public Key:\t%@\n", [service.publicKey XMAF_defaultValue:@"N/A"]];
        [logString appendFormat:@"Private Key:\t%@\n", [service.privateKey XMAF_defaultValue:@"N/A"]];
        [logString appendFormat:@"Method Name:\t%@\n", methodName];
        [logString appendFormat:@"Params:\n%@\n\n", response.requestParams];
        [logString appendFormat:@"Content:\n\t%@\n\n", response.responseString];
        
        [logString appendFormat:@"\n\n==============================================================\n=                 Cached Response End                        =\n==============================================================\n\n\n\n"];
        NSLog(@"%@", logString);

    }
}
@end
