//
//  NSDictionary+XMAFNetworkingMethods.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "NSDictionary+XMAFNetworkingMethods.h"
#import "NSArray+XMAFNetworkingMethods.h"

@implementation NSDictionary (XMAFNetworkingMethods)


/** 字符串前面是没有问号的，如果用于POST，那就不用加问号，如果用于GET，就要加个问号 */
- (NSString *)XMAF_urlParamsStringSignature:(BOOL)isForSignature
{
    NSArray *sortedArray = [self XMAF_transformedUrlParamsArraySignature:isForSignature];
    return [sortedArray XMAF_paramsString];
}

/** 字典变json */
- (NSString *)XMAF_jsonString
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/** 转义参数 */
- (NSArray *)XMAF_transformedUrlParamsArraySignature:(BOOL)isForSignature
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@", obj];
        }
        if (!isForSignature) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
            obj = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&;=+$,/?%#[]"]];
#else
            obj = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)obj,  NULL,  (CFStringRef)@"!*'();:@&;=+$,/?%#[]",  kCFStringEncodingUTF8));
#endif
        }
        if ([obj length] > 0) {
            [result addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
        }
    }];
    NSArray *sortedResult = [result sortedArrayUsingSelector:@selector(compare:)];
    return sortedResult;
}


@end
