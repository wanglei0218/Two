//
//  SSQ_NEW_NetWorkEnginer.h
//  SmallWallet
//
//  Created YTer on 2018/3/6.
//  Copyright © 2018年 YTer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
typedef void (^YTCompletioBlocker)(NSDictionary *dic, NSURLResponse *response, NSError *error);
typedef void (^YT_SuccessBlocker)(NSDictionary *data);
typedef void (^YT_CodeBlock)(NSData *data);
typedef void (^YT_FailureBlock)(NSError *error);

//DENGFANG_NetWorkEnginer
@interface SSQ_NEW_NetWorkEnginer : NSObject
/**
 *  get请求
 */
+ (void)YT_ytGetWithUrlStringer:(NSString *)url parameters:(id)parameters success:(YT_SuccessBlocker)successBlock failure:(YT_FailureBlock)failureBlock;
+(void)YT_YTImageUrlString:(NSString *)url parameters:(id)parameters success:(YT_CodeBlock)successBlock failure:(YT_FailureBlock)failureBlock;

/**
 * post请求
 */
+ (void)YT_YTSSPostWithUrlStringer:(NSString *)url parameters:(id)parameters success:(YT_SuccessBlocker)successBlock failure:(YT_FailureBlock)failureBlock;
+ (BOOL)YT_ytProxySettinger;


@end
