//
//  SSH_ChongZhiMingXiController.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ChongZhiMingXiController.h"
#import "SSH_ZhiFuXiangQingTableViewCell.h"//左文字右文字cell
#import "SSH_JiaoYiJiLuModel.h"//交易记录model

@interface SSH_ChongZhiMingXiController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *jinBiNumberLabel;//金币数
@property (nonatomic, strong) NSArray *leftTitleArray;//列表左侧标题的数组
@property (nonatomic, strong) NSArray *rightTitleArray;
@property (nonatomic, strong) SSH_JiaoYiJiLuModel *model;
@property (nonatomic, strong) UITableView *zfxqTableView;

@end

@implementation SSH_ChongZhiMingXiController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadChongZhiDetailData];
    self.titleLabelNavi.text = @"充值详情";
    self.normalBackView.backgroundColor = ColorBackground_Line;
    self.leftTitleArray = @[@[@"充值说明:",@"支付金额:",@"商品面值:",@"充值优惠:"],@[@"订单号:",@"充值时间:"]];
    self.rightTitleArray = @[@[@"普通充值",@"",@"",@""],@[@"",@""]];
    [self setupZhiFuDetailView];
}

- (void)loadChongZhiDetailData{
    NSString *traidString = [NSString stringWithFormat:@"%@",self.traId];
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGJiaoYiDetailURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:traidString],@"traId":self.traId} success:^(id responseObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            self.model = [[SSH_JiaoYiJiLuModel alloc] init];
            [self.model setValuesForKeysWithDictionary:diction[@"data"]];
            
            NSString *payMoney = [NSString stringWithFormat:@"%@元",self.model.relMoney];
            NSString *coinString = [NSString stringWithFormat:@"%@金币",self.model.coin];
            NSString *giveCoin = [NSString stringWithFormat:@"%@",self.model.giveCoin];
            NSString *discountString = [self isKongString:giveCoin]?@"0":giveCoin;
            NSString *youhuiString = [NSString stringWithFormat:@"获赠%@金币",discountString ];
            
            NSString * timeStr = [NSDate dateWithTimeInterval:[self.model.createTime integerValue]/1000 format:@"yyyy-MM-dd HH:mm:ss"];
            
            self.rightTitleArray = @[@[@"普通充值",payMoney,coinString,youhuiString],@[self.model.orderNo,timeStr]];
            self.jinBiNumberLabel.text = [NSString stringWithFormat:@"%@", self.model.sumCoin];
            [self.zfxqTableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
}
- (BOOL)isKongString:(NSString *)string {
    if (string == nil || [string isEqualToString:@""] || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}

- (void)setupZhiFuDetailView{
    
    UIImageView *fatherBackImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chongzhi_mingxi_beijing"]];
    fatherBackImgView.userInteractionEnabled = YES;
    [self.normalBackView addSubview:fatherBackImgView];
    [fatherBackImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(320);
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
        make.bottom.mas_equalTo(-16.5);
    }];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-64, 121)];
    self.zfxqTableView.tableHeaderView = headView;
    
    //充值所得金币-标题
    UILabel *suodeJinbiLabel = [[UILabel alloc] init];
    [headView addSubview:suodeJinbiLabel];
    suodeJinbiLabel.text = @"充值所得金币";
    suodeJinbiLabel.textColor = GrayColor666;
    suodeJinbiLabel.font = UIFONTTOOL13;
    suodeJinbiLabel.textAlignment = 1;
    [suodeJinbiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(26.5);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(13);
    }];
    
    
    //所得金币数
    self.jinBiNumberLabel = [[UILabel alloc] init];
    [headView addSubview:self.jinBiNumberLabel];
    self.jinBiNumberLabel.text = @"";
    self.jinBiNumberLabel.textAlignment = 1;
    self.jinBiNumberLabel.font = UIFONTTOOL(36);
    self.jinBiNumberLabel.textColor = ColorZhuTiHongSe;
    [self.jinBiNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(suodeJinbiLabel.mas_bottom).offset(11.5);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(28);
    }];
    
    self.zfxqTableView.tableFooterView = [UIView new];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 32;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat tHeight;
    if (section == 0) {
        tHeight = 1;
    }else{
        tHeight = 32;
    }
    UIView *sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-64, tHeight)];
    return sectionHeadView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else{
        return 2;
    }
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
    cell.leftTitleLabel.text = self.leftTitleArray[indexPath.section][indexPath.row];
    cell.rightNameLabel.text = self.rightTitleArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 3) {
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
