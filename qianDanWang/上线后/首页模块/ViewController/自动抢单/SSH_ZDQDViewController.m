
//
//  SSH_ZDQDViewController.m
//  qianDanWang
//
//  Created by 畅轻 on 2019/9/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_ZDQDViewController.h"
#import "SSH_TJDZViewController.h"

@interface SSH_ZDQDViewController ()<UITextFieldDelegate>
{
    NSString *isAuto;
    NSDictionary *dataDic;
}
@property (strong, nonatomic) IBOutlet UIImageView *kaiGuanImg;
@property (strong, nonatomic) IBOutlet UILabel *dingDanNumber;
@property (strong, nonatomic) IBOutlet UITextField *jinBiNumber;
@property (strong, nonatomic) IBOutlet UIButton *kaiGuanBut;


//蒙版弹出式图
@property (nonatomic, strong)UIView *grayView;
@property (nonatomic, strong)UIView *whiteView;
@property (nonatomic, strong)UIImageView *adImgView;

@end

@implementation SSH_ZDQDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitleView];
    self.normalBackView.hidden = YES;
    self.jinBiNumber.delegate = self;
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getUserAutoGetTiaoJian];
    
}

- (void)getUserAutoGetTiaoJian {
//    vip/autoGrab/getAutoGrab
    NSString *timeString = [NSString yf_getNowTimestamp];
    [[DENGFANGRequest shareInstance] postWithUrlString:@"vip/autoGrab/getAutoGrab" parameters:@{@"userId":[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString],@"mobile":[DENGFANGSingletonTime shareInstance].mobileString,@"timestamp":timeString,@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d%@",[DENGFANGSingletonTime shareInstance].useridString,[DENGFANGSingletonTime shareInstance].mobileString]]} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            id data = diction[@"data"];
            if ([data isKindOfClass:[NSNull class]]) {
                //用户设置条件为空（或者第一次打开 之前没有进行设置）
                self.kaiGuanBut.selected = YES;
                self.kaiGuanImg.image = [UIImage imageNamed:@"关闭"];
                self->isAuto = @"1";
                self.dingDanNumber.text = @"1";
                self.jinBiNumber.placeholder = @"60";
            } else {
                //
                self->dataDic = (NSDictionary *)data;
                if (![self->dataDic[@"isAuto"] isEqualToString:@"0"]) {
                    self.kaiGuanBut.selected = YES;
                    self.kaiGuanImg.image = [UIImage imageNamed:@"关闭"];
                    self->isAuto = @"1";
                } else {
                    self.kaiGuanBut.selected = NO;
                    self.kaiGuanImg.image = [UIImage imageNamed:@"打开"];
                    self->isAuto = @"0";
                }
                self.dingDanNumber.text = [NSString stringWithFormat:@"%@",self->dataDic[@"grabNum"]];
                self.jinBiNumber.placeholder = [NSString stringWithFormat:@"%@",self->dataDic[@"orderAmxCoin"]];
            }
        } else {
            
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)setTitleView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-95)/2, 12+getStatusHeight, 95, 20)];
//    titleView.backgroundColor = UIColor.redColor;
    [self.navigationView addSubview:titleView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"抢单无忧";
    titleLab.font = UIFONTTOOL17;
    [titleView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleView.mas_left);
        make.top.bottom.mas_equalTo(0);
        make.centerY.mas_equalTo(titleView.mas_centerY);
    }];
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"温馨提示"];
    [titleView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLab.mas_right).offset(6);
        make.height.width.mas_equalTo(17);
        make.centerY.mas_equalTo(titleView.mas_centerY);
    }];
    UIButton *but = [[UIButton alloc] init];
    [but addTarget:self action:@selector(showShouMingView) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:but];
    [but mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = ColorBlack999;
    [self.navigationView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.navigationView.mas_bottom);
        make.height.mas_equalTo(0.5);
        make.left.right.mas_equalTo(0);
    }];
}

- (void)showShouMingView {
    [MobClick event:@"tips"];
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 285, 552.5)];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"微信提示弹窗"];
    [contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIButton *shutBut = [[UIButton alloc] init];
    [shutBut setImage:[UIImage imageNamed:@"知道了1"] forState:UIControlStateNormal];
    [shutBut addTarget:self action:@selector(shutShowView) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:shutBut];
    [shutBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(contentView.mas_bottom).offset(-25);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(215);
        make.centerX.mas_equalTo(contentView.mas_centerX);
    }];
    
    [self popAlertViewWithImageName:@"" contentView:contentView height:552.5];
}

- (void)shutShowView {
    [self.whiteView removeFromSuperview];
    [self.grayView removeFromSuperview];
}

- (void)popAlertViewWithImageName:(NSString *)name contentView:(UIView *)cView height:(CGFloat)height{
    self.grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //     [[UIApplication sharedApplication].keyWindow addSubview:self.grayView];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.grayView];
    //    [self.navigationController.view addSubview:self.grayView];
    self.grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    self.whiteView = [[UIView alloc] init];
    [self.grayView addSubview:self.whiteView];
    self.whiteView.layer.masksToBounds = YES;
    self.whiteView.layer.cornerRadius = 6;
    CGFloat wHeight = (SCREEN_WIDTH-102)*273./279.;
    if (height == 0) {
        self.whiteView.frame = CGRectMake(51, (ScreenHeight-wHeight)/2, ScreenWidth-102, wHeight);
    } else {
        self.whiteView.frame = CGRectMake(51, (ScreenHeight-wHeight)/2, ScreenWidth-102, height);
    }
    
    
    UIImageView *adImgView = [[UIImageView alloc] initWithFrame:self.whiteView.bounds];
    UIImage *image = [UIImage imageNamed:name];
    CGFloat top = image.size.height*0.3-1; // 顶端盖高度
    CGFloat bottom = top ; // 底端盖高度
    CGFloat left = image.size.width*0.25-1; // 左端盖宽度
    CGFloat right = left; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self.whiteView addSubview:adImgView];
    adImgView.image = image;
    self.adImgView = adImgView;
    
    cView.frame = self.whiteView.bounds;
    [self.whiteView addSubview:cView];
    self.whiteView.center = self.grayView.center;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [MobClick event:@"Orderpricecap"];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if ([text integerValue] > 100) {
        return NO;
    } else {
        return YES;
    }
}

/*
 减号方法
 **/
- (IBAction)jianButton:(UIButton *)sender {
    [MobClick event:@"Numberofsnatches"];
    if ([self.dingDanNumber.text integerValue] == 1) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%ld",[self.dingDanNumber.text integerValue]-1];
    self.dingDanNumber.text = str;
}
/*
 加号方法
 **/
- (IBAction)jiaButton:(UIButton *)sender {
    [MobClick event:@"Numberofsnatches"];
    if ([self.dingDanNumber.text integerValue] == 100) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%ld",[self.dingDanNumber.text integerValue]+1];
    self.dingDanNumber.text = str;
}
/*
 条件定制方法
 **/
- (IBAction)tiaoJianDingZhiButton:(UIButton *)sender {
    [MobClick event:@"setup"];
    SSH_TJDZViewController *tjdz = [[SSH_TJDZViewController alloc] init];
    tjdz.isAuto = isAuto;
    tjdz.grabNum = self.dingDanNumber.text;
    if (self.jinBiNumber.text.length == 0) {
        tjdz.maxCoin = self.jinBiNumber.placeholder;
    } else {
        tjdz.maxCoin = self.jinBiNumber.text;
    }
    tjdz.dataDic = dataDic;
    [self.navigationController pushViewController:tjdz animated:YES];
}
/*
 开关切换方法
 **/
- (IBAction)openOrEnd:(UIButton *)sender {
    if (sender.selected == NO) {
        self.kaiGuanImg.image = [UIImage imageNamed:@"关闭"];
        isAuto = @"1";
        NSDictionary *paramDic = @{
                                   @"isAuto":isAuto,
                                   @"grabNum":[NSString stringWithFormat:@"%@",dataDic[@"grabNum"]],
                                   @"orderAmxCoin":[NSString stringWithFormat:@"%@",dataDic[@"orderAmxCoin"]],
                                   @"city":[NSString stringWithFormat:@"%@",dataDic[@"city"]],
                                   @"identityType":[NSString stringWithFormat:@"%@",dataDic[@"identityType"]],
                                   @"isFund":[NSString stringWithFormat:@"%@",dataDic[@"isFund"]],
                                   @"carProduction":[NSString stringWithFormat:@"%@",dataDic[@"carProduction"]],
                                   @"isSecurity":[NSString stringWithFormat:@"%@",dataDic[@"isSecurity"]],
                                   @"property":[NSString stringWithFormat:@"%@",dataDic[@"property"]],
                                   @"isWeiliD":[NSString stringWithFormat:@"%@",dataDic[@"isWeiliD"]],
                                   @"satrtLoanAmount":[NSString stringWithFormat:@"%@",dataDic[@"satrtLoanAmount"]],
                                   @"endLoanAmount":[NSString stringWithFormat:@"%@",dataDic[@"endLoanAmount"]],
                                   @"userId":@([DENGFANGSingletonTime shareInstance].useridString),
                                   @"mobile":[DENGFANGSingletonTime shareInstance].mobileString,
                                   @"timestamp":[NSString yf_getNowTimestamp],
                                   @"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d%@",[DENGFANGSingletonTime shareInstance].useridString,[DENGFANGSingletonTime shareInstance].mobileString]]
                                   };
        
        [[DENGFANGRequest shareInstance] postWithUrlString:@"vip/autoGrab/saveAutoGrab" parameters:paramDic success:^(id responsObject) {
            NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
            if ([diction[@"code"] isEqualToString:@"200"]) {
                [MBProgressHUD showError:@"已为您关闭抢单无忧"];
            } else {
                
            }
        } fail:^(NSError *error) {
            [MBProgressHUD showError:@"保存失败,请重试"];
        }];
    } else {
        self.kaiGuanImg.image = [UIImage imageNamed:@"打开"];
        isAuto = @"0";
        [self presentViewToSelfWithMsg:@"您必须设置完整客户条件并保存，才可开启抢单无忧！"];
    }
    sender.selected = !sender.selected;
}

- (void)presentViewToSelfWithMsg:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:actionConfirm];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
