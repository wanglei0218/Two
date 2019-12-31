//
//  SSH_YanZhengMaDengLuController.m
//  DENGFANGSC
//
//  Created by LY on 2018/9/18.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_YanZhengMaDengLuController.h"
#import "SSH_LoginCell.h"
#import "SSH_YongHuTongYiXieYiView.h"//用户同意协议view
#import "SSH_MiMaDengLuController.h"//密码登录controller
#import "SSH_SheZhiMiMaController.h"//设置密码
#import "SSH_WangYeViewController.h"
#import "JPUSHService.h"
#import "SSH_FengXianBaKongViewController.h"

@interface SSH_YanZhengMaDengLuController ()<UITextFieldDelegate>{
    NSInteger _seq;
}

@property (nonatomic, strong) UIButton *tiaoguoButton;//跳过
@property (nonatomic, strong) SSH_LoginCell *dengluCell1;//手机号
@property (nonatomic, strong) SSH_LoginCell *dengluCell2;//验证码
@property (nonatomic, strong) SSH_LoginCell *dengluCell3;//邀请码
@property (nonatomic, assign) BOOL isAgreeProtocol;//是否选择了同意协议，默认为1（是）
@property (nonatomic, strong) UIButton *loginButton;//登录按钮
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timeTime;
@property (nonatomic, strong) UIView *windowView;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic,assign)BOOL isClickedGetVertifyButton; //正确手机号下，是否点击过获取验证码
@property (nonatomic, strong) UITextField *codeTextField;//图形验证码输入框
@property (nonatomic, strong) UIImageView *codeImgView;//图形验证码
@property (nonatomic, strong) NSString *securityCode;//验证码
@property(nonatomic,strong) UILabel *songJinBiLab;
@end

@implementation SSH_YanZhengMaDengLuController

//首页未认证：NOT_AUTH  打折专区：DISCOUNT_AREA
-(void)getDENGFANGSystemData{
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil],@"sysTemCode":@"NOT_AUTH"};
    
    NSString *url = @"sys/getSysTemInfo";
    
    [[DENGFANGRequest shareInstance] postWithUrlString:url parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            NSString *price = [NSString stringWithFormat:@"%@",diction[@"data"][@"deaultPrice"]];
            if ([price isEqualToString:@"0"]) {
                self.songJinBiLab.hidden = YES;
            }else{
                self.songJinBiLab.hidden = ![DENGFANGSingletonTime shareInstance].isOnline;
                self.songJinBiLab.text = [NSString stringWithFormat:@"注册成功即获%@金币",price];
            }
            
        }
    } fail:^(NSError *error) {
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeTime = 59;
    self.isAgreeProtocol = 1;
    
    [self setupView];
    [self getDENGFANGSystemData];
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
        [self.goBackButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image =[UIImage imageNamed:@"logo"];
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
    self.dengluCell1.textField.placeholder = @"请输入手机号";
    [self.dengluCell1.textField addTarget:self action:@selector(vertiCodeKuaiJieTextIsChange:) forControlEvents:UIControlEventEditingChanged];
    self.dengluCell1.textField.keyboardType = UIKeyboardTypeNumberPad;
    NSString *phoneString = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGShowPhoneKey];
    self.dengluCell1.textField.text = phoneString;
    
    self.dengluCell2 = [[SSH_LoginCell alloc] init];
    [self.normalBackView addSubview:self.dengluCell2];
    self.dengluCell2.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.dengluCell2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.dengluCell1.mas_bottom);
        make.height.mas_equalTo(54);
    }];
    self.dengluCell2.textField.placeholder = @"请输入验证码";
    self.dengluCell2.getVertiButton.hidden = NO;
    [self.dengluCell2.textField addTarget:self action:@selector(vertiCodeKuaiJieTextIsChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.dengluCell2.getVertiButton addTarget:self action:@selector(getVertifyCodeAction) forControlEvents:UIControlEventTouchUpInside];
    
//    //邀请码cell
//    self.dengluCell3 = [[SSH_LoginCell alloc] init];
//    [self.normalBackView addSubview:self.dengluCell3];
//    [self.dengluCell3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.mas_equalTo(self.dengluCell2.mas_bottom);
//        make.height.mas_equalTo(54);
//    }];
//    self.dengluCell3.textField.placeholder = @"请输入您的邀请码(选填)";
    
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
    
    self.songJinBiLab = [[UILabel alloc] init];
    [self.normalBackView addSubview:self.songJinBiLab];
    self.songJinBiLab.textColor = ColorWithUnableClick;
    self.songJinBiLab.textAlignment = NSTextAlignmentCenter;
    self.songJinBiLab.font = [UIFont systemFontOfSize:14];
    [self.songJinBiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(27.5);
        make.right.mas_equalTo(-27.5);
        make.height.mas_equalTo(12);
        make.bottom.mas_equalTo(self.loginButton.mas_top).offset(-10);
    }];
    self.songJinBiLab.hidden = YES;
    
    //密码登录
    UIButton *mimaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.normalBackView addSubview:mimaButton];
    mimaButton.titleLabel.font = UIFONTTOOL13;
    [mimaButton setTitle:@"密码登录" forState:UIControlStateNormal];
    [mimaButton setTitleColor:GrayColor666 forState:UIControlStateNormal];
    [mimaButton addTarget:self action:@selector(passWordLoginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [mimaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-33);
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(0);
        make.height.mas_equalTo(43);
        make.width.mas_equalTo(58);
    }];
    
    SSH_YongHuTongYiXieYiView *agreeView = [[SSH_YongHuTongYiXieYiView alloc] init];
    [self.normalBackView addSubview:agreeView];
    [agreeView.selectButton addTarget:self action:@selector(selectAgreeProtocolOrNot:) forControlEvents:UIControlEventTouchUpInside];
    [agreeView.protocolButton addTarget:self action:@selector(pushToUserProtocolPage) forControlEvents:UIControlEventTouchUpInside];
    [agreeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-30);
        make.height.mas_equalTo(20);
    }];
    
    
    
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
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:[NSString stringWithFormat:@"%@",error]];
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

//跳过功能
- (void)tiaoGuoFunction{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.isDidDiss) {
            self.isDidDiss(YES);
        }
    }];
}

-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.isDidDiss) {
            self.isDidDiss(NO);
        }
    }];
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

//点击协议进入协议页面
- (void)pushToUserProtocolPage{
    //用户协议
    SSH_WangYeViewController *secondWebViewVC = [[SSH_WangYeViewController alloc] init];
    secondWebViewVC.webUrl = [NSString stringWithFormat:@"http://%@/useagreement.html",[DENGFANGSingletonTime shareInstance].lianJieArr[1]];
    secondWebViewVC.titleString = @"用户协议";
    [self.navigationController pushViewController:secondWebViewVC animated:YES];
}

//选择同意或不同意用户协议
- (void)selectAgreeProtocolOrNot:(UIButton *)sender{
    self.isAgreeProtocol = !self.isAgreeProtocol;
    if (self.isAgreeProtocol == 0) {
        [sender setImage:[UIImage imageNamed:@"weidianji"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"dianji"] forState:UIControlStateNormal];
    }
}

//密码登录按钮点击事件
- (void)passWordLoginButtonAction{
    
    SSH_MiMaDengLuController *passwordVC = [[SSH_MiMaDengLuController alloc] init];
    passwordVC.isShowTiaoGuo = self.isShowTiaoGuo;
    [self.navigationController pushViewController:passwordVC animated:YES];
}

//登录按钮点击事件
- (void)loginButtonAction{
    /*
     loginMethod
     登录方式  String  1：短信登录  2：密码登录
     */
    self.loginButton.userInteractionEnabled = NO;
    if (self.isAgreeProtocol == 0) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请同意用户服务协议"];
        return;
    }
    NSString *filterCity = [DENGFANGSingletonTime shareInstance].mapCity == nil?@"":[DENGFANGSingletonTime shareInstance].mapCity;;
    
    NSString *registrationID = [[NSUserDefaults standardUserDefaults] valueForKey:@"registrationID"]==nil?@"": [[NSUserDefaults standardUserDefaults] valueForKey:@"registrationID"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *appVersion = [userDefaults stringForKey:@"appVersion"];
    self.securityCode = self.dengluCell2.textField.text;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([DENGFANGSingletonTime shareInstance].dingWeiCity == nil || [[DENGFANGSingletonTime shareInstance].dingWeiCity isEqualToString:@""]) {
        
        dict[@"mobile"] = self.dengluCell1.textField.text;
        dict[@"loginMethod"] = @"1";
        dict[@"timestamp"] = [NSString yf_getNowTimestamp];
        dict[@"signs"] = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:self.dengluCell1.textField.text];
        dict[@"securityCode"] = self.securityCode;
        dict[@"password"] = @"";
        dict[@"terminalVersion"] = appVersion;
        dict[@"registrationId"] = registrationID;
        dict[@"filterCity"] = filterCity;
    }else{
        dict[@"mobile"] = self.dengluCell1.textField.text;
        dict[@"loginMethod"] = @"1";
        dict[@"timestamp"] = [NSString yf_getNowTimestamp];
        dict[@"signs"] = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:self.dengluCell1.textField.text];
        dict[@"securityCode"] = self.securityCode;
        dict[@"password"] = @"";
        dict[@"terminalVersion"] = appVersion;
        dict[@"registrationId"] = registrationID;
        dict[@"loginArea"] = [DENGFANGSingletonTime shareInstance].dingWeiCity==nil?@"":[DENGFANGSingletonTime shareInstance].dingWeiCity;
        dict[@"filterCity"] = filterCity;
        
    }
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGLoginURL parameters:dict success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        self.loginButton.userInteractionEnabled = YES;
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
            
            NSString *ispwdString = [NSString stringWithFormat:@"%@",diction[@"data"][@"isPwd"]];
            
            //设置别名
            [JPUSHService setAlias:self.dengluCell1.textField.text completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                self->_seq = seq;
            } seq:self->_seq];
            
            if ([ispwdString isEqualToString:@"0"]) {
                
                SSH_SheZhiMiMaController *setPWDVC = [[SSH_SheZhiMiMaController alloc] init];
                setPWDVC.securityCode = self.securityCode;
                setPWDVC.isDidDiss = ^(BOOL isYes) {
                    if (self.isDidDiss) {
                        self.isDidDiss(YES);
                    }
                };
                [self.navigationController pushViewController:setPWDVC animated:YES];
            }else{
              
                SSQ_HiddenNavigationViewController *nav = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:[SSH_FengXianBaKongViewController new]];
                UIViewController *vc2 = self.presentingViewController;
                
                [self dismissViewControllerAnimated:YES completion:^{
                    [vc2 presentViewController:nav animated:YES completion:nil];
                }];
            }
        }else if ([diction[@"code"] isEqualToString:@"11002"]) {
            //更换手机号后使用旧手机号登录给出提示
            [SSH_ZhangHaoDongJieView showInSuperView:diction[@"msg"]];
        }else if ([diction[@"code"] isEqualToString:@"10004"]) {
            
            [SSH_ZhangHaoDongJieView showInSuperView:diction[@"msg"]];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:diction[@"msg"]];
        }
        
    } fail:^(NSError *error) {

    }];
    /*
     {
     code = 200;
     data =     {
     bankCard = "<null>";
     businessCardUrl = "<null>";
     coinNum = 0;
     createTime = "<null>";
     enterpriseAddress = "<null>";
     enterpriseName = "<null>";
     idCard = "<null>";
     idCardBackUrl = "<null>";
     idCardFaceUrl = "<null>";
     idCardPhotoUrl = "<null>";
     isAuth = 0;
     isPush = 1;
     isPwd = 0;
     mobile = 15535907127;
     nickName = "<null>";
     photoUrl = "<null>";
     realName = "<null>";
     updateTime = "<null>";
     userId = 10004;
     userType = "<null>";
     workCardUrl = "<null>";
     };
     msg = "\U6210\U529f";
     token = 000166AEF789A63FE2F3D8B38162303F;
     }
     */
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
