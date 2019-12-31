//
//  SSQ_BaseNormalViewController.m
//  TaoYouDan
//
//  Created by LY on 2018/9/28.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSQ_BaseNormalViewController.h"

@interface SSQ_BaseNormalViewController ()

@end

@implementation SSQ_BaseNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLORWHITE;
    
    self.navigationController.navigationBar.hidden = YES;
    
    
    //顶部导航栏View
    self.navigationView = [[UIView alloc] init];
    [self.view addSubview:self.navigationView];
    self.navigationView.backgroundColor = COLORWHITE;
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(getRectNavAndStatusHight);
    }];
    [self.navigationView borderForColor:ColorBackground_Line borderWidth:0.5 borderType:UIBorderSideTypeBottom];
    
    
    //其它控制器里布局的父视图
    self.normalBackView = [[UIView alloc] init];
    [self.view addSubview:self.normalBackView];
    self.normalBackView.backgroundColor = COLORWHITE;
    [self.normalBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(getRectNavAndStatusHight);
    }];
    
    //导航栏返回按钮
    self.goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.goBackButton setImage:[UIImage imageNamed:@"jiantou_zuo_heise"] forState:UIControlStateNormal];
    [self.navigationView addSubview:self.goBackButton];
    [self.goBackButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.goBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(40.5);
        make.height.mas_equalTo(44);
    }];
    
    //导航栏标题
    self.titleLabelNavi = [[UILabel alloc] init];
    self.titleLabelNavi.font = UIFONTTOOL16;
    self.titleLabelNavi.textColor = ColorBlack222;
    self.titleLabelNavi.textAlignment = 1;
    [self.navigationView addSubview:self.titleLabelNavi];
    [self.titleLabelNavi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goBackButton.mas_right);
        make.right.mas_equalTo(-40.5);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = GrayLineColor;
    [self.navigationView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.mas_equalTo(0.5);
    }];
    self.lineView.hidden = YES;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
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
