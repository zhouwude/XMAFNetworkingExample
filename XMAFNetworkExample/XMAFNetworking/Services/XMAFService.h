//
//  XMAFService.h
//  XMAFNetworkExample
//
//  Created by shscce on 15/10/21.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import <Foundation/Foundation.h>

// 所有XMAFService的派生类都要符合这个protocal
@protocol XMAFServiceProtocal <NSObject>

@property (nonatomic, readonly) BOOL isOnline;/**< 是否是正式模式 */

@property (nonatomic, readonly) NSString *offlineApiBaseUrl; /**< 测试服务器地址 */
@property (nonatomic, readonly) NSString *onlineApiBaseUrl; /**< 正式服务器地址 */

@property (nonatomic, readonly) NSString *offlineApiVersion; /**< 测试服务器api版本 */
@property (nonatomic, readonly) NSString *onlineApiVersion; /**< 正式服务器api版本 */

@property (nonatomic, readonly) NSString *onlinePublicKey; /**< 正式服务器公钥 */
@property (nonatomic, readonly) NSString *offlinePublicKey; /**< 测试服务器公钥 */

@property (nonatomic, readonly) NSString *onlinePrivateKey; /**< 正式服务器私钥 */
@property (nonatomic, readonly) NSString *offlinePrivateKey; /**< 测试服务器私钥 */

@property (copy, nonatomic, readonly) NSDictionary *onlineCommonParams; /**< 正式服务器的通用请求参数 */

@property (copy, nonatomic, readonly) NSDictionary *offlineCommonParams; /**< 测试服务器的通用请求参数 */


@end

@interface XMAFService : NSObject

@property (nonatomic, strong, readonly) NSString *publicKey;
@property (nonatomic, strong, readonly) NSString *privateKey;
@property (nonatomic, strong, readonly) NSString *apiBaseUrl;
@property (nonatomic, strong, readonly) NSString *apiVersion;
@property (copy, nonatomic, readonly) NSDictionary *commonParams;
@property (copy, nonatomic, readonly) NSDictionary *httpHeaders;

@property (nonatomic, weak) id<XMAFServiceProtocal> child;

@end
