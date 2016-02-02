//
//  ViewController.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "ViewController.h"

#import "XMAFBaiduWeatherManager.h"
#import "XMAFDownloadManager.h"

#import "AFNetworking.h"

@interface ViewController ()<UIViewControllerContextTransitioning,UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) NSURLSessionDownloadTask *task;
@property (strong, nonatomic) NSURLSessionDownloadTask *task2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.backgroundColor = [UIColor blackColor];
    button.frame = CGRectMake(60, 60, 60, 60);
    button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self downloadFile];
        [self downloadFile2];
        return [RACSignal empty];
    }];
    [self.view addSubview:button];
    
}


- (void)viewWillAppear:(BOOL)animated    // Called when the view is about to made visible. Default does nothing
{
    
    [super viewWillAppear:animated];
    NSLog(@"%@",NSStringFromSelector(@selector(viewWillAppear:)));
}
- (void)viewDidAppear:(BOOL)animated     // Called when the view has been fully transitioned onto the screen. Default does nothing
{
    
    [super viewDidAppear:animated];
    NSLog(@"%@",NSStringFromSelector(@selector(viewDidAppear:)));
}
- (void)viewWillDisappear:(BOOL)animated // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
{
    
    [super viewWillDisappear:animated];
    NSLog(@"%@",NSStringFromSelector(@selector(viewWillDisappear:)));
}
- (void)viewDidDisappear:(BOOL)animated  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
{
    [super viewDidDisappear:animated];
    NSLog(@"%@",NSStringFromSelector(@selector(viewDidDisappear:)));
}

// Called just before the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
- (void)viewWillLayoutSubviews NS_AVAILABLE_IOS(5_0);
// Called just after the view controller's view's layoutSubviews method is invoked. Subclasses can implement as necessary. The default is a nop.
{
    [super viewWillLayoutSubviews];
    NSLog(@"%@",NSStringFromSelector(@selector(viewWillLayoutSubviews)));
}
- (void)viewDidLayoutSubviews NS_AVAILABLE_IOS(5_0){
    [super viewWillLayoutSubviews];
    NSLog(@"%@",NSStringFromSelector(@selector(viewDidLayoutSubviews)));
}

- (void)loadData {
    
    [[XMAFAPPContext sharedInstance] configWithChannelID:@"XMAF" appName:@"XMAFAppTypeDemo" appType:XMAFAppTypeDemo];
    XMAFBaiduWeatherManager *weatherManager = [[XMAFBaiduWeatherManager alloc] init];
    [[weatherManager getCityWeather:@"beijing"] subscribeNext:^(id x) {
        
    } error:^(NSError *error) {
        
    }];
    
}

- (void)downloadFile {
    NSString *imageURLString = @"http://d.hiphotos.baidu.com/image/pic/item/fcfaaf51f3deb48fefedb9dcf21f3a292df5782f.jpg";
    if (!self.task) {
        self.task = [[XMAFDownloadManager manager] downloadWithURLString:imageURLString fileName:@"test.jpg" progressBlock:^(int64_t bytes, int64_t totalBytes) {
            NSLog(@"this is progressBlock file1 :%.2f%%",bytes*100.0f/totalBytes);
        } completeBlock:^(NSString *filePath, NSError *error) {
            NSLog(@"fileDownload complete :%@",filePath);
        }];
    } else {
        [[XMAFDownloadManager manager] cancelTask:self.task];
        self.task = nil;
    }
    NSLog(@"this is task state :%ld",(long)self.task.state);
    
}


- (void)downloadFile2 {

    NSString *imageURLString = @"http://pic1.win4000.com/wallpaper/0/51f1e408b5ea1.jpg";
    if (!self.task2) {
        self.task2 = [[XMAFDownloadManager manager] downloadWithConstructBlock:^NSDictionary *{
            return @{kXMAFDownloadURLStringKey:imageURLString};
        } progressBlock:^(int64_t bytes, int64_t totalBytes) {
            NSLog(@"this is progressBlock file2 :%.2f%%",bytes*100.0f/totalBytes);
        } completeBlock:^(NSString *filePath, NSError *error) {
            NSLog(@"fileDownload complete :%@",filePath);
        }];
    } else {
        [[XMAFDownloadManager manager] cancelTask:self.task2];
        self.task2 = nil;
    }
    NSLog(@"this is task state :%ld",(long)self.task2.state);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
