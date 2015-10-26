//
//  XMAFUUIDGenerator.h
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XMAFUDIDGenerator : NSObject

+ (id)sharedInstance;

- (NSString *)UDID;
- (void)saveUDID:(NSString *)udid;


@end
