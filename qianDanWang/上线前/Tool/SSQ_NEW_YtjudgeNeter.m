//
//  SSQ_NEW_YtjudgeNeter.m
//  CCFinance
//
//  Created by liangyuan on 16/8/5.
//  Copyright © 2016年 chaoqianyan. All rights reserved.
//

#import "SSQ_NEW_YtjudgeNeter.h"

static SSQ_NEW_YtjudgeNeter *judge = nil;
@implementation SSQ_NEW_YtjudgeNeter

-(BOOL)YT_YTIsConnectionAvailablrer{
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    if (!isExistenceNetwork) {
        return NO;
    }
    return isExistenceNetwork;
}
- (BOOL)YTIsConnectioner{
    return [self YT_YTIsConnectionAvailablrer];
}

- (NSString*)YT_ytNetStatuser{
    NSString *str = nil;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case ReachableViaWiFi:
            str = @"WIFI";
            break;
        case ReachableViaWWAN:
            str = @"数据网络";
            break;
        default:
            str = @"网络连接异常";
            break;
    }
    return str;
}
//单例
+ (instancetype)YT_YTShareJudgeNeter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        judge = [[SSQ_NEW_YtjudgeNeter alloc]init];
    });
    return judge;
}


@end
