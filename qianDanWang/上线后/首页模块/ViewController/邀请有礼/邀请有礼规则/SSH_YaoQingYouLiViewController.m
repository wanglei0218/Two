//
//  SSH_YaoQingYouLiViewController.m
//  DENGFANGSC
//
//  Created by LY on 2018/12/11.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_YaoQingYouLiViewController.h"
#import "SSH_JiangLiGuiZeTableViewCell.h"//奖励规则cell
#import "SSH_ErWeiMaYaoqingyouliViewController.h"//二维码保存controller
#import "SSH_MyYongJinViewController.h"//我的佣金
#import "SSH_ShareView.h"

#import <ShareSDKUI/ShareSDKUI.h>
#import "SSH_YaoQingFenXiangModel.h"

@interface SSH_YaoQingYouLiViewController ()<UITableViewDelegate,UITableViewDataSource,SSH_ShareViewViewDelegate>

@property (nonatomic, strong) UITableView *guize_tableView;//规则tableView
@property (nonatomic, strong) UILabel *yaoqingmaLabel;//您的邀请码
@property (nonatomic, strong) NSString *yaoqingma_string;//邀请码
@property (nonatomic, strong) NSString *yaoqing_erweima_imgString;//二维码链接
@property (nonatomic, strong) NSString *jiangli_guize_string;//奖励规则
@property (nonatomic, strong) NSMutableArray *guize_Array;//规则数组
@property (nonatomic, strong) UIView *tableFootView;
@property (nonatomic, strong) UILabel *guizeLabel;//奖励规则label
@property(nonatomic,strong)SSH_ShareView *shareAlertView;

@property(nonatomic,strong)SSH_YaoQingFenXiangModel *yaoQingModel;

@end

@implementation SSH_YaoQingYouLiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text = @"邀请有礼";
    self.guize_Array = [NSMutableArray array];
    [self setupTableView];
    [self loadYaoqingData];
}

- (void)loadYaoqingData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.normalBackView animated:YES];
    
    NSString *useidString = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGYaoQingYouLiURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:useidString]} success:^(id responseObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
//            [hud hideAnimated:YES];
            self.yaoqingma_string = diction[@"data"][@"inviteCode"];
            self.yaoqing_erweima_imgString = diction[@"data"][@"qrCodeUrl"];
            self.jiangli_guize_string = diction[@"data"][@"rewardRules"];
            
            self.yaoqingmaLabel.text = [NSString stringWithFormat:@"您的邀请码：%@",self.yaoqingma_string];
            
            CGRect guizeRect = [self.jiangli_guize_string boundingRectWithSize:CGSizeMake(ScreenWidth-40, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:UIFONTTOOL13} context:nil];
            self.tableFootView.frame = CGRectMake(0, 0, ScreenWidth, guizeRect.size.height+40);
            self.guize_tableView.tableFooterView = self.tableFootView;
            self.guizeLabel.frame = CGRectMake(20, 0, ScreenWidth-40, guizeRect.size.height+10);
            self.guizeLabel.text = self.jiangli_guize_string;
            
            //分享的数据
            [self getInviteData];
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
        [hud hideAnimated:YES];
    } fail:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}
//分享出去的数据
-(void)getInviteData{
    
    NSString *url = @"user/getInviteUrl";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = [NSString yf_getNowTimestamp];
    dict[@"signs"] = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]];
    dict[@"userId"] = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
    
    [[DENGFANGRequest shareInstance] postWithUrlString:url parameters:dict success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        //        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]){
            
            self.yaoQingModel = [SSH_YaoQingFenXiangModel mj_objectWithKeyValues:diction];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:[NSString stringWithFormat:@"%@",error]];
    }];
}

//创建tableView
- (void)setupTableView{
    
    self.guize_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.normalBackView addSubview:self.guize_tableView];
    self.guize_tableView.delegate = self;
    self.guize_tableView.dataSource = self;
    [self.guize_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.guize_tableView.backgroundColor = COLOR_With_Hex(0xfb5a36);
    [self setupHeadView];
    
    self.tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    self.guize_tableView.tableFooterView = self.tableFootView;
    
    self.guizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-40, 20)];
    [self.tableFootView addSubview:self.guizeLabel];
    self.guizeLabel.font = UIFONTTOOL13;
    self.guizeLabel.textColor = COLORWHITE;
    self.guizeLabel.numberOfLines = 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = @"SSH_JiangLiGuiZeTableViewCell";
    SSH_JiangLiGuiZeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[SSH_JiangLiGuiZeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    return cell;
}

//高度要根据返回数据进行计算
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

//设置tableView
- (void)setupHeadView{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 527)];
    self.guize_tableView.tableHeaderView = headView;
    
    UIImageView *back_imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yaoqingyouli_background"]];
    [headView addSubview:back_imgView];
    [back_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    //顶部图片
    UIImageView *top_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yaoqingyouli_top"]];
    [headView addSubview:top_imageView];
    [top_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(375);
        make.height.mas_equalTo(253);
        make.centerX.mas_equalTo(headView);
    }];
    
    //邀请码提示
//    UILabel *yaoqingmaAlertLabel = [[UILabel alloc] init];
//    [top_imageView addSubview:yaoqingmaAlertLabel];
//    yaoqingmaAlertLabel.textColor = COLOR_WITH_HEX(0x8f5b24);
//    yaoqingmaAlertLabel.font = UIFONTTOOL(12);
//    yaoqingmaAlertLabel.textAlignment = 1;
//    yaoqingmaAlertLabel.text = @"请提示您的好友注册时输入邀请码!";
//    [yaoqingmaAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(-17);
//        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(12);
//    }];
//
//    //您的邀请码
//    self.yaoqingmaLabel = [[UILabel alloc] init];
//    [top_imageView addSubview:self.yaoqingmaLabel];
//    self.yaoqingmaLabel.font = UIFONTTOOL(15);
//    self.yaoqingmaLabel.textColor = COLOR_WITH_HEX(0x8f5b24);
//    self.yaoqingmaLabel.textAlignment = 1;
//    [self.yaoqingmaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(yaoqingmaAlertLabel.mas_top).offset(-10);
//        make.height.mas_equalTo(15);
//    }];
//
    //第二张图片
    UIImageView *secondImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yaoqingyouli_bottom"]];
    [headView addSubview:secondImgView];
    secondImgView.userInteractionEnabled = YES;
    [secondImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(375);
        make.centerX.mas_equalTo(self.normalBackView);
        make.top.mas_equalTo(top_imageView.mas_bottom);
        make.height.mas_equalTo(221);
    }];
    
    //我的佣金
    UIButton *wode_yongjin_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [secondImgView addSubview:wode_yongjin_button];
    [wode_yongjin_button setTitle:@"我的佣金" forState:UIControlStateNormal];
    wode_yongjin_button.titleLabel.font = UIFONTTOOL13;
    [wode_yongjin_button setTitleColor:COLOR_With_Hex(0xfb5a36) forState:UIControlStateNormal];
    [wode_yongjin_button  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.width.mas_equalTo(61);
        make.bottom.mas_equalTo(-2);
        make.height.mas_equalTo(35);
    }];
    [wode_yongjin_button addTarget:self action:@selector(my_yongjin_action) forControlEvents:UIControlEventTouchUpInside];
    
    //立即邀请
    UIButton *liji_yaoqing_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [secondImgView addSubview:liji_yaoqing_button];
    [liji_yaoqing_button setImage:[UIImage imageNamed:@"yaoqingyouli_lijiyaoqing"] forState:UIControlStateNormal];
    [liji_yaoqing_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(296);
        make.height.mas_equalTo(58);
        make.centerX.mas_equalTo(headView);
        make.bottom.mas_equalTo(-23);
    }];
    [liji_yaoqing_button addTarget:self action:@selector(liji_yaoqing_action) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *jiangli_guize_imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yaoqingyouli_jiangliguize"]];
    [headView addSubview:jiangli_guize_imgView];
    [jiangli_guize_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(133);
        make.height.mas_equalTo(13.5);
        make.top.mas_equalTo(secondImgView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(headView);
    }];
    
}

//立即邀请
- (void)liji_yaoqing_action{
    [MobClick event:@"my-activity-action"];
//    SSH_ErWeiMaYaoqingyouliViewController *erweimaVC = [[SSH_ErWeiMaYaoqingyouliViewController alloc] init];
//    erweimaVC.yaoqingmaString = self.yaoqingma_string;
//    erweimaVC.erweimaImgString = self.yaoqing_erweima_imgString;
//    [self.navigationController pushViewController:erweimaVC animated:YES];
    
    //弹出分享
    self.shareAlertView = [[SSH_ShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.shareAlertView showShareAlertView];
    self.shareAlertView.delegate = self;
    
}

//我的佣金
- (void)my_yongjin_action{
    SSH_MyYongJinViewController *myyongjinVC = [[SSH_MyYongJinViewController alloc] init];
    myyongjinVC.yaoQingMa_String = self.yaoqingma_string;
    [self.navigationController pushViewController:myyongjinVC animated:YES];
}

#pragma mark -分享内部的按钮点击代理
- (void)clickShareButtonAction:(int)index{
    
    SSDKPlatformType type;
    if (index == 0) {
        type = SSDKPlatformSubTypeWechatSession;
        
        if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
            [SSH_TOOL_GongJuLei showAlter:window WithMessage:@"您未安装微信"];
            return;
        }
    }else  if (index == 1) {
        if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
            [SSH_TOOL_GongJuLei showAlter:window WithMessage:@"您未安装微信"];
            return;
        }
        type = SSDKPlatformSubTypeWechatTimeline;
    }else{
        return;
    }
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString                  stringWithFormat:@"%@",self.yaoQingModel.inviteGiftImgUrl]]];
    
    UIImage *img = [UIImage imageWithData:data];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    [imageArray addObject:img==nil?@"":img];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:self.yaoQingModel.inviteGiftSideTitle images:imageArray url:[NSURL URLWithString:self.yaoQingModel.inviteGiftUrl] title:self.yaoQingModel.inviteGiftTitle type:SSDKContentTypeAuto];
    
    [ShareSDK share:type parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateUpload:
                // 分享视频的时候上传回调，进度信息在 userData
                break;
            case SSDKResponseStateSuccess:
                //成功
                break;
            case SSDKResponseStateFail:
            {
                NSLog(@"--%@",error.description);
                //失败
                break;
            }
            case SSDKResponseStateCancel:
                //取消
                break;
                
            default:
                break;
        }
    }];
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
