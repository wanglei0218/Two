//
//  SSH_ZhaoHuiMiMaController.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/29.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ZhaoHuiMiMaController.h"
#import "SSH_LoginCell.h"
#import "SSH_SheZhiMiMaController.h"
#import "JPUSHService.h"


@interface SSH_ZhaoHuiMiMaController ()<UITextFieldDelegate>{
    NSInteger _seq;
}

@property (nonatomic, strong) SSH_LoginCell *dengluCell1;
@property (nonatomic, strong) SSH_LoginCell *dengluCell2;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timeTime;
@property (nonatomic, strong) UIView *windowView;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic,assign)BOOL isClickedGetVertifyButton; //正确手机号下，是否点击过获取验证码
@property (nonatomic, strong) UITextField *codeTextField;//图形验证码输入框
@property (nonatomic, strong) UIImageView *codeImgView;//图形验证码
@property (nonatomic, strong) NSString *securityCode;//验证码

@end

@implementation SSH_ZhaoHuiMiMaController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeTime = 59;
    [self setupView];
}

- (void)setupView{
    
    UILabel *setPWDNameLabel = [[UILabel alloc] init];
    [self.normalBackView addSubview:setPWDNameLabel];
    setPWDNameLabel.text = @"手机号验证";
    setPWDNameLabel.font = UIFONTTOOL(24);
    setPWDNameLabel.textColor = ColorBlack222;
    [setPWDNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(27.5);
        make.top.mas_equalTo(17);
        make.right.mas_equalTo(-27.5);
        make.height.mas_equalTo(24);
    }];
    
    self.dengluCell1 = [[SSH_LoginCell alloc] init];
    [self.normalBackView addSubview:self.dengluCell1];
    [self.dengluCell1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(setPWDNameLabel.mas_bottom).offset(50);
        make.height.mas_equalTo(54);
    }];
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
    self.dengluCell2.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.dengluCell2.textField.placeholder = @"请输入手机验证码";
    self.dengluCell2.getVertiButton.hidden = NO;
    [self.dengluCell2.textField addTarget:self action:@selector(vertiCodeKuaiJieTextIsChange:) forControlEvents:UIControlEventEditingChanged];
    [self.dengluCell2.getVertiButton addTarget:self action:@selector(getVertifyCodeAction) forControlEvents:UIControlEventTouchUpInside];
    
    //确认按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.normalBackView addSubview:self.loginButton];
    self.loginButton.backgroundColor = ColorWithUnableClick;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.cornerRadius = 20;
    self.loginButton.enabled = NO;
    [self.loginButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(27.5);
        make.right.mas_equalTo(-27.5);
        make.top.mas_equalTo(self.dengluCell2.mas_bottom).offset(55);
        make.height.mas_equalTo(40);
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

#pragma mark - 获取验证码
- (void)getVertifyCodeAction{
    [self getVertifyCodeActionWithPicCode:@""];
}

- (void)getVertifyCodeActionWithPicCode:(NSString *)picCode{
    //    NSLog(@"picCode----%@",picCode);
    NSString *phoneString = self.dengluCell1.textField.text;
    if (![SSH_TOOL_GongJuLei checkTelNumber:phoneString]) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请输入正确的手机号"];
        return;
    }
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGGetVertifyCodeURL parameters:@{@"mobile":self.dengluCell1.textField.text,@"picCode":picCode} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"getVertifyCodeActionWithPicCode---%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [self.dengluCell2.getVertiButton setTitle:@"59s" forState:(UIControlStateNormal)];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer11) userInfo:nil repeats:YES];
            
            if (![picCode isEqualToString:@""]) {
                [self advertisementDismiss];
            }
        }else if ([diction[@"code"]  isEqual: @"10022"]){
            [self.dengluCell1.textField resignFirstResponder];
            if (!self.isClickedGetVertifyButton) {
                self.isClickedGetVertifyButton = YES;
                [self setupImgAlertView];
            }
        }else{
            [SSH_TOOL_GongJuLei showAlter:[UIApplication sharedApplication].keyWindow WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)timer11{
    _timeTime--;
    NSString *str = [NSString stringWithFormat:@"%lds",(long)_timeTime];
    
    self.dengluCell2.getVertiButton.userInteractionEnabled = NO;
    [self.dengluCell2.getVertiButton setTitle:str forState:(UIControlStateNormal)];
    if (_timeTime == 0) {
        [self.timer invalidate];
        [self.dengluCell2.getVertiButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        self.dengluCell2.getVertiButton.userInteractionEnabled = YES;
        _timeTime = 59;
    }
}

- (void)advertisementDismiss{
    self.isClickedGetVertifyButton = NO;
    self.windowView.alpha = 0;
    [self.whiteView removeFromSuperview];
    [self.windowView removeFromSuperview];
    
}

- (void)setupImgAlertView{
    
    [self getImgCode];
    
    self.windowView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.windowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.navigationController.view addSubview:self.windowView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(advertisementDismiss)];
    [self.windowView addGestureRecognizer:tapGes];
    
    self.whiteView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-295)/2, self.windowView.centerY-90, 295, 180)];
    [self.navigationController.view addSubview:self.whiteView];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    self.whiteView.layer.masksToBounds = YES;
    self.whiteView.layer.cornerRadius = 15;
    
    self.codeTextField = [[UITextField alloc] init];
    [self.whiteView addSubview:self.codeTextField];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.codeTextField.leftView = leftView;
    self.codeTextField.leftViewMode = UITextFieldViewModeAlways;
    self.codeTextField.layer.borderColor = ColorBlack999.CGColor;
    self.codeTextField.placeholder = @"请输入图形验证码";
    self.codeTextField.delegate = self;
    self.codeTextField.returnKeyType = UIReturnKeyDone;
    self.codeTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.codeTextField.layer.borderWidth = 0.5;
    self.codeTextField.layer.masksToBounds = YES;
    self.codeTextField.layer.cornerRadius = 5;
    self.codeTextField.font = [UIFont systemFontOfSize:15];
    self.codeTextField.textColor = ColorBlack999;
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22.5);
        make.width.mas_equalTo(158);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(45);
    }];
    
    self.codeImgView = [[UIImageView alloc] init];
    [self.whiteView addSubview:self.codeImgView];
    self.codeImgView.layer.borderColor = ColorBlack999.CGColor;
    self.codeImgView.layer.borderWidth = 0.5;
    [self.codeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.codeTextField.mas_right).offset(10);
        make.width.mas_equalTo(84.5);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(self.codeTextField);
    }];
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.whiteView addSubview:changeButton];
    changeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [changeButton setTitleColor:ColorZhuTiHongSe forState:UIControlStateNormal];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"点击换一换"];
    NSRange range = NSMakeRange(0, attString.length);
    [attString addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:ColorZhuTiHongSe} range:range];
    [changeButton setAttributedTitle:attString forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(getImgCode) forControlEvents:UIControlEventTouchUpInside];
    [changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.codeImgView);
        make.top.mas_equalTo(self.codeImgView.mas_bottom);
        make.height.mas_equalTo(32);
    }];
    
    
    UIButton *tijiaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.whiteView addSubview:tijiaoButton];
    tijiaoButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [tijiaoButton setTitle:@"确定" forState:UIControlStateNormal];
    tijiaoButton.layer.masksToBounds = YES;
    tijiaoButton.layer.cornerRadius = 20;
    [tijiaoButton addTarget:self action:@selector(tijiaoImgVertiCode) forControlEvents:UIControlEventTouchUpInside];
    tijiaoButton.backgroundColor = ColorZhuTiHongSe;
    [tijiaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22.5);
        make.right.mas_equalTo(-22.5);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(self.whiteView.mas_bottom).offset(-25);
    }];
    
    
}

- (void)getImgCode{
    NSString *timeString = [self getNowTimeTimestamp];
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGPicCodeURL parameters:@{@"mobile":self.dengluCell1.textField.text,@"t":timeString} success:^(id responsObject) {
        
        self.codeImgView.image = [UIImage imageWithData:responsObject];
        
    } fail:^(NSError *error) {
        
    }];
    
}

//获取当前时间戳  （以毫秒为单位）
- (NSString *)getNowTimeTimestamp{
    
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
}

- (void)tijiaoImgVertiCode{
    
    if (self.codeTextField.text == nil || [self.codeTextField.text isEqualToString:@""]) {
        [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:@"请输入验证码"];
        return;
    }
    [self getVertifyCodeActionWithPicCode:self.codeTextField.text];
    
}

//登录按钮点击事件
- (void)loginButtonAction{
    /*
     loginMethod
     登录方式  String  1：短信登录  2：密码登录
     */
    
    NSString *registrationID = [[NSUserDefaults standardUserDefaults] valueForKey:@"registrationID"]==nil?@"": [[NSUserDefaults standardUserDefaults] valueForKey:@"registrationID"];
    
    NSString *loginArea = [DENGFANGSingletonTime shareInstance].mapCity == nil?@"":[DENGFANGSingletonTime shareInstance].mapCity;
    
    NSString *filterCity = [[NSUserDefaults standardUserDefaults] valueForKey:@"chooseCitys"] == nil?@"": [[NSUserDefaults standardUserDefaults] valueForKey:@"chooseCitys"];
    
    self.securityCode = self.dengluCell2.textField.text;
    NSDictionary *parms = @{@"mobile":self.dengluCell1.textField.text,@"loginMethod":@"1",@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:self.dengluCell1.textField.text],@"securityCode":self.securityCode,@"password":@"",@"terminalVersion":@"1.0.0",@"registrationId":registrationID,@"loginArea":loginArea,@"filterCity":filterCity};
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGLoginURL parameters:parms success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            [[NSUserDefaults standardUserDefaults] setValue:diction[@"token"] forKey:DENGFANGTokenKey];
            [[NSUserDefaults standardUserDefaults] setValue:diction[@"data"][@"userId"] forKey:DENGFANGUserIDKey];
            [[NSUserDefaults standardUserDefaults] setValue:diction[@"data"][@"mobile"] forKey:DENGFANGPhoneKey];
            [[NSUserDefaults standardUserDefaults] setValue:diction[@"data"][@"newMobile"] forKey:DENGFANGShowPhoneKey];
            //登入信息 分销页面传给H5
            [[NSUserDefaults standardUserDefaults] setObject:diction[@"data"] forKey:DENGFANGLoginDataKey];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            [DENGFANGSingletonTime shareInstance].tokenString = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGTokenKey];
            [DENGFANGSingletonTime shareInstance].mobileString = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGPhoneKey];
            NSString *useidStr = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGUserIDKey];
            [DENGFANGSingletonTime shareInstance].useridString = [useidStr intValue];
            SSH_SheZhiMiMaController *setPWDVC = [[SSH_SheZhiMiMaController alloc] init];
            setPWDVC.securityCode = self.securityCode;
            
            [JPUSHService setAlias:self.dengluCell1.textField.text completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                self->_seq = seq;
            } seq:self->_seq];
            
            [self.navigationController pushViewController:setPWDVC animated:YES];
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:diction[@"msg"]];
        }
        
    } fail:^(NSError *error) {
        
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
