//
//  XMAFRequestGenerator.h
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMAFRequestGenerator : NSObject

+ (id)sharedInstance;

/**
 *  生成一个AF的GET请求
 *
 *  @param serviceIdentifier 请求的serviceIdentifier
 *  @param requestParams     请求的参数
 *  @param methodName        请求的方法名
 *
 *  @return NSURLRequest 实例
 */
- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

/**
 *  生成一个AF的POST请求
 *
 *  @param serviceIdentifier 请求的serviceIdentifier
 *  @param requestParams     请求的参数
 *  @param methodName        请求的方法名
 *
 *  @return NSURLRequest 实例
 */
- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

@end
