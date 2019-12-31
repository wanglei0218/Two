//
//  SSQ_ESCNetRequest.h
//  TaoYouDan
//
//  Created by LY on 2018/12/7.
//  Copyright © 2018年 esc. All rights reserved.
//

#import <Foundation/Foundation.h>
//ESCNetRequest
@interface SSQ_ESCNetRequest : NSObject

+ (instancetype)shareInstance;


#pragma mark -目前不用，使用下方的请求
- (void)getWithUrlString:(NSString *)UrlString
              parameters:(id)parameters
                 success:(void (^)(id responseObject))success
                    fail:(void (^)(NSError *error))fail;

- (void)postWithUrlString:(NSString *)UrlString
               parameters:(id)parameters
                  success:(void (^)(id responsObject))success
                     fail:(void (^)(NSError *error))fail;



#pragma mark -使用这些
- (void)getNormalWithUrlString:(NSString *)UrlString parameters:(id)parameters success:(void (^)(id responsObject))success fail:(void (^)(NSError *error))fail;


- (void)postNormalWithUrlString:(NSString *)UrlString parameters:(id)parameters success:(void (^)(id responsObject))success fail:(void (^)(NSError *error))fail;
//@property (nonatomic, strong) NSString *DENGFANGPicCodeURL;

@end
