//
//  SSH_PayPasswordListViewController.m
//  DENGFANGSC
//
//  Created by LY on 2018/12/13.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_PayPasswordListViewController.h"
#import "SSH_SheZhiTableViewCell.h"//cell
#import "SSH_SetPayPWViewController.h"//设置支付密码
#import "SSH_IDYanZhengViewController.h"//身份验证
#import "SSH_XiuGaiPayPWViewController.h"//修改密码
@interface SSH_PayPasswordListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *settingTableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSString *isSetPayPWD;

@end

@implementation SSH_PayPasswordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSUserDefaults standardUserDefaults] setValue:diction[@"data"][@"isPayPwd"] forKey:DENGFANGIsPayPwd];
    self.isSetPayPWD = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGIsPayPwd];
    if ([self.isSetPayPWD isEqualToString:@"0"]) {
        self.titleArray = @[@"设置支付密码"];
    }else if ([self.isSetPayPWD isEqualToString:@"1"]){
        self.titleArray = @[@"修改支付密码",@"忘记支付密码"];
    }
    self.titleLabelNavi.text = @"支付密码";
    self.normalBackView.backgroundColor = ColorBackground_Line;
    
    
    
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
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.isSetPayPWD isEqualToString:@"0"]) {
        
        SSH_IDYanZhengViewController *setPWVC = [[SSH_IDYanZhengViewController alloc] init];
        [self.navigationController pushViewController:setPWVC animated:YES];
    }else if ([self.isSetPayPWD isEqualToString:@"1"]){
        if (indexPath.row == 0) {
            
            SSH_XiuGaiPayPWViewController *xiugaiPWVC = [[SSH_XiuGaiPayPWViewController alloc] init];
            [self.navigationController pushViewController:xiugaiPWVC animated:YES];
        }else if (indexPath.row == 1) {
            SSH_IDYanZhengViewController *setPWVC = [[SSH_IDYanZhengViewController alloc] init];
            [self.navigationController pushViewController:setPWVC animated:YES];
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = @"DENGFANGSettingTableViewCellzhifumima";
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
