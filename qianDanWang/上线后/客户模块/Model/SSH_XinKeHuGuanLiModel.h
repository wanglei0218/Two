//
//  SSH_XinKeHuGuanLiModel.h
//  DENGFANGSC
//
//  Created by 新民 on 2019/5/11.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//DENGFANGXinKeHuGuanLiModel
@interface SSH_XinKeHuGuanLiModel : NSObject

@property (nonatomic, strong) NSString *creditName;//名字
@property (nonatomic, strong) NSString *createTime;//支付时间
@property (nonatomic, strong) NSString *orderStatus;//订单状态（1：支付中   2：成功   0:失败 3 ：退单）
@property (nonatomic, strong) NSString *loanTerm;//多久
@property (nonatomic, strong) NSString *loanStartLimit;//多少钱
@property (nonatomic, strong) NSString *loanStartLimitF;//多少钱
@property (nonatomic, strong) NSString *loanEndLimit;//多少钱
@property (nonatomic, strong) NSString *loanPurpose;//用途
@property (nonatomic, strong) NSString *expireDate;//支付倒计时
@property (nonatomic, strong) NSString *mobile;//电话
@property (nonatomic, strong) NSString *orderNo;//订单号
@property (nonatomic, strong) NSString *orderId;//订单id
@property (nonatomic, strong) NSString *creditId;//资源id
@property (nonatomic, strong) NSString *euserId;//用户id
@property (nonatomic, strong) NSString *coin;//金币

//修改后的新增字段
@property (nonatomic, strong) NSString *payTime;//退单（48小时）可根据订单时间验证
@property (nonatomic, strong) NSString *updateStatus;//未跟进
@property (nonatomic, strong) NSString *singleNote;//退单备注
@property (nonatomic, strong) NSString *singleAmount;//退单金额
@property (nonatomic, strong) NSString *singleState;//退单状态  (0:正常  1:申请中  2:申请中-申诉 3:已通过   4:未通过)  ---是否显示退单可根据此判断
@property (nonatomic, assign)NSInteger lastRecordId;//最后跟进记录 1:未跟进2:已处理

@end

NS_ASSUME_NONNULL_END
