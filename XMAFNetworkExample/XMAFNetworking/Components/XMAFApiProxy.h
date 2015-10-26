//
//  XMAFApiProxy.h
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMAFURLResponse.h"

typedef void(^XMAFRequestCallBack)(XMAFURLResponse *response);

@interface XMAFApiProxy : NSObject


+ (instancetype)sharedInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(XMAFRequestCallBack)success fail:(XMAFRequestCallBack)fail;
- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(XMAFRequestCallBack)success fail:(XMAFRequestCallBack)fail;

- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;
@end
