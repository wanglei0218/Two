//
//  SSH_MyYongJinViewController.m
//  DENGFANGSC
//
//  Created by LY on 2018/12/11.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_MyYongJinViewController.h"
#import "SSH_YaoQingSuccessTableViewCell.h"
#import "SSH_WoDeYongJinModel.h"
#import "SSH_TiXianJiLuViewController.h"//提现记录
#import "SSH_MyYongjinTableViewCell.h"
#import "SSH_TiXianViewController.h"//提现

@interface SSH_MyYongJinViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *yongjin_tableView;
@property (nonatomic, strong) UILabel *jinbishu_label;
@property (nonatomic, strong) NSArray *yaoqingTitleArray;//邀请标题数组
@property (nonatomic, assign) NSInteger yaoqingStatus;//邀请状态 0:成功 1:待认证 2:已失效
@property (nonatomic, assign) int page;
@property (nonatomic, assign) NSInteger yaoqingStatus_houtai;//给后台传的邀请状态 0:等待身份认证 1:邀请成功 2:已失效
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *tixianButton;//提现按钮
@property (nonatomic, strong) UILabel *yaoqingrenshuLabel;//邀请人数

@end

@implementation SSH_MyYongJinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    self.page = 1;
    self.titleLabelNavi.text = @"我的佣金";
    self.yaoqingStatus = 0;
    self.yaoqingStatus_houtai = 1;
    self.normalBackView.backgroundColor = ColorBackground_Line;
    self.yaoqingTitleArray = @[@"好友",@"认证时间",@"认证奖励",@"充值奖励"];
    [self setupView];
    [self loadDENGFANGDataWithPage:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAllPage) name:@"refreshMyyongjin" object:nil];
}

- (void)refreshAllPage{
    [self loadDENGFANGDataWithPage:1];
}

- (void)loadDENGFANGDataWithPage:(int)page{
    NSString *useidStr = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGWoDeYongJinURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%@%@",self.yaoQingMa_String,useidStr]],@"inviteCode":self.yaoQingMa_String,@"rows":@10,@"page":@(self.page)} success:^(id responseObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"wodeyongjin%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            self.jinbishu_label.text = [NSString stringWithFormat:@"%@", diction[@"coin"]];
            self.yaoqingrenshuLabel.text = [NSString stringWithFormat:@"邀请人数 %@",diction[@"invitCount"]];
            
            for (NSDictionary *dic in diction[@"data"]) {
                SSH_WoDeYongJinModel *model = [[SSH_WoDeYongJinModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            
            if ([diction[@"coin"] intValue] < [diction[@"extractCoin"] intValue]) {
                self.tixianButton.userInteractionEnabled = NO;
                [self.tixianButton setImage:[UIImage imageNamed:@"tixian_bukeyi"] forState:UIControlStateNormal];
            }
            
            [self.yongjin_tableView reloadData];
            [self.yongjin_tableView.mj_footer endRefreshing];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.normalBackView WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma makr 提现记录按钮
- (void)tixianjiluAction{
    
    SSH_TiXianJiLuViewController *tixianJiLuVC = [[SSH_TiXianJiLuViewController alloc] init];
    [self.navigationController pushViewController:tixianJiLuVC animated:YES];
}

#pragma mark 提现点击事件
- (void)tixianButtonAction{
    
    SSH_TiXianViewController *tixianVC = [[SSH_TiXianViewController alloc] init];
    [self.navigationController pushViewController:tixianVC animated:YES];
}

#pragma mark 设置页面布局
- (void)setupView{
    
    UIButton *tixianjiluButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navigationView addSubview:tixianjiluButton];
    [tixianjiluButton setTitle:@"提现记录" forState:UIControlStateNormal];
    [tixianjiluButton setTitleColor:COLOR_With_Hex(0xf56c37) forState:UIControlStateNormal];
    tixianjiluButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [tixianjiluButton addTarget:self action:@selector(tixianjiluAction) forControlEvents:UIControlEventTouchUpInside];
    [tixianjiluButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(0);
    }];
    
    UIImageView *bannerImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yongjin_banner"]];
    [self.normalBackView addSubview:bannerImgView];
    [bannerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(185);
    }];
    
    self.jinbishu_label = [[UILabel alloc] init];
    self.jinbishu_label.textColor = COLORWHITE;
    self.jinbishu_label.font = UIFONTTOOL(38);
    self.jinbishu_label.textAlignment = 1;
    [self.normalBackView addSubview:self.jinbishu_label];
    [self.jinbishu_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(46);
        make.height.mas_equalTo(29);
    }];
    
    UILabel *jinbiName = [[UILabel alloc] init];
    [self.normalBackView addSubview:jinbiName];
    jinbiName.text = @"当前金币";
    jinbiName.font = UIFONTTOOL13;
    jinbiName.textColor = COLORWHITE;
    jinbiName.textAlignment = 1;
    [jinbiName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.jinbishu_label.mas_bottom).offset(15);
        make.height.mas_equalTo(13);
    }];
    
    self.tixianButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.normalBackView addSubview:self.tixianButton];
    [self.tixianButton setImage:[UIImage imageNamed:@"tixian_keyi"] forState:UIControlStateNormal];//tixian_keyi tixian_bukeyi
    [self.tixianButton addTarget:self action:@selector(tixianButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tixianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(jinbiName.mas_bottom).offset(12);
        make.width.mas_equalTo(162);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(self.normalBackView);
    }];
    
    self.yaoqingrenshuLabel = [[UILabel alloc] init];
    [bannerImgView addSubview:self.yaoqingrenshuLabel];
    self.yaoqingrenshuLabel.textAlignment = 2;
    self.yaoqingrenshuLabel.font = [UIFont systemFontOfSize:11];
    self.yaoqingrenshuLabel.textColor = [UIColor whiteColor];
    [self.yaoqingrenshuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(11);
    }];
    
    for (int i = 0; i < 4; i++) {
        UILabel *yaoQing_zhuangtai_Label = [[UILabel alloc] init];
        [self.normalBackView addSubview:yaoQing_zhuangtai_Label];
        yaoQing_zhuangtai_Label.text = self.yaoqingTitleArray[i];
        yaoQing_zhuangtai_Label.textAlignment = 1;
        yaoQing_zhuangtai_Label.backgroundColor = [UIColor whiteColor];
        yaoQing_zhuangtai_Label.font = [UIFont systemFontOfSize:14];
        yaoQing_zhuangtai_Label.textColor = ColorBlack222;
        if (i== 3) {
            [yaoQing_zhuangtai_Label borderForColor:GrayLineColor borderWidth:0.5 borderType:UIBorderSideTypeTop & UIBorderSideTypeBottom];
        }else{
            [yaoQing_zhuangtai_Label borderForColor:GrayLineColor borderWidth:0.5 borderType:UIBorderSideTypeTop & UIBorderSideTypeBottom & UIBorderSideTypeRight];
        }
        
        [yaoQing_zhuangtai_Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScreenWidth*i/4);
            make.width.mas_equalTo(ScreenWidth/4);
            make.top.mas_equalTo(185+10);
            make.height.mas_equalTo(45);
        }];
    }
    
    self.yongjin_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.normalBackView addSubview:self.yongjin_tableView];
    self.yongjin_tableView.delegate = self;
    self.yongjin_tableView.dataSource = self;
    [self.yongjin_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(240);
    }];
    self.yongjin_tableView.separatorStyle = 0;
    self.yongjin_tableView.backgroundColor = ColorBackground_Line;
    self.yongjin_tableView.tableFooterView = [UIView new];
    self.yongjin_tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(shangLa_jiazai_refreshFooter)];
}

- (void)shangLa_jiazai_refreshFooter{
    self.page++;
    
    [self loadDENGFANGDataWithPage:self.page];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseID = @"SSH_YaoQingSuccessTableViewCell";
    SSH_MyYongjinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[SSH_MyYongjinTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    SSH_WoDeYongJinModel *model = self.dataArray[indexPath.row];
    
    cell.labelArray[0].text = model.mobile;
    
    
    
    if ([model.inviteType isEqualToString:@"0"]) {//等待身份认证
        if (model.isAuth.intValue == 2) {
            cell.labelArray[1].text = @"认证中";
        }else if (model.isAuth.intValue == 0){
            cell.labelArray[1].text = @"等待身份认证";
        }else if (model.isAuth.intValue == 3){
            cell.labelArray[1].text = @"认证失败";
        }//（0：未认证  1：已认证   2:认证中   3:认证失败）
        cell.labelArray[2].text = @"-";
        cell.labelArray[3].text = @"-";
    }else if ([model.inviteType isEqualToString:@"1"]){//邀请成功
        cell.labelArray[1].text = [NSDate dateWithTimeInterval:[model.updateTime integerValue]/1000 format:@"yyyy-MM-dd"];
        if (model.authCoin) {
            cell.labelArray[2].text = model.authCoin;
        }else{
            cell.labelArray[2].text = @"-";
        }
        if (model.firstRecharge) {
            cell.labelArray[3].text = model.firstRecharge;
        }else{
            cell.labelArray[3].text = @"-";
        }
        
        
    }else if ([model.inviteType isEqualToString:@"2"]){//已失效
        cell.labelArray[1].text = @"已失效";
        cell.labelArray[2].text = @"-";
        cell.labelArray[3].text = @"-";
    }
    
    
    cell.selectionStyle = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
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
