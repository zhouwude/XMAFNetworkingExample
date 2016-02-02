//
//  XMAFServiceFactory.h
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMAFService.h"

FOUNDATION_EXPORT NSString *const kXMAFBaiduServiceIdentifier;

@interface XMAFServiceFactory : NSObject

+ (instancetype)sharedInstance;

- (XMAFService *)serviceWithIdentifier:(NSString *)identifier;

@end
