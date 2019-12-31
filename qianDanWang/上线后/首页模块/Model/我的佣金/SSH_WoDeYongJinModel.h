//
//  SSH_WoDeYongJinModel.h
//  DENGFANGSC
//
//  Created by LY on 2018/12/19.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
//DENGFANGWoDeYongJinModel
@interface SSH_WoDeYongJinModel : NSObject

@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *inviteType;//邀请状态  0：等待身份认证  1：邀请成功  2：已失效
@property (nonatomic, strong) NSString *authCoin;//认证奖励
@property (nonatomic, strong) NSString *firstRecharge;//首冲奖励
@property (nonatomic, strong) NSString *isAuth;//是否认证（0：未认证  1：已认证   2:认证中   3:认证失败）
//先判断inviteType，若为0，则判断isAuth，若为2，显示认证中，其他状态为等待身份认证
@end
/*
 {
 "createTime": 1545184783000,
 "updateTime": 1545199502000,
 "mobile": "13581729796",
 "inviteType": "1",
 "authCoin": "0"
 “firstRecharge”:0
 “isAuth”:1
 },

 */
