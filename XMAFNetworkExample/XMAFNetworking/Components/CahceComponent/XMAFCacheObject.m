//
//  XMAFCacheObject.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/22.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFCacheObject.h"
#import "XMAFNetworkingConfiguration.h"

@interface XMAFCacheObject ()

@property (nonatomic, copy, readwrite) NSData *content;
@property (nonatomic, copy, readwrite) NSDate *lastUpdateTime;

@end

@implementation XMAFCacheObject

#pragma mark - life cycle
- (instancetype)initWithContent:(NSData *)content
{
    self = [super init];
    if (self) {
        self.content = content;
    }
    return self;
}

#pragma mark - public method

- (void)updateContent:(NSData *)content
{
    self.content = content;
}

#pragma mark - Getters
- (BOOL)isEmpty
{
    return self.content == nil;
}

- (BOOL)isOutdated
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > kXMAFCacheOutdateTimeSeconds;
}

- (void)setContent:(NSData *)content
{
    _content = [content copy];
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}



@end
