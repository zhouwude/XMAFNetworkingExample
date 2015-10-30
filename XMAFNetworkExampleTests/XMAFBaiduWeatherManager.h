//
//  XMAFBaiduCitylistManager.h
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/22.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFNetworking.h"
#import "ReactiveCocoa.h"

@interface XMAFBaiduWeatherManager : XMAFNetworkingBaseManager<XMAFManagerProtocol>

- (RACSignal *)getCityWeather:(NSString *)city;

@end
