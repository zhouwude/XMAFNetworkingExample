//
//  XMAFNetworkingConfiguration.h
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#ifndef XMAFNetworkingConfiguration_h
#define XMAFNetworkingConfiguration_h

typedef NS_ENUM(NSUInteger, XMAFURLResponseStatus)
{
    XMAFURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。
    XMAFURLResponseStatusErrorTimeout,
    XMAFURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

static NSTimeInterval kXMAFNetworkingTimeoutSeconds = 20.0f;

static NSString *XMAFKeychainServiceName = @"com.xmfraker";
static NSString *XMAFUDIDName = @"XMFrakerUDID";
static NSString *XMAFPasteboardType = @"XMAFNetworkingAppsContent";

static BOOL kXMAFShouldCache = NO;
static NSTimeInterval kXMAFCacheOutdateTimeSeconds = 300; // 5分钟的cache过期时间
static NSUInteger kXMAFCacheCountLimit = 1000; // 最多1000条cache


#endif /* XMAFNetworkingConfiguration_h */
