//
//  NSObject+XMAFNetworkingMethods.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "NSObject+XMAFNetworkingMethods.h"

@implementation NSObject (XMAFNetworkingMethods)


- (BOOL)XMAF_isEmptyObject {
    
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}


- (id)XMAF_defaultValue:(id)defaultData {
//    if (![defaultData isKindOfClass:[self class]]) {
//        return defaultData;
//    }
    
    if ([self XMAF_isEmptyObject]) {
        return defaultData;
    }
    
    return self;
}
@end
