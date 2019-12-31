//
//  SSH_ChargeGiftViewController.m
//  DENGFANGSC
//
//  Created by LY on 2018/12/14.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ChargeGiftViewController.h"
#import "SSH_ChongZhiHuoDongTableViewCell.h"
#import "SSH_ChargeActionViewController.h"
#import "SSH_ChongZhiJinEModel.h"

@interface SSH_ChargeGiftViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *chargeGift_tableView;
@property (nonatomic, strong) NSArray *backImg_cell_array;
@property (nonatomic, strong) NSArray *chongzhi_textColor_array;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *shuomingLabel;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SSH_ChargeGiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    self.titleLabelNavi.text = @"充值有礼";
    self.backImg_cell_array = @[@"chongzhiyouli_1",@"chongzhiyouli_2",@"chongzhiyouli_3",@"chongzhiyouli_3"];
    self.chongzhi_textColor_array = @[COLOR_With_Hex(0xfeb54f),COLOR_With_Hex(0xfc7d52),COLOR_With_Hex(0xf75f53),COLOR_With_Hex(0xf75f53)];
    [self setupTableView];
    [self loadChongzhiData];
}

- (void)loadChongzhiData{
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGPaymentMethodListURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:@""],@"rechargeGift":@2} success:^(id responseObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            for (NSDictionary *dic in diction[@"tydPayDiscount"]) {
                SSH_ChongZhiJinEModel *model = [[SSH_ChongZhiJinEModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            
            CGRect guizeRect = [diction[@"rechargeGift"] boundingRectWithSize:CGSizeMake(ScreenWidth-64, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFONTTOOL13} context:nil];
            self.footerView.frame = CGRectMake(0, 0, ScreenWidth, 47+50+guizeRect.size.height);
            self.chargeGift_tableView.tableFooterView = self.footerView;
            self.shuomingLabel.frame = CGRectMake(32, 47, ScreenWidth-64, guizeRect.size.height+10);
            self.shuomingLabel.text = diction[@"rechargeGift"];
            
            [self.chargeGift_tableView reloadData];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    
    } fail:^(NSError *error) {
        
    }];
}

- (void)setupTableView{
    self.chargeGift_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.normalBackView addSubview:self.chargeGift_tableView];
    self.chargeGift_tableView.delegate = self;
    self.chargeGift_tableView.dataSource = self;
    self.chargeGift_tableView.separatorStyle = 0;
    self.chargeGift_tableView.backgroundColor = COLOR_With_Hex(0xfce0bc);
    [self.chargeGift_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 270)];
    headView.image = [UIImage imageNamed:@"chongzhiyouli_beijign"];
    self.chargeGift_tableView.tableHeaderView = headView;
    
    UIImageView *head_back_imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chongzhiyouli_banner"]];
    [headView addSubview:head_back_imgView];
    [head_back_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(375);
        make.height.mas_equalTo(270);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(0);
    }];
    
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 47+50+30)];
    self.chargeGift_tableView.tableFooterView = self.footerView;
    
    UIImageView *huodong_shuoming_ImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chongzhiyouli_shuoming"]];
    [self.footerView addSubview:huodong_shuoming_ImgView];
    huodong_shuoming_ImgView.frame = CGRectMake((ScreenWidth-263.5)/2, 19, 263.5, 13.5);
    
    self.shuomingLabel = [[UILabel alloc] init];
    self.shuomingLabel.font = UIFONTTOOL12;
    self.shuomingLabel.textColor = COLOR_With_Hex(0xf75f53);
    self.shuomingLabel.numberOfLines = 0;
    [self.footerView addSubview:self.shuomingLabel];
    self.shuomingLabel.frame = CGRectMake(32, 47, ScreenWidth-64, 30);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = @"SSH_ChongZhiHuoDongTableViewCell";
    SSH_ChongZhiHuoDongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[SSH_ChongZhiHuoDongTableViewCell alloc] init];
    }
    cell.beijing_imgView.image = [UIImage imageNamed: self.backImg_cell_array[indexPath.row]];
    SSH_ChongZhiJinEModel *model = self.dataArray[indexPath.row];
    cell.chongzhi_num_Label.text = [NSString stringWithFormat:@"充值%@元",model.relMoney];
    if (model.discount == nil) {
        model.discount = @"0";
    }
    cell.song_num_Label.text = model.labelExplain;
    cell.chongzhi_num_Label.textColor = self.chongzhi_textColor_array[indexPath.row];
    cell.backgroundColor = COLOR_With_Hex(0xfce0bc);
    cell.selectionStyle = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SSH_ChargeActionViewController *chongzhiVC = [[SSH_ChargeActionViewController alloc] init];
    SSH_ChongZhiJinEModel *model = self.dataArray[indexPath.row];
    chongzhiVC.chongzhiYouliSelectID = [NSString stringWithFormat:@"%@",model.rechargeId];
    [self.navigationController pushViewController:chongzhiVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 107;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
