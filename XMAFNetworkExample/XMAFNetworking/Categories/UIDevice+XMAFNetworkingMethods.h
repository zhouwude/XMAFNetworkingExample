//
//  UIDevice+XMAFNetworkingMethods.h
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (XMAFNetworkingMethods)


/*
 * @method uuid
 * @description apple identifier support iOS6 and iOS5 below
 */

- (NSString *) XMAF_uuid;
- (NSString *) XMAF_udid;
- (NSString *) XMAF_macaddress;
- (NSString *) XMAF_macaddressMD5;
- (NSString *) XMAF_machineType;
- (NSString *) XMAF_ostype;//显示“ios6，ios5”，只显示大版本号
- (NSString *) XMAF_createUUID;

@end
