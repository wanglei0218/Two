//
//  USERCodeLoginViewController.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/18.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERCodeLoginViewController.h"
#import "USERTextLoginView.h"
#import "USERAgreementViewController.h"

@interface USERCodeLoginViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)USERTextLoginView *phoneText;
@property(nonatomic,strong)USERTextLoginView *codeText;

@property(strong,nonatomic)UIButton *btnGoRgs;

@property(strong,nonatomic)UILabel *labelRgsTipOne;
@property(strong,nonatomic)UIButton *btnRgsAgrment;


@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeTime;
@property (nonatomic, strong) UIView *windowView;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIImageView *codeImgView;
@property (nonatomic, strong) UITextField *codeTextField;

@end

@implementation USERCodeLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rootNaviBaseLine.hidden = NO;
    
    self.timeTime = 60;
    
    if (self.type == 1) {
        self.rootNaviBaseTitle.text = @"验证码登录";
    }else{
        self.rootNaviBaseTitle.text = @"安全中心";
    }
    
    [self setMyZhuCeLayout];
    
}

- (void)setMyZhuCeLayout{
    
    //手机号
    self.phoneText = [[USERTextLoginView alloc] init];
    [self.view addSubview:self.phoneText];
    self.phoneText.sd_layout.topSpaceToView(self.rootNaviBaseImg, 30).centerXEqualToView(self.view).heightIs(49).widthIs(ScreenWidth);
    [self changeTextFieldStyle:self.phoneText.inputContent placeHolder:@"请输入您的手机号"];
    self.phoneText.inputContent.keyboardType = UIKeyboardTypePhonePad;
    self.phoneText.iconImg.image = [UIImage imageNamed:@"手机"];
    
    //验证码
    self.codeText = [[USERTextLoginView alloc] init];
    [self.view addSubview:self.codeText];
    self.codeText.sd_layout.topSpaceToView(self.phoneText, 25).centerXEqualToView(self.view).heightIs(50).widthIs(ScreenWidth);
    [self changeTextFieldStyle:self.codeText.inputContent placeHolder:@"请输入验证码"];
    self.codeText.inputContent.keyboardType = UIKeyboardTypePhonePad;
    self.codeText.inputVeyCode.hidden = NO;
    [self.codeText.inputVeyCode addTarget:self action:@selector(inputVeyCodeClickAction) forControlEvents:UIControlEventTouchUpInside];
    self.codeText.iconImg.image = [UIImage imageNamed:@"验证码"];
    
    //
    self.btnGoRgs = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.btnGoRgs];
    self.btnGoRgs.sd_layout.topSpaceToView(self.codeText, 25).centerXEqualToView(self.view).heightIs(50).widthIs(ScreenWidth-60);
    
    if (self.type == 1) {
        [self.btnGoRgs setTitle:@"登录" forState:UIControlStateNormal];
    } else {
        [self.btnGoRgs setTitle:@"下一步" forState:UIControlStateNormal];
    }
    [self.btnGoRgs setBackgroundColor:TEXTMAINCOLOR];
    [self.btnGoRgs.titleLabel setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:18]];
    [self.btnGoRgs setTitleColor:[UIColor whiteColor] forState:0];
    [self.btnGoRgs setBackgroundImage:[UIImage imageNamed:@"矩形2"] forState:UIControlStateNormal];
    self.btnGoRgs.backgroundColor = TEXTFUCOLOR;
    self.btnGoRgs.layer.masksToBounds = YES;
    self.btnGoRgs.layer.cornerRadius = 8;
    [self.btnGoRgs addTarget:self action:@selector(btnGoRgsClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //只有注册时显示 协议
    if (self.type == 1) {
        //登录即表示同意《用户服务协议》 忘记密码？
        self.labelRgsTipOne = [[UILabel alloc] init];
        [self.view addSubview:self.labelRgsTipOne];
        self.labelRgsTipOne.sd_layout.leftSpaceToView(self.view, 120).topSpaceToView(self.btnGoRgs, 20).heightIs(20);
        [self.labelRgsTipOne setSingleLineAutoResizeWithMaxWidth:100];
        self.labelRgsTipOne.font = [UIFont systemFontOfSize:WidthScale(14)];
        self.labelRgsTipOne.textAlignment = NSTextAlignmentLeft;
        self.labelRgsTipOne.text = @"登录即同意";
        self.labelRgsTipOne.textColor = TEXTFUCOLOR;
        
        self.btnRgsAgrment = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:self.btnRgsAgrment];
        self.btnRgsAgrment.sd_layout.leftSpaceToView(self.labelRgsTipOne, 0).topEqualToView(self.labelRgsTipOne).heightIs(20).widthIs(135);
        self.btnRgsAgrment.titleLabel.font = [UIFont systemFontOfSize:WidthScale(14)];
        [self.btnRgsAgrment addTarget:self action:@selector(btnRgsAgrmentClickAction) forControlEvents:UIControlEventTouchUpInside];
        
        NSMutableAttributedString* tncString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"《隐私服务协议》"]];
        [tncString addAttribute:NSUnderlineStyleAttributeName
                          value:@(NSUnderlineStyleSingle)
                          range:(NSRange){0,[tncString length]}];
        //此时如果设置字体颜色要这样
        [tncString addAttribute:NSForegroundColorAttributeName value:TEXTREDCOLOR  range:NSMakeRange(0,[tncString length])];
        //设置下划线颜色...
        [tncString addAttribute:NSUnderlineColorAttributeName value:TEXTREDCOLOR range:(NSRange){0,[tncString length]}];
        [self.btnRgsAgrment setAttributedTitle:tncString forState:UIControlStateNormal];
    }
    
    
    UILabel *labelCopyRight = [[UILabel alloc] init];
    [self.view addSubview:labelCopyRight];
    labelCopyRight.sd_layout.centerXEqualToView(self.view).bottomSpaceToView(self.view, 20).heightIs(40).widthIs(ScreenWidth-20);
    labelCopyRight.font = [UIFont systemFontOfSize:14];
    labelCopyRight.textColor = TEXTSEN_Color;
    labelCopyRight.textAlignment = NSTextAlignmentCenter;
    labelCopyRight.text = COPYRIGHT;
    
}


-(void)changeTextFieldStyle:(UITextField *)textfield placeHolder:(NSString *)strholder
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:strholder attributes:@{NSForegroundColorAttributeName:TEXTSEN_Color,NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:style}];
    textfield.attributedPlaceholder = attri;
}

#pragma mark 点击注册
-(void)btnGoRgsClickAction
{
    if (self.type == 1) {
        NSLog(@"点击注册按钮");
        NSString *deviceID = [USERCheckClass UUID];
        NSString *phoneStr = self.phoneText.inputContent.text;
        NSString *vertifyStr = self.codeText.inputContent.text;
        if (![USERCheckClass checkTelNumber:phoneStr]) {
            [self.view showMBHudWithMessage:@"请输入正确的手机号" hide:1.5];
            return;
        }
        if (vertifyStr.length == 0) {
            [self.view showMBHudWithMessage:@"请输验证码" hide:1.5];
            return;
        }
        
        NSString *urlString = @"http://lt.gmogm.com:9056/individual/user/register";
        NSDictionary *dic = @{@"phone":phoneStr,@"securityCode":vertifyStr,@"password":@"",@"deviceId":deviceID};
        [USERNetWorkClass postWithUrlString:urlString parameters:dic success:^(NSDictionary *data) {
            if ([data[@"result"]  isEqualToString: @"100201"]) {
                [[NSUserDefaults standardUserDefaults] setValue:LoginValue forKey:LogStatus];
                [[NSUserDefaults standardUserDefaults] setValue:data[@"data"][@"token"] forKey:TOKEN];
                [[NSUserDefaults standardUserDefaults] setValue:data[@"data"][@"phone"] forKey:PHONE];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshorder" object:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else {
                [self.view showMBHudWithMessage:data[@"message"] hide:1.5];
            }
            
        } failure:^(NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
        }];
    } else {
        NSLog(@"点击重设密码");
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        NSString *deviceID = [USERCheckClass UUID];
        NSString *phoneStr = self.phoneText.inputContent.text;
        NSString *vertifyStr = self.codeText.inputContent.text;
        if (![USERCheckClass checkTelNumber:phoneStr]) {
            [self.view showMBHudWithMessage:@"请输入正确的手机号" hide:1.5];
            return;
        }
        if (vertifyStr.length == 0) {
            [self.view showMBHudWithMessage:@"请输验证码" hide:1.5];
            return;
        }
        
        NSString *urlString = @"http://lt.gmogm.com:9056/individual/user/forgetPwd";
        NSDictionary *dic = @{@"phone":phoneStr,@"securityCode":vertifyStr,@"password":@"",@"deviceId":deviceID};
        [USERNetWorkClass postWithUrlString:urlString parameters:dic success:^(NSDictionary *data) {
            if ([data[@"result"]  isEqualToString: @"200"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view showMBHudWithMessage:data[@"message"] hide:1.5];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
}


#pragma mark 点击获取验证码
-(void)inputVeyCodeClickAction
{
    NSLog(@"获取验证码");
    NSString *phoneStr = self.phoneText.inputContent.text;
    if (![USERCheckClass checkTelNumber:phoneStr]) {
        [self.view showMBHudWithMessage:@"请输入正确的手机号" hide:1.5];
        return;
    }
    NSDictionary *param = @{@"mobile":phoneStr,@"picCode":@"",@"ie":@"1"};
    NSString *urlString;
    urlString = @"http://lt.gmogm.com:9056/individual/user/sendSmsVerifyCode";
    
    [USERNetWorkClass postWithUrlString:urlString parameters:param success:^(NSDictionary *data) {
        NSLog(@"注册====%@",data);
        if ([data[@"result"] isEqualToString:@"200"]) {
            [self.codeText.inputVeyCode setTitle:@"59s" forState:(UIControlStateNormal)];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(danoJiShiTimer) userInfo:nil repeats:YES];
            
        }else if ([data[@"result"]  isEqual: @"10022"]){
            [self.phoneText.inputContent resignFirstResponder];
            [self ImgAlertViewTip];
        }else{
//            [self.view showMBHudWithMessage:[NSString stringWithFormat:@"%@",data[@"message"]] hide:1.5];
            [self.phoneText.inputContent resignFirstResponder];
            [self ImgAlertViewTip];
        }
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络连接错误"];
        
        NSLog(@"失败了");
        
    }];
}

- (void)danoJiShiTimer{
    _timeTime--;
    NSString *str = [NSString stringWithFormat:@"%lds",(long)_timeTime];
    
    self.codeText.inputVeyCode.userInteractionEnabled = NO;
    [self.codeText.inputVeyCode setTitle:str forState:(UIControlStateNormal)];
    if (_timeTime == 0) {
        [self.timer invalidate];
        [self.codeText.inputVeyCode setTitle:@"重试" forState:(UIControlStateNormal)];
        self.codeText.inputVeyCode.userInteractionEnabled = YES;
        _timeTime = 60;
    }
}


- (void)ImgAlertViewTip{
    
    [self huoQuImgCode];
    
    self.windowView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.windowView.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.6];
    [self.navigationController.view addSubview:self.windowView];
    
    self.whiteView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-250)/2, 195, 250, 174)];
    [self.windowView addSubview:self.whiteView];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    self.whiteView.layer.masksToBounds = YES;
    self.whiteView.layer.cornerRadius = 5;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.windowView addSubview:closeButton];
    [closeButton setImage:[UIImage imageNamed:@"XX"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(advertisementDismiss) forControlEvents:UIControlEventTouchUpInside];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.whiteView.mas_right).offset(-14.5);
        make.width.height.mas_equalTo(29);
        make.bottom.mas_equalTo(self.whiteView.mas_top).offset(14.5);
    }];
    
    UILabel *codeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.5, 15, 250-25, 12.5)];
    [self.whiteView addSubview:codeTitleLabel];
    codeTitleLabel.text = @"请填写验证码";
    codeTitleLabel.font = [UIFont systemFontOfSize:12.5];
    codeTitleLabel.textColor = RGB(45, 45, 45);
    
    self.codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.5, 35.5, 250-25, 30)];
    [self.whiteView addSubview:self.codeTextField];
    self.codeTextField.backgroundColor = RGB(246, 246, 246);
    self.codeTextField.layer.borderColor = RGB(4, 79, 148).CGColor;
    self.codeTextField.layer.borderWidth = 0.5;
    self.codeTextField.font = [UIFont systemFontOfSize:17.5];
    self.codeTextField.textColor = RGB(45, 45, 45);
    
    self.codeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 77.5, 110, 38)];
    [self.whiteView addSubview:self.codeImgView];
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.whiteView addSubview:changeButton];
    changeButton.titleLabel.font = [UIFont systemFontOfSize:12.5];
    [changeButton setTitle:@"点击换一换" forState:UIControlStateNormal];
    [changeButton setTitleColor:RGB(4, 79, 148) forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(huoQuImgCode) forControlEvents:UIControlEventTouchUpInside];
    [changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.codeImgView.mas_right).offset(15);
        make.bottom.mas_equalTo(self.codeImgView.mas_bottom);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(70);
    }];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    [self.whiteView addSubview:lineLabel];
    lineLabel.backgroundColor = RGB(234, 234, 234);
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(changeButton.mas_bottom).offset(20);
    }];
    
    UIButton *tijiaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.whiteView addSubview:tijiaoButton];
    tijiaoButton.backgroundColor = MAINCOLOR1;
    [tijiaoButton setTitle:@"提交" forState:UIControlStateNormal];
    [tijiaoButton addTarget:self action:@selector(tijiaoImgVertiCode) forControlEvents:UIControlEventTouchUpInside];
    [tijiaoButton setTitleColor:RGB(30, 30, 30) forState:UIControlStateNormal];
    [tijiaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(lineLabel.mas_bottom);
        make.bottom.mas_equalTo(self.whiteView.mas_bottom);
    }];
    
    
}
- (void)huoQuImgCode{
    NSString *timeString = [self getNowTimeTimestamp];
    [USERNetWorkClass ImageUrlString:@"http://lt.gmogm.com:9056/individual/user/authCode" parameters:@{@"mobile":self.phoneText.inputContent.text,@"t":timeString} success:^(NSData *data) {
        self.codeImgView.image = [UIImage imageWithData:data];
        
    } failure:^(NSError *error) {
    }];
    
}

- (void)advertisementDismiss{
    self.windowView.alpha = 0;
    [self.whiteView removeFromSuperview];
    [self.windowView removeFromSuperview];
    
}
- (NSString *)getNowTimeTimestamp{
    
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self advertisementDismiss];
}

#pragma mark 用户协议
-(void)btnRgsAgrmentClickAction
{
    NSLog(@"点击协议");
    USERAgreementViewController *agreementVC = [[USERAgreementViewController alloc] init];
    [self.navigationController pushViewController:agreementVC animated:YES];
}

/**
 图形验证码
 */
- (void)tijiaoImgVertiCode{
    
    if (self.codeTextField.text == nil || [self.codeTextField.text isEqualToString:@""]) {
        [USERCheckClass showInView:self.view wydkTile:@"请输入验证码"];
        return;
    }
    [self QianZhanDaigetVertifyAction:self.codeTextField.text];
}

//获取验证码
- (void)QianZhanDaigetVertifyAction:(NSString *)picCode{
    NSString *phoneStr = self.phoneText.inputContent.text;
    if (![USERCheckClass checkTelNumber:phoneStr]) {
        [USERCheckClass showInView:self.view wydkTile:@"请输入正确的手机号"];
        return;
    }
    NSString *urlString = @"http://lt.gmogm.com:9056/individual/user/sendSmsVerifyCode";
    NSDictionary *dic = @{@"mobile":phoneStr,@"picCode":picCode};
    [USERNetWorkClass postWithUrlString:urlString parameters:dic success:^(NSDictionary *data) {
        if ([data[@"result"]  isEqualToString: @"200"]) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(danoJiShiTimer) userInfo:nil repeats:YES];
            if (![picCode isEqualToString:@""]) {
                [self advertisementDismiss];
            }
        }else if ([data[@"result"]  isEqual: @"10022"]){
            [self.phoneText.inputContent resignFirstResponder];
            [self ImgAlertViewTip];
        }else{
            [USERCheckClass showInView:self.view wydkTile:data[@"message"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"失败");
        [USERCheckClass showInView:self.view wydkTile:[NSString stringWithFormat:@"%@", error]];
    }];
    
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
