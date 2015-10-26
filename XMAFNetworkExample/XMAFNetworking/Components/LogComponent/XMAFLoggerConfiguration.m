//
//  XMAFLoggerConfiguration.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFLoggerConfiguration.h"
#import "XMAFAPPContext.h"

@implementation XMAFLoggerConfiguration

- (void)configWithAppType:(XMAFAppType)appType {
    switch (appType) {
        case XMAFAppTypeDemo:
            self.channelID = [XMAFAPPContext sharedInstance].channelID;
            self.appKey = @"appKey";
            self.logAppName = [XMAFAPPContext sharedInstance].appName;
            self.serviceType = @"com.XMAFNetworking.demo";
            self.sendLogMethod = @"admin.writeAppLog";
            self.sendActionMethod = @"admin.recordaction";
            self.sendLogKey = @"data";
            self.sendActionKey = @"action_note";
            self.shouldLog = YES;
            break;
            
        default:
            self.channelID = [XMAFAPPContext sharedInstance].channelID;
            self.appKey = @"appKey";
            self.logAppName = [XMAFAPPContext sharedInstance].appName;
            self.serviceType = @"com.XMAFNetworking.demo";
            self.sendLogMethod = @"admin.writeAppLog";
            self.sendActionMethod = @"admin.recordaction";
            self.sendLogKey = @"data";
            self.sendActionKey = @"action_note";
            self.shouldLog = YES;
            break;
    }
}


@end
