//
//  SSH_GeRenZhongXinController.m
//  DENGFANGSC
//
//  Created by LY on 2018/9/17.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_GeRenZhongXinController.h"
#import "SSH_GeRenZhongXinListCell.h"//列表cell

#import "SSH_New_RZViewController.h"
#import "SSH_WoDeZhangHuController.h"//我的账户
#import "SSH_SheZhiController.h"//设置-controller
#import "SSH_BangZhuZhongXinController.h"//帮助中心
#import "SSH_GeRenXinXiController.h" //个人信息界面

#import "SSH_GeRenXinXiModel.h" //model
#import "SSH_WeChatAlertView.h"//公众号弹出
#import "SSH_DingYueHaoModel.h"//公众号model
#import "SSH_YaoQingYouLiViewController.h"//邀请有礼controller
#import "SSH_YaoQingViewController.h"       //新邀请有礼controller
#import "SSH_TuiSongSheZhiController.h"//推送设置
#import "SSH_ShenFenZhengRenZhengViewController.h"
#import "SSH_FenXiaoViewController.h" //分销
#import "SSH_XTXXViewController.h"
#import "SSH_MemberViewController.h"//会员
#import "SSH_ZYViewController.h"    //展业
#import "SSH_CreditToolViewController.h"//工具

#import <PDBotKit/PDBotKit.h>

@interface SSH_GeRenZhongXinController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isShowFX;//是否展示分销
}
@property (nonatomic, strong) UITableView *mineTableView;
@property (nonatomic, strong) NSArray *listImgArray;
@property (nonatomic, strong) NSArray *listTitleArray;
@property (nonatomic, strong) UIImageView *headImgView;//头像
@property (nonatomic, strong) UILabel *phoneNumberLabel;//手机号label
@property (nonatomic, strong) SSH_GeRenXinXiModel * infoModel;
@property (nonatomic, strong) SSH_DingYueHaoModel *gzhModel;

@property(nonatomic,strong)NSString *liaoTianKey;
@property(nonatomic,strong)UIViewController *controller;
/*
 新版本
 */
@property (strong, nonatomic) IBOutlet UILabel *RZLab;
@property (strong, nonatomic) IBOutlet UIImageView *TXImg;
@property (strong, nonatomic) IBOutlet UILabel *userLab;
@property (strong, nonatomic) IBOutlet UILabel *jinBiLab;
@property (strong, nonatomic) IBOutlet UILabel *shouRuLab;
@property (strong, nonatomic) IBOutlet UILabel *tiXianLab;
@property (strong, nonatomic) IBOutlet UILabel *xinDaiLab;
@property (strong, nonatomic) IBOutlet UIImageView *tiShiImg;
@property (strong, nonatomic) IBOutlet UILabel *tiShiLab;
@property (strong, nonatomic) IBOutlet UIImageView *vipImg;

/*
 新版本
 */

@end

@implementation SSH_GeRenZhongXinController
//是否认证（0：未认证  1：已认证   2:认证中   3:认证失败） DENGFANGUserInfoURL
#pragma mark 获取用户信息
-(void)getDENGFANGUserInfoData{
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]};
    
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGUserInfoURL parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"获取用户信息 数据 %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {

            self.infoModel = [[SSH_GeRenXinXiModel alloc]init];
            if ([diction[@"data"] isKindOfClass:NSDictionary.class]) {
                [self.infoModel setValuesForKeysWithDictionary:diction[@"data"]];
            }
            if ([self.infoModel.isAuth intValue] == 1 && [self.infoModel.isFaceCheck intValue] == 1) {
                [DENGFANGSingletonTime shareInstance].isTongguoIDRenZheng = 1;
            }else{
                [DENGFANGSingletonTime shareInstance].isTongguoIDRenZheng = 0;
            }
            
            if([self.infoModel.isAuth intValue] == 1 && [self.infoModel.isFaceCheck intValue] == 1){
                self.tiShiImg.image = [UIImage imageNamed:@"shenfen-yirenzheng"];
                self.RZLab.text = @"已认证";
                self.tiShiLab.text = @"";
            }else if([self.infoModel.isAuth intValue] == 2){
                self.tiShiImg.image = [UIImage imageNamed:@"shenfen-zhong"];
                self.tiShiLab.text = @"";
                self.RZLab.text = @"未认证";
            }else if([self.infoModel.isAuth intValue] == 3){
                self.tiShiImg.image = [UIImage imageNamed:@"shenfen-shibai"];
                self.tiShiLab.text = @"";
                self.RZLab.text = @"未认证";
            }else{
                self.tiShiImg.image = [UIImage imageNamed:@"qipao"];
                self.tiShiLab.text = @"通过后可抢单";
                self.RZLab.text = @"未认证";
            }
            
            self.jinBiLab.text = [NSString stringWithFormat:@"%@",self.infoModel.coinNum];
            if ([self.infoModel.isVip isEqualToString:@"0"]) {
                self.vipImg.image = [UIImage imageNamed:@""];
            } else {
                [self.vipImg sd_setImageWithURL:[NSURL URLWithString:self.infoModel.markUrl]];
            }
            if (self.infoModel.photoUrl.length == 0) {
                self.TXImg.image = [UIImage imageNamed:@"头像"];
            } else {
                self.TXImg.layer.cornerRadius = self.TXImg.frame.size.width/2;
                [self.TXImg sd_setImageWithURL:[NSURL URLWithString:self.infoModel.photoUrl]];
            }
            
            
            [self.mineTableView reloadData];
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.infoModel.photoUrl] placeholderImage:[UIImage imageNamed:@"touxiang_moren"]];

            self.userLab.text = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGShowPhoneKey];
            [self getDENGFANGFenXiaoInfo];

        }else if ([diction[@"code"] isEqualToString:@"10014"]){
            
            [self tuiChuLoginAction];
        }else if ([diction[@"code"] isEqualToString:@"10004"]) {
            [self tuiChuLoginAction];
            [SSH_ZhangHaoDongJieView showInSuperView:diction[@"msg"]];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];

}

#pragma mark 获取用户分销信息测试接口
-(void)getDENGFANGFenXiaoInfo {
    
    
    [[DENGFANGRequest shareInstance] postWithUrl:[NSString stringWithFormat:@"%@dist/myAccount",[DENGFANGSingletonTime shareInstance].fenXiaoLianJie] parameters:@{@"mobile":[DENGFANGSingletonTime shareInstance].mobileString} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"result"] isEqualToString:@"200"]) {
            id data = diction[@"data"];
            if ([data isKindOfClass:NSNumber.class]) {
                self.shouRuLab.text = @"0";
                self.tiXianLab.text = @"0";
            } else {
                NSDictionary *dic = diction[@"data"];
                self.shouRuLab.text = [self eliminateZeroWithString:dic[@"totalMoney"] Double:2];
                self.tiXianLab.text = [self eliminateZeroWithString:dic[@"residue"] Double:2];
            }
        } else {
            
        }
    } fail:^(NSError *error) {
        
    }];
}
//FIXME: 设置double
- (NSString *)eliminateZeroWithString:(NSString *)string Double:(NSInteger)integer{
    
    NSString *str = [string copy];
    double fdouble = [str doubleValue];
    NSString *ftotal;
    switch (integer) {
        case 1:
            ftotal = [NSString stringWithFormat:@"%.1f", fdouble];
            break;
        case 2:
            ftotal = [NSString stringWithFormat:@"%.2f", fdouble];
            break;
        case 3:
            ftotal = [NSString stringWithFormat:@"%.3f", fdouble];
            break;
        case 4:
            ftotal = [NSString stringWithFormat:@"%.4f", fdouble];
            break;
        case 5:
            ftotal = [NSString stringWithFormat:@"%.5f", fdouble];
            break;
        default:
            break;
    }
    while ([ftotal hasSuffix:@"0"]) {
        ftotal = [ftotal substringToIndex:[ftotal length]-1];
    }
    if ([ftotal hasSuffix:@"."]) {
        ftotal = [ftotal substringToIndex:[ftotal length]-1];
    }
    return ftotal;
}

#pragma mark - 退出登录事件
- (void)tuiChuLoginAction{

    [[NSNotificationCenter defaultCenter] postNotificationName:DENGFANGLogOutObserverName object:nil];
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popViewControllerAnimated:NO];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick event:@"my"];
    self.navigationController.navigationBar.hidden = YES;
    [self getDENGFANGUserInfoData];
    
    [self getOpenFenXiao];
    //获取机器人聊天appKey
    [self getLiaoTianAppKey];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.navigationView.hidden = YES;
    self.gzhModel = [[SSH_DingYueHaoModel alloc] init];
    
    self.listImgArray = @[@[@"zhanghu",@"shenfenrenzheng",@"weixinhao",@"wode_yaoqing",@"dailiren_jihua"],@[@"tuiguang_youqian"],@[@"bangzhu",@"xiaoxituisong",@"shezhi"]];
    self.listTitleArray = @[@[@"账户",@"身份认证",@"微信号  (关注微信号，了解更多惊喜)",@"邀请有礼"],@[@"推广有钱"],@[@"帮助",@"消息推送设置",@"设置"]];
    
    
    [self gongzhonghaoData];
    [self configTableView];
}

#pragma mark - 获取机器人聊天appKey
-(void)getLiaoTianAppKey{
    
    NSString *url = @"sys/getRobotAppKey";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = [NSString yf_getNowTimestamp];
    dict[@"signs"] = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil];
    
    [[DENGFANGRequest shareInstance] getWithUrlString:url parameters:dict success:^(id responseObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([diction[@"code"] isEqualToString:@"200"]) {
            self.liaoTianKey = diction[@"data"][@"appKey"];

            [[PDBotKitClient sharedClient] initWithAccessKey:self.liaoTianKey];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

#pragma mark - 获取是否l打开分销入口
- (void)getOpenFenXiao {
    NSDictionary * dic = @{
                           @"timestamp":[NSString yf_getNowTimestamp],
                           @"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil],
                           @"sysTemCode":@"DISTRIBUTION"};
    
    NSString *url = @"sys/getSysTemInfo";
    
    [[DENGFANGRequest shareInstance] postWithUrlString:url parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            NSDictionary *dic = diction[@"data"];
            if ([dic isKindOfClass:NSNull.class] || [dic[@"isOpen"] isEqualToString:@"1"]) {
                self->isShowFX = NO;
            } else {
                self->isShowFX = YES;
            }
            [self.mineTableView reloadData];
        }
    } fail:^(NSError *error) {
    }];
}

#pragma mark - 公众号数据请求
- (void)gongzhonghaoData{
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGGetWechatImgURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil]} success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [self.gzhModel setValuesForKeysWithDictionary:diction[@"data"]];
            [DENGFANGSingletonTime shareInstance].systemImgUrl = self.gzhModel.systemImgUrl;
            [DENGFANGSingletonTime shareInstance].systemName = self.gzhModel.systemName;
            [DENGFANGSingletonTime shareInstance].systemName = self.gzhModel.systemMsg;
        }else if ([diction[@"code"] isEqualToString:@"10014"]){
            
            [self tuiChuLoginAction];
        }else if ([diction[@"code"] isEqualToString:@"10004"]) {
            [self tuiChuLoginAction];
            [SSH_ZhangHaoDongJieView showInSuperView:diction[@"msg"]];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 头像点击事件
-(void)headImgTap{
    [MobClick event:@"my-information"];
    SSH_GeRenXinXiController * infoVC = [[SSH_GeRenXinXiController alloc]init];
    infoVC.hidesBottomBarWhenPushed = YES;
    infoVC.isFaceCheck = [self.infoModel.isFaceCheck integerValue];
    infoVC.isAuth = [self.infoModel.isAuth integerValue];
    infoVC.headUrl = self.infoModel.photoUrl;
    [self.navigationController pushViewController:infoVC animated:YES];
}

#pragma mark - cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            [MobClick event:@"my-account"];
            SSH_WoDeZhangHuController *accountVC = [[SSH_WoDeZhangHuController alloc] init];
            accountVC.hidesBottomBarWhenPushed = YES;
            accountVC.coinNum = self.infoModel.coinNum;
            [self.navigationController pushViewController:accountVC animated:YES];
        }else if (indexPath.row == 1) {
            [MobClick event:@"my-ID"];
            SSH_New_RZViewController * idVC = [[SSH_New_RZViewController alloc]init];
            idVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:idVC animated:YES];
            
        }else if (indexPath.row == 2) {
            [MobClick event:@"my-WeChat"];
            SSH_DingYueHaoModel *m = [[SSH_DingYueHaoModel alloc] init];
            SSH_WeChatAlertView *wexinAlertView = [[SSH_WeChatAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            m.titleText = self.gzhModel.systemName;
            
            
            NSRange range = [self.gzhModel.systemMsg rangeOfString:@"#"];
            
            m.contentText1 = [self.gzhModel.systemMsg substringToIndex:range.location];
            m.contentText2 = [self.gzhModel.systemMsg substringFromIndex:range.location+1];
            
            
            wexinAlertView.dingYueHaoModel = m;
            
            [wexinAlertView.QRCodeImgview sd_setImageWithURL:[NSURL URLWithString:self.gzhModel.systemImgUrl]];
            
            [wexinAlertView.jumpButton addTarget:self action:@selector(gotoWeChat) forControlEvents:UIControlEventTouchUpInside];
        }else if (indexPath.row == 3) {
            [MobClick event:@"my-activity"];
            SSH_YaoQingViewController *yaoqing = [[SSH_YaoQingViewController alloc] init];
            yaoqing.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:yaoqing animated:YES];
        }else{
            SSH_FenXiaoViewController *vc = [[SSH_FenXiaoViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [MobClick event:@"my-help"];
            SSH_BangZhuZhongXinController *helpVC = [[SSH_BangZhuZhongXinController alloc] init];
            helpVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:helpVC animated:YES];
        }else if (indexPath.row == 1){
            [MobClick event:@"my-personal"];
            SSH_TuiSongSheZhiController *helpVC = [[SSH_TuiSongSheZhiController alloc] init];
            helpVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:helpVC animated:YES];
        }else{
            [MobClick event:@"my-set"];
            SSH_SheZhiController *setVC = [[SSH_SheZhiController alloc] init];
            setVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setVC animated:YES];
        }
    } else {
        SSH_FenXiaoViewController *vc = [[SSH_FenXiaoViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark WeChat&QQ跳转点击事件
-(void) gotoWeChat{
    
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    //先判断是否能打开该url
    if (canOpen)
    {   //打开微信
        [[UIApplication sharedApplication] openURL:url];
    }else {
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [SSH_TOOL_GongJuLei showAlter:window WithMessage:@"您未安装微信"];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseID = @"DENGFANGMineListTableViewCell";
    SSH_GeRenZhongXinListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[SSH_GeRenZhongXinListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.selectionStyle = 0;
    cell.leftImgView.image = [UIImage imageNamed:self.listImgArray[indexPath.section][indexPath.row]];
    cell.cellTitle.text = self.listTitleArray[indexPath.section][indexPath.row];
    
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.rightJinBiLabel.hidden = NO;
            cell.rightJinBiLabel.text =  [NSString stringWithFormat:@"%@金币",self.infoModel.coinNum];
        }else if (indexPath.row == 1) {
            cell.rightYiShiMing.hidden = NO;
//            0：未认证  1：已认证   2:认证中   3:认证失败
            NSLog(@"%@",self.infoModel.isAuth);
//            NSLog(@"%@",self.infoModel.isFaceCheck);
            if([self.infoModel.isAuth intValue] == 1 && [self.infoModel.isFaceCheck intValue] == 1){
                cell.rightYiShiMing.image = [UIImage imageNamed:@"shenfen-yirenzheng"];
            }else if([self.infoModel.isAuth intValue] == 2){
                cell.rightYiShiMing.image = [UIImage imageNamed:@"shenfen-zhong"];
            }else if([self.infoModel.isAuth intValue] == 3){
                cell.rightYiShiMing.image = [UIImage imageNamed:@"shenfen-shibai"];
            }else{
                cell.rightYiShiMing.hidden = YES;
                NSString *string = @"身份认证（通过认证后才可以抢单哦!）";
                NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string];
                NSRange range = [string rangeOfString:@"（通过认证后才可以抢单哦!）"];
                [att beginEditing];
                [att setAttributes:@{NSFontAttributeName:UIFONTTOOL13,NSForegroundColorAttributeName:COLOR_With_Hex(0x999999)} range:range];
                
                cell.cellTitle.attributedText = att;
            }
        }else if (indexPath.row == 2){
            NSString *string = @"微信号  (关注微信号，了解更多惊喜)";
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:string];
            NSRange range = [string rangeOfString:@"(关注微信号，了解更多惊喜)"];
            [att beginEditing];
            [att setAttributes:@{NSFontAttributeName:UIFONTTOOL13,NSForegroundColorAttributeName:COLOR_With_Hex(0x999999)} range:range];
            
            cell.cellTitle.attributedText = att;
        }else if(indexPath.row == 3){
            
        }else if (indexPath.row == 4){
            
        }
        
    } else if (indexPath.section == 1) {
        cell.hotImage.image = [UIImage imageNamed:@"HOT"];
        cell.hotImage.hidden = NO;
    }
    
    return cell;
}


- (void)configTableView{
    
    UIView *topRedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    [self.view addSubview:topRedView];
    topRedView.backgroundColor = ColorZhuTiHongSe;
    
    self.mineTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.mineTableView];
    self.mineTableView.delegate = self;
    self.mineTableView.dataSource = self;
    self.mineTableView.bounces = NO;
    self.mineTableView.scrollEnabled = NO;
    self.mineTableView.showsVerticalScrollIndicator = NO;
    self.mineTableView.backgroundColor = ColorBackground_Line;
    [self.mineTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    self.mineTableView.separatorColor = ColorLineeee;
    UIView *footerView = [UIView new];
    self.mineTableView.tableFooterView = footerView;
    
    UIView *headerView = [[NSBundle mainBundle] loadNibNamed:@"SSH_GRZXXibView" owner:self options:nil].lastObject;
    self.xinDaiLab.text = [NSString stringWithFormat:@"信%@工具",[DENGFANGSingletonTime shareInstance].name[1]];
    self.mineTableView.tableHeaderView = headerView;
    
}

-(void)clickSeriviceButton{

    UIViewController *controller = [[PDUIChatController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    self.controller = controller;
    [self.navigationController pushViewController:controller animated:YES];
    controller.navigationController.navigationBar.hidden = NO;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"jiantou_zuo_heise"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    btn.size = CGSizeMake(40.5, 44);
    
//    controller.navigationItem.hidesBackButton = YES;
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}

-(void)clickBackBtn{
    [self.controller.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [self.listTitleArray[0] count];
    } else if (section == 1) {
        return [self.listTitleArray[1] count];
    } else{
        return [self.listTitleArray[2] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isShowFX) {
        return 55;
    } else {
        if (indexPath.section == 1) {
            return 0;
        }
        return 55;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeaderView = [[UIView alloc] init];
    if (isShowFX) {
        sectionHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 7);
    } else {
        if (section == 1) {
            sectionHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        } else {
            sectionHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 7);
        }
    }
    
    sectionHeaderView.backgroundColor = ColorBackground_Line;
    return sectionHeaderView;
}
/**
 设置
 */
- (IBAction)toSettingController:(UIButton *)sender {
    [MobClick event:@"my-set"];
    SSH_SheZhiController *setVC = [[SSH_SheZhiController alloc] init];
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
}
/**
 消息
 */
- (IBAction)toMyMessageController:(UIButton *)sender {
    SSH_XTXXViewController *mesgVC = [[SSH_XTXXViewController alloc] init];
    mesgVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mesgVC animated:YES];
}
/**
 我的会员
 */
- (IBAction)toMyVipController:(UIButton *)sender {
    SSH_MemberViewController *menber = [[SSH_MemberViewController alloc] init];
    menber.hidesBottomBarWhenPushed = YES;
    menber.type = 2;
    [self.navigationController pushViewController:menber animated:YES];
}
/**
 头像-账户-收入-体现-明细-订单
 */
- (IBAction)headerButtonDidSelected:(UIButton *)sender {
    switch (sender.tag) {
        case 4300:
        {
            //头像
            [MobClick event:@"my-information"];
            SSH_GeRenXinXiController * infoVC = [[SSH_GeRenXinXiController alloc]init];
            infoVC.hidesBottomBarWhenPushed = YES;
            infoVC.isFaceCheck = [self.infoModel.isFaceCheck integerValue];
            infoVC.isAuth = [self.infoModel.isAuth integerValue];
            infoVC.headUrl = self.infoModel.photoUrl;
            [self.navigationController pushViewController:infoVC animated:YES];
        }
            break;
        case 4301:
        {
            //账户(金币)
            [MobClick event:@"my-account"];
            SSH_WoDeZhangHuController *accountVC = [[SSH_WoDeZhangHuController alloc] init];
            accountVC.hidesBottomBarWhenPushed = YES;
            accountVC.coinNum = self.infoModel.coinNum;
            [self.navigationController pushViewController:accountVC animated:YES];
        }
            break;
        case 4302:
        {
            //总收入(元)
        }
            break;
        case 4303:
        {
            [MobClick event:@"cashwithdrawal"];
            //可提现  ---- /#/tixian
            if (isShowFX) {
                SSH_FenXiaoViewController *fxVC = [[SSH_FenXiaoViewController alloc] init];
                fxVC.hidesBottomBarWhenPushed = YES;
                fxVC.otherUrl = @"/#/tixian";
                [self.navigationController pushViewController:fxVC animated:YES];
            } else {
                [MBProgressHUD showError:@"此功能暂未上线，敬请期待。"];
            }
        }
            break;
        case 4304:
        {
            //收入明细 ----/#/incomedetails
            [MobClick event:@"Incomedetalis"];
            if (isShowFX) {
                SSH_FenXiaoViewController *fxVC = [[SSH_FenXiaoViewController alloc] init];
                fxVC.hidesBottomBarWhenPushed = YES;
                fxVC.otherUrl = @"/#/incomedetails";
                [self.navigationController pushViewController:fxVC animated:YES];
            } else {
                [MBProgressHUD showError:@"此功能暂未上线，敬请期待。"];
            }
        }
            break;
        case 4305:
        {
            //订单列表 ----/#/orders
            [MobClick event:@"orderlist"];
            if (isShowFX) {
                SSH_FenXiaoViewController *fxVC = [[SSH_FenXiaoViewController alloc] init];
                fxVC.hidesBottomBarWhenPushed = YES;
                fxVC.otherUrl = @"/#/orders";
                [self.navigationController pushViewController:fxVC animated:YES];
            } else {
                [MBProgressHUD showError:@"此功能暂未上线，敬请期待。"];
            }
        }
            break;
        default:
            break;
    }
}
/**
 下方
 */
- (IBAction)jiaCollectionViewCell:(UIButton *)sender {
    switch (sender.tag) {
        case 5000:{
            //我的会员
            SSH_MemberViewController *menber = [[SSH_MemberViewController alloc] init];
            menber.hidesBottomBarWhenPushed = YES;
            menber.type = 2;
            [self.navigationController pushViewController:menber animated:YES];
        }
            break;
        case 5001:{
            
            //认证
            [MobClick event:@"my-ID"];
            SSH_New_RZViewController *idVC = [[SSH_New_RZViewController alloc]init];
            idVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:idVC animated:YES];
        }break;
        case 5002:{
            //邀请
            [MobClick event:@"my-activity"];
            SSH_YaoQingViewController *yaoqing = [[SSH_YaoQingViewController alloc] init];
            yaoqing.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:yaoqing animated:YES];
        }break;
        case 5003:{
            //推送
            [MobClick event:@"my-personal"];
            SSH_TuiSongSheZhiController *helpVC = [[SSH_TuiSongSheZhiController alloc] init];
            helpVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:helpVC animated:YES];
        }break;
        case 5004:{
            //客服
            [self clickSeriviceButton];
        }break;
        case 5005:{
            //信贷工具
            SSH_CreditToolViewController *cred = [[SSH_CreditToolViewController alloc] init];
            cred.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cred animated:YES];
        }break;
        case 5006:{
            //展业海报
            SSH_ZYViewController *zy = [[SSH_ZYViewController alloc] init];
            zy.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:zy animated:YES];
        }break;
        case 5007:{
            //帮助中心
            [MobClick event:@"my-help"];
            SSH_BangZhuZhongXinController *helpVC = [[SSH_BangZhuZhongXinController alloc] init];
            helpVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:helpVC animated:YES];
        }break;
        case 5008:{
            //微信公众号
            [MobClick event:@"my-WeChat"];
            SSH_DingYueHaoModel *m = [[SSH_DingYueHaoModel alloc] init];
            SSH_WeChatAlertView *wexinAlertView = [[SSH_WeChatAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            m.titleText = self.gzhModel.systemName;
            NSRange range = [self.gzhModel.systemMsg rangeOfString:@"#"];
            m.contentText1 = [self.gzhModel.systemMsg substringToIndex:range.location];
            m.contentText2 = [self.gzhModel.systemMsg substringFromIndex:range.location+1];
            wexinAlertView.dingYueHaoModel = m;
            [wexinAlertView.QRCodeImgview sd_setImageWithURL:[NSURL URLWithString:self.gzhModel.systemImgUrl]];
            [wexinAlertView.jumpButton addTarget:self action:@selector(gotoWeChat) forControlEvents:UIControlEventTouchUpInside];
        }break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (isShowFX) {
        return 7;
    } else {
        if (section == 1) {
            return 0;
        } else {
            return 7;
        }
    }
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
