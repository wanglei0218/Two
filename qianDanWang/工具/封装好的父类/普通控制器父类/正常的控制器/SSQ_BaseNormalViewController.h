//
//  SSQ_BaseNormalViewController.h
//  TaoYouDan
//
//  Created by LY on 2018/9/28.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
//DENGFANGBaseNormalViewController
@interface SSQ_BaseNormalViewController : UIViewController

@property (nonatomic, strong) UIView *navigationView;//顶部导航栏View
@property (nonatomic, strong) UIButton *goBackButton;//导航栏返回按钮
@property (nonatomic, strong) UILabel *titleLabelNavi;//导航栏标题

@property (nonatomic, strong) UIView *normalBackView;//其它控制器里布局的父视图
@property (nonatomic,strong) UIView *lineView;  //分割线

-(void)backBtnClicked;

@end
