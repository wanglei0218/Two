//
//  SSH_SheZhiMiMaController.h
//  DENGFANGSC
//
//  Created by LY on 2018/10/26.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSQ_BaseNormalViewController.h"

typedef void(^didDiss)(BOOL isYes);
//DENGFANGSheZhiMiMaController
@interface SSH_SheZhiMiMaController : SSQ_BaseNormalViewController

@property (nonatomic, strong) NSString *securityCode;//验证码
//@property (nonatomic, assign) BOOL isFromWhereToJudgeSureAction;//根据从哪里进来的，来判断确认按钮的点击事件是dismiss还是POP,0:dismiss,1:POP

@property (nonatomic,copy) didDiss isDidDiss;

@end
