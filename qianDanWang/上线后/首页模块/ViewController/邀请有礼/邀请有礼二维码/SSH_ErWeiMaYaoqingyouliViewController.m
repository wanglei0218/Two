//
//  SSH_ErWeiMaYaoqingyouliViewController.m
//  DENGFANGSC
//
//  Created by LY on 2018/12/11.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ErWeiMaYaoqingyouliViewController.h"
#import "SSH_ShareView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "SSH_YaoQingFenXiangModel.h"

#define buttonWidth ([UIScreen mainScreen].bounds.size.width-47-10-47)*0.5

@interface SSH_ErWeiMaYaoqingyouliViewController ()<UITableViewDelegate,UITableViewDataSource,SSH_ShareViewViewDelegate>

@property (nonatomic, strong) UITableView *erweima_tableView;//规则tableView
@property (nonatomic, strong) UILabel *yaoqingmaLabel;//您的邀请码
@property (nonatomic, strong) UIImageView *erweima_imgView;//二维码
@property (nonatomic, strong) UIView *headView;//头布局


@property(nonatomic,strong)SSH_ShareView *shareAlertView;

@property(nonatomic,strong)SSH_YaoQingFenXiangModel *yaoQingModel;

@end

@implementation SSH_ErWeiMaYaoqingyouliViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text = @"邀请有礼";
    [self setupTableView];
    
    [self getInviteData];
}

//创建tableView
- (void)setupTableView{
    
    self.erweima_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.normalBackView addSubview:self.erweima_tableView];
    self.erweima_tableView.delegate = self;
    self.erweima_tableView.dataSource = self;
    self.erweima_tableView.backgroundColor = COLOR_With_Hex(0xfb5a36);
    [self.erweima_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self setupHeadView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
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
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 523)];
    self.erweima_tableView.tableHeaderView = self.headView;
    
    UIImageView *back_imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yaoqingyouli_background"]];
    [self.headView addSubview:back_imgView];
    [back_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    //顶部图片
    UIImageView *top_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiugai_yaoqing_erweima_top"]];
    [self.headView addSubview:top_imageView];
    [top_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(375);
        make.height.mas_equalTo(253);
        make.centerX.mas_equalTo(self.headView);
    }];
    
    //您的邀请码
    self.yaoqingmaLabel = [[UILabel alloc] init];
    [top_imageView addSubview:self.yaoqingmaLabel];
    self.yaoqingmaLabel.font = UIFONTTOOL(20);
    self.yaoqingmaLabel.textColor = COLOR_WITH_HEX(0xff2b01);
    self.yaoqingmaLabel.textAlignment = 1;
    self.yaoqingmaLabel.text = [NSString stringWithFormat:@"邀请码：%@",self.yaoqingmaString];
    [self.yaoqingmaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-22);
        make.height.mas_equalTo(20);
    }];
    
    //第二张图片
    UIImageView *secondImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiugai_yaoqing_erweima_bottom"]];
    [self.headView addSubview:secondImgView];
    secondImgView.userInteractionEnabled = YES;
    [secondImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(375);
        make.centerX.mas_equalTo(self.normalBackView);
        make.top.mas_equalTo(top_imageView.mas_bottom);
        make.height.mas_equalTo(270);
    }];
    
    //二维码背景
    UIView *erweima_beijing_view = [[UIView alloc] init];
    [secondImgView addSubview:erweima_beijing_view];
    erweima_beijing_view.layer.masksToBounds = YES;
    erweima_beijing_view.layer.cornerRadius = 12;
    erweima_beijing_view.backgroundColor = COLOR_With_Hex(0xffddd5);
    [erweima_beijing_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.width.height.mas_equalTo(164);
        make.centerX.mas_equalTo(secondImgView);
    }];
    
    //二维码
    self.erweima_imgView = [[UIImageView alloc] init];
    [self.erweima_imgView sd_setImageWithURL:[NSURL URLWithString:self.erweimaImgString]];
    [erweima_beijing_view addSubview:self.erweima_imgView];
    [self.erweima_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(150);
        make.centerX.centerY.mas_equalTo(erweima_beijing_view);
    }];
    
    //二维码描述
    UILabel *miaoshu_label = [[UILabel alloc] init];
    [secondImgView addSubview:miaoshu_label];
    miaoshu_label.text = @"扫描二维码下载app，注册时请输入邀请码";
    miaoshu_label.font = UIFONTTOOL14;
    miaoshu_label.textColor = COLOR_With_Hex(0xd4995b);
    miaoshu_label.textAlignment = 1;
    [miaoshu_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(erweima_beijing_view.mas_bottom).offset(27);
        make.height.mas_equalTo(14);
    }];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 73)];
    self.erweima_tableView.tableFooterView = footView;
    footView.backgroundColor = COLOR_With_Hex(0xfb5a36);
    
//    //保存图片
//    UIButton *baocun_tupian_button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [footView addSubview:baocun_tupian_button];
//    [baocun_tupian_button setImage:[UIImage imageNamed:@"yaoqing_erweima_baocun"] forState:UIControlStateNormal];
//    [baocun_tupian_button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(296);
//        make.height.mas_equalTo(58);
//        make.centerX.mas_equalTo(footView);
//        make.top.mas_equalTo(0);
//    }];
//    [baocun_tupian_button addTarget:self action:@selector(saveImgToAlbum) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *fenxiang_tupian_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [footView addSubview:fenxiang_tupian_button];
    [fenxiang_tupian_button setImage:[UIImage imageNamed:@"xiugai_yaoqing_erweima_fenxiang"] forState:UIControlStateNormal];
    [fenxiang_tupian_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(58);
        make.left.mas_equalTo(47);
        make.top.mas_equalTo(0);
    }];
    [fenxiang_tupian_button addTarget:self action:@selector(shareQRCode) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *baocun_tupian_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [footView addSubview:baocun_tupian_button];
    [baocun_tupian_button setImage:[UIImage imageNamed:@"xiugai_yaoqing_erweima_baocun"] forState:UIControlStateNormal];
    [baocun_tupian_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(58);
        make.right.mas_equalTo(-47);
        make.top.mas_equalTo(0);
    }];
    [baocun_tupian_button addTarget:self action:@selector(saveImgToAlbum) forControlEvents:UIControlEventTouchUpInside];
}

- (void)saveImgToAlbum{
    
    UIImageWriteToSavedPhotosAlbum([self snapshotSingleView:self.headView], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

-(void)shareQRCode{

    self.shareAlertView = [[SSH_ShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.shareAlertView showShareAlertView];
    self.shareAlertView.delegate = self;
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
    
    NSLog(@"%@",self.yaoQingModel.inviteGiftImgUrl);
    
    NSArray * imageArray = @[img];
    
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



#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"保存图片失败"];
    }else{
        msg = @"保存图片成功" ;
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"保存图片成功"];
    }
}
//
-(UIImage *)snapshotSingleView:(UIView *)view
{
    //ttyydd-graphics:制图法 制图法开始图片环境（上下文），设置size，opaque，scale
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    //ttyydd-用view.layer 在当前上下文中渲染
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //ttyydd-制图法从当前图片上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //ttyydd-制图法结束图形上下文。
    UIGraphicsEndImageContext();
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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



@end
