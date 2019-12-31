//
//  SSH_ZhiFujiluController.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ZhiFujiluController.h"
#import "SSH_ZhiFuJiLuListViewCell.h"//充值记录-支付记录cell
#import "SSH_ChongZhiMingXiController.h"//充值明细-controller
#import "SSH_ZhiFuMingXiController.h"//支付明细-controller
#import "SSH_JiaoYiJiLuModel.h"//交易记录model

@interface SSH_ZhiFujiluController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *recordTableView;
@property (nonatomic, strong) UIImageView *placeholderImageView;//占位图
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIView *noDataFatherView;
@property (nonatomic,strong) UILabel *showTitleLabel;
@property (nonatomic, assign) NSInteger pageNum;//页数


@end

@implementation SSH_ZhiFujiluController
- (UIView *)noDataFatherView {
    if (!_noDataFatherView) {
        _noDataFatherView = [[UIView alloc] init];
        
        //背景图
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"充值记录"]];
        [_noDataFatherView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(107);
            make.size.mas_equalTo([imageView image].size);
            make.centerX.mas_equalTo(_noDataFatherView);
        }];
        //文字label
        [_noDataFatherView addSubview:self.showTitleLabel];
        [self.showTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(imageView.mas_bottom).offset(12.5);
        }];
    }
    return _noDataFatherView;
}
- (UILabel *)showTitleLabel {
    if (!_showTitleLabel) {
        _showTitleLabel = [[UILabel alloc] init];
        _showTitleLabel.font = [UIFont systemFontOfSize:15];
        _showTitleLabel.textColor = Colorbdbdbd;
        _showTitleLabel.textAlignment = 1;
        _showTitleLabel.numberOfLines = 0;
    }
    return _showTitleLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    self.view.backgroundColor = ColorBackground_Line;
    
    if (self.jiaoYiRecord == 1) {
        self.titleLabelNavi.text = @"支付记录";
        self.showTitleLabel.text = @"暂无支付记录";
    }else{
        self.titleLabelNavi.text = @"充值记录";
        self.showTitleLabel.text = @"暂无充值记录";
    }
    
    self.normalBackView.backgroundColor = ColorBackground_Line;
    
    self.recordTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.normalBackView addSubview:self.recordTableView];
    self.recordTableView.delegate = self;
    self.recordTableView.dataSource = self;
    self.recordTableView.backgroundColor = ColorBackground_Line;
    [self.recordTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.pageNum = 1;
    self.recordTableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        self.pageNum = self.pageNum + 1;
        [self loadJiaoYiJiLuData];
    }];
    UIView *footerView = [UIView new];
    self.recordTableView.tableFooterView = footerView;
    [self loadJiaoYiJiLuData];
}

- (void)loadJiaoYiJiLuData{
    NSString *useidString = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGJiaoYiJiLuURL parameters:@{@"rows":@(15),@"page":@(self.pageNum),@"timestamp":[NSString yf_getNowTimestamp],@"userId":useidString,@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:useidString],@"payType":@(self.jiaoYiRecord)} success:^(id responseObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"jiaoyi_jilu%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            for (NSDictionary *dict in diction[@"data"]) {
                SSH_JiaoYiJiLuModel *model = [[SSH_JiaoYiJiLuModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
            }
            [self.recordTableView reloadData];
            
            NSArray * arr = diction[@"data"];
            if ( arr.count == 0) {
                [self.recordTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.recordTableView.mj_footer endRefreshing];
            }
            
        }
        
        //
    } fail:^(NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SSH_JiaoYiJiLuModel *model = self.dataArray[indexPath.row];
//    [model.payType isEqualToString:@"4"]
    if ([model.payType intValue] == 2) {
        SSH_ChongZhiMingXiController *detailVC = [[SSH_ChongZhiMingXiController alloc] init];
        detailVC.traId = model.traId;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        SSH_ZhiFuMingXiController *detailVC = [[SSH_ZhiFuMingXiController alloc] init];
        detailVC.traId = model.traId;
        detailVC.payType = model.payType;
        detailVC.payMethod = model.payMethod;
        
        
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseid = @"DENGFANGPayRecordTableViewCell";
    SSH_ZhiFuJiLuListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
    if (!cell) {
        cell = [[SSH_ZhiFuJiLuListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseid];
    }
    SSH_JiaoYiJiLuModel *model = self.dataArray[indexPath.row];
    if ([model.payType isEqualToString:@"4"]) {
        
        cell.leftImgView.image = [UIImage imageNamed:@"chongzhijilu_zengsong"];
        cell.cellTitle.text = @"赠送";
        
        if ([model.giftType isEqualToString:@"邀请好友认证"] || [model.giftType isEqualToString:@"邀请有礼首充"]) {
            NSString *jinbiString = [NSString stringWithFormat:@"%@金币",model.coin];
            [self configAttributeString:jinbiString rangeString:@"金币" withLabel:cell.moneyLabel];
        }else{
            
            NSString *coin = [NSString stringWithFormat:@"%@",model.coin];
            NSString *uCoinNum = [NSString stringWithFormat:@"%@",model.uCoinNum];
            NSInteger num = [coin integerValue] + [uCoinNum integerValue];
            NSString *jinbiString = [NSString stringWithFormat:@"%ld金币",num];
            [self configAttributeString:jinbiString rangeString:@"金币" withLabel:cell.moneyLabel];
        }
        
        
    }else if ([model.payType isEqualToString:@"2"]) {
        
        cell.leftImgView.image = [UIImage imageNamed:@"account_chognzhi"];
        cell.cellTitle.text = @"充值";
        NSString *jinbiString = [NSString stringWithFormat:@"%@元",model.relMoney];
        [self configAttributeString:jinbiString rangeString:@"元" withLabel:cell.moneyLabel];
    }else if ([model.payType isEqualToString:@"3"]){
        
        cell.leftImgView.image = [UIImage imageNamed:@"account_chognzhi"];
        cell.cellTitle.text = @"退单";
        if ([model.payMethod isEqualToString:@"1"]) { //优币支付
            NSString *jinbiString = [NSString stringWithFormat:@"%@金币",model.coin];
            [self configAttributeString:jinbiString rangeString:@"金币" withLabel:cell.moneyLabel];
        }else{
            NSString *jinbiString = [NSString stringWithFormat:@"%@金币",model.coin];
            [self configAttributeString:jinbiString rangeString:@"金币" withLabel:cell.moneyLabel];
        }
    }else{
        cell.leftImgView.image = [UIImage imageNamed:@"account_zhifu"];
        cell.cellTitle.text = @"支付";
        
        if (model.payMethod.intValue == 1) {
            NSString *youbiStr = [NSString stringWithFormat:@"%@金币",model.coin];
            [self configAttributeString:youbiStr rangeString:@"金币" withLabel:cell.moneyLabel];
        }else{
            NSString *jinbiStr = [NSString stringWithFormat:@"%@金币",model.coin];
            [self configAttributeString:jinbiStr rangeString:@"金币" withLabel:cell.moneyLabel];
        }
    }
    
    NSString * timeStr = [NSDate dateWithTimeInterval:[model.createTime integerValue]/1000 format:@"yyyy-MM-dd HH:mm:ss"];
    
    cell.timeLabel.text = timeStr;
    return cell;
}

- (void)configAttributeString:(NSString *)configString rangeString:(NSString *)rangeString withLabel:(UILabel *)label{
    
    NSString *jineString = configString;
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] initWithString:jineString];
    NSRange range = [jineString rangeOfString:rangeString];
    [mutableAttString addAttributes:@{NSFontAttributeName:UIFONTTOOL12,NSForegroundColorAttributeName:label.textColor} range:range];
    [mutableAttString beginEditing];
    label.attributedText = mutableAttString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewWithYourSelfView:self.noDataFatherView forRowCount:self.dataArray.count];
    return self.dataArray.count;
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
