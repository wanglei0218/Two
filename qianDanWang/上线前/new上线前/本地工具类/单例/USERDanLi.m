//
//  USERDanLi.m
//  USERPRODUCT
//
//  Created by 河神 on 2019/5/31.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERDanLi.h"

static USERDanLi *_singletonTime = nil;


@implementation USERDanLi

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singletonTime = [[USERDanLi alloc] init];
    });
    return _singletonTime;
}

@end
