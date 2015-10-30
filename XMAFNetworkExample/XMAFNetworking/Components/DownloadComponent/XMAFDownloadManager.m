//
//  XMAFDownloadManager.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/27.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFDownloadManager.h"
#import "AFNetworking.h"
#import <objc/runtime.h>

#import "NSString+XMAFNetworkingMethods.h"

NSString *const kXMAFDownloadSessionIdentifier = @"com.XMFraker.XMAFDownloadSessionIdentifier";

NSString *const kXMAFDownloadURLStringKey = @"com.XMFraker.XMAFDownloadManager.URLStringKey";
NSString *const kXMAFDownloadFileNameKey = @"com.XMFraker.XMAFDownloadManager.FileNameKey";

static void * progressBlockKey;


@interface XMAFDownloadManager ()

@property (strong, nonatomic) AFURLSessionManager *sessionManager;
@property (copy, nonatomic, readonly) NSString *downloadingCachePath;
@property (copy, nonatomic, readonly) NSString *downloadedCachePath;
@property (copy, nonatomic) NSString *cachePath;

@end

@implementation XMAFDownloadManager


#pragma mark - Life Cycle

+ (instancetype)manager{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] initWithCachePath:nil];
    });
    return shareInstance;
}

- (instancetype)initWithCachePath:(NSString *)cachePath {
    if ([super init]) {
        if (!cachePath) {
            NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachePath = [cachePaths firstObject];
            self.cachePath = [cachePath stringByAppendingPathComponent:@"com.XMFraker.XMAFDownloadManager"];
        }else {
            self.cachePath = cachePath;
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.downloadingCachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:self.downloadingCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.downloadedCachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:self.downloadedCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        
    }
    return self;
}

- (void)dealloc {

}

#pragma mark - Public Methods

- (NSURLSessionDownloadTask *)downloadWithConstructBlock:(XMAFDownloadConstructBlock)constructBlock progressBlock:(XMAFDownloadProgressBlock)progressBlock completeBlock:(XMAFDownloadCompleteBlock)completeBlock {
    NSAssert(constructBlock, @"must have constructBlock");
    NSDictionary *arguments = constructBlock();
    NSString *URLString = arguments[kXMAFDownloadURLStringKey];
    NSAssert(URLString, @"must have url");
    NSString *fileName = arguments[kXMAFDownloadFileNameKey];
    if (!fileName) {
        fileName = [URLString XMAF_md5];
    }
    return [self downloadWithURLString:URLString fileName:fileName progressBlock:progressBlock completeBlock:completeBlock];
}

- (NSURLSessionDownloadTask *)downloadWithURLString:(NSString *)URLString fileName:(NSString *)fileName progressBlock:(XMAFDownloadProgressBlock)progressBlock completeBlock:(XMAFDownloadCompleteBlock)completeBlock {
    
    NSString *resultFileName = fileName ? fileName : [URLString XMAF_md5];
    
    NSString *fileDownloadingPath = [self.downloadingCachePath stringByAppendingPathComponent:[URLString XMAF_md5]];
    BOOL isFileDownloading = [self isFileDownloading:fileDownloadingPath];;
    NSString *fileAbsolutePath = [self.downloadedCachePath stringByAppendingPathComponent:resultFileName];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    NSURLSessionDownloadTask *task;
    __weak __typeof(&*self) wself = self;
    if (!isFileDownloading) {
        task = [self.sessionManager downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL URLWithString:[NSString stringWithFormat:@"file:%@",fileAbsolutePath]];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            __strong __typeof(wself)self = wself;
            [self downloadCompleteWithResponse:response error:error];
            completeBlock ? completeBlock(fileAbsolutePath, error) : nil;
        }];
    }else {
        task = [self.sessionManager downloadTaskWithResumeData:[NSData dataWithContentsOfFile:fileDownloadingPath] progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL URLWithString:[NSString stringWithFormat:@"file:%@",fileAbsolutePath]];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            __strong __typeof(wself)self = wself;
            [self downloadCompleteWithResponse:response error:error];
            completeBlock ? completeBlock(fileAbsolutePath, error) : nil;
        }];
    }
    objc_setAssociatedObject(task, &progressBlockKey, progressBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);

    [task resume];
    return task;
}


- (void)suspendTasks {
    for (NSURLSessionDownloadTask *downloadTask in self.downloadTasks) {
        [downloadTask suspend];
    }
}

- (void)cancelTasks {
    for (NSURLSessionDownloadTask *downloadTask in self.downloadTasks) {
        [self cancelTask:downloadTask];
    }
}

- (void)cancelTask:(NSURLSessionDownloadTask *)downloadTask {
    [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        [resumeData writeToFile:[self.downloadingCachePath stringByAppendingPathComponent:[downloadTask.originalRequest.URL.absoluteString XMAF_md5]] atomically:NO];
    }];
}

- (void)cleanDownloadingCache {
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.downloadingCachePath error:nil];
    if (array) {
        for (NSString *str in array) {
            [self deleteCacheFile:str];
        }
    }
}

- (void)cleanDownloadedCahce {
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.downloadedCachePath error:nil];
    if (array) {
        for (NSString *str in array) {
            [[NSFileManager defaultManager] removeItemAtPath:[self.downloadedCachePath stringByAppendingPathComponent:str] error:nil];
        }
    }
}
#pragma mark - Private Methods

- (void)downloadCompleteWithResponse:(NSURLResponse *)response error:(NSError *)error {
    if (!error) {
        [self deleteCacheFile:response.URL.absoluteString];
    }
}

- (void)deleteCacheFile:(NSString *)absoluteURLString {
    NSString *fileDownloadingPath = [self.downloadingCachePath stringByAppendingPathComponent:[absoluteURLString XMAF_md5]];
    BOOL isDirectiroy;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileDownloadingPath isDirectory:&isDirectiroy] && !isDirectiroy) {
        [[NSFileManager defaultManager] removeItemAtPath:fileDownloadingPath error:nil];
    }
}

- (BOOL)isFileDownloading:(NSString *)fileDownloadingPath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileDownloadingPath]) {
        return YES;
    }
    return NO;
}

#pragma mark - Getters

- (AFURLSessionManager *)sessionManager {
    if (!_sessionManager) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:kXMAFDownloadSessionIdentifier];
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 1;
        _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
        [_sessionManager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            XMAFDownloadProgressBlock progressBlock = objc_getAssociatedObject(downloadTask, &progressBlockKey);
            progressBlock(totalBytesWritten,totalBytesExpectedToWrite);
        }];
    }
    return _sessionManager;
}

- (NSArray *)downloadTasks {
    return self.sessionManager.downloadTasks;
}

/**
 *  正在下载的缓存路径
 *  当用户cancel某个downloadTask时,将已经下载的部分数据移动到此目录下,方便用户之后重新下载的话,使用断点续传功能
 */
- (NSString *)downloadingCachePath {
    return [self.cachePath stringByAppendingPathComponent:@"downloading"];
}

/**
 *  下载完成后存放目录路径,当用户没有传入destination时使用
 */
- (NSString *)downloadedCachePath {
    return [self.cachePath stringByAppendingPathComponent:@"downloaded"];
}

@end
