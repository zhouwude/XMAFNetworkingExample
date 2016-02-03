//
//  XMAFLoggerConfiguration.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFLoggerConfiguration.h"
#import "XMAFAPPContext.h"

@interface XMAFLoggerConfiguration ()
/** 是否自动打印网络调试 */
@property (assign, nonatomic, readwrite) BOOL logEnable;

/** 渠道ID */
@property (nonatomic, strong, readwrite) NSString *channelID;

/** app标志 */
@property (nonatomic, strong, readwrite) NSString *appKey;

/** app名字 */
@property (nonatomic, strong, readwrite) NSString *logAppName;


@end

@implementation XMAFLoggerConfiguration

+ (XMAFLoggerConfiguration *)configurationWithAppKey:(NSString *)appKey logEnable:(BOOL)logEnable {
    XMAFLoggerConfiguration *configuration = [[XMAFLoggerConfiguration alloc] init];
    configuration.channelID = [XMAFAPPContext sharedInstance].channelID ? : @"on channle id";
    configuration.appKey = appKey ? : @"no app key";
    configuration.logAppName = [XMAFAPPContext sharedInstance].appName? : @"no app name";
    configuration.logEnable = logEnable;
    return configuration;
}

@end
