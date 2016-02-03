//
//  XMAFLoggerConfiguration.h
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMAFNetworkingConfiguration.h"

@interface XMAFLoggerConfiguration : NSObject

/** 是否自动打印网络调试 */
@property (assign, nonatomic, readonly) BOOL logEnable;

/** 渠道ID */
@property (nonatomic, strong, readonly) NSString *channelID;

/** app标志 */
@property (nonatomic, strong, readonly) NSString *appKey;

/** app名字 */
@property (nonatomic, strong, readonly) NSString *logAppName;


+ (XMAFLoggerConfiguration *)configurationWithAppKey:(NSString *)appKey logEnable:(BOOL)logEnable;

@end
