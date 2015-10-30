//
//  XMAFApiProxy.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMAFApiProxy.h"

#import "AFNetworking.h"
#import "XMAFLogger.h"
#import "XMAFRequestGenerator.h"

@interface XMAFApiProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;

//AFNetorking 请求管理manager,使用最新的AFHTTPSessionManager
@property (strong, nonatomic) AFHTTPSessionManager *operationManager;

@end

@implementation XMAFApiProxy

#pragma mark - Life Cycle

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static id shareInstance;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}


#pragma mark - Public methods

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(XMAFRequestCallBack)success fail:(XMAFRequestCallBack)fail {
    NSURLRequest *request = [[XMAFRequestGenerator sharedInstance] generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}


- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(XMAFRequestCallBack)success fail:(XMAFRequestCallBack)fail {
    NSURLRequest *request = [[XMAFRequestGenerator sharedInstance] generatePOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *dataTask = self.dispatchTable[requestID];
    [dataTask cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

#pragma mark - Private Methods

/** 这个函数存在的意义在于，如果将来要把AFNetworking换掉，只要修改这个函数的实现即可。 */
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(XMAFRequestCallBack)success fail:(XMAFRequestCallBack)fail
{
    // 之所以不用getter，是因为如果放到getter里面的话，每次调用self.recordedRequestId的时候值就都变了，违背了getter的初衷
    NSNumber *requestId = [self generateRequestId];
    
    __weak __typeof(&*self) wself = self;
    NSURLSessionDataTask *dataTask = [self.operationManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        __strong __typeof(wself)self = wself;
        NSURLSessionDataTask *storedDataTask = self.dispatchTable[requestId];
        if (!storedDataTask) {
            return ;
        }else{
            [self.dispatchTable removeObjectForKey:requestId];
        }
        XMAFURLResponse *httpResponse = [[XMAFURLResponse alloc] initWithResponse:responseObject requestId:requestId request:request error:error];
        [XMAFLogger logDebugInfoWithResponse:(NSHTTPURLResponse *)response resposeString:httpResponse.responseString request:request error:error];
        if (error) {
            fail ? fail(httpResponse) : nil;
        }else {
            success ? success(httpResponse) : nil;
        }
    }];
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    return requestId;
}


#pragma mark - Getters

- (NSNumber *)generateRequestId
{
    if (_recordedRequestId == nil) {
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        } else {
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}


- (NSMutableDictionary *)dispatchTable
{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}


- (AFHTTPSessionManager *)operationManager {
    if (!_operationManager) {
        _operationManager = [[AFHTTPSessionManager alloc] init];
        _operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _operationManager;
}

@end
