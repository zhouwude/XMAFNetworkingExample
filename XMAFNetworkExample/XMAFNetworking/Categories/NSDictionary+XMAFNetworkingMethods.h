//
//  NSDictionary+XMAFNetworkingMethods.h
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (XMAFNetworkingMethods)

- (NSString *)XMAF_jsonString;
- (NSString *)XMAF_urlParamsStringSignature:(BOOL)isForSignature;
- (NSArray *)XMAF_transformedUrlParamsArraySignature:(BOOL)isForSignature;

@end
