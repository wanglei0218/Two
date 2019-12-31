//
//  SSH_ZYDetailsUViewController.m
//  qianDanWang
//
//  Created by AN94 on 9/17/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_ZYDetailsViewController.h"
#import "SSH_ZYBottomView.h"
#import "SSH_ZYAddViewController.h"
#import "SSH_ShareView.h"
#import <ShareSDKUI/ShareSDKUI.h>

@interface SSH_ZYDetailsViewController ()<SSH_ZYBottomViewDelegate,SSH_ZYAddViewControllerDelegate,SSH_ShareViewViewDelegate>

@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)UIImageView *bigImage;
@property (nonatomic,strong)UIImageView *bottomImage;
@property (nonatomic,strong)UILabel *bottomIntorLabel;
@property (nonatomic,strong)UILabel *bottomPhoneLabel;
@property (nonatomic,strong)SSH_ZYBottomView *bottomView;
@property (nonatomic,strong)NSArray *bottomViewData;
@property (nonatomic,strong)SSH_ShareView *shareAlertView;
@property (nonatomic,strong)UIImage *shareImage;

@end

@implementation SSH_ZYDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabelNavi.text = @"海报详情";
    self.view.backgroundColor = COLOR_With_Hex(0xf9f9f9);
    self.bottomViewData = @[@"微信好友",@"朋友圈",@"保存图片"];
    [self rightBtn];
    [self bigImage];
    [self bottomView];
    [self bottomIntorLabel];
    [self bottomPhoneLabel];
    [self bottomView];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (UIButton *)rightBtn{
    if(!_rightBtn){
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - WidthScale(70), getStatusHeight, WidthScale(70), getRectNavAndStatusHight - getStatusHeight)];
        
        NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"编辑名片" attributes:@{
                                                            NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                            NSForegroundColorAttributeName:COLOR_With_Hex(0x0063ff)
                                                                                                  }];
        
        [_rightBtn setAttributedTitle:attr forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(didSelecteTheRightbtn) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationView addSubview:_rightBtn];
    }
    return _rightBtn;
}

- (UIImageView *)bigImage{
    if(!_bigImage){
        _bigImage = [[UIImageView alloc]init];
        [self.view addSubview:_bigImage];
        
        [_bigImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(getRectNavAndStatusHight + HeightScale(10));
            make.width.mas_equalTo(WidthScale(281));
            make.height.mas_equalTo(WidthScale(500));
        }];
        _bigImage.backgroundColor = UIColor.blueColor;
        NSString *imageStr = [self.data objectForKey:@"postersUrl"];
        [_bigImage sd_setImageWithURL:[NSURL URLWithString:imageStr]];
        
    }
    return _bigImage;
}

- (UIImageView *)bottomImage{
    if(!_bottomImage){
        _bottomImage = [[UIImageView alloc]init];
        [self.bigImage addSubview:_bottomImage];
        _bottomImage.image = [UIImage imageNamed:@"bottom_background"];
        _bottomImage.sd_layout
        .topSpaceToView(self.bigImage, WidthScale(410))
        .leftSpaceToView(self.bigImage, 0)
        .widthIs(WidthScale(281))
        .heightIs(WidthScale(90));
        
    }
    return _bottomImage;
}

- (UILabel *)bottomIntorLabel{
    if(!_bottomIntorLabel){
        _bottomIntorLabel = [[UILabel alloc] init];
        _bottomIntorLabel.textAlignment = NSTextAlignmentCenter;
        _bottomIntorLabel.textColor = [UIColor whiteColor];
        _bottomIntorLabel.text = [self.data objectForKey:@"shareName"];
        [self.bottomImage addSubview:_bottomIntorLabel];
        _bottomIntorLabel.sd_layout
        .topSpaceToView(self.bottomImage, WidthScale(40))
        .leftSpaceToView(self.bottomImage, 0)
        .widthIs(WidthScale(281))
        .heightIs(WidthScale(20));
    }
    return _bottomIntorLabel;
}

- (UILabel *)bottomPhoneLabel{
    if(!_bottomPhoneLabel){
        _bottomPhoneLabel = [[UILabel alloc] init];
        _bottomPhoneLabel.textAlignment = NSTextAlignmentCenter;
        _bottomPhoneLabel.textColor = [UIColor whiteColor];
        [self.bottomImage addSubview:_bottomPhoneLabel];
        _bottomPhoneLabel.text = [self.data objectForKey:@"shareMobile"];
        _bottomPhoneLabel.sd_layout
        .topSpaceToView(self.bottomIntorLabel, WidthScale(5))
        .leftSpaceToView(self.bottomImage,0)
        .widthIs(WidthScale(281))
        .heightIs(WidthScale(20));
        
    }
    return _bottomPhoneLabel;
}

- (SSH_ZYBottomView *)bottomView{
    if (!_bottomView){
        _bottomView = [[SSH_ZYBottomView alloc]initWithFrame:CGRectMake(0, ScreenHeight - SafeAreaBottomHEIGHT - HeightScale(75), SCREEN_WIDTH, HeightScale(75))];
        _bottomView.layer.borderColor = RGB(238, 238, 238).CGColor;
        _bottomView.layer.borderWidth = 1;
        _bottomView.delagte = self;
        _bottomView.collectionData = self.bottomViewData;
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

#pragma mark =================自定义代理=============
- (void)didSelecteTheCollectItemWithTarget:(NSInteger)tag{
    [self posterUseCount];
    
    self.shareImage = [self snapshot:self.bigImage];
    
    if(tag == 2){
        [MobClick event:@"pictures"];
        UIImageWriteToSavedPhotosAlbum(self.shareImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else{
        [self clickShareButtonAction:(int)tag];
    }
    
}

//编辑完成之后返回
- (void)didEnterTheEditContentWithIntro:(NSString *)intro phone:(NSString *)phone{
    self.bottomIntorLabel.text = intro;
    self.bottomPhoneLabel.text = phone;
}

#pragma mark =================编辑按钮点击方法===============
- (void)didSelecteTheRightbtn{
    [MobClick event:@"posterdetailseditor"];
    SSH_ZYAddViewController *add = [[SSH_ZYAddViewController alloc]init];
    add.phoneNum = self.bottomPhoneLabel.text;
    add.delegate = self;
    add.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];
    
}

#pragma mark ===============网络请求，海报使用次数=================
- (void)posterUseCount{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]];
    
    NSString *str = [self.data objectForKey:@"id"];
    
    NSDictionary *params = @{
                             @"postersId":str,
                             @"userId":userId,
                             @"timestamp":[NSString yf_getNowTimestamp],
                             @"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%@",userId]]
                             };
    [[DENGFANGRequest shareInstance] postWithUrlString:@"vip/posterTool/posterNumStat" parameters:params success:^(id responsObject) {
        
    } fail:^(NSError *error) {
        
    }];
}

- (UIImage *)snapshot:(UIView *)view {
    
    
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,0);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    UIGraphicsEndImageContext();
    
    
    
    
    
    return image;
    
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:msg];
}

#pragma mark =================分享代理=================
#pragma mark -分享内部的按钮点击代理
- (void)clickShareButtonAction:(int)index{
    
    SSDKPlatformType type;
    if (index == 0) {
        [MobClick event:@"friends"];
        type = SSDKPlatformSubTypeWechatSession;
        
        if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
            [SSH_TOOL_GongJuLei showAlter:window WithMessage:@"您未安装微信"];
            return;
        }
    }else  if (index == 1) {
        [MobClick event:@"circle"];
        if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
            [SSH_TOOL_GongJuLei showAlter:window WithMessage:@"您未安装微信"];
            return;
        }
        type = SSDKPlatformSubTypeWechatTimeline;
    }else{
        return;
    }
    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    [imageArray addObject:self.shareImage==nil?@"":self.shareImage];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    if (self.flag == 0) {
    [params SSDKSetupShareParamsByText:nil images:imageArray url:nil title:nil type:SSDKContentTypeAuto];
        
//    }else if (self.flag == 1){
//        [params SSDKSetupShareParamsByText:self.sideTitle images:imageArray url:[NSURL URLWithString:self.shareUrl] title:self.shareTitle type:SSDKContentTypeAuto];
//    }
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
