//
//  TYDLocationCityModel.m
//  TYDSC
//
//  Created by huang on 2018/10/25.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "ShangChengLocationCityModel.h"

@implementation ShangChengLocationCityModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list": [TYDLocationCityList class], @"hotCity" : [TYDLocationCity class]};
}
@end


@implementation TYDLocationCityList

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"citys": [TYDLocationCity class]};
}

@end


@implementation TYDLocationCity
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id": @"id"};
}
@end
