//
//  DENGFANGSettingViewController.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_SheZhiController.h"
#import "SSH_SheZhiTableViewCell.h"//设置cell
#import "SSH_LiuYanController.h"//意见反馈-Controller
#import "SSH_GuanYuWoMenController.h"//关于我们-Controller
#import "SSH_ZhaoHuiMiMaController.h"//设置密码
#import "SSH_PayPasswordListViewController.h"//支付密码
#import "SSH_XGSJH_ViewController.h"//修改手机号

@interface SSH_SheZhiController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *settingTableView;
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation SSH_SheZhiController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.titleLabelNavi.text = @"设置";
    self.normalBackView.backgroundColor = ColorBackground_Line;
    self.titleArray = @[@"密码设置",@"修改手机号",@"意见反馈",@"关于我们",@"应用评价"];
    
    self.settingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.normalBackView addSubview:self.settingTableView];
    self.settingTableView.delegate  = self;
    self.settingTableView.dataSource = self;
    [self.settingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.settingTableView.backgroundColor = ColorBackground_Line;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    self.settingTableView.tableFooterView = footerView;
    
    UIButton *tuichuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:tuichuButton];
    tuichuButton.layer.masksToBounds = YES;
    tuichuButton.layer.cornerRadius = 20;
    [tuichuButton setTitle:@"退出登录" forState:UIControlStateNormal];
    tuichuButton.backgroundColor = COLOR_WITH_HEX(0x0964F6);
    tuichuButton.titleLabel.font = UIFONTTOOL15;
    [tuichuButton addTarget:self action:@selector(tuiChuLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [tuichuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(40);
    }];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //密码设置
        SSH_ZhaoHuiMiMaController *pwdVC = [[SSH_ZhaoHuiMiMaController alloc] init];
        [self.navigationController pushViewController:pwdVC animated:YES];
        [DENGFANGSingletonTime shareInstance].isIndividualClickSetPwd = 1;
    }else if (indexPath.row == 1){
        //修改手机号
        SSH_XGSJH_ViewController *xgsjh = [[SSH_XGSJH_ViewController alloc] init];
        [self.navigationController pushViewController:xgsjh animated:YES];
    }else if (indexPath.row == 2){
        //意见反馈
        [MobClick event:@"my-set-suggestion"];
        SSH_LiuYanController *feedVC = [[SSH_LiuYanController alloc] init];
        [self.navigationController pushViewController:feedVC animated:YES];
    }else if (indexPath.row == 3){
        //关于我们
        [MobClick event:@"my-set-about"];
        SSH_GuanYuWoMenController *aboutVC = [[SSH_GuanYuWoMenController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }else if (indexPath.row == 4){
        //应用评价
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", KAPPID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark - 退出登录事件
- (void)tuiChuLoginAction{
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
    [[NSNotificationCenter defaultCenter] postNotificationName:DENGFANGLogOutObserverName object:nil];
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popViewControllerAnimated:NO];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = @"DENGFANGSettingTableViewCellshezhi";
    SSH_SheZhiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[SSH_SheZhiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.leftTitleLabel.text = self.titleArray[indexPath.row];
    cell.selectionStyle = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
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
