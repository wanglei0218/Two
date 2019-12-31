//
//  SSH_XGSJH_ViewController.m
//  qianDanWang
//
//  Created by 畅轻 on 2019/11/26.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_XGSJH_ViewController.h"

@interface SSH_XGSJH_ViewController ()

@property (strong, nonatomic) IBOutlet UITextField *phoneTf;
@property (strong, nonatomic) IBOutlet UITextField *codeTf;
@property (strong, nonatomic) IBOutlet UIButton *getCodeBut;
@property (strong, nonatomic) IBOutlet UIButton *nextBut;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timeTime;

@end

@implementation SSH_XGSJH_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _timeTime = 59;
    self.titleLabelNavi.text = @"修改手机号";
    self.normalBackView.hidden = YES;
    self.view.backgroundColor = COLOR_WITH_HEX(0xf3f3f3);
    
}

- (IBAction)getMessageCodeButton:(UIButton *)sender {
    NSString *phoneString = self.phoneTf.text;
    if (![SSH_TOOL_GongJuLei checkTelNumber:phoneString]) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请输入正确的手机号"];
        return;
    }
    
    [[DENGFANGRequest shareInstance] postWithUrlString:@"user/sendSmsVerifyCode" parameters:@{@"mobile":self.phoneTf.text} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"getVertifyCodeActionWithPicCode---%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [self.getCodeBut setTitle:@"59s" forState:UIControlStateNormal];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer11) userInfo:nil repeats:YES];
            
        }else if ([diction[@"code"] isEqual:@"10022"]){
            [SSH_TOOL_GongJuLei showAlter:[UIApplication sharedApplication].keyWindow WithMessage:diction[@"msg"]];
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
    
    self.getCodeBut.userInteractionEnabled = NO;
    [self.getCodeBut setTitle:str forState:(UIControlStateNormal)];
    if (_timeTime == 0) {
        [self.timer invalidate];
        [self.getCodeBut setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        self.getCodeBut.userInteractionEnabled = YES;
        _timeTime = 59;
    }
}


- (IBAction)didSeletcedButton:(UIButton *)sender {
    NSString *signStr = [NSString stringWithFormat:@"%d%@%@",[DENGFANGSingletonTime shareInstance].useridString,[DENGFANGSingletonTime shareInstance].mobileString,self.phoneTf.text];
    [[DENGFANGRequest shareInstance] postWithUrlString:@"user/updateMobile" parameters:@{@"userId":@([DENGFANGSingletonTime shareInstance].useridString),@"mobile":[DENGFANGSingletonTime shareInstance].mobileString,@"newMobile":self.phoneTf.text,@"code":self.codeTf.text,@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:signStr]} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneTf.text forKey:DENGFANGShowPhoneKey];
            [self endLoginAndLogin];
        }else{
            [SSH_TOOL_GongJuLei showAlter:[UIApplication sharedApplication].keyWindow WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)endLoginAndLogin {
    [MobClick event:@"my-set-logoff"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"card_name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"card_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"faceId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"upMap"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com_name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com_diqu"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com_jiedao"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mingpian"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gongpai"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hetong"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logoqian"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"yingyezhizhao"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bdOne"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bdTwo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bdThree"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bdFour"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"wancheng"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fx"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changePhoneNumber" object:nil];
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
