//
//  SSH_TixianStatusViewController.m
//  DENGFANGSC
//
//  Created by LY on 2019/1/24.
//  Copyright © 2019年 DENGFANG. All rights reserved.
//

#import "SSH_TixianStatusViewController.h"
#import "SSH_MyYongJinViewController.h"
@interface SSH_TixianStatusViewController ()

@end

@implementation SSH_TixianStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lineView.hidden = NO;
    [self setup_tixianStatus_View];
}

- (void)setup_tixianStatus_View{
    
    UIImageView *statusImgView = [[UIImageView alloc] init];
    [self.normalBackView addSubview:statusImgView];
    [statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_offset(94);
        make.centerX.mas_equalTo(self.normalBackView);
        make.top.mas_equalTo(80);
    }];
    
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.textAlignment = 1;
    statusLabel.textColor = Color000;
    statusLabel.font = [UIFont systemFontOfSize:18];
    [self.normalBackView addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(statusImgView.mas_bottom).offset(22.5);
        make.height.mas_equalTo(18);
    }];
    
    UILabel *miaoshuLabel = [[UILabel alloc] init];
    [self.normalBackView addSubview:miaoshuLabel];
    miaoshuLabel.textAlignment = 1;
    miaoshuLabel.textColor = Color000;
    miaoshuLabel.numberOfLines = 0;
    miaoshuLabel.font = [UIFont systemFontOfSize:12];
    [miaoshuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(statusLabel.mas_bottom).offset(22.5);
    }];
    
    
    
    if ([self.fromWhere isEqualToString:@"1"]) {
        self.titleLabelNavi.text = @"提现";
        self.goBackButton.hidden = YES;
        statusImgView.image = [UIImage imageNamed:@"提现等待处理"];
        statusLabel.text = @"等待处理";
        miaoshuLabel.text = @"已提交申请，等待工作人员处理\n提现到账时间：发起提现请求后七个工作日内";
        UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.normalBackView addSubview:finishButton];
        [finishButton setTitle:@"完成" forState:UIControlStateNormal];
        finishButton.backgroundColor = ColorZhuTiHongSe;
        finishButton.layer.masksToBounds = YES;
        finishButton.layer.cornerRadius = 20;
        [finishButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(300);
            make.height.mas_equalTo(40);
            make.centerX.mas_equalTo(self.normalBackView);
            make.top.mas_equalTo(miaoshuLabel.mas_bottom).offset(37.5);
        }];
    }else{
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = ColorBlack999;
        timeLabel.textAlignment = 1;
        [self.normalBackView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(miaoshuLabel.mas_bottom).offset(9);
            make.height.mas_equalTo(12);
        }];
        
        if (self.status == 0) {
            self.titleLabelNavi.text = @"提现记录";
            statusImgView.image = [UIImage imageNamed:@"提现审核中"];
            statusLabel.text = @"审核中";
            miaoshuLabel.text = @"已提交申请，等待工作人员处理";
            timeLabel.text = self.timeStr;
        }else if (self.status == 1) {
            self.titleLabelNavi.text = @"提现记录";
            statusImgView.image = [UIImage imageNamed:@"提现成功"];
            statusLabel.text = @"提现成功";
            miaoshuLabel.text = [NSString stringWithFormat:@"已发放至您的银行卡%@，请及时查收",self.bankNumber];
            timeLabel.text = self.timeStr;
        }else if (self.status == 2) {
            self.titleLabelNavi.text = @"提现记录";
            statusImgView.image = [UIImage imageNamed:@"提现异常"];
            statusLabel.text = @"提现异常";
            miaoshuLabel.text = @"经人工查询发现您的账户存在风险，请联系客服";
            timeLabel.text = self.timeStr;
        }
    }
}


- (void)finishButtonAction{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyyongjin" object:nil];
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[SSH_MyYongJinViewController class]]) {
            SSH_MyYongJinViewController *payDetailVC = (SSH_MyYongJinViewController *)viewController;
            [self.navigationController popToViewController:payDetailVC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
