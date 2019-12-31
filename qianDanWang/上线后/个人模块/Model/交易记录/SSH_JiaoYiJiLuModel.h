//
//  SSH_JiaoYiJiLuModel.h
//  DENGFANGSC
//
//  Created by LY on 2018/11/6.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
//DENGFANGJiaoYiJiLuModel
@interface SSH_JiaoYiJiLuModel : NSObject

@property (nonatomic, strong) NSString *traId;//交易ID
@property (nonatomic, strong) NSString *createTime;//充值时间
@property (nonatomic, strong) NSString *relMoney;//充值金额
@property (nonatomic, strong) NSString *coin;//支付金币,商品面值
@property (nonatomic, strong) NSString *orderNo;//订单号
@property (nonatomic, strong) NSString *sumCoin;//充值所得金币
@property (nonatomic, strong) NSString *giveCoin;//充值优惠 赠送金币
@property (nonatomic, strong) NSString *name;//资源人姓名
@property (nonatomic, strong) NSString *payType;//分类 1:支付，2:充值，4:赠送
/** 金币类型 */
@property (nonatomic,strong) NSString *giftType;  //0：交易分歧补偿  1：系统bug补偿 2:邀请有礼-认证 3：邀请有礼-首充
@property (nonatomic, strong) NSString *payMethod;//支付方式：（0：金币支付  1：优币支付）
@property (nonatomic, strong) NSString *uCoinNum; //赠送优币

@end
