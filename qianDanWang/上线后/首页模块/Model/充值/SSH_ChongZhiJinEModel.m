//
//  SSH_ChongZhiJinEModel.m
//  DENGFANGSC
//
//  Created by LY on 2018/11/8.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ChongZhiJinEModel.h"

@implementation SSH_ChongZhiJinEModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.rechargeId = value;
    }
}

@end
