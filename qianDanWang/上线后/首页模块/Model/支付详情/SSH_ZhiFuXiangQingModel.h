//
//  SSH_ZhiFuXiangQingModel.h
//  DENGFANGSC
//
//  Created by LY on 2018/10/30.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

//DENGFANGZhiFuXiangQingModel
@interface SSH_ZhiFuXiangQingModel : NSObject

@property (nonatomic, strong) NSString *coin;//所需金币
@property (nonatomic, strong) NSString *coinNum;//用户金币余额
@property (nonatomic, strong) NSString *createTime;//申请时间
@property (nonatomic, strong) NSString *expireDate;//剩余支付时间
@property (nonatomic, strong) NSString *loanStartLimit;//金额
@property (nonatomic, strong) NSString *loanTerm;//期限（月）
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uCoinNum;//用户优币余额



@end
