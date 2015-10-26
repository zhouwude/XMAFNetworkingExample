//
//  ViewController.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "ViewController.h"

#import "XMAFBaiduWeatherManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self loadData];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.backgroundColor = [UIColor blackColor];
    button.frame = CGRectMake(60, 60, 60, 60);
    button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self loadData];
        return [RACSignal empty];
    }];
    [self.view addSubview:button];
}

- (void)loadData {
    [[XMAFAPPContext sharedInstance] configWithChannelID:@"XMAF" appName:@"XMAFAppTypeDemo" appType:XMAFAppTypeDemo];
    XMAFBaiduWeatherManager *weatherManager = [[XMAFBaiduWeatherManager alloc] init];
    [[weatherManager getCityWeather:@"beijing"] subscribeNext:^(id x) {
        
    } error:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
