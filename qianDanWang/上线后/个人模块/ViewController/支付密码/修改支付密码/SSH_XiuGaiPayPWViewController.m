//
//  SSH_XiuGaiPayPWViewController.m
//  DENGFANGSC
//
//  Created by LY on 2018/12/13.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_XiuGaiPayPWViewController.h"
#import "SSH_LoginCell.h"

@interface SSH_XiuGaiPayPWViewController ()

@property (nonatomic, strong) SSH_LoginCell *yuanmimaCell;
@property (nonatomic, strong) SSH_LoginCell *mimaCell;
@property (nonatomic, strong) SSH_LoginCell *mimaAgainCell;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, assign) BOOL isShowPassword1;
@property (nonatomic, assign) BOOL isShowPassword2;
@property (nonatomic, assign) BOOL isShowPassword3;
@end

@implementation SSH_XiuGaiPayPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
}

- (void)mimaSecuretyAction1{
    self.isShowPassword1 = !self.isShowPassword1;
    if (self.isShowPassword1 == 0) {
        [self.yuanmimaCell.mimashowButton setImage:[UIImage imageNamed:@"weidakaiyanjing"] forState:UIControlStateNormal];
        self.yuanmimaCell.textField.secureTextEntry = YES;
    }else{
        [self.yuanmimaCell.mimashowButton setImage:[UIImage imageNamed:@"dakaiyanjing"] forState:UIControlStateNormal];
        self.yuanmimaCell.textField.secureTextEntry = NO;
    }
}

//密码显示按钮1
- (void)mimaSecuretyAction2{
    self.isShowPassword2 = !self.isShowPassword2;
    if (self.isShowPassword2 == 0) {
        [self.mimaCell.mimashowButton setImage:[UIImage imageNamed:@"weidakaiyanjing"] forState:UIControlStateNormal];
        self.mimaCell.textField.secureTextEntry = YES;
    }else{
        [self.mimaCell.mimashowButton setImage:[UIImage imageNamed:@"dakaiyanjing"] forState:UIControlStateNormal];
        self.mimaCell.textField.secureTextEntry = NO;
    }
}

//密码显示按钮
- (void)mimaSecuretyAction3{
    self.isShowPassword3 = !self.isShowPassword3;
    if (self.isShowPassword3 == 0) {
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
    setPWDNameLabel.text = @"修改支付密码";
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
    alertPWDLabel.text = @"需要输入原支付密码，验证身份";
    alertPWDLabel.textColor = ColorBlack999;
    alertPWDLabel.font = UIFONTTOOL15;
    [alertPWDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(setPWDNameLabel);
        make.top.mas_equalTo(setPWDNameLabel.mas_bottom).offset(17.5);
        make.height.mas_equalTo(15);
    }];
    
    self.yuanmimaCell = [[SSH_LoginCell alloc] init];
    [self.normalBackView addSubview:self.yuanmimaCell];
    self.yuanmimaCell.textField.secureTextEntry = YES;
    self.yuanmimaCell.mimashowButton.hidden = NO;
    [self.yuanmimaCell.mimashowButton addTarget:self action:@selector(mimaSecuretyAction1) forControlEvents:UIControlEventTouchUpInside];
    [self.yuanmimaCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(alertPWDLabel.mas_bottom).offset(16.5);
        make.height.mas_equalTo(54);
    }];
    self.yuanmimaCell.textField.placeholder = @"请输入您的原支付密码";
    [self.yuanmimaCell.textField addTarget:self action:@selector(vertiCodeKuaiJieTextIsChange:) forControlEvents:UIControlEventEditingChanged];
    self.yuanmimaCell.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.mimaCell = [[SSH_LoginCell alloc] init];
    [self.normalBackView addSubview:self.mimaCell];
    self.mimaCell.textField.secureTextEntry = YES;
    self.mimaCell.mimashowButton.hidden = NO;
    [self.mimaCell.mimashowButton addTarget:self action:@selector(mimaSecuretyAction2) forControlEvents:UIControlEventTouchUpInside];
    [self.mimaCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.yuanmimaCell.mas_bottom);
        make.height.mas_equalTo(54);
    }];
    self.mimaCell.textField.placeholder = @"请输入新的6位支付密码";
    [self.mimaCell.textField addTarget:self action:@selector(vertiCodeKuaiJieTextIsChange:) forControlEvents:UIControlEventEditingChanged];
    self.mimaCell.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.mimaAgainCell = [[SSH_LoginCell alloc] init];
    [self.normalBackView addSubview:self.mimaAgainCell];
    self.mimaAgainCell.textField.secureTextEntry = YES;
    self.mimaAgainCell.mimashowButton.hidden = NO;
    [self.mimaAgainCell.mimashowButton addTarget:self action:@selector(mimaSecuretyAction3) forControlEvents:UIControlEventTouchUpInside];
    [self.mimaAgainCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.mimaCell.mas_bottom);
        make.height.mas_equalTo(54);
    }];
    self.mimaAgainCell.textField.placeholder = @"请再次输入支付密码";
    [self.mimaAgainCell.textField addTarget:self action:@selector(vertiCodeKuaiJieTextIsChange:) forControlEvents:UIControlEventEditingChanged];
    self.mimaAgainCell.textField.keyboardType = UIKeyboardTypeNumberPad;
    
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
    
    
}

- (void)sureToSetPWDAction{
    
    if (self.yuanmimaCell.textField.text.length !=6 ||  self.mimaCell.textField.text.length !=6 || self.mimaAgainCell.textField.text.length !=6) {
        [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:@"请输入6位支付密码"];
        return;
    }
    
    if (![self.mimaCell.textField.text isEqualToString:self.mimaAgainCell.textField.text]) {
        
        [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:@"两次密码输入不一致"];
        return;
    }
    NSString *userString = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGModifyPayPWDURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:userString],@"oldPwd":[self.yuanmimaCell.textField.text yf_MD5String],@"newPwd":[self.mimaCell.textField.text yf_MD5String],@"mobile":[DENGFANGSingletonTime shareInstance].mobileString} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];
    
    
}

#pragma mark 监听输入
-(void)vertiCodeKuaiJieTextIsChange:(UITextField *)textfied
{
    if (self.yuanmimaCell.textField.text == nil || [self.yuanmimaCell.textField.text isEqualToString:@""] ||self.mimaCell.textField.text == nil || [self.mimaCell.textField.text isEqualToString:@""] || self.mimaAgainCell.textField.text == nil || [self.mimaAgainCell.textField.text isEqualToString:@""]) {
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
