//
//  SSH_MemberModel.h
//  qianDanWang
//
//  Created by AN94 on 9/23/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSH_MemberModel : NSObject

/*
 "id": 1,
 "vipName": "青铜会员",
 "vipAmount": 268,
 "vipMaxAmount": 588,
 "vipDays": 30,
 "vipRefund": 6,
 "createTime": 1568622494000,
 "vipIcon": null
 */

@property (nonatomic,strong)NSString *ID;                   ///<id
@property (nonatomic,strong)NSString *vipName;              ///<名称
@property (nonatomic,strong)NSString *vipAmount;            ///<现价
@property (nonatomic,strong)NSString *vipAmounts;            ///<现价
@property (nonatomic,strong)NSString *vipMaxAmount;         ///<原价
@property (nonatomic,strong)NSString *vipDays;              ///<会员期限
@property (nonatomic,strong)NSString *vipRefund;            ///<可退单次数
@property (nonatomic,strong)NSString *createTime;           ///<创建时间
@property (nonatomic,strong)NSString *vipIcon;              ///<图标

+ (instancetype)shardeInstance;

- (NSArray *)getvipModelWithData:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END
