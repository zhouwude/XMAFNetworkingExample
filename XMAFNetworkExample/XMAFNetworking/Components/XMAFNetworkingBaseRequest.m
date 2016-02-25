//
//  XMAFNetworkingBaseRequest.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFNetworkingBaseRequest.h"

#import "XMAFCache.h"
#import "XMAFLogger.h"
#import "XMAFApiProxy.h"
#import "XMAFServiceFactory.h"
#import "XMAFNetworkingConfiguration.h"


@interface XMAFNetworkingBaseRequest ()

@property (nonatomic, strong, readwrite) id fetchedRawData;

@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, readwrite) XMAFManagerErrorType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, strong) XMAFCache *cache;

@end

@implementation XMAFNetworkingBaseRequest

#pragma mark - Life Cycle

- (instancetype)init {
    
    if ([super init]) {
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;
        _fetchedRawData = nil;
        
        _callBackBlock = nil;
        
        _errorMessage = nil;
        _errorType = XMAFManagerErrorTypeDefault;
        if ([self conformsToProtocol:@protocol(XMAFManagerProtocol)]) {
            self.child = (id<XMAFManagerProtocol>)self;
        }else{
            NSAssert(NO, @"you must conforms To Protocol XMAFManagerProtocol");
        }
    }
    return self;
}

- (void)dealloc {
    [self cancelAllRequests];
    self.requestIdList = nil;
    self.callBackBlock = nil;
}

#pragma mark - Public Methods

- (void)cancelAllRequests {
    [[XMAFApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID {
    [[XMAFApiProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
    [self removeRequestIdWithRequestID:requestID];
}

- (id)fetchDataWithReformer:(id<XMAFManagerCallBackDataReformer>)reformer {
    id resultData = nil;
    if (reformer ) {
        resultData = [reformer manage:self reformerData:self.fetchedRawData];
    }else {
        resultData = self.fetchedRawData;
    }
    return resultData;
}

- (NSInteger)loadData {
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}


#pragma mark - 拦截器方法,提供后可以让子类重载,实现内部拦截

/**
 *  notes
 *  拦截器使用: XMAFNetworkingBaseRequest 子类重载此方法,实现内部拦截,或者直接使用外部拦截器self.interceptor拦截
 *  子类重载后 需要调用[super xxx] 实现外部拦截,根据调用[super xxx]的顺序决定内,外拦截器使用顺序
 */

- (void)beforePerformSuccessWithResponse:(XMAFURLResponse *)response
{
    self.errorType = XMAFManagerErrorTypeSuccess;
    if ((id<XMAFManagerInterceptor>)self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformSuccessWithResponse:)]) {
        [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
}

- (void)afterPerformSuccessWithResponse:(XMAFURLResponse *)response
{
    if ((id<XMAFManagerInterceptor>)self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (void)beforePerformFailWithResponse:(XMAFURLResponse *)response
{
    if ((id<XMAFManagerInterceptor>)self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
}

- (void)afterPerformFailWithResponse:(XMAFURLResponse *)response
{
    if ((id<XMAFManagerInterceptor>)self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if ((id<XMAFManagerInterceptor>)self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if ((id<XMAFManagerInterceptor>)self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}


/**
 *  提前写好,以下三个方法不是必须实现的,在BaseManager中又调用了,所以在BaseManager中实现一下,防止出现方法不存在的情况,子类可以重写一下三个方法
 *
 */
- (void)cleanData
{

    self.fetchedRawData = nil;
    self.errorMessage = nil;
    self.errorType = XMAFManagerErrorTypeDefault;
}

- (NSDictionary *)reformParams:(NSDictionary *)params
{

    return params;
}

- (BOOL)shouldCache
{
    return kXMAFShouldCache;
}

#pragma mark - XMAFManagerProtocol Methods

- (NSString *)methodName {
    return @"";
}

- (NSString *)serviceIdentifer {
    return @"";
}

- (XMAFManagerRequestType)requestType {
    return XMAFManagerRequestTypeGet;
}

#pragma mark - Private Methods


- (NSInteger)loadDataWithParams:(NSDictionary *)params {
    NSInteger requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];
    if ([self shouldCallAPIWithParams:apiParams]) {
        
        if (!self.validator || [self.validator manager:self isCorrectWithRequestParamsData:apiParams]) {
            // 先检查一下是否有缓存
            if ([self shouldCache] && [self hasCacheWithParams:apiParams]) {
                return 0;
            }
            
            // 实际的网络请求
            if ([self isReachable]) {
                switch (self.child.requestType)
                {
                    case XMAFManagerRequestTypeGet:
                    {
                        requestId = [[XMAFApiProxy sharedInstance] callGETWithParams:apiParams serviceIdentifier:self.child.serviceIdentifer methodName:self.child.methodName success:^(XMAFURLResponse *response) {
                            [self successedOnCallingAPI:response];
                        } fail:^(XMAFURLResponse *response) {
                            [self failedOnCallingAPI:response withErrorType:XMAFManagerErrorTypeDefault];
                        }];
                        [self.requestIdList addObject:@(requestId)];
                    }
                        break;
                    case XMAFManagerRequestTypePost:
                    {
                        requestId = [[XMAFApiProxy sharedInstance] callPOSTWithParams:apiParams serviceIdentifier:self.child.serviceIdentifer methodName:self.child.methodName success:^(XMAFURLResponse *response) {
                            [self successedOnCallingAPI:response];
                        } fail:^(XMAFURLResponse *response) {
                            [self failedOnCallingAPI:response withErrorType:XMAFManagerErrorTypeDefault];
                        }];
                        [self.requestIdList addObject:@(requestId)];
                    }
                        break;
                    default:
                        break;
                }
                
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[kXMAFNetworkingBaseRequestRequestID] = @(requestId);
                [self afterCallingAPIWithParams:params];
                return requestId;
                
            } else {
                [self failedOnCallingAPI:nil withErrorType:XMAFManagerErrorTypeNoNetWork];
                return requestId;
            }
        } else {
            [self failedOnCallingAPI:nil withErrorType:XMAFManagerErrorTypeParamsError];
            return requestId;
        }
    }
    return requestId;
    
}

- (BOOL)hasCacheWithParams:(NSDictionary *)params
{
    NSString *serviceIdentifier = self.child.serviceIdentifer;
    NSString *methodName = self.child.methodName;
    NSData *result = [self.cache fetchCachedDataWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params];
        
    if (result == nil) {
        return NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        XMAFURLResponse *response = [[XMAFURLResponse alloc] initWithData:result];
        response.requestParams = params;
        [XMAFLogger logDebugInfoWithCachedResponse:response methodName:methodName serviceIdentifier:[[XMAFServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier]];
        [self successedOnCallingAPI:response];
    });
    return YES;
}

- (void)apiCallBack:(XMAFURLResponse *)response
{
    if (response.status == XMAFURLResponseStatusSuccess) {
        [self successedOnCallingAPI:response];
    }else if (response.status == XMAFURLResponseStatusErrorTimeout) {
        [self failedOnCallingAPI:response withErrorType:XMAFManagerErrorTypeTimeout];
    }else{
        [self failedOnCallingAPI:response withErrorType:XMAFManagerErrorTypeContentError];
    }
}

- (void)successedOnCallingAPI:(XMAFURLResponse *)response
{
    if (response.responseObject) {
        self.fetchedRawData = [response.responseObject copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestId];
    if (!self.validator || [self.validator manager:self isCorrectWithResponseData:self.fetchedRawData]) {
        if ([self shouldCache] && !response.isCache) {
            [self.cache saveCacheWithData:response.responseData serviceIdentifier:self.child.serviceIdentifer methodName:self.child.methodName requestParams:response.requestParams];
        }
        [self beforePerformSuccessWithResponse:response];
        [self.delegate managerDidSuccess:self];
        if (self.callBackBlock) {
            self.callBackBlock(self,YES);
        }
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:XMAFManagerErrorTypeContentError];
    }
}

- (void)failedOnCallingAPI:(XMAFURLResponse *)response withErrorType:(XMAFManagerErrorType)errorType {
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    [self beforePerformFailWithResponse:response];
    [self.delegate managerDidFailed:self];
    if (self.callBackBlock) {
        self.callBackBlock(self,NO);
    }
    [self afterPerformFailWithResponse:response];
}


- (void)removeRequestIdWithRequestID:(NSInteger)requestId {
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

#pragma mark - Getters

- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isReachable
{
    BOOL isReachability = [XMAFAPPContext sharedInstance].isReachable;
    if (!isReachability) {
        self.errorType = XMAFManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

- (BOOL)isLoading
{
    return [self.requestIdList count] > 0;
}

- (XMAFCache *)cache {
    if (!_cache) {
        _cache = [XMAFCache sharedInstance];
    }
    return _cache;
}

@end
