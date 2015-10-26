//
//  XMAFServiceFactory.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFServiceFactory.h"
#import "XMAFBaiduService.h"

NSString *const kXMAFBaiduServiceIdentifier = @"kXMAFBaiduServiceIdentifier";

@interface XMAFServiceFactory ()

@property (strong, nonatomic) NSMutableDictionary *serviceStorage;

@end

@implementation XMAFServiceFactory


#pragma mark - Life Cycle

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

#pragma mark - Public Methods

- (XMAFService<XMAFServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier {
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self createServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

#pragma mark - Private Methods

- (XMAFService<XMAFServiceProtocal> *)createServiceWithIdentifier:(NSString *)identifier {
    //TODO增加各种不同的service
    if ([identifier isEqualToString:kXMAFBaiduServiceIdentifier]) {
        return [[XMAFBaiduService alloc] init];
    }
    return nil;
}

#pragma mark - Getters
- (NSMutableDictionary *)serviceStorage {
    if (!_serviceStorage) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}
@end
