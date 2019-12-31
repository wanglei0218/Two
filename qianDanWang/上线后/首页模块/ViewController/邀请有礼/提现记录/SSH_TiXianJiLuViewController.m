//
//  SSH_TiXianJiLuViewController.m
//  DENGFANGSC
//
//  Created by LY on 2019/1/22.
//  Copyright © 2019年 DENGFANG. All rights reserved.
//

#import "SSH_TiXianJiLuViewController.h"
#import "SSH_TiXianJiluTableViewCell.h"
#import "SSH_TixianJiluModel.h"
#import "SSH_TixianStatusViewController.h"

@interface SSH_TiXianJiLuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation SSH_TiXianJiLuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text = @"提现记录";
    [self setup_Tixianjilu_View];
    [self load_tixian_jilu_data];
}


- (void)load_tixian_jilu_data{
    [[DENGFANGRequest shareInstance] postWithUrlString:@"user/queryUserapplyWithdrawCash" parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]]} success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        for (NSDictionary *dic in diction[@"data"]) {
            SSH_TixianJiluModel *model = [[SSH_TixianJiluModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [self.tableView tableViewWitingImageName:@"当前无提现记录" forRowCount:self.dataArray.count];
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SSH_TixianJiluModel *model = self.dataArray[indexPath.row];
    SSH_TixianStatusViewController *statusVC = [[SSH_TixianStatusViewController alloc] init];
    statusVC.status = model.grantStatus.intValue;
    if (model.grantStatus == 0) {
        statusVC.timeStr = [NSDate dateWithTimeInterval:[model.createTime integerValue]/1000 format:@"yyyy-MM-dd HH:mm"];
    }else{
        statusVC.timeStr = [NSDate dateWithTimeInterval:[model.updateTime integerValue]/1000 format:@"yyyy-MM-dd HH:mm"];
    }
    statusVC.bankNumber = model.bankNumber;
    [self.navigationController pushViewController:statusVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = @"DENGFANGTiXianJiluTableViewCell123";
    SSH_TiXianJiluTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[SSH_TiXianJiluTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    SSH_TixianJiluModel *model = self.dataArray[indexPath.row];
    if ([model.grantStatus intValue]==0) {
        
        cell.statusLabel.text = @"审核中";
        cell.statusLabel.textColor = COLOR_With_Hex(0x1abc9c);
        cell.timeLabel.text = [NSDate dateWithTimeInterval:[model.createTime integerValue]/1000 format:@"yyyy-MM-dd"];
    }else if ([model.grantStatus intValue]==1) {
        
        cell.statusLabel.text = @"提现成功";
        cell.statusLabel.textColor = ColorBlack999;
        cell.timeLabel.text = [NSDate dateWithTimeInterval:[model.updateTime integerValue]/1000 format:@"yyyy-MM-dd"];
    }else if ([model.grantStatus intValue]==2) {
        
        cell.statusLabel.text = @"提现异常";
        cell.statusLabel.textColor = COLOR_With_Hex(0xffa847);
        cell.timeLabel.text = [NSDate dateWithTimeInterval:[model.updateTime integerValue]/1000 format:@"yyyy-MM-dd"];
    }
    cell.moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.withdrawCash];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}

- (void)setup_Tixianjilu_View{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.normalBackView addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    self.tableView.backgroundColor = ColorBackground_Line;
    self.tableView.tableFooterView = [UIView new];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
