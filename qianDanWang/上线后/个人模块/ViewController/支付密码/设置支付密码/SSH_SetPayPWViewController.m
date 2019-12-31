//
//  SSH_SetPayPWViewController.m
//  DENGFANGSC
//
//  Created by LY on 2018/12/13.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_SetPayPWViewController.h"
#import "SSH_LoginCell.h"
#import "SSH_ZhifuXiangQingViewController.h"

@interface SSH_SetPayPWViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) SSH_LoginCell *dengluCell1;
@property (nonatomic, strong) SSH_LoginCell *dengluCell2;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, assign) BOOL isShowPassword1;
@property (nonatomic, assign) BOOL isShowPassword2;

@end

@implementation SSH_SetPayPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView{
    
    UILabel *setPWDNameLabel = [[UILabel alloc] init];
    [self.normalBackView addSubview:setPWDNameLabel];
    setPWDNameLabel.text = @"设置支付密码";
    setPWDNameLabel.font = UIFONTTOOL(24);
    setPWDNameLabel.textColor = ColorBlack222;
    [setPWDNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(27.5);
        make.top.mas_equalTo(17);
        make.right.mas_equalTo(-27.5);
        make.height.mas_equalTo(24);
    }];
    
    //请输入6位支付密码
    self.dengluCell1 = [[SSH_LoginCell alloc] init];
    [self.normalBackView addSubview:self.dengluCell1];
    [self.dengluCell1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(setPWDNameLabel.mas_bottom).offset(50);
        make.height.mas_equalTo(54);
    }];
    self.dengluCell1.textField.placeholder = @"请输入6位支付密码";
    [self.dengluCell1.textField addTarget:self action:@selector(vertiCodeKuaiJieTextIsChange:) forControlEvents:UIControlEventEditingChanged];
    self.dengluCell1.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.dengluCell1.textField.secureTextEntry = YES;
    self.dengluCell1.mimashowButton.hidden = NO;
    [self.dengluCell1.mimashowButton addTarget:self action:@selector(mimaSecuretyAction1) forControlEvents:UIControlEventTouchUpInside];
    
    //请再次输入支付密码
    self.dengluCell2 = [[SSH_LoginCell alloc] init];
    [self.normalBackView addSubview:self.dengluCell2];
    [self.dengluCell2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.dengluCell1.mas_bottom);
        make.height.mas_equalTo(54);
    }];
    self.dengluCell2.textField.secureTextEntry = YES;
    self.dengluCell2.mimashowButton.hidden = NO;
    [self.dengluCell2.mimashowButton addTarget:self action:@selector(mimaSecuretyAction2) forControlEvents:UIControlEventTouchUpInside];
    self.dengluCell2.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.dengluCell2.textField.placeholder = @"请再次输入支付密码";
    [self.dengluCell2.textField addTarget:self action:@selector(vertiCodeKuaiJieTextIsChange:) forControlEvents:UIControlEventEditingChanged];
    
    //确认按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.normalBackView addSubview:self.loginButton];
    self.loginButton.backgroundColor = ColorWithUnableClick;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 20;
    self.loginButton.enabled = NO;
    [self.loginButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(sureToSetPWDAction) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(27.5);
        make.right.mas_equalTo(-27.5);
        make.top.mas_equalTo(self.dengluCell2.mas_bottom).offset(55);
        make.height.mas_equalTo(40);
    }];
    
    
}

//密码显示按钮1
- (void)mimaSecuretyAction1{
    self.isShowPassword1 = !self.isShowPassword1;
    if (self.isShowPassword1 == 0) {
        [self.dengluCell1.mimashowButton setImage:[UIImage imageNamed:@"weidakaiyanjing"] forState:UIControlStateNormal];
        self.dengluCell1.textField.secureTextEntry = YES;
    }else{
        [self.dengluCell1.mimashowButton setImage:[UIImage imageNamed:@"dakaiyanjing"] forState:UIControlStateNormal];
        self.dengluCell1.textField.secureTextEntry = NO;
    }
}

//密码显示按钮1
- (void)mimaSecuretyAction2{
    self.isShowPassword2 = !self.isShowPassword2;
    if (self.isShowPassword2 == 0) {
        [self.dengluCell2.mimashowButton setImage:[UIImage imageNamed:@"weidakaiyanjing"] forState:UIControlStateNormal];
        self.dengluCell2.textField.secureTextEntry = YES;
    }else{
        [self.dengluCell2.mimashowButton setImage:[UIImage imageNamed:@"dakaiyanjing"] forState:UIControlStateNormal];
        self.dengluCell2.textField.secureTextEntry = NO;
    }
}

- (void)sureToSetPWDAction{
    
    if (self.dengluCell1.textField.text.length !=6 ||  self.dengluCell2.textField.text.length !=6) {
        [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:@"请输入6位支付密码"];
        return;
    }
    
    if (![self.dengluCell1.textField.text isEqualToString:self.dengluCell2.textField.text]) {
        
        [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:@"两次密码输入不一致"];
        return;
    }
    
    
    NSString *userString = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGSetPayPWURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:userString],@"name":self.name,@"idCard":self.shenfenzheng,@"type":@2,@"payPwd":[self.dengluCell1.textField.text yf_MD5String]} success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"shenfen_yanzheng%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            //支付密码设置成功后，设置value=1
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:DENGFANGIsPayPwd];
            int isToPayDetail = 0;
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[SSH_ZhifuXiangQingViewController class]]) {
                    isToPayDetail = 1;
                    SSH_ZhifuXiangQingViewController *payDetailVC = (SSH_ZhifuXiangQingViewController *)viewController;
                    [self.navigationController popToViewController:payDetailVC animated:YES];
                    
                }
            }
            if (!isToPayDetail) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark 监听输入
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
