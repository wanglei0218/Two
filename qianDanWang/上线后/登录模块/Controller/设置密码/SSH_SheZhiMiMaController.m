//
//  SSH_SheZhiMiMaController.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/26.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_SheZhiMiMaController.h"
#import "SSH_LoginCell.h"
#import "SSH_FengXianBaKongViewController.h"

@interface SSH_SheZhiMiMaController ()

@property (nonatomic, strong) SSH_LoginCell *mimaCell;
@property (nonatomic, strong) SSH_LoginCell *mimaAgainCell;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, assign) BOOL isShowPassword1;
@property (nonatomic, assign) BOOL isShowPassword2;

@end

@implementation SSH_SheZhiMiMaController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
}

//密码显示按钮1
- (void)mimaSecuretyAction1{
    self.isShowPassword1 = !self.isShowPassword1;
    if (self.isShowPassword1 == 0) {
        [self.mimaCell.mimashowButton setImage:[UIImage imageNamed:@"weidakaiyanjing"] forState:UIControlStateNormal];
        self.mimaCell.textField.secureTextEntry = YES;
    }else{
        [self.mimaCell.mimashowButton setImage:[UIImage imageNamed:@"dakaiyanjing"] forState:UIControlStateNormal];
        self.mimaCell.textField.secureTextEntry = NO;
    }
}

//密码显示按钮1
- (void)mimaSecuretyAction2{
    self.isShowPassword2 = !self.isShowPassword2;
    if (self.isShowPassword2 == 0) {
        [self.mimaAgainCell.mimashowButton setImage:[UIImage imageNamed:@"weidakaiyanjing"] forState:UIControlStateNormal];
        self.mimaAgainCell.textField.secureTextEntry = YES;
    }else{
        [self.mimaAgainCell.mimashowButton setImage:[UIImage imageNamed:@"dakaiyanjing"] forState:UIControlStateNormal];
        self.mimaAgainCell.textField.secureTextEntry = NO;
    }
}

- (void)setupView{
    
    UILabel *setPWDNameLabel = [[UILabel alloc] init];
    [self.normalBackView addSubview:setPWDNameLabel];
    setPWDNameLabel.text = @"设置密码";
    setPWDNameLabel.font = UIFONTTOOL(24);
    setPWDNameLabel.textColor = ColorBlack222;
    [setPWDNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(27.5);
        make.top.mas_equalTo(16);
        make.right.mas_equalTo(-27.5);
        make.height.mas_equalTo(24);
    }];
    
    UILabel *alertPWDLabel = [[UILabel alloc] init];
    [self.normalBackView addSubview:alertPWDLabel];
    alertPWDLabel.text = @"设置密码后,可以通过手机号+密码登录";
    alertPWDLabel.textColor = ColorBlack999;
    alertPWDLabel.font = UIFONTTOOL15;
    [alertPWDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(setPWDNameLabel);
        make.top.mas_equalTo(setPWDNameLabel.mas_bottom).offset(17.5);
        make.height.mas_equalTo(15);
    }];
    
    self.mimaCell = [[SSH_LoginCell alloc] init];
    [self.normalBackView addSubview:self.mimaCell];
    self.mimaCell.textField.secureTextEntry = YES;
    self.mimaCell.mimashowButton.hidden = NO;
    [self.mimaCell.mimashowButton addTarget:self action:@selector(mimaSecuretyAction1) forControlEvents:UIControlEventTouchUpInside];
    [self.mimaCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(alertPWDLabel.mas_bottom).offset(16.5);
        make.height.mas_equalTo(54);
    }];
    self.mimaCell.textField.placeholder = @"请输入6~8位新密码";
    [self.mimaCell.textField addTarget:self action:@selector(vertiCodeKuaiJieTextIsChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.mimaAgainCell = [[SSH_LoginCell alloc] init];
    [self.normalBackView addSubview:self.mimaAgainCell];
    self.mimaAgainCell.textField.secureTextEntry = YES;
    self.mimaAgainCell.mimashowButton.hidden = NO;
    [self.mimaAgainCell.mimashowButton addTarget:self action:@selector(mimaSecuretyAction2) forControlEvents:UIControlEventTouchUpInside];
    [self.mimaAgainCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.mimaCell.mas_bottom);
        make.height.mas_equalTo(54);
    }];
    self.mimaAgainCell.textField.placeholder = @"请再次输入新密码";
    [self.mimaAgainCell.textField addTarget:self action:@selector(vertiCodeKuaiJieTextIsChange:) forControlEvents:UIControlEventEditingChanged];
    
    //确认按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.normalBackView addSubview:self.loginButton];
    self.loginButton.backgroundColor = ColorWithUnableClick;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 20;
    self.loginButton.enabled = NO;
    [self.loginButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(sureToSetPWDAction) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(27.5);
        make.right.mas_equalTo(-27.5);
        make.top.mas_equalTo(self.mimaAgainCell.mas_bottom).offset(55);
        make.height.mas_equalTo(40);
    }];
    
    
    
    //以后设置
    UIButton *mimaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.normalBackView addSubview:mimaButton];
    mimaButton.titleLabel.font = UIFONTTOOL13;
    [mimaButton setTitle:@"以后设置" forState:UIControlStateNormal];
    [mimaButton setTitleColor:GrayColor666 forState:UIControlStateNormal];
    [mimaButton addTarget:self action:@selector(setPWDLater) forControlEvents:UIControlEventTouchUpInside];
    [mimaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-33);
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(0);
        make.height.mas_equalTo(43);
        make.width.mas_equalTo(58);
    }];
    
    
    if ([DENGFANGSingletonTime shareInstance].isIndividualClickSetPwd) {
        
        self.goBackButton.hidden = NO;
        mimaButton.hidden = YES;
        
    }else{
        self.goBackButton.hidden = YES;
        mimaButton.hidden = NO;
    }
    
    
}

//以后设置
- (void)setPWDLater{
    
    if ([DENGFANGSingletonTime shareInstance].isIndividualClickSetPwd == 1) {
        SSQ_HiddenNavigationViewController *nav = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:[SSH_FengXianBaKongViewController new]];
        UIViewController *vc2 = self.presentingViewController;
        
        [self dismissViewControllerAnimated:YES completion:^{
            [vc2 presentViewController:nav animated:YES completion:nil];
        }];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        SSQ_HiddenNavigationViewController *nav = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:[SSH_FengXianBaKongViewController new]];
        UIViewController *vc2 = self.presentingViewController;
//
//        [self dismissViewControllerAnimated:YES completion:^{
//
//        }];
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.isDidDiss) {
                self.isDidDiss(YES);
            }
            [vc2 presentViewController:nav animated:YES completion:nil];
        }];
    }
}

- (void)sureToSetPWDAction{
    
    if (self.mimaCell.textField.text.length <6 || self.mimaCell.textField.text.length >8 ||  self.mimaAgainCell.textField.text.length <6 || self.mimaAgainCell.textField.text.length >8) {
        [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:@"请输入6~8位新密码"];
        return;
    }
    
    if (![self.mimaCell.textField.text isEqualToString:self.mimaAgainCell.textField.text]) {
        
        [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:@"两次密码输入不一致"];
        return;
    }
    
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGPhoneKey];
    
    //type 1:注册完以后  密码设置   2：忘记密码短息验证修改密码
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGSetPasswordURL parameters:@{@"mobile":phoneNumber,@"type":@"1",@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:phoneNumber],@"securityCode":self.securityCode,@"password":[self.mimaCell.textField.text yf_MD5String]} success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"注册完以后  密码设置---%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [self setPWDLater];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:diction[@"msg"]];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark 监听输入
-(void)vertiCodeKuaiJieTextIsChange:(UITextField *)textfied
{
    if (self.mimaCell.textField.text == nil || [self.mimaCell.textField.text isEqualToString:@""] || self.mimaAgainCell.textField.text == nil || [self.mimaAgainCell.textField.text isEqualToString:@""]) {
        self.loginButton.enabled = NO;
        self.loginButton.backgroundColor = ColorWithUnableClick;
        
    }else{
        self.loginButton.enabled = YES;
        self.loginButton.backgroundColor = ColorZhuTiHongSe;
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
