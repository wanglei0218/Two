//
//  SSH_KeHuGuanLiListModel.h
//  DENGFANGSC
//
//  Created by huang on 2018/11/1.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//DENGFANGKeHuGuanLiListModel
@interface SSH_KeHuGuanLiListModel : NSObject
@property (nonatomic, strong) NSString *creditName;//名字
@property (nonatomic, strong) NSString *createTime;//支付时间
@property (nonatomic, strong) NSString *orderStatus;//订单状态（1：支付中   2：成功   0:失败 3 ：退单）
@property (nonatomic, strong) NSString *loanTerm;//多久
@property (nonatomic, strong) NSString *loanStartLimit;//多少钱
@property (nonatomic, strong) NSString *loanPurpose;//用途
@property (nonatomic, strong) NSString *expireDate;//支付倒计时
@property (nonatomic, strong) NSString *mobile;//电话
@property (nonatomic, strong) NSString *orderNo;//订单号
@property (nonatomic, strong) NSString *orderId;//订单id
@property (nonatomic, strong) NSString *creditId;//资源id
@property (nonatomic, strong) NSString *euserId;//用户id
@property (nonatomic, strong) NSString *coin;//金币

/* 列表标签：公积金，社保，实名，微粒贷 */
@property (nonatomic, strong) NSString *isFund;//公
@property (nonatomic, strong) NSString *isSecurity;//社
@property (nonatomic, strong) NSString *isRealName;//实
@property (nonatomic, strong) NSString *isWeiliD;//微

@end

NS_ASSUME_NONNULL_END
