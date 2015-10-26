//
//  XMAFService.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFService.h"

@implementation XMAFService

- (instancetype)init
{
    if (self = [super init]) {
        if ([self conformsToProtocol:@protocol(XMAFServiceProtocal)]) {
            self.child = (id<XMAFServiceProtocal>)self;
        }else {
            NSAssert(NO, @"XMAFService is not conforms To XMAFServiceProtocal");
        }
    }
    return self;
}

#pragma mark - Getters

- (NSString *)privateKey {
    return self.child.isOnline ? self.child.onlinePrivateKey : self.child.offlinePrivateKey;
}

- (NSString *)publicKey {
    return self.child.isOnline ? self.child.onlinePublicKey : self.child.offlinePublicKey;
}

- (NSString *)apiBaseUrl {
    return self.child.isOnline ? self.child.onlineApiBaseUrl : self.child.offlineApiBaseUrl;
}

- (NSString *)apiVersion {
    return self.child.isOnline ? self.child.onlineApiVersion : self.child.offlineApiVersion;
}

- (NSDictionary *)commonParams {
    return self.child.isOnline ? self.child.onlineCommonParams : self.child.offlineCommonParams;
}
@end
