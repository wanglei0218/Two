//
//  SSH_WoDeZhangHuController.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_WoDeZhangHuController.h"
#import "SSH_WoDeZhangHuViewCell.h"//账户信息cell
#import "SSH_ZhiFujiluController.h"//支付记录-充值记录-控制器
#import "SSH_ChargeActionViewController.h"//充值页面-控制器
#import "SSH_GeRenXinXiModel.h"
#import "SSH_YaoQingYouLiViewController.h"

@interface SSH_WoDeZhangHuController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *accountTableView;
@property (nonatomic, strong) UILabel *jinbiNumberLabel;//当前金币数
@property (nonatomic,strong) SSH_GeRenXinXiModel *infoModel;
//@property (nonatomic, strong) UILabel *youbiNumberLabel;//当前优币数

@end

@implementation SSH_WoDeZhangHuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.goBackButton.hidden = YES;
    
    //导航栏返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"jiantou_zuo_heise"] forState:UIControlStateNormal];
    [self.navigationView addSubview:backButton];
    [backButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(40.5);
        make.height.mas_equalTo(44);
    }];
    
    self.navigationView.backgroundColor = ColorZhuTiHongSe;
    [self.goBackButton setImage:[UIImage imageNamed:@"jiantou_zuo_baise"] forState:UIControlStateNormal];
    self.titleLabelNavi.text = @"我的账户";
    self.titleLabelNavi.textColor = COLORWHITE;
    
    
    self.accountTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.accountTableView.scrollEnabled = NO;
    [self.normalBackView addSubview:self.accountTableView];
    self.accountTableView.delegate = self;
    self.accountTableView.dataSource = self;
    self.accountTableView.separatorStyle = 0;
    self.accountTableView.backgroundColor = ColorBackground_Line;
    [self.accountTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 157)];
    self.accountTableView.tableHeaderView = tableHeadView;
    tableHeadView.backgroundColor = ColorZhuTiHongSe;
    
    UILabel *accountNumTitleLabel = [[UILabel alloc] init];
    [tableHeadView addSubview:accountNumTitleLabel];
    accountNumTitleLabel.text = @"金币";
    accountNumTitleLabel.textColor = COLORWHITE;
    accountNumTitleLabel.textAlignment = 1;
    accountNumTitleLabel.font = UIFONTTOOL13;
    [accountNumTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(35);
        make.height.mas_equalTo(13);
    }];

    self.jinbiNumberLabel = [[UILabel alloc] init];
    [tableHeadView addSubview:self.jinbiNumberLabel];
    self.jinbiNumberLabel.font = UIFONTTOOL(46);
    self.jinbiNumberLabel.textColor = COLORWHITE;
    self.jinbiNumberLabel.textAlignment = 1;
    self.jinbiNumberLabel.text = [NSString stringWithFormat:@"%@",self.coinNum];
    [self.jinbiNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(accountNumTitleLabel);
        make.top.mas_equalTo(accountNumTitleLabel.mas_bottom).offset(27);
        make.height.mas_equalTo(33);
    }];
    
//    UILabel *youbiTitleLabel = [[UILabel alloc] init];
//    [tableHeadView addSubview:youbiTitleLabel];
//    youbiTitleLabel.text = @"优币";
//    youbiTitleLabel.textColor = COLORWHITE;
//    youbiTitleLabel.textAlignment = 1;
//    youbiTitleLabel.font = UIFONTTOOL13;
//    [youbiTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(0);
//        make.left.mas_equalTo(ScreenWidth/2);
//        make.top.mas_equalTo(35);
//        make.height.mas_equalTo(13);
//    }];
//
//    self.youbiNumberLabel = [[UILabel alloc] init];
//    [tableHeadView addSubview:self.youbiNumberLabel];
//    self.youbiNumberLabel.font = UIFONTTOOL(46);
//    self.youbiNumberLabel.textColor = COLORWHITE;
//    self.youbiNumberLabel.textAlignment = 1;
//    self.youbiNumberLabel.text = [NSString stringWithFormat:@"%@",self.coinNum];
//    [self.youbiNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(youbiTitleLabel);
//        make.top.mas_equalTo(youbiTitleLabel.mas_bottom).offset(27);
//        make.height.mas_equalTo(33);
//    }];
    
    UIView *tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    self.accountTableView.tableFooterView = tableFootView;
    tableFootView.backgroundColor = ColorBackground_Line;
    
    UIButton *toChargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tableFootView addSubview:toChargeButton];
    toChargeButton.layer.masksToBounds = YES;
    toChargeButton.layer.cornerRadius = 20;
    toChargeButton.backgroundColor = ColorZhuTiHongSe;
    [toChargeButton setTitle:@"去充值" forState:UIControlStateNormal];
    toChargeButton.titleLabel.font = UIFONTTOOL15;
    [toChargeButton addTarget:self action:@selector(toChargeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [toChargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(40);
    }];
    
//    UIButton *zhuanYoubiButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [tableFootView addSubview:zhuanYoubiButton];
//    zhuanYoubiButton.layer.masksToBounds = YES;
//    zhuanYoubiButton.layer.cornerRadius = 20;
//    zhuanYoubiButton.backgroundColor = [UIColor whiteColor];
//    [zhuanYoubiButton setTitleColor:ColorZhuTiHongSe forState:UIControlStateNormal];
//    [zhuanYoubiButton setTitle:@"赚优币" forState:UIControlStateNormal];
//    zhuanYoubiButton.layer.borderColor = ColorZhuTiHongSe.CGColor;
//    zhuanYoubiButton.layer.borderWidth = 0.5;
//    zhuanYoubiButton.titleLabel.font = UIFONTTOOL15;
//    [zhuanYoubiButton addTarget:self action:@selector(zhuanyoubiButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [zhuanYoubiButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.right.mas_equalTo(-15);
//        make.top.mas_equalTo(toChargeButton.mas_bottom).offset(15);
//        make.height.mas_equalTo(40);
//    }];
//
    
    
}

#pragma mark 赚优币按钮
- (void)zhuanyoubiButtonAction{
    
    SSH_YaoQingYouLiViewController *yaoqingVC = [[SSH_YaoQingYouLiViewController alloc] init];
    [MobClick event:@"my-account-made"];
    [self.navigationController pushViewController:yaoqingVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getDENGFANGUserInfoData];
}

#pragma mark 获取用户信息
-(void)getDENGFANGUserInfoData{
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]};
    
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGUserInfoURL parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"获取用户信息 数据 %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            self.infoModel = [[SSH_GeRenXinXiModel alloc]init];
            if ([diction[@"data"] isKindOfClass:NSDictionary.class]) {
                [self.infoModel setValuesForKeysWithDictionary:diction[@"data"]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.jinbiNumberLabel.text = [NSString stringWithFormat:@"%@",self.infoModel.coinNum];
//                self.youbiNumberLabel.text = [NSString stringWithFormat:@"%@",self.infoModel.uCoinNum];
            });

        }else if ([diction[@"code"] isEqualToString:@"10014"]){
            
            [self tuiChuLoginAction];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];
    
}
#pragma mark - 退出登录事件
- (void)tuiChuLoginAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:DENGFANGLogOutObserverName object:nil];
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popViewControllerAnimated:NO];
    
    
    
}



#pragma mark - cell的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SSH_ZhiFujiluController *payVC = [[SSH_ZhiFujiluController alloc] init];
    if (indexPath.row == 0) {
        payVC.jiaoYiRecord = 2;
    }else{
        payVC.jiaoYiRecord = 1;
    }
    [self.navigationController pushViewController:payVC animated:YES];
    
}

#pragma mark - 去充值点击事件
- (void)toChargeButtonAction{
    SSH_ChargeActionViewController *chargeVC = [[SSH_ChargeActionViewController alloc] init];
    [MobClick event:@"my-account-recharge"];
    [self.navigationController pushViewController:chargeVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseID = @"DENGFANGMyAccountTableViewCell";
    SSH_WoDeZhangHuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[SSH_WoDeZhangHuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    if (indexPath.row == 0) {
        cell.leftImgView.image = [UIImage imageNamed:@"account_chognzhi"];
        cell.cellTitle.text = @"充值记录";
    }else{
        cell.leftImgView.image = [UIImage imageNamed:@"account_zhifu"];
        cell.cellTitle.text = @"支付记录";
    }
    cell.selectionStyle = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnClicked{
    [MobClick event:@"my-account-back"];
    [self.navigationController popViewControllerAnimated:YES];
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
