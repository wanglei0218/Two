//
//  SSH_LiuYanController.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_LiuYanController.h"
#import "SSH_LiuYanZhanWeiFuTextView.h"

@interface SSH_LiuYanController ()

@property(strong,nonatomic)SSH_LiuYanZhanWeiFuTextView *mkTextView;

@end

@implementation SSH_LiuYanController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text = @"意见反馈";
    self.normalBackView.backgroundColor = ColorBackground_Line;
    
    [self LYConfigView];
}

- (void)LYConfigView{
    
    self.mkTextView = [[SSH_LiuYanZhanWeiFuTextView alloc] init];
    [self.normalBackView addSubview:self.mkTextView];
    self.mkTextView.backgroundColor = COLORWHITE;
    self.mkTextView.layer.masksToBounds = YES;
    self.mkTextView.layer.cornerRadius = 7.5;
    self.mkTextView.placeholderColor = ColorBlack222;
    //self.mkTextView.returnKeyType = UIReturnKeyDone;
    
    [self.mkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(155);
    }];
    self.mkTextView.placeholder = @"嗨！在这里可以输入您的意见和想法！";
    
    UIButton *tijiaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.normalBackView addSubview:tijiaoButton];
    tijiaoButton.backgroundColor = ColorZhuTiHongSe;
    tijiaoButton.layer.masksToBounds = YES;
    tijiaoButton.layer.cornerRadius = 20;
    [tijiaoButton setTitle:@"提交反馈" forState:UIControlStateNormal];
    tijiaoButton.titleLabel.font = UIFONTTOOL15;
    [tijiaoButton setTitleColor:COLOR_With_Hex(0xfefefe) forState:UIControlStateNormal];
    [tijiaoButton addTarget:self action:@selector(submitFeedBackAction) forControlEvents:UIControlEventTouchUpInside];
    [tijiaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(self.mkTextView.mas_bottom).offset(55);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - 提交反馈
- (void)submitFeedBackAction{
    if (self.mkTextView.text == nil || [self.mkTextView.text isEqualToString:@""]) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请输入您的意见和想法"];
        return;
    }
    
    if ([SSH_TOOL_GongJuLei isContainsEmoji:self.mkTextView.text]) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"不能输入表情符号"];
        return;
    }
    
    NSString *useridString = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGFeedbackURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:useridString],@"mobile":[DENGFANGSingletonTime shareInstance].mobileString,@"messages":self.mkTextView.text} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
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
