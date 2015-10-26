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

//AFNetworking stuff
@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;


//@property (strong, nonatomic) AFHTTPSessionManager *operationManager;

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
    NSOperation *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
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
    
    // 跑到这里的block的时候，就已经是主线程了。
    AFHTTPRequestOperation *httpRequestOperation = [self.operationManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
        if (storedOperation == nil) {
            // 如果这个operation是被cancel的，那就不用处理回调了。
            return;
        } else {
            [self.dispatchTable removeObjectForKey:requestId];
        }
        
        [XMAFLogger logDebugInfoWithResponse:operation.response
                               resposeString:operation.responseString
                                     request:operation.request
                                       error:NULL];
        
        XMAFURLResponse *response = [[XMAFURLResponse alloc] initWithResponseString:operation.responseString
                         requestId:requestId
                           request:operation.request
                      responseData:operation.responseData
                            status:XMAFURLResponseStatusSuccess];
        success?success(response):nil;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
        if (storedOperation == nil) {
            // 如果这个operation是被cancel的，那就不用处理回调了。
            return;
        } else {
            [self.dispatchTable removeObjectForKey:requestId];
        }
        
        [XMAFLogger logDebugInfoWithResponse:operation.response
                               resposeString:operation.responseString
                                     request:operation.request
                                       error:error];
        
        XMAFURLResponse *response = [[XMAFURLResponse alloc] initWithResponseString:operation.responseString
                         requestId:requestId
                           request:operation.request
                      responseData:operation.responseData
                             error:error];
        
        fail?fail(response):nil;
        
    }];
    
    self.dispatchTable[requestId] = httpRequestOperation;
    [[self.operationManager operationQueue] addOperation:httpRequestOperation];
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

- (AFHTTPRequestOperationManager *)operationManager
{
    if (_operationManager == nil) {
        _operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        _operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _operationManager;
}

@end
