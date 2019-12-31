//
//  SSH_TuiDanWanChengViewController.m
//  DENGFANGSC
//
//  Created by 河神 on 2019/5/14.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_TuiDanWanChengViewController.h"

@interface SSH_TuiDanWanChengViewController ()

@end

@implementation SSH_TuiDanWanChengViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleLabelNavi.text = @"申请退单";
    self.lineView.hidden = NO;
    self.goBackButton.hidden = YES;
    
    [self setUpDataView];
    
}

- (void)setUpDataView{
    
    UIImageView *duihaoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chenggong_tuidan"]];
    [self.view addSubview:duihaoImg];
    duihaoImg.sd_layout.topSpaceToView(self.view, WidthScale(75.5)+getRectNavAndStatusHight).centerXEqualToView(self.view).widthIs(WidthScale(110)).heightIs(WidthScale(110));
    
    UILabel *tishiLable = [[UILabel alloc] init];
    [self.view addSubview:tishiLable];
    tishiLable.textColor = ColorBlack222;
    tishiLable.font = [UIFont systemFontOfSize:WidthScale(15)];
    tishiLable.textAlignment = NSTextAlignmentCenter;
    tishiLable.sd_layout.topSpaceToView(duihaoImg, WidthScale(25)).centerXEqualToView(self.view).heightIs(WidthScale(15)).widthIs(ScreenWidth);
    tishiLable.text = @"退单申请已提交，等待系统审核";
    
    
    UILabel *showLabel = [[UILabel alloc] init];
    [self.view addSubview:showLabel];
    showLabel.textColor = ColorBlack999;
    showLabel.font = [UIFont systemFontOfSize:WidthScale(12)];
    showLabel.textAlignment = NSTextAlignmentCenter;
    showLabel.sd_layout.topSpaceToView(tishiLable, WidthScale(9.5)).centerXEqualToView(self.view).heightIs(WidthScale(12)).widthIs(ScreenWidth);
    showLabel.text = @"审核通过后，您会收到短信通知\n此订单将会从客户管理中移除";
    
    UIButton *wancBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:wancBtn];
    [wancBtn setTitle:@"完成" forState:UIControlStateNormal];
    [wancBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [wancBtn setBackgroundImage:[UIImage imageNamed:@"wancheng_tuidan"] forState:UIControlStateNormal];
    [wancBtn addTarget:self action:@selector(popToViewController) forControlEvents:UIControlEventTouchUpInside];
    wancBtn.sd_layout.topSpaceToView(showLabel, WidthScale(61)).centerXEqualToView(self.view).widthIs(ScreenWidth-WidthScale(60)).heightIs(WidthScale(40));
    
}

- (void)popToViewController{
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
