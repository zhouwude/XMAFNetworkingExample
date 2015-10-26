//
//  XMAFNetworkExampleTests.m
//  XMAFNetworkExampleTests
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AFNetworking.h"
#import "XMAFBaiduWeatherManager.h"

@interface XMAFNetworkExampleTests : XCTestCase

@property (strong, nonatomic) XMAFBaiduWeatherManager *baiduWeatherManager;

@end

@implementation XMAFNetworkExampleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [[XMAFAPPContext sharedInstance] configWithChannelID:@"XMAF" appName:@"XMAFAppTypeDemo" appType:XMAFAppTypeDemo];
    self.baiduWeatherManager = [[XMAFBaiduWeatherManager alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.baiduWeatherManager = nil;
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


- (void)testGetBaiduCityList {

    XCTestExpectation *expectation = [self expectationWithDescription:@"test load weather"];
    
    [[self.baiduWeatherManager getCityWeather:@"beijing"] subscribeNext:^(id x) {
        NSLog(@"this is success");
        [expectation fulfill];
    } error:^(NSError *error) {
        NSLog(@"this is error");
        XCTAssert(@"error");
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"load weather timeout");
        }
    }];
}

@end
