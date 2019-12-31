//
//  USERLoginViewController.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/18.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERLoginViewController.h"
#import "USERTextLoginView.h"
#import "USERCodeLoginViewController.h"

@interface USERLoginViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *headView;

@property(nonatomic,strong)USERTextLoginView *phoneText;
@property(nonatomic,strong)USERTextLoginView *passwordText;

@property(strong,nonatomic)UIButton *btnGoLgn;
@property(strong,nonatomic)UIButton *btnGoCod;


@end

@implementation USERLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rootNaviBaseLine.hidden = YES;
    [self.rootGoBackBtn setImage:[UIImage imageNamed:@"guanbi1"] forState:UIControlStateNormal];
    self.rootNaviBaseImg.image = [UIImage imageNamed:@""];
    [self.rootNaviBaseImg removeFromSuperview];
    
    [self.view addSubview:self.scrollView];
    [self creatHeadView];
    [self creatLoginView];
    [self.view addSubview:self.rootNaviBaseImg];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -getStatusHeight, ScreenWidth, ScreenHeight+getStatusHeight)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        
    }
    return _scrollView;
}

- (void)creatHeadView{
    self.headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, WidthScale(255))];
    self.headView.image = [UIImage imageNamed:@"登录背景"];
    [self.scrollView addSubview:self.headView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headView.height-WidthScale(8), ScreenWidth, WidthScale(16))];
    lineView.backgroundColor = [UIColor whiteColor];
    lineView.layer.cornerRadius = lineView.height/2;
    lineView.layer.masksToBounds = YES;
    [self.headView addSubview:lineView];
}

- (void)creatLoginView{
    
    self.phoneText = [[USERTextLoginView alloc] init];
    [self.scrollView addSubview:self.phoneText];
    self.phoneText.sd_layout.topSpaceToView(self.headView, 25).centerXEqualToView(self.scrollView).heightIs(49).widthIs(ScreenWidth);
    [self changeTextFieldStyle:self.phoneText.inputContent placeHolder:@"请输入您的手机号"];
    self.phoneText.inputContent.keyboardType = UIKeyboardTypePhonePad;
    self.phoneText.iconImg.image = [UIImage imageNamed:@"手机"];
    
    
    self.passwordText = [[USERTextLoginView alloc] init];
    [self.scrollView addSubview:self.passwordText];
    self.passwordText.sd_layout.topSpaceToView(self.phoneText, 15).widthIs(ScreenWidth).heightIs(49);
    [self changeTextFieldStyle:self.passwordText.inputContent placeHolder:@"请输入登录密码"];
    self.passwordText.eyeBtn.hidden = NO;
    self.passwordText.inputContent.secureTextEntry = YES;
    self.passwordText.inputContent.keyboardType = UIKeyboardTypeASCIICapable;
    [self.passwordText.eyeBtn addTarget:self action:@selector(eyeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    self.passwordText.iconImg.image = [UIImage imageNamed:@"密码"];
    
    self.btnGoLgn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollView addSubview:self.btnGoLgn];
    self.btnGoLgn.sd_layout.topSpaceToView(self.passwordText, 25).centerXEqualToView(self.scrollView).heightIs(44).widthIs(ScreenWidth-60);
    [self.btnGoLgn setTitle:@"登录" forState:UIControlStateNormal];
    [self.btnGoLgn setBackgroundImage:[UIImage imageNamed:@"矩形2"] forState:UIControlStateNormal];
    self.btnGoLgn.backgroundColor = TEXTFUCOLOR;
    [self.btnGoLgn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:18]];
    [self.btnGoLgn setTitleColor:[UIColor whiteColor] forState:0];
    self.btnGoLgn.layer.masksToBounds = YES;
    self.btnGoLgn.layer.cornerRadius = 8;
    [self.btnGoLgn addTarget:self action:@selector(btnGoLgnClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.btnGoCod = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollView addSubview:self.btnGoCod];
    self.btnGoCod.sd_layout.topSpaceToView(self.btnGoLgn, 25).centerXEqualToView(self.scrollView).heightIs(30).widthIs(180);
    NSMutableAttributedString* yzmString = [[NSMutableAttributedString alloc] initWithString:@"切换登录方式"];
    //此时如果设置字体颜色要这样
    [yzmString addAttribute:NSForegroundColorAttributeName value:MAINCOLOR1  range:NSMakeRange(0,[yzmString length])];
    [self.btnGoCod.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:WidthScale(15)]];
    [self.btnGoCod setAttributedTitle:yzmString forState:UIControlStateNormal];
    [self.btnGoCod addTarget:self action:@selector(btnGoCodClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *labelCopyRight = [[UILabel alloc] init];
    [self.scrollView addSubview:labelCopyRight];
    labelCopyRight.sd_layout.centerXEqualToView(self.scrollView).bottomSpaceToView(self.scrollView, 30+SafeAreaBottomHEIGHT).heightIs(40).widthIs(ScreenWidth-20);
    labelCopyRight.font = [UIFont systemFontOfSize:13];
    labelCopyRight.textColor = TEXTSEN_Color;
    labelCopyRight.textAlignment = NSTextAlignmentCenter;
    labelCopyRight.text = COPYRIGHT;
}

-(void)changeTextFieldStyle:(UITextField *)textfield placeHolder:(NSString *)strholder{
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:strholder attributes:@{NSForegroundColorAttributeName:TEXTSEN_Color,NSFontAttributeName:[UIFont systemFontOfSize:WidthScale(16)], NSParagraphStyleAttributeName:style}];
    textfield.attributedPlaceholder = attri;
}

#pragma mark 点击登录
-(void)btnGoLgnClickAction{
    
    NSLog(@"点击登录");
    NSString *phoneStr = self.phoneText.inputContent.text;
    NSString *passWordStr = self.passwordText.inputContent.text;
    if (![USERCheckClass checkTelNumber:phoneStr]) {
        [self.view showMBHudWithMessage:@"请输入正确的手机号码" hide:1.5];
        return;
    }else if (passWordStr.length < 6 || passWordStr.length > 16){
        [self.view showMBHudWithMessage:@"请输入6～16位密码" hide:1.5];
        return;
    }
    
    NSString *urlString = @"http://lt.gmogm.com:9056/individual/user/login";
    NSDictionary *dic = @{@"phone":phoneStr,@"password":passWordStr};
    [USERNetWorkClass postWithUrlString:urlString parameters:dic success:^(NSDictionary *data) {
        if ([data[@"result"]  isEqualToString: @"200"]) {
            [[NSUserDefaults standardUserDefaults] setValue:LoginValue forKey:LogStatus];
            [[NSUserDefaults standardUserDefaults] setValue:data[@"data"][@"token"] forKey:TOKEN];
            [[NSUserDefaults standardUserDefaults] setValue:data[@"data"][@"phone"] forKey:PHONE];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Login" object:nil];
            
            [self.view showMBHudWithMessage:@"登录成功" hide:1.0];
            [self performSelector:@selector(back:) withObject:nil afterDelay:1.0];
            
        }else{
            [self.view showMBHudWithMessage:data[@"message"] hide:1.0];
        }
        
    } failure:^(NSError *error) {
        [self.view showMBHudWithMessage:[NSString stringWithFormat:@"%@",error] hide:1.5];
    }];
}

#pragma mark 点击注册
-(void)btnGoCodClickAction{
    
    NSLog(@"点击验证码登录");
    USERCodeLoginViewController *registerVC = [[USERCodeLoginViewController alloc] init];
    registerVC.type = 1;
    [self.navigationController pushViewController:registerVC animated:YES];
}

-(void)eyeBtnClickAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"eyetwo"] forState:UIControlStateNormal];
        self.passwordText.inputContent.secureTextEntry = NO;
    } else {
        self.passwordText.inputContent.secureTextEntry = YES;
        [sender setImage:[UIImage imageNamed:@"eyeone"] forState:UIControlStateNormal];
    }
}



- (void)back:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
