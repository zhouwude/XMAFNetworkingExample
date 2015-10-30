//
//  XMAFDownloadManager.h
//  XMAFNetworkExample
//  基于AFNetworking封装的上传manager
//  Created by shscce on 15/10/27.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^XMAFDownloadProgressBlock)(int64_t bytes,int64_t totalBytes);
typedef void(^XMAFDownloadCompleteBlock)(NSString *filePath, NSError *error);
typedef NSDictionary *(^XMAFDownloadConstructBlock)();

FOUNDATION_EXTERN NSString *const kXMAFDownloadURLStringKey;
FOUNDATION_EXTERN NSString *const kXMAFDownloadFileNameKey;

@interface XMAFDownloadManager : NSObject

@property (copy, nonatomic, readonly) NSArray *downloadTasks;

+ (instancetype)manager;
- (instancetype)initWithCachePath:(NSString *)cachePath;

- (void)cleanDownloadingCache;
- (void)cleanDownloadedCahce;

/**
 *  下载文件
 *
 *  @param URLString     下载地址
 *  @param fileName      下载文件名
 *  @param progressBlock 进度条block
 *  @param completeBlock 完成block
 *
 *  @return NSURLSessionDownloadTask 实例
 */
- (NSURLSessionDownloadTask *)downloadWithURLString:(NSString *)URLString fileName:(NSString *)fileName progressBlock:(XMAFDownloadProgressBlock)progressBlock completeBlock:(XMAFDownloadCompleteBlock)completeBlock;

/**
 *  下载文件
 *
 *  @param constructBlock 构造block,返回NSDictionary类型
 *  @param progressBlock  进度条block
 *  @param completeBlock  完成block
 *
 *  @return NSURLSessionDownloadTask 实例
 */
- (NSURLSessionDownloadTask *)downloadWithConstructBlock:(XMAFDownloadConstructBlock)constructBlock progressBlock:(XMAFDownloadProgressBlock)progressBlock completeBlock:(XMAFDownloadCompleteBlock)completeBlock;

- (void)suspendTasks;
- (void)cancelTasks;
- (void)cancelTask:(NSURLSessionDownloadTask *)downloadTask;
@end
