//
//  XMAFNetworkingBaseRequest.h
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMAFURLResponse.h"

// 在调用成功之后的params字典里面，用这个key可以取出requestID
static NSString * const kXMAFNetworkingBaseRequestRequestID = @"kXMAFNetworkingBaseRequestRequestID";

@class XMAFNetworkingBaseRequest;
@protocol XMAFManagerCallBackDelegate <NSObject>
@required
- (void)managerDidSuccess:(XMAFNetworkingBaseRequest *)request;
- (void)managerDidFailed:(XMAFNetworkingBaseRequest *)request;
@end

typedef void(^XMAFManagerCallBackBlock)(XMAFNetworkingBaseRequest *manager, BOOL didSuccess);

@protocol XMAFManagerCallBackDataReformer <NSObject>

@required
- (id)manage:(XMAFNetworkingBaseRequest *)request reformerData:(NSDictionary *)data;

@end

@protocol XMAFManagerValidator <NSObject>

@required
- (BOOL)manager:(XMAFNetworkingBaseRequest *)request isCorrectWithResponseData:(NSDictionary *)responseData;
- (BOOL)manager:(XMAFNetworkingBaseRequest *)request isCorrectWithRequestParamsData:(NSDictionary *)requestParamsData;
@end


@protocol XMAFManagerParamSourceDelegate <NSObject>

@required
- (NSDictionary *)paramsForApi:(XMAFNetworkingBaseRequest *)request;

@end


/*
 当产品要求返回数据不正确或者为空的时候显示一套UI，请求超时和网络不通的时候显示另一套UI时，使用这个enum来决定使用哪种UI。（安居客PAD就有这样的需求，sigh～）
 你不应该在回调数据验证函数里面设置这些值，事实上，在任何派生的子类里面你都不应该自己设置manager的这个状态，baseManager已经帮你搞定了。
 强行修改manager的这个状态有可能会造成程序流程的改变，容易造成混乱。
 */
typedef NS_ENUM (NSUInteger, XMAFManagerErrorType){
    XMAFManagerErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    XMAFManagerErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    XMAFManagerErrorTypeContentError,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    XMAFManagerErrorTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    XMAFManagerErrorTypeTimeout,       //请求超时。RTApiProxy设置的是20秒超时，具体超时时间的设置请自己去看RTApiProxy的相关代码。
    XMAFManagerErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

typedef NS_ENUM (NSUInteger, XMAFManagerRequestType){
    XMAFManagerRequestTypeGet,
    XMAFManagerRequestTypePost
};


@protocol XMAFManagerInterceptor <NSObject>

@optional
- (void)manager:(XMAFNetworkingBaseRequest *)request beforePerformSuccessWithResponse:(XMAFURLResponse *)response;
- (void)manager:(XMAFNetworkingBaseRequest *)request afterPerformSuccessWithResponse:(XMAFURLResponse *)response;

- (void)manager:(XMAFNetworkingBaseRequest *)request beforePerformFailWithResponse:(XMAFURLResponse *)response;
- (void)manager:(XMAFNetworkingBaseRequest *)request afterPerformFailWithResponse:(XMAFURLResponse *)response;

- (BOOL)manager:(XMAFNetworkingBaseRequest *)request shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(XMAFNetworkingBaseRequest *)request afterCallingAPIWithParams:(NSDictionary *)params;

@end

@protocol XMAFManagerProtocol <NSObject>

@required
- (NSString *)methodName;
- (NSString *)serviceIdentifer;
- (XMAFManagerRequestType)requestType;

@end

@interface XMAFNetworkingBaseRequest : NSObject <XMAFManagerProtocol>

@property (nonatomic, weak) id<XMAFManagerCallBackDelegate> delegate;
@property (copy, nonatomic) XMAFManagerCallBackBlock callBackBlock;
@property (nonatomic, weak) id<XMAFManagerParamSourceDelegate> paramSource;
@property (nonatomic, weak) id<XMAFManagerValidator> validator;
@property (nonatomic, weak) NSObject<XMAFManagerProtocol> *child; //里面会调用到NSObject的方法，所以这里不用id
@property (nonatomic, weak) id<XMAFManagerInterceptor> interceptor;

/*
 baseManager是不会去设置errorMessage的，派生的子类manager可能需要给controller提供错误信息。所以为了统一外部调用的入口，设置了这个变量。
 派生的子类需要通过extension来在保证errorMessage在对外只读的情况下使派生的manager子类对errorMessage具有写权限。
 */
@property (nonatomic, copy, readonly) NSString *errorMessage;
@property (nonatomic, readonly) XMAFManagerErrorType errorType;

@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;

#pragma mark - 提供给子类manager实例使用的方法
- (NSInteger)loadData;
- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;
- (id)fetchDataWithReformer:(id<XMAFManagerCallBackDataReformer>)reformer;

#pragma mark - 拦截器方法,提供后可以让子类重载,实现内部拦截
- (void)beforePerformSuccessWithResponse:(XMAFURLResponse *)response;
- (void)afterPerformSuccessWithResponse:(XMAFURLResponse *)response;

- (void)beforePerformFailWithResponse:(XMAFURLResponse *)response;
- (void)afterPerformFailWithResponse:(XMAFURLResponse *)response;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
- (void)afterCallingAPIWithParams:(NSDictionary *)params;

- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (BOOL)shouldCache;

@end
