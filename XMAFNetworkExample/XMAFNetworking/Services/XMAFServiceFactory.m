//
//  XMAFServiceFactory.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFServiceFactory.h"


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

- (XMAFService *)serviceWithIdentifier:(NSString *)identifier {
    if (self.serviceStorage[identifier] == nil) {
        NSLog(@"you must create service for :%@ before use it",identifier);
        return nil;
    }
    return self.serviceStorage[identifier];
}

- (void)setService:(XMAFService *)service forIdentifier:(NSString *)identifier {
    self.serviceStorage[identifier] = service;
}

#pragma mark - Getters
- (NSMutableDictionary *)serviceStorage {
    if (!_serviceStorage) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}
@end
