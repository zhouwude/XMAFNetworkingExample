//
//  XMAFUploadManager.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/28.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFUploadManager.h"
#import "AFNetworking.h"
#import <objc/runtime.h>

NSString *const kXMAFUploadManagerSessionIdentifier = @"com.XMFraker.XMAFUploadManager.SessionIdentifier";
NSString *const kXMAFUploadURLStringKey = @"com.XMFraker.XMAFUploadManager.URLStringKey";
NSString *const kXMAFUploadRequestHeadersKey = @"com.XMFraker.XMAFUploadManager.RequestHeadersKey";
NSString *const kXMAFUploadRequestParamsKey = @"com.XMFraker.XMAFUploadManager.RequestParamsKey";

@interface XMAFUploadManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) AFHTTPRequestSerializer *requestSerizalizer;

@end

@implementation XMAFUploadManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (NSURLSessionUploadTask *)uploadFileWithConstructingRequestBlock:(NSDictionary *(^)())constructingRequestBlock constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))constructingBodyBlock progressBlock:(void(^)(int64_t bytes,int64_t totalBytes))progressBlock completeBlock:(void(^)(id responseObject,NSError *error))completeBlock {
    __weak __typeof(&*self) wself = self;
    NSDictionary *arguments = constructingRequestBlock();
    NSAssert(arguments[kXMAFUploadURLStringKey], @"does not have urlstring");
    NSDictionary *requestHeaders = arguments[kXMAFUploadRequestHeadersKey];
    if (requestHeaders) {
        [requestHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            __strong __typeof(wself)self = wself;
            [self.requestSerizalizer setValue:obj forHTTPHeaderField:key];
        }];
    }
    NSMutableURLRequest *request = [self.requestSerizalizer multipartFormRequestWithMethod:@"POST" URLString:arguments[kXMAFUploadURLStringKey] parameters:arguments[kXMAFUploadRequestParamsKey] constructingBodyWithBlock:constructingBodyBlock error:nil];
    NSURLSessionUploadTask *uploadTask = [self.sessionManager uploadTaskWithStreamedRequest:request  progress:^(NSProgress * _Nonnull uploadProgress) {
        progressBlock(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        completeBlock(responseObject,error);
    }];
    [uploadTask resume];
    return uploadTask;
}

#pragma mark - Getters

- (AFHTTPRequestSerializer *)requestSerizalizer {
    if (!_requestSerizalizer) {
        _requestSerizalizer = [AFHTTPRequestSerializer serializer];
    }
    return _requestSerizalizer;
}

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
        _sessionManager.requestSerializer = self.requestSerizalizer;
    }
    return _sessionManager;
}

@end
