//
//  SSH_TixianStatusViewController.h
//  DENGFANGSC
//
//  Created by LY on 2019/1/24.
//  Copyright © 2019年 DENGFANG. All rights reserved.
//

#import "SSQ_BaseNormalViewController.h"

//DENGFANGTixianStatusViewController
@interface SSH_TixianStatusViewController : SSQ_BaseNormalViewController

@property (nonatomic, strong) NSString *fromWhere;//1:点击-立即提现-进入
@property (nonatomic, assign) int status;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *bankNumber;

@end
