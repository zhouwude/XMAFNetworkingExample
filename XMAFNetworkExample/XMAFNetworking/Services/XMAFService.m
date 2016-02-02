//
//  XMAFService.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFService.h"

@implementation XMAFService

#pragma mark - Getters

- (NSString *)privateKey {
    return @"";
}

- (NSString *)publicKey {
    return @"";
}


- (NSString *)apiBaseUrl {
    return @"";
}

- (NSString *)apiVersion {
    return @"v1.0";
}

- (NSDictionary *)commonParams {
    return [NSDictionary dictionary];
}

- (NSDictionary *)httpHeaders {
    return [NSDictionary dictionary];
}

- (BOOL)needSign {
    return NO;
}

- (NSString *)serviceStatus {
    switch (self.serviceType) {
        case XMAFServiceCustom:
            return @"custom";
            break;
        case XMAFServiceDevIn:
            return @"DevIn";
            break;
        case XMAFServiceDevOut:
            return @"DevOut";
            break;
        case XMAFServiceUAT:
            return @"UAT";
            break;
        case XMAFServiceDis:
            return @"online";
            break;
        default:
            return @"unknown";
            break;
    }
}

@end
