//
//  XMAFURLResponse.h
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMAFAPPContext.h"

@interface XMAFURLResponse : NSObject


@property (copy, nonatomic, readonly) id responseObject;
@property (nonatomic, copy, readonly) NSData *responseData;

@property (nonatomic, copy, readonly) NSString *responseString;
@property (nonatomic, assign, readonly) XMAFURLResponseStatus status;

@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy) NSDictionary *requestParams;
@property (nonatomic, assign, readonly) BOOL isCache;


/**
 *  生成一个XMAFURLResponse实例 默认isCache为NO
 *
 *  @param response  传入的response返回数据,可能是NSData 也可能是NSDictionary
 *  @param requestId 请求id
 *  @param request   请求request实例
 *  @param error     请求的错误 可能为nil
 *
 *  @return 一个XMAFURLResponse 实例
 */
- (instancetype)initWithResponse:(id)response requestId:(NSNumber *)requestId request:(NSURLRequest *)request error:(NSError *)error;

/**
 *  生成一个XMAFURLResponse实例,默认isCache为YES
 *
 *  @param data 传入的数据
 *
 *  @return 一个XMAFURLResponse 实例
 */
- (instancetype)initWithData:(NSData *)data;

@end
