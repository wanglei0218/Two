//
//  SSH_BanBenXinXiController.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_BanBenXinXiController.h"
#import "SSH_WeChatAlertView.h"

@interface SSH_BanBenXinXiController ()

@end

@implementation SSH_BanBenXinXiController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLORWHITE;
    self.titleLabelNavi.text = @"版本信息";
    
    self.lineView.hidden = NO;
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self.normalBackView addSubview:logoImgView];
    [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(75.5);
        make.width.height.mas_equalTo(117.5);
        make.centerX.mas_equalTo(self.view);
    }];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    [self.normalBackView addSubview:versionLabel];
    versionLabel.text = @"1.1";
    versionLabel.font = UIFONTTOOL(18);
    versionLabel.textColor = ColorBlack222;
    versionLabel.textAlignment = 1;
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(logoImgView.mas_bottom).offset(24);
        make.height.mas_equalTo(18);
    }];
    
    UILabel *appNameLabel = [[UILabel alloc] init];
    [self.normalBackView addSubview:appNameLabel];
    appNameLabel.text = @"小象抢单";
    appNameLabel.textAlignment = 1;
    appNameLabel.textColor = ColorBlack222;
    appNameLabel.font = UIFONTTOOL(18);
    [appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(versionLabel.mas_bottom).offset(14);
        make.height.mas_equalTo(18);
    }];
    
    UILabel *alertLabel = [[UILabel alloc] init];
    alertLabel.numberOfLines = 0;
    [self.normalBackView addSubview:alertLabel];
    alertLabel.textColor = ColorBlack999;
    alertLabel.font = UIFONTTOOL15;
    alertLabel.textAlignment = 1;
    NSString *alertString = @"点击关注「小象抢单」微信公众号\n了解更多惊喜";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:alertString];
    NSRange range = [alertString rangeOfString:@"小象抢单"];
    [attString beginEditing];
    [attString addAttributes:@{NSForegroundColorAttributeName:ColorZhuTiHongSe} range:range];
    alertLabel.attributedText = attString;
    [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(appNameLabel.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(92);
    }];
    
    UIButton *guanzhuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [guanzhuButton addTarget:self action:@selector(guanzhuGongZhongHaoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.normalBackView addSubview:guanzhuButton];
    [guanzhuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(appNameLabel.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(92);
    }];
    
}


- (void)guanzhuGongZhongHaoAction{
    SSH_WeChatAlertView *wexinAlertView = [[SSH_WeChatAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [wexinAlertView showWeXinQQAlertView];
    
    NSRange fanganRange = NSMakeRange(0, 4);
    //方案一： &&  二维码
    [wexinAlertView.QRCodeImgview sd_setImageWithURL:[NSURL URLWithString:[DENGFANGSingletonTime shareInstance].systemImgUrl]];
    
    NSString *methodString = [NSString stringWithFormat:@"方案一：去微信搜索%@关注公众号",[DENGFANGSingletonTime shareInstance].systemName];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:methodString];
    [attString beginEditing];
    
    NSRange range = [methodString rangeOfString:[DENGFANGSingletonTime shareInstance].systemName];
    [attString addAttribute:NSForegroundColorAttributeName value:ColorZhuTiHongSe range:range];
    
    [attString addAttributes:@{NSFontAttributeName:UIFONTTOOL14,NSForegroundColorAttributeName:ColorBlack222} range:fanganRange];
    
    wexinAlertView.method1ContentLabel.attributedText = attString;
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [DENGFANGSingletonTime shareInstance].systemName;
    //
    //方案二：
    NSString *method2String = @"方案二：截屏后，微信识别二维码";
    NSMutableAttributedString *method2Att = [[NSMutableAttributedString alloc] initWithString:method2String];
    [method2Att addAttributes:@{NSFontAttributeName:UIFONTTOOL14,NSForegroundColorAttributeName:ColorBlack222} range:fanganRange];
    wexinAlertView.method2ContentLabel.attributedText = method2Att;
    
    [wexinAlertView.jumpButton addTarget:self action:@selector(gotoWeChat) forControlEvents:UIControlEventTouchUpInside];
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
