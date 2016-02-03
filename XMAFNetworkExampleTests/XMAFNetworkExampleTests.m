//
//  XMAFNetworkExampleTests.m
//  XMAFNetworkExampleTests
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AFNetworking.h"
#import "XMAFDownloadManager.h"
#import "XMAFUploadManager.h"
#import "XMAFBaiduWeatherManager.h"
#import "XMAFBaiduService.h"

@interface XMAFNetworkExampleTests : XCTestCase

@property (strong, nonatomic) XMAFBaiduWeatherManager *baiduWeatherManager;
@property (strong, nonatomic) XMAFDownloadManager *downloadManager;
@property (strong, nonatomic) XMAFUploadManager *uploadManager;
@end

@implementation XMAFNetworkExampleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [[XMAFAPPContext sharedInstance] configWithChannelID:@"XMAF" appName:@"XMAFAppTypeDemo" appType:XMAFAppTypeDemo];
    [[XMAFServiceFactory sharedInstance] setService:[[XMAFBaiduService alloc] init] forIdentifier:kXMAFBaiduServiceIdentifier];
    self.baiduWeatherManager = [[XMAFBaiduWeatherManager alloc] init];
    self.downloadManager = [XMAFDownloadManager manager];
    self.uploadManager = [XMAFUploadManager manager];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.baiduWeatherManager = nil;
    self.downloadManager = nil;
    self.uploadManager = nil;
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



- (void)testDownloadFile {
    XCTestExpectation *expectation = [self expectationWithDescription:@"test download file"];
    NSArray *imageURLStrings = @[@"http://fmn.rrimg.com/fmn062/xiaozhan/20130110/2030/original_TeQA_6cce00004369118f.jpg",@"http://f6.topit.me/6/ee/41/118829204023441ee6o.jpg",@"http://ic.topit.me/c/47/76/1188291099fa67647co.jpg",@"http://p1.gexing.com/G1/M00/51/F3/rBACFFMvA5rw4Yd-AAH0szYro28554_600x.jpg",@"http://fa.topit.me/a/e3/24/118829314547d24e3ao.jpg",@"http://www.bz55.com/uploads/allimg/140415/1-1404151A507.jpg",@"http://wayqq.cn/article/UploadPic/2012-8/201283121221853174.jpg"];
    
    for (NSString *urlString in imageURLStrings) {
        [self.downloadManager downloadWithConstructBlock:^NSDictionary *{
            return @{kXMAFDownloadURLStringKey:urlString};
        } progressBlock:^(int64_t bytes, int64_t totalBytes) {
            NSLog(@"this is :%d %.2f%%",(int)[imageURLStrings indexOfObject:urlString],bytes*100.0f/totalBytes);
        } completeBlock:^(NSString *filePath, NSError *error) {
            NSLog(@"file download success :%@",filePath);
            if (self.downloadManager.downloadTasks.count == 0) {
                NSLog(@"all download complete");
                [expectation fulfill];
            }
        }];
    }

    [self waitForExpectationsWithTimeout:20 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"download file timeout");
            [[XMAFDownloadManager manager] cancelTasks];
        }
    }];
}

- (void)testGetQINIUToken:(void(^)(NSString *token))completeBlock {
    XCTestExpectation *expectation = [self expectationWithDescription:@"test get qiniu token"];
    [[AFHTTPSessionManager manager] GET:@"http://127.0.0.1:9999/token" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"this is responseObject");
        completeBlock(responseObject[@"token"]);
        [expectation fulfill];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        completeBlock(nil);
        NSAssert(NO, @"error");
    }];

}

- (void)testUploadFile {

    XCTestExpectation *expectation = [self expectationWithDescription:@"test  uploadfile"];
    [self.uploadManager uploadFileWithConstructingRequestBlock:^NSDictionary *{
        return @{kXMAFUploadURLStringKey:@"http://127.0.0.1:9999/file"};
    } constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //上传文件装用
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle ] pathForResource:@"upload" ofType:@"png"]] name:@"file" fileName:@"file_test1.png" mimeType:@"png"];
        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle ] pathForResource:@"upload" ofType:@"png"]] name:@"file2" fileName:@"file_test2.png" mimeType:@"png"];
        
        [formData appendPartWithFormData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle ] pathForResource:@"upload" ofType:@"png"]] name:@"data_test1"];
        [formData appendPartWithFormData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle ] pathForResource:@"upload" ofType:@"png"]] name:@"data_test2"];
        //上传data数据使用
        [formData appendPartWithFormData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle ] pathForResource:@"upload" ofType:@"png"]] name:@"date_test3"];

    } progressBlock:^(int64_t bytes, int64_t totalBytes) {
        NSLog(@"this is :%.2f%%",bytes*100.0f/totalBytes);
    } completeBlock:^(id responseObject, NSError *error) {
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:3.0 handler:^(NSError * _Nullable error) {
        
    }];
}

@end
