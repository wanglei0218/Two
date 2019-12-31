//
//  DENGFENGSingletonTime.m
//  jiaogeqian
//
//  Created by 神马的 on 2018/8/24.
//  Copyright © 2018年 zdtc. All rights reserved.
//

#import "DENGFANGSingletonTime.h"

static DENGFANGSingletonTime *_singletonTime = nil;

@implementation DENGFANGSingletonTime

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singletonTime = [[DENGFANGSingletonTime alloc] init];
    });
    return _singletonTime;
}

- (void)setMapCity:(NSString *)mapCity {
    NSString *selectCityName = [DENGFANGHelperFunction getSelectedCityName];
    if (![selectCityName isEqualToString:@""]) {
        _mapCity = [selectCityName isEqualToString:@"全国"]?@"":selectCityName;
    }else {
        if (mapCity == nil) {
            mapCity = @"全国";
        }
        _mapCity = [mapCity isEqualToString:@"全国"]?@"":mapCity;
    }
}

@end
