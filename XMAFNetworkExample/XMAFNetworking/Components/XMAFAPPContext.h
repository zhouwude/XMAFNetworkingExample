//
//  XMAFAPPContext.h
//  XMAFNetworkExample
//  XMAFAPPContext 关于app的一些基础配置
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "XMAFNetworkingConfiguration.h"

@interface XMAFAPPContext : NSObject

@property (nonatomic, copy) NSString *channelID;    //渠道号
@property (nonatomic, copy) NSString *appName;      //应用名称

#pragma mark - 请求相关参数
@property (nonatomic, copy, readonly) NSString *deviceName;            //设备名称
@property (nonatomic, copy, readonly) NSString *osName;            //系统名称
@property (nonatomic, copy, readonly) NSString *osVersion;            //系统版本
@property (nonatomic, copy, readonly) NSString *bundleVersion;           //Bundle版本
@property (nonatomic, copy, readonly) NSString *from;         //请求来源，值都是@"mobile"
@property (nonatomic, copy, readonly) NSString *osType;      //操作系统类型
@property (nonatomic, copy, readonly) NSString *qtime;        //发送请求的时间
@property (nonatomic, copy, readonly) NSString *macid;
@property (nonatomic, copy, readonly) NSString *uuid;
@property (nonatomic, copy, readonly) NSString *udid;
@property (nonatomic, readonly) BOOL isReachable;

+ (instancetype)sharedInstance;

- (void)configWithChannelID:(NSString *)channelID appName:(NSString *)appName appKey:(NSString *)appKey logEnable:(BOOL)logEnable;

@end
