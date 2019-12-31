//
//  SSH_JiaoYiJiLuModel.m
//  DENGFANGSC
//
//  Created by LY on 2018/11/6.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_JiaoYiJiLuModel.h"

@implementation SSH_JiaoYiJiLuModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.traId = value;
    }
}

- (void)setGiftType:(NSString *)giftType {
    switch ([giftType integerValue]) {
        case 0:
            giftType = @"交易分歧补偿";
            break;
        case 1:
            giftType = @"系统bug补偿";
            break;
        case 2:
            giftType = @"邀请好友认证";
            break;
        case 3:
            giftType = @"邀请好友首充";
            break;
        case 4:
            giftType = @"注册奖励"; //金币
            break;
        case 5:
            giftType = @"注册奖励"; //金币
            break;
        default:
            break;
    }
    _giftType = giftType;
}
@end
