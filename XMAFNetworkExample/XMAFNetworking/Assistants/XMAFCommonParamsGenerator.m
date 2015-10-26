//
//  XMAFCommonParamsGenerator.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFCommonParamsGenerator.h"
#import "XMAFAPPContext.h"

@implementation XMAFCommonParamsGenerator

+ (NSDictionary *)commonParamsDictionary {
    XMAFAPPContext *context = [XMAFAPPContext sharedInstance];
    return @{
             @"appName":context.appName,
             @"osName":context.osName,
             @"osType":context.osType,
             @"osVersion":context.osVersion,
             @"bundleVersion":context.bundleVersion,
             @"from":context.from,
             @"deveiceName":context.deviceName,
             @"qtime":context.qtime,
             @"udid":context.udid};
}

@end
