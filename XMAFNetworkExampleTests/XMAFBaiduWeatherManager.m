//
//  XMAFBaiduCitylistManager.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/22.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFBaiduWeatherManager.h"
#import "XMAFServiceFactory.h"


@interface XMAFBaiduWeatherManager ()<XMAFManagerCallBackDelegate,XMAFManagerParamSourceDelegate>

@property (copy, nonatomic) NSString *city;
@end
@implementation XMAFBaiduWeatherManager

- (instancetype)init {
    if ([super init]) {
        self.delegate = self;
        self.paramSource = self;
    }
    return self;
}


#pragma mark - XMAFManagerParamSourceDelegate

- (NSDictionary *)paramsForApi:(XMAFNetworkingBaseManager *)manager {
    return @{@"city":self.city};
}

#pragma mark - XMAFManagerCallBackDelegate

- (void)managerDidFailed:(XMAFNetworkingBaseManager *)manager {
    NSLog(@"request did failed in manager");
}

- (void)managerDidSuccess:(XMAFNetworkingBaseManager *)manager {
    NSLog(@"request did success in manager");
}

#pragma mark - XMAFManager Protocols Methods

- (NSString *)methodName {
    return @"heweather/weather/free";
}

- (NSString *)serviceType {
    return kXMAFBaiduServiceIdentifier;
}

- (XMAFManagerRequestType)requestType {
    return XMAFManagerRequestTypeGet;
}

- (BOOL)shouldCache {
    return YES;
}


#pragma mark - Public Methods

- (RACSignal *)getCityWeather:(NSString *)city {
    self.city = [city copy];
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self setCallBackBlock:^(XMAFNetworkingBaseManager *manager, BOOL isSuccess) {
            if (isSuccess) {
                [subscriber sendNext:manager];
                [subscriber sendCompleted];
            }else{
                [subscriber sendError:nil];
            }
        }];
        [self loadData];
        return nil;
    }];
}

@end
