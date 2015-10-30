//
//  NSURLRequest+XMAFNetworkingMethods.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "NSURLRequest+XMAFNetworkingMethods.h"
#import <objc/runtime.h>

static void *kXMAFNetworkingRequestParams;

@implementation NSURLRequest (XMAFNetworkingMethods)

- (void)setRequestParams:(NSDictionary *)requestParams
{
    objc_setAssociatedObject(self, &kXMAFNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams
{
    return objc_getAssociatedObject(self, &kXMAFNetworkingRequestParams);
}


@end
