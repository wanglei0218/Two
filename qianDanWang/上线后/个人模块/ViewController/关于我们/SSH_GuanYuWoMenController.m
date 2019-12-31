//
//  SSH_GuanYuWoMenController.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_GuanYuWoMenController.h"
#import "SSH_SheZhiTableViewCell.h"//设置cell
#import "SSH_BanBenXinXiController.h"//版本信息-Controller
#import "SSH_WangYeViewController.h"

//
@interface SSH_GuanYuWoMenController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *settingTableView;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation SSH_GuanYuWoMenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleArray = @[@"用户协议",@"免责协议",@"版本信息"];
    self.normalBackView.backgroundColor = ColorBackground_Line;
    self.titleLabelNavi.text = @"关于我们";
    self.settingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.normalBackView addSubview:self.settingTableView];
    self.settingTableView.delegate  = self;
    self.settingTableView.dataSource = self;
    [self.settingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.settingTableView.backgroundColor = ColorBackground_Line;
    
    self.settingTableView.tableFooterView = [UIView new];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //用户协议
        SSH_WangYeViewController *secondWebViewVC = [[SSH_WangYeViewController alloc] init];
        secondWebViewVC.webUrl = [NSString stringWithFormat:@"http://%@/useagreement.html",[DENGFANGSingletonTime shareInstance].lianJieArr[1]];
        secondWebViewVC.titleString = @"用户协议";
        [self.navigationController pushViewController:secondWebViewVC animated:YES];
    }else if (indexPath.row == 1){
        //免责协议
        SSH_WangYeViewController *secondWebViewVC = [[SSH_WangYeViewController alloc] init];
        secondWebViewVC.webUrl = [NSString stringWithFormat:@"http://%@/liability/index.html",[DENGFANGSingletonTime shareInstance].lianJieArr[1]];
        secondWebViewVC.titleString = @"免责协议";
        [self.navigationController pushViewController:secondWebViewVC animated:YES];
    }else{
        //版本信息
        SSH_BanBenXinXiController *versionVC = [[SSH_BanBenXinXiController alloc] init];
        [self.navigationController pushViewController:versionVC animated:YES];
    }
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
