//
//  XMAFRequestGenerator.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFRequestGenerator.h"

#import "XMAFLogger.h"
#import "AFNetworking.h"
#import "XMAFServiceFactory.h"
#import "XMAFNetworkingConfiguration.h"

#import "NSDictionary+XMAFNetworkingMethods.h"
#import "NSArray+XMAFNetworkingMethods.h"
#import "NSURLRequest+XMAFNetworkingMethods.h"

@interface XMAFRequestGenerator ()

@property (strong, nonatomic) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation XMAFRequestGenerator

#pragma mark - Life Cycle

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

#pragma mark - Public Methods

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName {
    
    //1.获取请求service
    XMAFService *service = [[XMAFServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSAssert(service, @"service not exist !!!");
    
    //2.签名请求参数,并且带上public_key
    NSMutableDictionary *sigParams = [NSMutableDictionary dictionaryWithDictionary:requestParams];
    if (service.needSign) {
        sigParams[@"sign_key"] = service.publicKey;
        NSString *signature = @"";
        sigParams[@"sign"] = signature;
    }
    
    //3.拼接所有的请求参数
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:service.commonParams];
    [allParams addEntriesFromDictionary:sigParams];
    
    //4.拼接urlString
    NSString *urlString = [NSString stringWithFormat:@"%@%@?%@",service.apiBaseUrl,methodName,[allParams XMAF_urlParamsStringSignature:NO]];
    
    //5.拼接httpHeaders
    if (service.httpHeaders && service.httpHeaders.allKeys.count > 0) {
        __weak __typeof(&*self) wself = self;
        [service.httpHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            __strong __typeof(&*wself)self = wself;
            [self.httpRequestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    //5.获取request实例
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:NULL];
    request.requestParams = requestParams;
    request.timeoutInterval = kXMAFNetworkingTimeoutSeconds;
    [XMAFLogger logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:@"GET"];
    
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName {
    
    //1.获取请求service
    XMAFService *service = [[XMAFServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSAssert(service, @"service not exist !!!");
    
    NSMutableDictionary *allParams = [[NSMutableDictionary alloc] initWithDictionary:service.commonParams];
    
    [allParams addEntriesFromDictionary:requestParams];
    
    //2.签名请求参数
    NSString *signature = @"";
    if (service.needSign) {
        allParams[@"sign_key"] = service.publicKey;
        allParams[@"sign"] = signature;
    }
    
    //3.拼接请求参数
    NSString *urlString = [NSString stringWithFormat:@"%@%@",service.apiBaseUrl,methodName];
    
    //4.获取request实例
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:allParams error:NULL];
    request.timeoutInterval = kXMAFNetworkingTimeoutSeconds;
    request.requestParams = requestParams;
    [XMAFLogger logDebugInfoWithRequest:request apiName:methodName service:service requestParams:requestParams httpMethod:@"POST"];
    
    return request;
}

#pragma mark - Getters

- (AFHTTPRequestSerializer *)httpRequestSerializer {
    if (!_httpRequestSerializer) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kXMAFNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        _httpRequestSerializer.HTTPShouldHandleCookies = YES;
    }
    return _httpRequestSerializer;
}

@end
