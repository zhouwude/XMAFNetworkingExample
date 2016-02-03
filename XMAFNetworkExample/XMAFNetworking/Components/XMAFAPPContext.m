//
//  XMAFAPPContext.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFAPPContext.h"
#import "AFNetworking.h"
#import "XMAFLogger.h"

#import "NSString+XMAFNetworkingMethods.h"
#import "NSObject+XMAFNetworkingMethods.h"
#import "UIDevice+XMAFNetworkingMethods.h"

@interface XMAFAPPContext ()

@property (nonatomic, strong) UIDevice *device;
#pragma mark - 请求相关参数
@property (nonatomic, copy, readwrite) NSString *deviceName;            //设备名称
@property (nonatomic, copy, readwrite) NSString *osName;            //系统名称
@property (nonatomic, copy, readwrite) NSString *osVersion;            //系统版本
@property (nonatomic, copy, readwrite) NSString *bundleVersion;           //Bundle版本
@property (nonatomic, copy, readwrite) NSString *from;         //请求来源，值都是@"mobile"
@property (nonatomic, copy, readwrite) NSString *qtime;        //发送请求的时间
@property (nonatomic, copy, readwrite) NSString *macid;
@property (nonatomic, copy, readwrite) NSString *uuid;
@property (nonatomic, copy, readwrite) NSString *udid;
@property (nonatomic, readwrite) BOOL isReachable;

@end

@implementation XMAFAPPContext

- (UIDevice *)device
{
    if (_device == nil) {
        _device = [UIDevice currentDevice];
    }
    return _device;
}

- (NSString *)deviceName
{
    if (_deviceName == nil) {
        _deviceName = self.device.model;
    }
    return _deviceName;
}

- (NSString *)osName{
    if (!_osName) {
        _osName = self.device.systemName;
    }
    return _osName;
}

- (NSString *)osVersion {
    if (!_osVersion) {
        _osVersion = self.device.systemVersion;
    }
    return _osVersion;
}

- (NSString *)osType {
    return [NSString stringWithFormat:@"%@ %@",self.osName,self.osVersion];
}

- (NSString *)bundleVersion {
    if (!_bundleVersion) {
        _bundleVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] XMAF_defaultValue:@"no bundle version"];
    }
    return _bundleVersion;
}

- (NSString *)from {
    if (!_from) {
        _from = @"mobile";
    }
    return _from;
}

- (NSString *)qtime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:NSLocalizedString(@"yyyyMMddHHmmss", nil)];
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)macid {
    if (_macid == nil) {
        _macid = [[self.device XMAF_macaddressMD5] XMAF_defaultValue:@"no macaddressMD5"];
    }
    return _macid;
}

- (NSString *)uuid {
    if (_uuid == nil) {
        _uuid = [[self.device XMAF_uuid] XMAF_defaultValue:@"no uuid"];
    }
    return _uuid;
}


- (NSString *)udid {
    if (!_udid) {
        _udid = [[self.device XMAF_udid] XMAF_defaultValue:@"no udid"];
    }
    return _udid;
}


- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}


#pragma mark - Life Cycle

+ (instancetype)sharedInstance
{
    static XMAFAPPContext *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XMAFAPPContext alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedInstance;
}

#pragma mark - Public Methods

- (void)configWithChannelID:(NSString *)channelID appName:(NSString *)appName appKey:(NSString *)appKey logEnable:(BOOL)logEnable
{
    self.channelID = channelID;
    self.appName = appName;
    [[XMAFLogger sharedInstance] setConfiguration:[XMAFLoggerConfiguration configurationWithAppKey:appKey logEnable:YES]];
}

@end
