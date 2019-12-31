//
//  SSH_ZhiFuMingXiController.h
//  DENGFANGSC
//
//  Created by LY on 2018/10/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSQ_BaseNormalViewController.h"
//DENGFANGZhiFuMingXiController
@interface SSH_ZhiFuMingXiController : SSQ_BaseNormalViewController

@property (nonatomic, strong) NSString *traId;//交易ID
@property (nonatomic, strong) NSString *payType;//4:赠送 1:支付
@property (nonatomic, strong) NSString *payMethod;//支付方式（0:金币 1:优币）

@end
