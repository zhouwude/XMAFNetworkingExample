//
//  XMAFBaiduService.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/22.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFBaiduService.h"
#import "XMAFCommonParamsGenerator.h"

@implementation XMAFBaiduService

#pragma mark - Getters

- (BOOL)isOnline {
    return YES;
}

- (NSString *)offlineApiBaseUrl {
    return self.onlineApiBaseUrl;
}

- (NSString *)offlineApiVersion {
    return self.onlineApiVersion;
}

- (NSString *)offlinePrivateKey {
    return self.onlinePrivateKey;
}

- (NSString *)offlinePublicKey {
    return self.onlinePublicKey;
}

- (NSString *)onlinePublicKey {
    return @"";
}

- (NSString *)onlinePrivateKey {
    return @"";
}

- (NSString *)onlineApiVersion {
    return @"v1.0";
}

- (NSString *)onlineApiBaseUrl {
    return @"http://apis.baidu.com/";
}

- (NSDictionary *)onlineCommonParams {
    return [XMAFCommonParamsGenerator commonParamsDictionary];
}

- (NSDictionary *)offlineCommonParams {
    return self.onlineCommonParams;
}

- (NSDictionary *)httpHeaders {
    return @{@"apikey":@"3324c6172adfa49500f83424d10435d1"};
}

@end
