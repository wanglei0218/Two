//
//  SSH_WeChatAlertView.h
//  jiaogeqian
//
//  Created by LY on 2018/8/6.
//  Copyright © 2018年 zdtc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SSH_DingYueHaoModel.h"
//DENGFANGWeChatAlertView
@interface SSH_WeChatAlertView : UIView

@property (nonatomic, strong) UILabel *titleOfficalLabel;//标题
@property (nonatomic, strong) UIImageView *QRCodeImgview;//二维码图片
@property (nonatomic, strong) UILabel *method1ContentLabel;//方案一内容
@property (nonatomic, strong) UILabel *method2ContentLabel;//方案二内容
@property (nonatomic, strong) UIButton *jumpButton;//跳转按钮
@property (nonatomic, strong) UIButton *closeButton;//关闭按钮

@property(nonatomic,strong)SSH_DingYueHaoModel *dingYueHaoModel;

- (void)showWeXinQQAlertView;
- (void)closeCurrentView;

@end
