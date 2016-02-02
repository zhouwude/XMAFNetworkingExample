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

- (NSDictionary *)commonParams {
    switch (self.serviceType) {
        default:
            return [XMAFCommonParamsGenerator commonParamsDictionary];
            break;
    }
}

- (NSDictionary *)httpHeaders {
    switch (self.serviceType) {
        default:
            return @{@"apikey":@"3324c6172adfa49500f83424d10435d1"};
            break;
    }
}

- (NSString *)apiBaseUrl {
    switch (self.serviceType) {
        default:
            return @"http://apis.baidu.com/";
            break;
    }
}

@end
