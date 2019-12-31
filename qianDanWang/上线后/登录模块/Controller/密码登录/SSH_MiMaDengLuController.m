//
//  SSH_MiMaDengLuController.m
//  DENGFANGSC
//
//  Created by LY on 2018/9/27.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_MiMaDengLuController.h"
#import "SSH_LoginCell.h"
#import "SSH_ZhaoHuiMiMaController.h"//找回密码
#import "JPUSHService.h"
#import "SSH_FengXianBaKongViewController.h"
//#import "<#header#>"

@interface SSH_MiMaDengLuController (){
    NSInteger _seq;
}

@property (nonatomic, strong) UIButton *tiaoguoButton;//跳过
@property (nonatomic, strong) SSH_LoginCell *dengluCell1;
@property (nonatomic, strong) SSH_LoginCell *dengluCell2;
@property (nonatomic, strong) UIButton *loginButton;//登录按钮
@property (nonatomic, assign) BOOL isShowPassword;//是否展示密码，1:展示，0:安全

@end

@implementation SSH_MiMaDengLuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isShowPassword = 0;
    
    [self setupView];
}

- (void)setupView{
    
    //跳过
    self.tiaoguoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navigationView addSubview:self.tiaoguoButton];
    [self.tiaoguoButton setTitleColor:GrayColor666 forState:UIControlStateNormal];
    [self.tiaoguoButton setTitle:@"跳过" forState:UIControlStateNormal];
    self.tiaoguoButton.titleLabel.font = UIFONTTOOL14;
    [self.tiaoguoButton addTarget:self action:@selector(tiaoGuoFunction) forControlEvents:UIControlEventTouchUpInside];
    [self.tiaoguoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(14);
    }];
    
    if (self.isShowTiaoGuo) {
        self.goBackButton.hidden = YES;
    }else{
        self.tiaoguoButton.hidden = YES;
        [self.goBackButton addTarget:self action:@selector(yanZhengMaLoginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self.normalBackView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.width.height.mas_equalTo(75);
        make.centerX.mas_equalTo(self.normalBackView);
    }];
    
    self.dengluCell1 = [[SSH_LoginCell alloc] init];
    [self.normalBackView addSubview:self.dengluCell1];
    [self.dengluCell1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(logoImageView.mas_bottom).offset(30);
        make.height.mas_equalTo(54);
    }];
    NSString *phoneString = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGShowPhoneKey];
    self.dengluCell1.textField.text = phoneString;
    self.dengluCell1.textField.placeholder = @"请输入手机号";
    [self.dengluCell1.textField addTarget:self action:@selector(vertiCodeKuaiJieTextIsChange:) forControlEvents:UIControlEventEditingChanged];
    self.dengluCell1.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.dengluCell2 = [[SSH_LoginCell alloc] init];
    [self.normalBackView addSubview:self.dengluCell2];
    [self.dengluCell2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.dengluCell1.mas_bottom);
        make.height.mas_equalTo(54);
    }];
    self.dengluCell2.textField.placeholder = @"请输入密码";
    self.dengluCell2.mimashowButton.hidden = NO;
    self.dengluCell2.textField.secureTextEntry = YES;
    [self.dengluCell2.textField addTarget:self action:@selector(vertiCodeKuaiJieTextIsChange:) forControlEvents:UIControlEventEditingChanged];
    [self.dengluCell2.mimashowButton addTarget:self action:@selector(mimaSecuretyAction) forControlEvents:UIControlEventTouchUpInside];
    
    //登录按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.normalBackView addSubview:self.loginButton];
    self.loginButton.backgroundColor = ColorWithUnableClick;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 20;
    self.loginButton.enabled = NO;
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(27.5);
        make.right.mas_equalTo(-27.5);
        make.top.mas_equalTo(self.dengluCell2.mas_bottom).offset(55);
        make.height.mas_equalTo(40);
    }];
    
    //验证码登录
    UIButton *yanZhengMaLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.normalBackView addSubview:yanZhengMaLoginButton];
    yanZhengMaLoginButton.titleLabel.font = UIFONTTOOL13;
    [yanZhengMaLoginButton setTitle:@"验证码登录" forState:UIControlStateNormal];
    [yanZhengMaLoginButton setTitleColor:GrayColor666 forState:UIControlStateNormal];
    [yanZhengMaLoginButton addTarget:self action:@selector(yanZhengMaLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [yanZhengMaLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(33);
        make.top.mas_equalTo(self.loginButton.mas_bottom);
        make.height.mas_equalTo(43);
        make.width.mas_equalTo(71);
    }];
    
    //忘记密码
    UIButton *mimaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.normalBackView addSubview:mimaButton];
    mimaButton.titleLabel.font = UIFONTTOOL13;
    [mimaButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [mimaButton setTitleColor:GrayColor666 forState:UIControlStateNormal];
    [mimaButton addTarget:self action:@selector(passWordLoginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [mimaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-33);
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(0);
        make.height.mas_equalTo(43);
        make.width.mas_equalTo(58);
    }];
    
}

//密码显示按钮
- (void)mimaSecuretyAction{
    self.isShowPassword = !self.isShowPassword;
    if (self.isShowPassword == 0) {
        [self.dengluCell2.mimashowButton setImage:[UIImage imageNamed:@"weidakaiyanjing"] forState:UIControlStateNormal];
        self.dengluCell2.textField.secureTextEntry = YES;
    }else{
        [self.dengluCell2.mimashowButton setImage:[UIImage imageNamed:@"dakaiyanjing"] forState:UIControlStateNormal];
        self.dengluCell2.textField.secureTextEntry = NO;
    }
}

//验证码登录
- (void)yanZhengMaLoginAction{
    [self.navigationController popViewControllerAnimated:YES];
}

//跳过功能
- (void)tiaoGuoFunction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 快捷登录监听验证码输入
-(void)vertiCodeKuaiJieTextIsChange:(UITextField *)textfied
{
    if (self.dengluCell1.textField.text == nil || [self.dengluCell1.textField.text isEqualToString:@""] || self.dengluCell2.textField.text == nil || [self.dengluCell2.textField.text isEqualToString:@""]) {
        self.loginButton.enabled = NO;
        self.loginButton.backgroundColor = ColorWithUnableClick;
        
    }else{
        self.loginButton.enabled = YES;
        self.loginButton.backgroundColor = ColorZhuTiHongSe;
    }
}

//忘记密码按钮点击事件
- (void)passWordLoginButtonAction{
    
    SSH_ZhaoHuiMiMaController *passwordVC = [[SSH_ZhaoHuiMiMaController alloc] init];
    [self.navigationController pushViewController:passwordVC animated:YES];
    [DENGFANGSingletonTime shareInstance].isIndividualClickSetPwd = 0;
}

//登录按钮点击事件
- (void)loginButtonAction{
    
    NSString *registrationID = [[NSUserDefaults standardUserDefaults] valueForKey:@"registrationID"]==nil?@"": [[NSUserDefaults standardUserDefaults] valueForKey:@"registrationID"];

    NSString *loginArea = [DENGFANGSingletonTime shareInstance].mapCity == nil?@"":[DENGFANGSingletonTime shareInstance].mapCity;
    
    NSString *filterCity = [[NSUserDefaults standardUserDefaults] valueForKey:@"chooseCitys"] == nil?@"": [[NSUserDefaults standardUserDefaults] valueForKey:@"chooseCitys"];
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGLoginURL parameters:@{@"mobile":self.dengluCell1.textField.text,@"loginMethod":@"2",@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:self.dengluCell1.textField.text],@"securityCode":@"",@"password":[self.dengluCell2.textField.text yf_MD5String],@"terminalVersion":@"1.0.0",@"registrationId":registrationID,@"loginArea":loginArea,@"filterCity":filterCity} success:^(id responsObject) {
        
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"loginButtonAction---%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            [[NSUserDefaults standardUserDefaults] setValue:diction[@"token"] forKey:DENGFANGTokenKey];
            [[NSUserDefaults standardUserDefaults] setValue:diction[@"data"][@"userId"] forKey:DENGFANGUserIDKey];
            
            [[NSUserDefaults standardUserDefaults] setValue:diction[@"data"][@"mobile"] forKey:DENGFANGPhoneKey];
            [[NSUserDefaults standardUserDefaults] setValue:diction[@"data"][@"newMobile"] forKey:DENGFANGShowPhoneKey];
            
            [[NSUserDefaults standardUserDefaults] setValue:diction[@"data"][@"isPayPwd"] forKey:DENGFANGIsPayPwd];
            
            //登入信息 分销页面传给H5
            [[NSUserDefaults standardUserDefaults] setObject:diction[@"data"] forKey:DENGFANGLoginDataKey];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [DENGFANGSingletonTime shareInstance].tokenString = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGTokenKey];
            [DENGFANGSingletonTime shareInstance].mobileString = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGPhoneKey];
            NSString *useidStr = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGUserIDKey];
            [DENGFANGSingletonTime shareInstance].useridString = [useidStr intValue];
            
            [JPUSHService setAlias:self.dengluCell1.textField.text completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                self->_seq = seq;
            } seq:self->_seq];
            SSQ_HiddenNavigationViewController *nav = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:[SSH_FengXianBaKongViewController new]];
            UIViewController *vc2 = self.presentingViewController;
            
            

            [self dismissViewControllerAnimated:YES completion:^{
                [vc2 presentViewController:nav animated:YES completion:nil];
            }];
            
        }else if ([diction[@"code"] isEqualToString:@"11002"]) {
            //更换手机号后使用旧手机号登录给出提示
            [SSH_ZhangHaoDongJieView showInSuperView:diction[@"msg"]];
        }else if ([diction[@"code"] isEqualToString:@"10004"]) {
            
            [SSH_ZhangHaoDongJieView showInSuperView:diction[@"msg"]];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:diction[@"msg"]];
        }
        
    } fail:^(NSError *error) {
//        NSLog(@"%@",error);
    }];
    
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
