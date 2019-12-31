//
//  SSH_TiXianViewController.m
//  DENGFANGSC
//
//  Created by LY on 2019/1/22.
//  Copyright © 2019年 DENGFANG. All rights reserved.
//

#import "SSH_TiXianViewController.h"
#import "SSH_TiXianTableViewCell.h"
#import "SSH_TixianStatusViewController.h"

@interface SSH_TiXianViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSArray *placeholderArray;
@property (nonatomic, strong) NSArray *shuruArray;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *lijiTixianButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timeTime;
@property (nonatomic, strong) UIButton *yanzhengma_button;
@property (nonatomic, strong) UITextField *ketixian_jine_textField;
@property (nonatomic, strong) UILabel *tixian_guize_label;
@property (nonatomic, strong) NSMutableArray<UITextField*> *rightTextFieldArray;

@end

@implementation SSH_TiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeTime = 59;
    
    [self setupView];
    [self load_dangqianJine_tixianguize_Data];
}

#pragma mark view布局
- (void)setupView{
    
    self.titleLabelNavi.text = @"提现";
    self.normalBackView.backgroundColor = ColorBackground_Line;
    self.nameArray = @[@"当前可提现金额",@"当前登录手机号",@"短信验证码:",@"姓名:",@"身份证号:",@"提现金额:",@"开户银行名称:",@"银行卡号:"];
    self.placeholderArray = @[@"请输入短信验证码",@"请输入本人姓名",@"请输入本人身份证号",@"请输入提现金额",@"请输入开户银行名称",@"请输入银行卡号",@""];
    self.shuruArray = @[@"",@"",@"",@"",@"",@""];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.normalBackView addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    self.tableView.backgroundColor = ColorBackground_Line;
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 121+14+50)];
    self.tableView.tableFooterView = self.footerView;
    self.footerView.backgroundColor = ColorBackground_Line;
    
    self.lijiTixianButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.footerView addSubview:self.lijiTixianButton];
    self.lijiTixianButton.backgroundColor = COLOR_With_Hex(0xfda7a8);
    [self.lijiTixianButton setTitle:@"立即提现" forState:UIControlStateNormal];
    self.lijiTixianButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.lijiTixianButton.layer.masksToBounds = YES;
    self.lijiTixianButton.layer.cornerRadius = 17.5;
    [self.lijiTixianButton addTarget:self action:@selector(lijiTixianButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.lijiTixianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(175);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(32);
        make.centerX.mas_equalTo(self.footerView);
    }];
    
    UILabel *guize_name_label = [[UILabel alloc] init];
    guize_name_label.font = [UIFont systemFontOfSize:13];
    guize_name_label.textColor = GrayColor666;
    guize_name_label.text = @"提现规则：";
    [self.footerView addSubview:guize_name_label];
    [guize_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.lijiTixianButton.mas_bottom).offset(41);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(13);
    }];
    
    self.tixian_guize_label = [[UILabel alloc] initWithFrame:CGRectMake(22, 121+14, ScreenWidth-44, 50)];
    self.tixian_guize_label.numberOfLines = 0;
    [self.footerView addSubview:self.tixian_guize_label];
    self.tixian_guize_label.textColor = ColorBlack999;
    self.tixian_guize_label.font = [UIFont systemFontOfSize:12];
    
}

#pragma mark 当前可提现金额与提现规则的获取
- (void)load_dangqianJine_tixianguize_Data{
    
    [[DENGFANGRequest shareInstance] postWithUrlString:@"user/getGiftCoinInfo" parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]]} success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            self.ketixian_jine_textField.text = [NSString stringWithFormat:@"¥%@",diction[@"data"][@"uCoinNum"]];
            
            CGFloat guizeHeight = [SSH_TOOL_GongJuLei labelHeightLabelWithWidth:ScreenWidth-44 text:[NSString stringWithFormat:@"%@",diction[@"data"][@"giftRule"]] font:12];
            self.footerView.frame = CGRectMake(0, 0, ScreenWidth, 121+14+guizeHeight+5+80);
            self.tixian_guize_label.text = [NSString stringWithFormat:@"%@",diction[@"data"][@"giftRule"]];
            self.tixian_guize_label.frame = CGRectMake(22, 121+14, ScreenWidth-44, guizeHeight+5);
            self.tableView.tableFooterView = self.footerView;
        }
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark 提现验证码按钮
- (void)tixian_yanzhengma_buttonAction{
    
    [[DENGFANGRequest shareInstance] postWithUrlString:@"user/sendVerifyCodeuCoin" parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[DENGFANGSingletonTime shareInstance].mobileString],@"mobile":[DENGFANGSingletonTime shareInstance].mobileString} success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            //成功
            
            [self.yanzhengma_button setTitle:@"59s" forState:(UIControlStateNormal)];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer11) userInfo:nil repeats:YES];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.normalBackView WithMessage:diction[@"msg"]];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)timer11{
    _timeTime--;
    NSString *str = [NSString stringWithFormat:@"%lds",(long)_timeTime];
    
    self.yanzhengma_button.userInteractionEnabled = NO;
    [self.yanzhengma_button setTitle:str forState:(UIControlStateNormal)];
    if (_timeTime == 0) {
        [self.timer invalidate];
        [self.yanzhengma_button setTitle:@"获取验证码" forState:(UIControlStateNormal)];
        self.yanzhengma_button.userInteractionEnabled = YES;
        _timeTime = 59;
    }
}



#pragma mark 立即提现按钮
- (void)lijiTixianButtonAction{
    
    if ([self.rightTextFieldArray[0].text isEqualToString:@""] || self.rightTextFieldArray[0].text == nil) {
        [SSH_TOOL_GongJuLei showAlter:self.normalBackView WithMessage:@"请输入短信验证码"];
        return;
    }
    if ([self.rightTextFieldArray[1].text isEqualToString:@""] || self.rightTextFieldArray[1].text == nil) {
        [SSH_TOOL_GongJuLei showAlter:self.normalBackView WithMessage:@"请输入本人姓名"];
        return;
    }
    if ([self.rightTextFieldArray[2].text isEqualToString:@""] || self.rightTextFieldArray[2].text == nil) {
        [SSH_TOOL_GongJuLei showAlter:self.normalBackView WithMessage:@"请输入本人身份证号"];
        return;
    }
    if (![SSH_TOOL_GongJuLei checkUserIdCard:self.rightTextFieldArray[2].text]) {
        [SSH_TOOL_GongJuLei showAlter:self.normalBackView WithMessage:@"请输入正确的身份证号"];
        return;
    }
    if ([self.rightTextFieldArray[3].text isEqualToString:@""] || self.rightTextFieldArray[3].text == nil) {
        [SSH_TOOL_GongJuLei showAlter:self.normalBackView WithMessage:@"请输入提现金额"];
        return;
    }
    if ([self.rightTextFieldArray[4].text isEqualToString:@""] || self.rightTextFieldArray[4].text == nil) {
        [SSH_TOOL_GongJuLei showAlter:self.normalBackView WithMessage:@"请输入开户银行名称"];
        return;
    }
    
    if ([self.rightTextFieldArray[5].text isEqualToString:@""] || self.rightTextFieldArray[5].text == nil) {
        [SSH_TOOL_GongJuLei showAlter:self.normalBackView WithMessage:@"请输入银行卡号"];
        return;
    }
    
    if (self.rightTextFieldArray[5].text.length > 19) {
        [SSH_TOOL_GongJuLei showAlter:self.normalBackView WithMessage:@"请输入正确的银行卡号"];
        return;
    }

    
    NSString *signString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",[DENGFANGSingletonTime shareInstance].mobileString,self.rightTextFieldArray[0].text,self.rightTextFieldArray[1].text,self.rightTextFieldArray[2].text,self.rightTextFieldArray[4].text,self.rightTextFieldArray[5].text,self.rightTextFieldArray[3].text];
    [[DENGFANGRequest shareInstance] postWithUrlString:@"user/applyWithdrawCash" parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:signString],@"mobile":[DENGFANGSingletonTime shareInstance].mobileString,@"authCode":self.rightTextFieldArray[0].text,@"name":self.rightTextFieldArray[1].text,@"idcard":self.rightTextFieldArray[2].text,@"withdrawCash":self.rightTextFieldArray[3].text,@"openingBankAddress":self.rightTextFieldArray[4].text,@"bankNumber":self.rightTextFieldArray[5].text} success:^(id responsObject) {

        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            SSH_TixianStatusViewController *tixianChenggongVC = [[SSH_TixianStatusViewController alloc] init];
            tixianChenggongVC.fromWhere = @"1";
            [self.navigationController pushViewController:tixianChenggongVC animated:YES];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.normalBackView WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {

    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = @"SSH_TiXianTableViewCell";
    SSH_TiXianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[SSH_TiXianTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.shuruTextField.delegate = self;
    cell.nameLabel.text = self.nameArray[indexPath.row];
    if (indexPath.row == 0) {
        
        cell.shuruTextField.textColor = ColorZhuTiHongSe;
        cell.shuruTextField.userInteractionEnabled =NO;
        self.ketixian_jine_textField = cell.shuruTextField;
    }else if (indexPath.row == 1){
        NSString *telStr = [[DENGFANGSingletonTime shareInstance].mobileString stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
        cell.shuruTextField.text = telStr;
        cell.shuruTextField.userInteractionEnabled =NO;
        cell.yanzhengmaButton.hidden = NO;
        self.yanzhengma_button = cell.yanzhengmaButton;
        [cell.yanzhengmaButton addTarget:self action:@selector(tixian_yanzhengma_buttonAction) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.shuruTextField.placeholder = self.placeholderArray[indexPath.row-2];
        self.rightTextFieldArray[indexPath.row-2] = cell.shuruTextField;
    }
    cell.shuruTextField.delegate = self;
    cell.selectionStyle = 0;
    return cell;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    int textCount = 0;
    for (int i =0 ; i < 6; i++) {
        if (![self.rightTextFieldArray[i].text isEqualToString:@""]) {
            textCount++;
        }
    }
    if (textCount == 6) {
        self.lijiTixianButton.backgroundColor = ColorZhuTiHongSe;
        self.lijiTixianButton.userInteractionEnabled = YES;
    }else{
        self.lijiTixianButton.backgroundColor = COLOR_With_Hex(0xfda7a8);
        self.lijiTixianButton.userInteractionEnabled = NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    int textCount = 0;
    for (int i =0 ; i < 6; i++) {
        if (![self.rightTextFieldArray[i].text isEqualToString:@""]) {
            textCount++;
        }
    }
    if (textCount == 6) {
        self.lijiTixianButton.backgroundColor = ColorZhuTiHongSe;
        self.lijiTixianButton.userInteractionEnabled = YES;
    }else{
        self.lijiTixianButton.backgroundColor = COLOR_With_Hex(0xfda7a8);
        self.lijiTixianButton.userInteractionEnabled = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (NSMutableArray<UITextField*> *)rightTextFieldArray{
    if (!_rightTextFieldArray) {
        _rightTextFieldArray = [NSMutableArray array];
    }
    return _rightTextFieldArray;
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
