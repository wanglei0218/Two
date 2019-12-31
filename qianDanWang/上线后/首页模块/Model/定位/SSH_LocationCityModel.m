//
//  SSH_LocationCityModel.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/25.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_LocationCityModel.h"

@implementation SSH_LocationCityModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list": [DENGFANGLocationCityList class], @"hotCity" : [DENGFANGLocationCity class],
             @"zuiDuoCity" : [DENGFANGLocationCity class]};
}
@end


@implementation DENGFANGLocationCityList

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"citys": [DENGFANGLocationCity class]};
}

@end


@implementation DENGFANGLocationCity
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id": @"id"};
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.Id forKey:@"Id"];
}

//只要解析一个文件的时候就会调用
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.Id = [aDecoder decodeIntegerForKey:@"Id"];
    }
    return self;
}

@end
