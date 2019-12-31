//
//  MemberViewController.m
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_MemberViewController.h"
#import "SSH_MemberFristerTableViewCell.h"
#import "SSH_MemberSecondeTableViewCell.h"
#import "SSH_MemberHeaderView.h"
#import "SSH_MemberOtherTableViewCell.h"
#import "SSH_EquitiesView.h"
#import "SSH_MemberTableHeaderView.h"
#import "SSH_RechargeViewController.h"
#import "SSH_MemberModel.h"
#import "SSH_ZDQDViewController.h"
#import "SSH_ZYViewController.h"
#import "SSH_New_RZViewController.h"
#import "SSH_GeRenXinXiModel.h"

@interface SSH_MemberViewController ()<UITableViewDelegate,UITableViewDataSource,SSH_MemberHeaderViewDelegate,SSH_MemberFristerTableViewCellDelegate,SSH_MemberSecondeTableViewCellDelegate,SSH_EquitiesViewDelegate>
{
    BOOL iSvip;
}
@property (nonatomic,strong)UITableView *memberTable;
@property (nonatomic,strong)UITableView *otherTable;
@property (nonatomic,strong)NSArray *otherData;
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)SSH_MemberHeaderView *headerView;
@property (nonatomic,strong)NSArray *fristerData;
@property (nonatomic,strong)NSArray *secondeData;
@property (nonatomic,strong)SSH_EquitiesView *equitiesView;
@property (nonatomic,strong)XPBackView *backView;

@end

@implementation SSH_MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabelNavi.text = @"会员";
    
    UIButton *rightbtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - WidthScale(90), getStatusHeight, WidthScale(70), getRectNavAndStatusHight - getStatusHeight)];
    NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"权益说明" attributes:@{
                                                        NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                        NSForegroundColorAttributeName:COLOR_WITH_HEX(0x666666)
                                                                                              }];
    
    [rightbtn setAttributedTitle:attr forState:UIControlStateNormal];
    
    [rightbtn addTarget:self action:@selector(didSelecteTheRightBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationView addSubview:rightbtn];
    
    [self getVipData];
    
    self.fristerData = @[
                         @{
                             @"name":@"自动抢单",
                             @"content":@"自动抢单\n抢单无忧",
                             @"image":@"1"
                             },@{
                             @"name":@"退单无忧",
                             @"content":@"退单服务\n退单无忧",
                             @"image":@"2"
                             },@{
                             @"name":@"展业海报",
                             @"content":@"展业海报\n开单神器",
                             @"image":@"3"
                             },@{
                             @"name":@"推广贷款",
                             @"content":@"推广贷款\n敬请期待",
                             @"image":@"4"
                             },@{
                             @"name":@"办卡返佣",
                             @"content":@"办卡返佣\n敬请期待",
                             @"image":@"5"
                             },@{
                             @"name":@"信用查询",
                             @"content":@"免费信用查询\n敬请期待",
                             @"image":@"6"
                             }];
    
    self.otherData = @[@{
                           @"name":@"自动抢单",
                           @"content":@"抢单无忧",
                           @"image":@"1",
                           @"right":@"开启抢单"
                           },@{
                           @"name":@"退单无忧",
                           @"content":@"可申请12次退单",
                           @"image":@"2",
                           @"right":@"去退单"
                           },@{
                           @"name":@"展业海报",
                           @"content":@"展业神器",
                           @"image":@"3",
                           @"right":@"去生成"
                           },@{
                           @"name":@"信用查询",
                           @"content":@"免费试用信用查询",
                           @"image":@"4",
                           @"right":@"敬请期待"
                           },@{
                           @"name":@"推广贷款",
                           @"content":@"最高返%5",
                           @"image":@"5",
                           @"right":@"敬请期待"
                           },@{
                           @"name":@"办卡返佣",
                           @"content":@"下卡佣金最高260/账",
                           @"image":@"1",
                           @"right":@"敬请期待"
                           },
                       ];
    
    [self headerView];
    [self equitiesView];
    
    if (_type == 1) {
        [self memberTable];
        [self bottomBtn];
        
    }else{
        [self otherTable];
        _otherTable.tableHeaderView = _headerView;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getUserInfo];
}

#pragma mark ==================导航条右侧按钮==============
- (void)didSelecteTheRightBtn{
    [MobClick event:@"interests"];
    self.backView = [XPBackView makeViewWithMask:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT) andView:self.equitiesView];
}

#pragma mark ==================懒加载=================
- (SSH_MemberHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[SSH_MemberHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WidthScale(105))];
        _headerView.delagate = self;
    }
    return _headerView;
}

- (UITableView *)memberTable{
    if(!_memberTable){
        _memberTable = [[UITableView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREENH_HEIGHT - WidthScale(getRectNavAndStatusHight) - WidthScale(SafeAreaAllBottomHEIGHT)) style:UITableViewStyleGrouped];
        _memberTable.delegate = self;
        _memberTable.dataSource = self;
        
        _memberTable.separatorColor = [UIColor clearColor];
        _memberTable.backgroundColor = [UIColor whiteColor];
        _memberTable.tableHeaderView = _headerView;
        
        [_memberTable registerClass:[SSH_MemberFristerTableViewCell class] forCellReuseIdentifier:@"fristCell"];
        [_memberTable registerClass:[SSH_MemberSecondeTableViewCell class] forCellReuseIdentifier:@"secondeCell"];
        
        [self.view addSubview:_memberTable];
    }
    return _memberTable;
}

- (UITableView *)otherTable{
    if(!_otherTable){
        _otherTable = [[UITableView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREENH_HEIGHT - getRectNavAndStatusHight - SafeAreaAllBottomHEIGHT) style:UITableViewStyleGrouped];
        
        _otherTable.delegate = self;
        _otherTable.dataSource = self;
        
        [_otherTable registerNib:[UINib nibWithNibName:@"SSH_MemberOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"otherCell"];
        
        [self.view addSubview:_otherTable];
    }
    return _otherTable;
}

- (UIButton *)bottomBtn{
    if(!_bottomBtn){
        _bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREENH_HEIGHT - WidthScale(SafeAreaAllBottomHEIGHT), SCREEN_WIDTH, WidthScale(SafeAreaAllBottomHEIGHT) - WidthScale(SafeAreaBottomHEIGHT))];
        NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"立即开通" attributes:@{
                                NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSFontAttributeName:[UIFont systemFontOfSize:15]
                                                                                                  }];
        [_bottomBtn setAttributedTitle:attr forState:UIControlStateNormal];
        [_bottomBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(didSelecteTheBottomEnterBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bottomBtn];
    }
    return _bottomBtn;
}

- (SSH_EquitiesView *)equitiesView{
    if(!_equitiesView){
        _equitiesView = [[SSH_EquitiesView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - WidthScale(285)) / 2, (SCREENH_HEIGHT - WidthScale(470)) / 2, WidthScale(285), WidthScale(470))];
        _equitiesView.delegate = self;
    }
    return _equitiesView;
}

#pragma mark ====================按钮点击方法==================
- (void)didSelecteTheBottomEnterBtn{
    [MobClick event:@"openmembership"];
    SSH_RechargeViewController *recharge = [[SSH_RechargeViewController alloc]init];
//    recharge.type = (int)tag;
    recharge.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recharge animated:YES];
}

#pragma mark ====================自定义代理====================
//头部视图点击方法
- (void)didSelecteTheMemberHeaderView{
    [MobClick event:@"Immediaterenewal"];
    SSH_RechargeViewController *recharge = [[SSH_RechargeViewController alloc]init];
//    recharge.type = (int)tag;
    recharge.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recharge animated:YES];
}

//六大权益点击方法
- (void)didSelecteTheFristerCellWithTarget:(NSInteger)tag{
    
    if(tag == 0){
        self.backView = [XPBackView makeViewWithMask:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT) andImage:@"zidong" withBtn:@"chacha"];
    }else if (tag == 1){
        self.backView = [XPBackView makeViewWithMask:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT) andImage:@"tuidan" withBtn:@"chacha"];
    }else if (tag == 2){
        self.backView = [XPBackView makeViewWithMask:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT) andImage:@"tuiguang" withBtn:@"chacha"];
    }else{
//        self.backView = [XPBackView makeViewWithMask:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT) andImage:@"tuiguang" withBtn:@"chacha"];
    }
    
}

//会员等级点击方法
- (void)didSelecteTheSecondeItemWithTarget:(NSInteger)tag{
    SSH_RechargeViewController *recharge = [[SSH_RechargeViewController alloc]init];
    recharge.type = (int)tag;
    recharge.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recharge animated:YES];
}

//点击我知道了
- (void)didSelecteTheKnow{
    
    [self.backView block:^{
        
    }];
    
}

#pragma mark ====================表格数据源=====================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(tableView == self.otherTable){
        return self.otherData.count;
    }else{
        return 2;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == self.otherTable){
        SSH_MemberOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherCell" forIndexPath:indexPath];
        
        NSDictionary *dic = self.otherData[indexPath.section];
        [cell setCellContentWithData:dic];
        
        return cell;
    }
    
    if(indexPath.section == 0){
        SSH_MemberFristerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fristCell" forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.collectData = self.fristerData;
        
        return cell;
    }else{
        SSH_MemberSecondeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secondeCell" forIndexPath:indexPath];
        
        cell.backgroundColor = RGB(245, 245, 245);
        cell.layer.cornerRadius = 20;
        cell.layer.masksToBounds = YES;
        cell.delegate = self;
        cell.collectData = self.secondeData;
        
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.otherTable){
        return WidthScale(67);
    }
    
    if (indexPath.section == 0){
        return WidthScale(230);
    }else{
        return WidthScale(280);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return WidthScale(60);
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        SSH_MemberTableHeaderView *header = [[SSH_MemberTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WidthScale(60))];
        
        header.imageV.image = [UIImage imageNamed:@"title1"];
        
        return header;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(tableView == self.otherTable){
        if (indexPath.section == 0) {
            //自动抢单
            if (iSvip) {
                [self joinQdwy];
            } else {
                [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"该功能只对会员开放"];
            }
        } else if (indexPath.section == 1) {
            //客户管理
            self.tabBarController.selectedIndex = 2;
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else if (indexPath.section == 2) {
            //展业海报
            SSH_ZYViewController *zhanYe = [[SSH_ZYViewController alloc] init];
            zhanYe.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:zhanYe animated:YES];
        } else if (indexPath.section == 3) {
            
        } else if (indexPath.section == 4) {
            
        } else {
            
        }
    }
}

#pragma mark ========================网络请求=======================
- (void)getVipData{
    
    NSDictionary *params = @{
                             @"timestamp":[NSString yf_getNowTimestamp],
                             @"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil]
                             };
    
    [[DENGFANGRequest shareInstance] postWithUrlString:@"vip/queryVipGradeList" parameters:params success:^(id responsObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
        if(![[dic objectForKey:@"code"] isEqualToString:@"200"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:dic[@"msg"]];
            });
            return ;
        }
        
        NSArray *dataDic = [dic objectForKey:@"data"];
        self.secondeData = [[SSH_MemberModel shardeInstance]getvipModelWithData:dataDic];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(self.type == 1){
                [self.memberTable reloadData];
            }else{
                [self.otherTable reloadData];
            }
            
        });
        
        
    } fail:^(NSError *error) {
        
    }];
    
}

#pragma mark =======================获取用户信息====================
- (void)getUserInfo{
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]};
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGUserInfoURL parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        //        NSLog(@"获取用户信息 数据 %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            NSDictionary *dic = [diction objectForKey:@"data"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.headerView setMemberHeaderViewContentWithData:dic];
                self->iSvip = [dic[@"isVip"] boolValue];
            });
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

-(void)joinQdwy{
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]};
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGUserInfoURL parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"获取用户信息 数据 %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            SSH_GeRenXinXiModel *infoModel = [[SSH_GeRenXinXiModel alloc]init];
            if ([diction[@"data"] isKindOfClass:NSDictionary.class]) {
                [infoModel setValuesForKeysWithDictionary:diction[@"data"]];
            }
            
            //（0：未认证  1：已认证   2:认证中   3:认证失败）
            //（0：未检测  1：已检测）
            if ([infoModel.isAuth intValue] == 1 && [infoModel.isFaceCheck intValue] == 1) { //已认证
                SSH_ZDQDViewController *zdqd = [[SSH_ZDQDViewController alloc] init];
                zdqd.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:zdqd animated:YES];
            } else {
                SSH_New_RZViewController *rz = [[SSH_New_RZViewController alloc] init];
                rz.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:rz animated:YES];
            }
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];
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
