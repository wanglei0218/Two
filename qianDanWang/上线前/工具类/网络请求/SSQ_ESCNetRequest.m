//
//  SSQ_ESCNetRequest.m
//  TaoYouDan
//
//  Created by LY on 2018/12/7.
//  Copyright © 2018年 esc. All rights reserved.
//

#import "SSQ_ESCNetRequest.h"
static SSQ_ESCNetRequest *_tydRequest = nil;
NSString *const httpHeaderString = @"http://fengjian.checome.cn/file/ly/";

//static NSString *httpHeaderString = @"http://qfq.qiboni.xyz/ershouche/";
@implementation SSQ_ESCNetRequest

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tydRequest = [[SSQ_ESCNetRequest alloc] init];
    });
    return _tydRequest;
}


- (void)getNormalWithUrlString:(NSString *)UrlString parameters:(id)parameters success:(void (^)(id responsObject))success fail:(void (^)(NSError *error))fail{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
     NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
     
     NSDictionary *settings = proxies[0];
     
     if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
         {
            
            [manager GET:UrlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [DENGFANGHelperFunction showErrorAlter:SHAREDAPP.window];
                
                if (fail) {
                    fail(error);
                }
            }];
            
        }
    else {
        
        return;
    }
}



- (void)getWithUrlString:(NSString *)UrlString parameters:(id)parameters success:(void (^)(id))success fail:(void (^)(NSError *))fail{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *lastUrlString = [httpHeaderString stringByAppendingString:UrlString];
    
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    
    NSDictionary *settings = proxies[0];
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
        {
            
            [manager GET:lastUrlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [DENGFANGHelperFunction showErrorAlter:SHAREDAPP.window];
                
                if (fail) {
                    fail(error);
                }
            }];
            
        }
    else {
        
        return;
    }
}

- (void)postWithUrlString:(NSString *)UrlString parameters:(id)parameters success:(void (^)(id))success fail:(void (^)(NSError *))fail{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *lastUrlString = [httpHeaderString stringByAppendingString:UrlString];
    if ([UrlString hasPrefix:@"http"]) {
        lastUrlString = UrlString;
    }
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = proxies[0];
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
        {
            
            [manger POST:lastUrlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [DENGFANGHelperFunction showErrorAlter:SHAREDAPP.window];
                
                
                if (fail) {
                    fail(error);
                }
            }];
        }
    else {
        
        return;
    }
    
}

- (void)postNormalWithUrlString:(NSString *)UrlString parameters:(id)parameters success:(void (^)(id responsObject))success fail:(void (^)(NSError *error))fail{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
     NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
     NSDictionary *settings = proxies[0];
     
     if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
         {
            
            [manger POST:UrlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [DENGFANGHelperFunction showErrorAlter:SHAREDAPP.window];
                
                
                if (fail) {
                    fail(error);
                }
            }];
        }
    else {
        
        return;
    }
    
}


@end
