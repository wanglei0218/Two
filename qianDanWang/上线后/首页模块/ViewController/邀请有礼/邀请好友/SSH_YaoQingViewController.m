//
//  SSH_YaoQingViewController.m
//  qianDanWang
//
//  Created by 小锦鲤 on 2019/6/25.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_YaoQingViewController.h"
#import "SSH_ShareView.h"
#import <ShareSDKUI/ShareSDKUI.h>
#import "SSH_YaoQingFenXiangModel.h"
#import "WXApi.h"

@interface SSH_YaoQingViewController ()<SSH_ShareViewViewDelegate>
{
    NSDictionary *diction;
    //用户邀请码
    NSString *yaoQingCode;
    NSString *registeredCount; //注册用户数
    NSString *authSuccessCount; //认证用户数
    NSString *notAuthCount;     //未认证用户数
    NSString *userInviteCoin;   //获取金币数
    //用户邀请人数
    NSArray *yaoQingArr;
    //邀请详情
    NSDictionary *dataDic;
    UILabel *twoOne;
    //邀请规则
    NSArray *yaoQianGZArr;
}
//蒙版弹出式图
@property (nonatomic, strong)UIView *grayView;
@property (nonatomic, strong)UIView *whiteView;
@property (nonatomic, strong)UIImageView *adImgView;

//本周战绩
@property (weak, nonatomic) IBOutlet UILabel *jinbiLab;
@property (weak, nonatomic) IBOutlet UILabel *registerNum;
@property (weak, nonatomic) IBOutlet UILabel *renZhengNum;
@property (weak, nonatomic) IBOutlet UILabel *noRenZhengNum;

//邀请规则
@property (weak, nonatomic) IBOutlet UILabel *xibOneRen;
@property (weak, nonatomic) IBOutlet UILabel *xibTwoRen;
@property (weak, nonatomic) IBOutlet UILabel *xibThreeRen;
@property (weak, nonatomic) IBOutlet UILabel *xibFourRen;
@property (weak, nonatomic) IBOutlet UILabel *xibGuiZe;
@property (weak, nonatomic) IBOutlet UILabel *xibFuLi;


//弹出视图
@property (nonatomic, strong)SSH_ShareView *shareAlertView;

@property(nonatomic,strong)SSH_YaoQingFenXiangModel *yaoQingModel;

@end

@implementation SSH_YaoQingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text = @"邀请有礼";
    
    self.normalBackView.hidden = YES;
    
    self.view.backgroundColor = COLOR_WITH_HEX(0x7550F6);
    
    [self getbenZhouZhanJi];
    
    
    twoOne = [[UILabel alloc] init];
}


//活动规则
- (IBAction)huoDongGuiZe:(id)sender {
    UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 273, 279)];
    
    UILabel *labOne = [[UILabel alloc] init];
    labOne.text = @"一、奖励方式：";
    labOne.textColor = COLOR_WITH_HEX(0x474747);
    labOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [smallView addSubview:labOne];
    [labOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(43);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    //富文本
    UILabel *yaoqinOne = [[UILabel alloc] init];
    yaoqinOne.attributedText = [self setAttributedStringWithArrayString:yaoQianGZArr[0][@"note"]];
//    yaoqinOne.textColor = COLOR_WITH_HEX(0x888888);
//    yaoqinOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:10];
    [smallView addSubview:yaoqinOne];
    [yaoqinOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labOne.mas_bottom).offset(10);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
    }];
    
    UILabel *yaoqinTwo = [[UILabel alloc] init];
    yaoqinTwo.attributedText = [self setAttributedStringWithArrayString:yaoQianGZArr[1][@"note"]];
//    yaoqinTwo.textColor = COLOR_WITH_HEX(0x888888);
//    yaoqinTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:10];
    [smallView addSubview:yaoqinTwo];
    [yaoqinTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yaoqinOne.mas_bottom).offset(7);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
    }];
    
    UILabel *yaoqinThree = [[UILabel alloc] init];
    yaoqinThree.attributedText = [self setAttributedStringWithArrayString:yaoQianGZArr[2][@"note"]];
//    yaoqinThree.textColor = COLOR_WITH_HEX(0x888888);
//    yaoqinThree.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:10];
    [smallView addSubview:yaoqinThree];
    [yaoqinThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yaoqinTwo.mas_bottom).offset(7);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
    }];
    
    UILabel *youqinFour = [[UILabel alloc] init];
    youqinFour.attributedText = [self setAttributedStringWithArrayString:yaoQianGZArr[3][@"note"]];
//    youqinFour.textColor = COLOR_WITH_HEX(0x888888);
//    youqinFour.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:10];
    [smallView addSubview:youqinFour];
    [youqinFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yaoqinThree.mas_bottom).offset(7);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
    }];
    
    UILabel *remindLab = [[UILabel alloc] init];
    remindLab.attributedText = [self setAttributedStringWithString:yaoQianGZArr[4][@"note"]];
//    remindLab.textColor = COLOR_WITH_HEX(0x888888);
//    remindLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:WidthScale(9)];
    [smallView addSubview:remindLab];
    remindLab.numberOfLines = 0;
    remindLab.textAlignment = NSTextAlignmentCenter;
    [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(youqinFour.mas_bottom).offset(7);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
    }];
    
    UILabel *labTwo = [[UILabel alloc] init];
    labTwo.text = @"二、奖励规则：";
    labTwo.textColor = COLOR_WITH_HEX(0x474747);
    labTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:WidthScale(13)];
    [smallView addSubview:labTwo];
    [labTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(remindLab.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(243);
    }];
    
    
    
    twoOne.textColor = COLOR_WITH_HEX(0x888888);
    twoOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:WidthScale(11)];
    [smallView addSubview:twoOne];
    twoOne.numberOfLines = 0;
    [twoOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labTwo.mas_bottom).offset(7);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [smallView setNeedsLayout];
    [smallView layoutIfNeeded];
    CGFloat height = twoOne.y + twoOne.height + 15;
    [self popAlertViewWithImageName:@"活动规则背景" contentView:smallView height:height];

}
//立即邀请
- (IBAction)liJiYaoQiang:(id)sender {
    [MobClick event:@"Invitattion activitties-1"];
    
    [self getInviteData];
    
    
}
//查看详情
- (IBAction)chaKanXiangQiang:(id)sender {
    [MobClick event:@"Invitattion activitties-4"];
    [self chaKanXiangQiangData];
}

- (void)addXiangQingData {
    UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 273, 279)];
    UILabel *labOne = [[UILabel alloc] init];
    labOne.text = @"已认证";
    labOne.textColor = COLOR_WITH_HEX(0xfb6451);
    labOne.font = [UIFont fontWithName:@"PingFang-SC-medium" size:14];
    [smallView addSubview:labOne];
    NSInteger widthNum = 50*273/279;
    [labOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55);
        make.left.mas_equalTo(widthNum);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *labTwo = [[UILabel alloc] init];
    labTwo.text = @"未认证";
    labTwo.textColor = COLOR_WITH_HEX(0xfb6451);
    labTwo.font = [UIFont fontWithName:@"PingFang-SC-medium" size:14];
    [smallView addSubview:labTwo];
    [labTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55);
        make.right.mas_equalTo(-widthNum);
        make.height.mas_equalTo(15);
    }];
    
    //没有邀请记录
    if (yaoQingArr.count == 0) {
        UILabel *remindLab = [[UILabel alloc] init];
        remindLab.text = @"当前没有记录";
        remindLab.textColor = COLOR_WITH_HEX(0x7f7b77);
        remindLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
        remindLab.textAlignment = NSTextAlignmentCenter;
        [smallView addSubview:remindLab];
        [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(139);
        }];
    } else {
        smallView.tag = 1010;
        //认证人数为0
        NSMutableArray *renZhengArr = [NSMutableArray array];
        NSMutableArray *yaoArr = [NSMutableArray array];
        for (NSDictionary *dic in yaoQingArr) {
            if ([dic[@"isAuth"] integerValue] == 1) {
                [renZhengArr addObject:dic];
            } else {
                [yaoArr addObject:dic];
            }
        }
        if (yaoQingArr.count == 0) {
            UILabel *lab = [[UILabel alloc] init];
            lab.textColor = COLOR_WITH_HEX(0x474747);
            lab.text = @"暂无记录";
            lab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
            [smallView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(labOne.mas_bottom).offset(10);
                make.left.mas_equalTo(0);
                make.width.mas_equalTo(smallView.width/2);
                make.height.mas_equalTo(12);
            }];
            //邀请成功
            UIScrollView *scrollTwo = [[UIScrollView alloc] initWithFrame:CGRectMake(273/2, 0, 273/2, 279)];
            scrollTwo.userInteractionEnabled = YES;
            scrollTwo.showsVerticalScrollIndicator = NO;
            [smallView addSubview:scrollTwo];
            [scrollTwo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(labOne.mas_bottom).offset(0);
                make.width.mas_equalTo(smallView.width_sd/2);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(smallView.mas_bottom).offset(0);
            }];
            scrollTwo.contentSize = CGSizeMake(smallView.frame.size.width/2, yaoQingArr.count * 22);
            
            for (int i = 0; i<yaoQingArr.count; i++) {
                NSDictionary *dic = yaoQingArr[i];
                UILabel *lab = [[UILabel alloc] init];
                lab.textColor = COLOR_WITH_HEX(0x474747);
                lab.text = dic[@"mobile"];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
                [scrollTwo addSubview:lab];
                [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(10 + 10*i + 12*i);
                    make.left.mas_equalTo(0);
                    make.width.mas_equalTo(scrollTwo.width);
                    make.height.mas_equalTo(12);
                }];
            }
        } else {
            //邀请成功且认证成功
            
            //认证成功
            UIScrollView *scrollOne = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 273/2, 279)];
            scrollOne.userInteractionEnabled = YES;
            scrollOne.showsVerticalScrollIndicator = NO;
            [smallView addSubview:scrollOne];
            [scrollOne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(labOne.mas_bottom).offset(0);
                make.bottom.mas_equalTo(smallView).offset(0);
                make.width.mas_equalTo(smallView.width_sd/2);
                make.left.mas_equalTo(0);
            }];
            scrollOne.contentSize = CGSizeMake(smallView.frame.size.width/2, renZhengArr.count * 22);
            
            for (int i = 0; i<renZhengArr.count; i++) {
                NSDictionary *dic = renZhengArr[i];
                UILabel *lab = [[UILabel alloc] init];
                lab.textColor = COLOR_WITH_HEX(0x474747);
                lab.text = dic[@"mobile"];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
                [scrollOne addSubview:lab];
                [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(10 + 10*i + 12*i);
                    make.left.mas_equalTo(0);
                    make.width.mas_equalTo(scrollOne.width);
                    make.height.mas_equalTo(12);
                }];
            }
            
            //邀请成功
            UIScrollView *scrollTwo = [[UIScrollView alloc] initWithFrame:CGRectMake(273/2, 0, 273/2, 279)];
            scrollTwo.userInteractionEnabled = YES;
            scrollTwo.showsVerticalScrollIndicator = NO;
            [smallView addSubview:scrollTwo];
            [scrollTwo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(labOne.mas_bottom).offset(0);
                make.width.mas_equalTo(smallView.width_sd/2);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(smallView.mas_bottom).offset(0);
            }];
            scrollTwo.contentSize = CGSizeMake(smallView.frame.size.width/2, yaoArr.count * 22);
            
            for (int i = 0; i<yaoArr.count; i++) {
                NSDictionary *dic = yaoArr[i];
                UILabel *lab = [[UILabel alloc] init];
                lab.textColor = COLOR_WITH_HEX(0x474747);
                lab.text = dic[@"mobile"];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
                [scrollTwo addSubview:lab];
                [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(10 + 10*i + 12*i);
                    make.left.mas_equalTo(0);
                    make.width.mas_equalTo(scrollTwo.width);
                    make.height.mas_equalTo(12);
                }];
            }
            
        }
    }
    
    
    [self popAlertViewWithImageName:@"邀请有礼2" contentView:smallView height:0];
}

- (void)clickAdImgView:(UIButton *) sender{
    
    [self.whiteView removeFromSuperview];
    [self.grayView removeFromSuperview];
    
//    [self activeClickActionWithType:self.popViewModel.linkType webUrl:self.popViewModel.url];
}

- (void)closeCurrentView{
    [self.whiteView removeFromSuperview];
    [self.grayView removeFromSuperview];
}

- (void)popAlertViewWithImageName:(NSString *)name contentView:(UIView *)cView height:(CGFloat)height{
    self.grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //     [[UIApplication sharedApplication].keyWindow addSubview:self.grayView];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.grayView];
    //    [self.navigationController.view addSubview:self.grayView];
    self.grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    self.whiteView = [[UIView alloc] init];
    [self.grayView addSubview:self.whiteView];
    self.whiteView.layer.masksToBounds = YES;
    self.whiteView.layer.cornerRadius = 6;
    CGFloat wHeight = (SCREEN_WIDTH-102)*273./279.;
    if (height == 0) {
        self.whiteView.frame = CGRectMake(51, (ScreenHeight-wHeight)/2, ScreenWidth-102, wHeight);
    } else {
        self.whiteView.frame = CGRectMake(51, (ScreenHeight-wHeight)/2, ScreenWidth-102, height);
    }
    
    
    UIImageView *adImgView = [[UIImageView alloc] initWithFrame:self.whiteView.bounds];
    UIImage *image = [UIImage imageNamed:name];
    CGFloat top = image.size.height*0.3-1; // 顶端盖高度
    CGFloat bottom = top ; // 底端盖高度
    CGFloat left = image.size.width*0.25-1; // 左端盖宽度
    CGFloat right = left; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self.whiteView addSubview:adImgView];
    adImgView.image = image;
    self.adImgView = adImgView;
    
    cView.frame = self.whiteView.bounds;
    [self.whiteView addSubview:cView];
    
    UIButton *button = [UIButton new];
    [self.whiteView addSubview:button];
    button.frame = self.whiteView.bounds;
    [button addTarget:self action:@selector(clickAdImgView:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 500;
    self.whiteView.center = self.grayView.center;
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.grayView addSubview:closeButton];
    [closeButton setImage:[UIImage imageNamed:@"yaoqing_X"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeCurrentView) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake((ScreenWidth-35)/2, CGRectGetMaxY(self.whiteView.frame)+30, 35, 35);
    if (cView.tag == 1010) {
        [button removeFromSuperview];
    }
}

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
    [imageArray addObject:@"http://www.baidu.com"];
    
    
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:self.yaoQingModel.inviteGiftSideTitle images:imageArray url:[NSURL URLWithString:self.yaoQingModel.inviteGiftUrl] title:self.yaoQingModel.inviteGiftTitle type:SSDKContentTypeAuto];
//    [params SSDKSetupShareParamsByText:@"分享内容http://www.baidu.com" images:@[@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"] url:[NSURL URLWithString:@"http://www.baidu.com"] title:@"分享标题" type:SSDKContentTypeAuto];
    
    [ShareSDK share:type parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        NSLog(@"error --- %@",error);
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
//分享出去的数据
-(void)getInviteData{
    NSLog(@"=============");
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
            
            //弹出分享
            self.shareAlertView = [[SSH_ShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [self.shareAlertView showShareAlertView];
            self.shareAlertView.delegate = self;
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (void)getbenZhouZhanJi {
    NSLog(@"---------");
    [[DENGFANGRequest shareInstance] getWithUrlString:@"user/inviteGift" parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString],} success:^(id responseObject) {
        self->diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",self->diction);
        self->dataDic = self->diction[@"data"];
        self->yaoQingCode = self->dataDic[@"inviteCode"];
        NSDictionary *dic = self->dataDic[@"rewardRules"];
        self->yaoQianGZArr = self->dataDic[@"invitaWelfare"];
        [self giveLabText];
        self->twoOne.attributedText = [self setAttributedStringWithString:dic[@"systemMsg"]];
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
    [[DENGFANGRequest shareInstance] getWithUrlString:@"user/getUserInviteCount" parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString],} success:^(id responseObject) {
        self->diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([self->diction[@"code"] isEqualToString:@"200"]) {
            NSDictionary *data = self->diction[@"data"];
            self->registeredCount = data[@"registeredCount"];
            self.registerNum.text = [NSString stringWithFormat:@"%@",data[@"registeredCount"]];
            self->notAuthCount = data[@"notAuthCount"];
            self.noRenZhengNum.text = [NSString stringWithFormat:@"%@",data[@"notAuthCount"]];
            self->userInviteCoin = data[@"userInviteCoin"];
            if ([self->userInviteCoin isKindOfClass:NSNull.class]) {
                self.jinbiLab.text = [NSString stringWithFormat:@"0金币"];
            } else {
                self.jinbiLab.text = [NSString stringWithFormat:@"%@金币",data[@"userInviteCoin"]];
            }
            
            self->authSuccessCount = data[@"authSuccessCount"];
            self.renZhengNum.text = [NSString stringWithFormat:@"%@",data[@"authSuccessCount"]];
        } else {
            NSLog(@"%@",self->diction);
        }
        
    } fail:^(NSError *error) {
        
    }];
    
}

- (void)giveLabText {
//    yaoQianGZArr
    self.xibOneRen.attributedText = [self setAttributedStringWithArrayString:yaoQianGZArr[0][@"note"]];
    self.xibTwoRen.attributedText = [self setAttributedStringWithArrayString:yaoQianGZArr[1][@"note"]];
    self.xibThreeRen.attributedText = [self setAttributedStringWithArrayString:yaoQianGZArr[2][@"note"]];
    self.xibFourRen.attributedText = [self setAttributedStringWithArrayString:yaoQianGZArr[3][@"note"]];
    self.xibGuiZe.attributedText = [self setAttributedStringWithString:yaoQianGZArr[4][@"note"]];
    NSDictionary *dic = dataDic[@"friendWelfare"];
    self.xibFuLi.attributedText = [self setAttributedStringWithArrayString:dic[@"systemMsg"]];
}

- (void)chaKanXiangQiangData {
    if (yaoQingCode == nil) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请求错误，请重新进入该页面重试！"];
    } else {
        [[DENGFANGRequest shareInstance] getWithUrlString:@"user/getUserInviteMobile" parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:self->yaoQingCode],@"inviteCode":yaoQingCode,} success:^(id responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([dic[@"code"] isEqualToString:@"200"]) {
                self->yaoQingArr = dic[@"data"];
                [self addXiangQingData];
            } else {
                [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请求错误，请重试！"];
            }
            
        } fail:^(NSError *error) {
            
        }];
    }
}

- (NSMutableAttributedString *)setAttributedStringWithString:(NSString *)string {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    UIFont *font = [UIFont fontWithName:@"PingFang-SC-Medium" size:WidthScale(11.5)];
    NSInteger range = string.length;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = WidthScale(5); // 调整行间距
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, range)];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,range)];
    self.xibGuiZe.textAlignment = NSTextAlignmentCenter;
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0x888888) range:NSMakeRange(0,range)];
    return attrString;
}

- (NSMutableAttributedString *)setAttributedStringWithArrayString:(NSString *)string {
    NSString *newString = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];//去掉空格
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:newString];
    UIFont *font = [UIFont fontWithName:@"PingFang-SC-Medium" size:WidthScale(11.5)];
    NSInteger range = newString.length;
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(range - 4,4)];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,range - 4)];
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0x888888) range:NSMakeRange(0,range - 4)];
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0xff9d00) range:NSMakeRange(range - 4,4)];
    return attrString;
}

@end
