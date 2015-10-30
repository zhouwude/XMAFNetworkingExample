//
//  XMAFUploadManager.h
//  XMAFNetworkExample
//  上传图片manager,基于AFNetworking封装
//  提供带有上传进度的回调block,支持多图片同时上传
//  Created by shscce on 15/10/28.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const kXMAFUploadURLStringKey /**< 上传地址key */;
FOUNDATION_EXTERN NSString *const kXMAFUploadRequestParamsKey /**< 上传请求参数key */;
FOUNDATION_EXTERN NSString *const kXMAFUploadRequestHeadersKey /**< 上传头部key */;

typedef void(^XMAFUploadProgressBlock)(int64_t bytes,int64_t totalBytes);

@protocol AFMultipartFormData;
@interface XMAFUploadManager : NSObject

+ (instancetype)manager;

/**
 *  构造一个NSURLSessionUploadTask实例
 *
 *  @param constructingRequestBlock 构造请求block 包含urlString,requestParams,requestHeaders
 *  @param constructingBodyBlock    构造上传文件block
 *  @param progressBlock            上传进度block
 *  @param completeBlock            上传完成block
 *
 */
- (NSURLSessionUploadTask *)uploadFileWithConstructingRequestBlock:(NSDictionary *(^)())constructingRequestBlock constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))constructingBodyBlock progressBlock:(void(^)(int64_t bytes,int64_t totalBytes))progressBlock completeBlock:(void(^)(id responseObject,NSError *error))completeBlock;

@end
