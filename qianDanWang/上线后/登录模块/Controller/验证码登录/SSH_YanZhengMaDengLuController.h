//
//  SSH_YanZhengMaDengLuController.h
//  DENGFANGSC
//
//  Created by LY on 2018/9/18.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSQ_BaseNormalViewController.h"
//DENGFANGYanZhengMaDengLuController
typedef void(^didDiss)(BOOL isYes);
@interface SSH_YanZhengMaDengLuController : SSQ_BaseNormalViewController

@property (nonatomic, assign)  BOOL isShowTiaoGuo;//是否展示跳过按钮：1:跳过，0:返回按钮
@property (nonatomic,copy) didDiss isDidDiss;
@end
