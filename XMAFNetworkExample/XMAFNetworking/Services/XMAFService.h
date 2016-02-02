//
//  XMAFService.h
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 服务器类型 */
typedef NS_ENUM(NSUInteger, XMAFServiceType) {
    /** 未知服务器 */
    XMAFServiceUnknown = 0,
    /** 自定义服务器 */
    XMAFServiceCustom,
    /** 开发环境内网服务器 */
    XMAFServiceDevIn,
    /** 开发环境外网服务器 */
    XMAFServiceDevOut,
    /** UAT测试预发服务器 */
    XMAFServiceUAT,
    /** 正式发布服务器 */
    XMAFServiceDis,
};

@interface XMAFService : NSObject

@property (nonatomic, strong, readonly) NSString *publicKey;
@property (nonatomic, strong, readonly) NSString *privateKey;
@property (nonatomic, strong, readonly) NSString *apiBaseUrl;
@property (nonatomic, strong, readonly) NSString *apiVersion;
@property (copy, nonatomic, readonly) NSDictionary *commonParams;
@property (copy, nonatomic, readonly) NSDictionary *httpHeaders;
@property (nonatomic, assign, readonly) BOOL needSign;
@property (nonatomic, assign) XMAFServiceType serviceType;
@property (nonatomic, copy, readonly)   NSString *serviceStatus;

@end
