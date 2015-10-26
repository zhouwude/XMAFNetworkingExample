//
//  NSMutableString+XMAFNetworkingMethods.m
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "NSMutableString+XMAFNetworkingMethods.h"
#import "NSObject+XMAFNetworkingMethods.h"

@implementation NSMutableString (XMAFNetworkingMethods)

- (void)appendURLRequest:(NSURLRequest *)request
{
    [self appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [self appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [self appendFormat:@"\n\nHTTP Body:\n\t%@", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] XMAF_defaultValue:@"\t\t\t\tN/A"]];
}

@end
