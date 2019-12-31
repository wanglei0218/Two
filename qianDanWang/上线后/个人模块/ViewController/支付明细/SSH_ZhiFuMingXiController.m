//
//  SSH_ZhiFuMingXiController.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ZhiFuMingXiController.h"
#import "SSH_ZhiFuXiangQingTableViewCell.h"//左文字右文字cell
#import "SSH_JiaoYiJiLuModel.h"//交易记录model

@interface SSH_ZhiFuMingXiController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *jinBiNumberLabel;//金币数
@property (nonatomic, strong) NSArray *leftTitleArray;//列表左侧标题的数组
@property (nonatomic, strong) NSArray *rightTitleArray;
@property (nonatomic, strong) SSH_JiaoYiJiLuModel *model;
@property (nonatomic, strong) UITableView *zfxqTableView;
@property (nonatomic, strong) UILabel *suodeJinbiLabel;
@end

@implementation SSH_ZhiFuMingXiController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.payType intValue] == 1) {
        self.titleLabelNavi.text = @"支付详情";
        self.leftTitleArray = @[@"客户对象:",@"订单号:",@"抢单时间:"];
    } else if ([self.payType intValue] == 3){
        self.titleLabelNavi.text = @"退单详情";
        self.leftTitleArray = @[@"退单说明:",@"订单号:",@"退单时间时间:"];
    } else if ([self.payType intValue] == 4) {
        self.titleLabelNavi.text = @"赠送详情";
        self.leftTitleArray = @[@"赠送说明:",@"订单号:",@"赠送时间:"];
    } else if ([self.payType intValue] == 7) {
        self.titleLabelNavi.text = @"支付详情";
        self.leftTitleArray = @[@"客户对象:",@"订单号:",@"抢单时间:"];
    }
    
    self.normalBackView.backgroundColor = ColorBackground_Line;
    
    self.rightTitleArray = @[@"",@"",@""];
    [self setupZhiFuDetailView];
    [self loadChongZhiDetailData];
    
}

- (void)loadChongZhiDetailData{
    NSString *traidString = [NSString stringWithFormat:@"%@",self.traId];
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGJiaoYiDetailURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:traidString],@"traId":self.traId} success:^(id responseObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            self.model = [[SSH_JiaoYiJiLuModel alloc] init];
            [self.model setValuesForKeysWithDictionary:diction[@"data"]];
            
            NSString * timeStr = [NSDate dateWithTimeInterval:[self.model.createTime integerValue]/1000 format:@"yyyy-MM-dd HH:mm:ss"];
            
            NSString *nameString;
            if (self.model.name == nil || [self.model.name isEqualToString:@""]) {
                nameString = @"";
            }else{
                nameString = self.model.name;
            }
            
            
            
            if ([self.payType intValue]== 1) {
                self.suodeJinbiLabel.text = @"抢单支付金币";
                self.jinBiNumberLabel.text = [NSString stringWithFormat:@"%@", self.model.coin];
            }else if ([self.payType intValue]== 3){
                
                self.suodeJinbiLabel.text = @"退单所得金币";
                self.jinBiNumberLabel.text = [NSString stringWithFormat:@"%@", self.model.coin];
                nameString = @"退单返还金币";
                
            } else if ([self.payType intValue]== 4){
                self.jinBiNumberLabel.text = [NSString stringWithFormat:@"%@", self.model.coin];
                self.suodeJinbiLabel.text = @"赠送所得金币";
                
            } else if ([self.payType intValue]== 7){
                self.jinBiNumberLabel.text = [NSString stringWithFormat:@"%@", self.model.coin];
                self.suodeJinbiLabel.text = @"自动抢单支付金币";
                
            }
            
            self.rightTitleArray = @[nameString,self.model.orderNo,timeStr];
            [self.zfxqTableView reloadData];
            
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)setupZhiFuDetailView{
    
    UIImageView *fatherBackImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhifu_mingxi_beijing"]];
    fatherBackImgView.userInteractionEnabled = YES;
    [self.normalBackView addSubview:fatherBackImgView];
    [fatherBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(217);
    }];
    
    self.zfxqTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [fatherBackImgView addSubview:self.zfxqTableView];
    self.zfxqTableView.backgroundColor = [UIColor clearColor];
    self.zfxqTableView.delegate = self;
    self.zfxqTableView.dataSource = self;
    self.zfxqTableView.separatorStyle = 0;
    self.zfxqTableView.scrollEnabled = NO;
    self.zfxqTableView.showsVerticalScrollIndicator = NO;
    [self.zfxqTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-15);
    }];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-64, 122)];
    self.zfxqTableView.tableHeaderView = headView;
    headView.backgroundColor = [UIColor clearColor];
    
    //充值所得金币-标题
    self.suodeJinbiLabel = [[UILabel alloc] init];
    [headView addSubview:self.suodeJinbiLabel];
    
    
    self.suodeJinbiLabel.textColor = GrayColor666;
    self.suodeJinbiLabel.font = UIFONTTOOL13;
    self.suodeJinbiLabel.textAlignment = 1;
    [self.suodeJinbiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(26.5);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(13);
    }];
    
    
    //支付金币数
    self.jinBiNumberLabel = [[UILabel alloc] init];
    [headView addSubview:self.jinBiNumberLabel];
    self.jinBiNumberLabel.text = @"";
    self.jinBiNumberLabel.textAlignment = 1;
    self.jinBiNumberLabel.font = UIFONTTOOL(36);
    self.jinBiNumberLabel.textColor = ColorZhuTiHongSe;
    [self.jinBiNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.suodeJinbiLabel.mas_bottom).offset(11.5);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(28);
    }];
    
    self.zfxqTableView.tableFooterView = [UIView new];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = @"zfxqTableViewCell";
    SSH_ZhiFuXiangQingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[SSH_ZhiFuXiangQingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.rightNameLabel.text = self.rightTitleArray[indexPath.row];
    if (indexPath.row == 0 && [self.payType intValue] == 4) {
//        cell.rightNameLabel.text = @"邀请有礼";
        cell.rightNameLabel.text = self.model.giftType;
    }
    cell.leftTitleLabel.text = self.leftTitleArray[indexPath.row];
    
    if (indexPath.row == 0) {
        cell.rightNameLabel.textColor = ColorZhuTiHongSe;
    }
    cell.selectionStyle = 0;
    return cell;
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
