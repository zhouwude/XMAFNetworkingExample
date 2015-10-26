//
//  XMAFCache.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/22.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFCache.h"
#import "XMAFCacheObject.h"
#import "XMAFNetworkingConfiguration.h"

#import "NSDictionary+XMAFNetworkingMethods.h"
#import "NSString+XMAFNetworkingMethods.h"

@interface XMAFCache ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation XMAFCache

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}


#pragma mark - Public Method

- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)serviceIdentifier
                                      methodName:(NSString *)methodName
                                   requestParams:(NSDictionary *)requestParams
{
    return [self fetchCachedDataWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)saveCacheWithData:(NSData *)cachedData
        serviceIdentifier:(NSString *)serviceIdentifier
               methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    [self saveCacheWithData:cachedData key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                              methodName:(NSString *)methodName
                           requestParams:(NSDictionary *)requestParams
{
    [self deleteCacheWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (NSData *)fetchCachedDataWithKey:(NSString *)key
{
    XMAFCacheObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject.isOutdated || cachedObject.isEmpty) {
        return nil;
    } else {
        return cachedObject.content;
    }
}

- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key
{
    XMAFCacheObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject == nil) {
        cachedObject = [[XMAFCacheObject alloc] init];
    }
    [cachedObject updateContent:cachedData];
    [self.cache setObject:cachedObject forKey:key];
    
}

- (void)deleteCacheWithKey:(NSString *)key
{
    [self.cache removeObjectForKey:key];
}

- (void)clean
{
    [self.cache removeAllObjects];
}

- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    return [[NSString stringWithFormat:@"%@%@%@", serviceIdentifier, methodName, [requestParams XMAF_urlParamsStringSignature:NO]] XMAF_md5];
}

#pragma mark - Getters

- (NSCache *)cache {
    if (!_cache) {
        _cache = [[NSCache alloc] init];
        _cache.totalCostLimit = kXMAFCacheCountLimit;
    }
    return _cache;
}
@end
