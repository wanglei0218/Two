//
//  SSH_IDYanZhengViewController.m
//  DENGFANGSC
//
//  Created by LY on 2018/12/13.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_IDYanZhengViewController.h"
#import "SSH_LoginCell.h"
#import "SSH_SetPayPWViewController.h"

@interface SSH_IDYanZhengViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) SSH_LoginCell *dengluCell1;
@property (nonatomic, strong) SSH_LoginCell *dengluCell2;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, assign) BOOL isShowPassword1;
@property (nonatomic, assign) BOOL isShowPassword2;

@end

@implementation SSH_IDYanZhengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView{
    
    UILabel *setPWDNameLabel = [[UILabel alloc] init];
    [self.normalBackView addSubview:setPWDNameLabel];
    setPWDNameLabel.text = @"需要进行身份验证";
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
    self.dengluCell1.textField.placeholder = @"请输入您的真实姓名";
    [self.dengluCell1.textField addTarget:self action:@selector(vertiCodeKuaiJieTextIsChange:) forControlEvents:UIControlEventEditingChanged];
    
    //请再次输入支付密码
    self.dengluCell2 = [[SSH_LoginCell alloc] init];
    [self.normalBackView addSubview:self.dengluCell2];
    [self.dengluCell2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.dengluCell1.mas_bottom);
        make.height.mas_equalTo(54);
    }];
    self.dengluCell2.textField.placeholder = @"请输入您的身份证号";
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


- (void)sureToSetPWDAction{
    
    
    if (self.dengluCell1.textField.text.length <= 0) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请填写真实姓名"];
        return;
    }else if (self.dengluCell2.textField.text.length <= 0){
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请填写身份证号"];
        return;
    }
//    else if (![SSH_TOOL_GongJuLei checkUserIdCard:self.dengluCell2.textField.text]) {
//        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请填写正确的身份证号"];
//        return;
//    }
    
    NSString *userString = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGSetPayPWURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:userString],@"name":self.dengluCell1.textField.text,@"idCard":self.dengluCell2.textField.text,@"type":@1,@"payPwd":@""} success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"shenfen_yanzheng%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            SSH_SetPayPWViewController *SetPayPWVC = [[SSH_SetPayPWViewController alloc] init];
            SetPayPWVC.name = self.dengluCell1.textField.text;
            SetPayPWVC.shenfenzheng = self.dengluCell2.textField.text;
            
            [self.navigationController pushViewController:SetPayPWVC animated:YES];
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
