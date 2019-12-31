//
//  SSH_ShenFenZhengRenZhengViewController.m
//  DENGFANGSC
//
//  Created by 河神 on 2019/5/15.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_ShenFenZhengRenZhengViewController.h"
#import "SSH_ShenFenUploadView.h"
#import "UIImage+DENGFANGCompressImage.h"

#import "SSH_ShenFenZhengTiJiaoTopView.h" //顶部提示view
#import "SSH_ShenFenZhengPopView.h"    //弹窗
#import "SSH_ShuaLianRenZhengViewController.h"

#import <objc/runtime.h>
#import "SSH_GeRenXinXiModel.h"

@interface SSH_ShenFenZhengRenZhengViewController ()<SSH_ShenFenUploadViewlDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) SSH_GeRenXinXiModel *infoModel;
@property (nonatomic, strong) UIImageView *renZhengResultImageView;//认证结果图片
@property (nonatomic, strong) UILabel *topLabel;//认证结果显示的第一行文字
@property (nonatomic, strong) UIButton *infoBtn;//认证结果显示的按钮

@property (nonatomic,strong)UIScrollView * bgScrollView;//

@property (nonatomic,strong)SSH_ShenFenUploadView * zhengView;//正面view
@property (nonatomic,strong)SSH_ShenFenUploadView * fanView;//反面view

@property (nonatomic,strong)UIButton * submitBtn;//确认上传按钮

@property (nonatomic,strong)UILabel * remindLab;

@property (nonatomic,assign)NSInteger btnTag;//按钮的tag值

@property (nonatomic,strong)NSString * photo1;
@property (nonatomic,strong)NSString * photo2;

@property (nonatomic,strong) MBProgressHUD *zhuanquan;

//正面认证成功
@property(nonatomic,assign)BOOL isZhengMianRenZhengSucc;
//反面认证成功
@property(nonatomic,assign)BOOL isFanMianRenZhengSucc;
//身份证名字
@property(nonatomic,strong) NSString *card_name;
//身份证号码
@property(nonatomic,strong) NSString *card_id;

@end

@implementation SSH_ShenFenZhengRenZhengViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLORWHITE;
    self.titleLabelNavi.text = @"身份证上传";
    UIView * line = [[UIView alloc]init];
    line.frame = CGRectMake(0, getRectNavAndStatusHight-0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = GrayLineColor;
    [self.view addSubview:line];
    
    [self configView];

}

#pragma mark  懒加载
-(UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREENH_HEIGHT-getRectNavAndStatusHight)];
        _bgScrollView.backgroundColor = COLORWHITE;
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREENH_HEIGHT+120);
        
    }
    return _bgScrollView;
}

-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.layer.cornerRadius = 20;
        _submitBtn.clipsToBounds = YES;
        _submitBtn.titleLabel.font = UIFONTTOOL15;
        [_submitBtn setTitleColor:Colorfefefe forState:UIControlStateNormal];
        [_submitBtn setTitle:@"确认上传" forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:Colorffb5b7];
        //        _submitBtn.enabled = NO;
        [_submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (UILabel *)remindLab {
    if (!_remindLab) {
        _remindLab = [[UILabel alloc] init];
        _remindLab.text = @"提示：请上传本人真实身份证件及工作证明，如经发现\n上传信息与本人信息不一致，平台给予封号处理。";
        _remindLab.numberOfLines = 0;
        _remindLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _remindLab.textColor = COLOR_WITH_HEX(0x222222);
        _remindLab.textAlignment = NSTextAlignmentCenter;
    }
    return _remindLab;
}

//

-(void)submitBtnClicked{
    
    if (self.photo1.length<10) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请上传身份证正面照"];
        return;
    }
    
    if (self.photo2.length<10) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请上传身份证反面照"];
        return;
    }
    
    //下一步
    SSH_ShuaLianRenZhengViewController *shualianVC = [[SSH_ShuaLianRenZhengViewController alloc] init];
    shualianVC.card_id = self.card_id;
    shualianVC.card_name = self.card_name;
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController pushViewController:shualianVC animated:YES];
}

#pragma mark -------- 上传单张接口 -----------
- (void)uploadOnlyImage:(NSData *)image{
    
    self.zhuanquan = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.zhuanquan.label.text = NSLocalizedString(@"图片上传中...", @"HUD loading title");
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *timestamp = [NSString yf_getNowTimestamp];
    NSString *signs = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:@"" timesTamp:timestamp];
    [param setValue:timestamp forKey:@"timestamp"];
    [param setValue:signs forKey:@"signs"];
    
    NSLog(@"%@",UploadImgUrl);
    [DENGFANGRequest uploadImageWithURLString:UploadImgUrl parameters:param uploadDatas:image progress:nil success:^(id reponse) {
         NSMutableDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dictionary[@"result"] integerValue] == 200) {
            
            if (self.btnTag == 30) {
                self.photo1 = dictionary[@"url"][0];
                [[NSUserDefaults standardUserDefaults] setValue:self.photo1 forKey:DENGFANGIdCardFaceUrlKey];
                [DENGFANGSingletonTime shareInstance].idCardFaceUrl = self.photo1;
            }else if (self.btnTag == 31){
                self.photo2 = dictionary[@"url"][0];
                [[NSUserDefaults standardUserDefaults] setValue:self.photo2 forKey:DENGFANGIdCardBackUrlKey];
                [DENGFANGSingletonTime shareInstance].idCardBackUrl = self.photo2;
            }
            if (self.isZhengMianRenZhengSucc == YES && self.isFanMianRenZhengSucc == YES) {
                [self.zhuanquan hideAnimated:YES];
                //按钮可点击
                self.submitBtn.backgroundColor = ColorZhuTiHongSe;
            }
            [self.zhuanquan hideAnimated:YES];
        }else{
            [self.zhuanquan hideAnimated:YES];
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:dictionary[@"message"]];
        }
        
    } failure:^(NSError *failure) {
        NSLog(@"%@",failure);
        [self.zhuanquan hideAnimated:YES];
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"图片上传失败，请重试"];
    }];
}

- (void)getRemindLabTextData {
    [[DENGFANGRequest shareInstance] getWithUrlString:@"sys/getCardUploadTips" parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:@""]} success:^(id responseObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        self.remindLab.text = diction[@"data"];
        NSLog(@"%@",diction);
    } fail:^(NSError *error) {
        
        NSLog(@"error = %@",error);
        
    }];
}

//请上传身份证正面
-(void)shangChuanZhengBtnClicked:(UIButton *)btn{
    
    self.view.userInteractionEnabled = NO;
    if (self.isAuth == 1) {
        btn.userInteractionEnabled = NO;
        
    }else{
        btn.userInteractionEnabled = YES;
        self.btnTag = btn.tag;
        WBOCRService *service = [WBOCRService sharedService];
        WBOCRConfig *config = [WBOCRConfig sharedConfig];
        if (btn.tag == 30) {
            config.SDKType = WBOCRSDKTypeIDCardFrontSide;//身份证正面OCR
        }else{
            config.SDKType = WBOCRSDKTypeIDCardBackSide;//身份证反面OCR
        }
        
        NSString *userId = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]];
        
        [[DENGFANGRequest shareInstance] postWithUrlString:@"auth/getSign" parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil],@"status":@"1",@"userId":userId} success:^(id responsObject) {
            NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@",diction);
            if ([diction[@"code"] isEqualToString:@"200"]) {
                NSDictionary *dic = diction[@"data"];
                [service startOCRServiceWithConfig:config version:dic[@"version"] appId:dic[@"appId"] nonce:dic[@"nonce"] userId:userId sign:dic[@"sign"] orderNo:dic[@"orderNO"] startSucceed:^{
                    NSLog(@"开始识别");
                } recognizeSucceed:^(id  _Nonnull resultModel, id  _Nullable extension) {
                    NSLog(@"%@",resultModel);
                    WBIDCardInfoModel *model = resultModel;
                    if (btn.tag == 30) {
                        self.card_id = model.idcard;
                        self.card_name = model.name;
                        [[NSUserDefaults standardUserDefaults] setValue:self.card_name forKey:@"card_name"];
                        [[NSUserDefaults standardUserDefaults] setValue:self.card_id forKey:@"card_id"];
                        self.zhengView.bgImgView.image = model.frontFullImg;
                        [self pushJavaImg:model.frontFullImg btnTag:30];
                    } else {
                        self.fanView.bgImgView.image = model.backFullImg;
                        [self pushJavaImg:model.backFullImg btnTag:31];
                    }
                    
                } failed:^(NSError * _Nonnull error, id  _Nullable extension) {
                    [MBProgressHUD showError:@"拍摄失败，请重试"];
                    NSLog(@"识别失败");
                }];
            }
            self.view.userInteractionEnabled = YES;
        } fail:^(NSError *error) {
            self.view.userInteractionEnabled = YES;
        }];
    }
}

//给后台图片
- (void)pushJavaImg:(UIImage *)image btnTag:(NSInteger)tag {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *biz_type = nil;
    if (tag == 30) { //正面
        biz_type = @"front";
        self.isZhengMianRenZhengSucc = YES;
        [self uploadOnlyImage:imageData];
    }else{  //反面
        biz_type = @"back";
        self.isFanMianRenZhengSucc = YES;
        [self uploadOnlyImage:imageData];
    }
}
//取消识别
- (void)receiveOcrCancel {
    NSLog(@"取消识别");
}
//超时自动取消
- (void)receiveOcrTimerOut {
    NSLog(@"超时自动取消");
}

//是否认证（0：未认证  1：已认证   2:认证中   3:认证失败） DENGFANGUserInfoURL
#pragma mark 获取用户信息
-(void)getDENGFANGUserInfoData{
    
    self.zhuanquan = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.zhuanquan.label.text = NSLocalizedString(@"", @"HUD loading title");
    
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]};
    
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGUserInfoURL parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        //        NSLog(@"获取用户信息 数据 %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            self.infoModel = [[SSH_GeRenXinXiModel alloc]init];
            [self.infoModel setValuesForKeysWithDictionary:diction[@"data"]];
            self.infoModel.isFinish = NO;
            
//            [self setupFailInfoModel];
            if([self.infoModel.isAuth intValue] == 0 || [self.infoModel.isFaceCheck intValue] == 0){//0：未认证
                
                [self configView];
                
            }else{//1：已认证 2：认证中 3：认证失败
                
                [self configRenZhengZhongAndFail];
                //
                if ([self.infoModel.isAuth intValue] == 1 && [self.infoModel.isFaceCheck intValue] == 1) {
                    self.renZhengResultImageView.image = [UIImage imageNamed:@"renzheng_shenhechenggong"];
                    self.topLabel.text = @"您的身份认证已通过审核，快去抢单吧!";
                    [self.infoBtn setTitle:@"去抢单" forState:UIControlStateNormal];
                }else if ([self.infoModel.isAuth intValue] == 2) {
                    self.renZhengResultImageView.image = [UIImage imageNamed:@"renzhengzhong"];
                    self.topLabel.text = @"您的申请正在进行人工审核！\n我们会在一个工作日内反馈审核结果！";
                    [self.infoBtn setTitle:@"确定" forState:UIControlStateNormal];
                }else{
                    self.renZhengResultImageView.image = [UIImage imageNamed:@"renzhengshibai"];
                    [self.infoBtn setTitle:@"重新认证" forState:UIControlStateNormal];
                    [self getDENGFANGAuthMarkForData];
                }
                
            }
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
        [self.zhuanquan hideAnimated:YES];
    } fail:^(NSError *error) {
        [self.zhuanquan hideAnimated:YES];
    }];
    
}

-(void)configView{
    
    [self.view addSubview:self.bgScrollView];
    if (!IS_IPHONE5) {
        self.bgScrollView.scrollEnabled = NO;
    }
    UIView * lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, WidthScale(7.5));
    lineView.backgroundColor = COLOR_With_Hex(0xf3f3f3);
    [self.bgScrollView addSubview:lineView];
    
    NSMutableArray * viewArr = [[NSMutableArray alloc]init];
    NSArray * textArr = @[@"请上传身份证正面",@"请上传身份证反面"];
    NSArray * imgArr = @[@"ID-zheng",@"ID-fan"];
    for (int i = 0; i < 2; i++) {
        SSH_ShenFenUploadView * baseView = [[SSH_ShenFenUploadView alloc]initWithFrame:CGRectMake(0, lineView.bottom+37-15+170*i, SCREEN_WIDTH, 170)];
        baseView.myLabel.text = textArr[i];
        baseView.bgImgView.image = [UIImage imageNamed:imgArr[i]];
        baseView.delegate = self;
        [baseView setChildBtnTag:30+i];
        [self.bgScrollView addSubview:baseView];
        [viewArr addObject:baseView];
        
    }
    self.zhengView = viewArr[0];
    self.fanView = viewArr[1];
    
    [self.bgScrollView addSubview:self.submitBtn];
    [self.bgScrollView addSubview:self.remindLab];
    [self getRemindLabTextData];
    self.submitBtn.frame = CGRectMake(30, self.fanView.bottom+WidthScale(30), SCREEN_WIDTH-WidthScale(60), WidthScale(40));
    self.remindLab.frame = CGRectMake(35, self.fanView.bottom+WidthScale(75), SCREEN_WIDTH-WidthScale(60), WidthScale(40));
    
}

#pragma mark 获取验证失败接口 DENGFANGAuthMarkURL
-(void)getDENGFANGAuthMarkForData{
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]};
    
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGAuthMarkURL parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"认证失败 信息 数据 %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [self.infoModel setValuesForKeysWithDictionary:diction[@"data"]];
            self.infoModel.isFinish = YES;
//            [self setupFailInfoModel];
            self.topLabel.textColor = ColorBlack999;
            
            NSString *failString = [NSString stringWithFormat:@"认证审核失败\n\n%@",diction[@"data"][@"mark"]];
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:failString];
            [attString beginEditing];
            NSRange attRange = [failString rangeOfString:@"认证审核失败"];
            [attString addAttributes:@{NSForegroundColorAttributeName:ColorZhuTiHongSe} range:attRange];
            
            self.topLabel.attributedText  = attString;
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
    }];
}

#pragma mark - 认证审核中 和 认证失败 的页面
- (void)configRenZhengZhongAndFail{
    
    
    self.renZhengResultImageView = [[UIImageView alloc]init];
    [self.normalBackView addSubview:self.renZhengResultImageView];
    self.renZhengResultImageView.image = [UIImage imageNamed:@"renzhengshibai"];
    [self.renZhengResultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getRectNavAndStatusHight+50);
        make.width.height.mas_equalTo(126);
        make.centerX.mas_equalTo(self.view);
    }];
    
    //  label
    self.topLabel = [[UILabel alloc]init];
    [self.normalBackView addSubview:self.topLabel];
    self.topLabel.font = UIFONTTOOL14;
    self.topLabel.textColor = ColorZhuTiHongSe;
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.numberOfLines = 0;
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.renZhengResultImageView.mas_bottom).offset(33);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(55);
    }];
    
    //按钮
    self.infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.normalBackView addSubview:self.infoBtn];
    self.infoBtn.layer.cornerRadius = 15;
    self.infoBtn.clipsToBounds = YES;
    self.infoBtn.titleLabel.font = UIFONTTOOL13;
    [self.infoBtn setTitleColor:COLORWHITE forState:UIControlStateNormal];
    [self.infoBtn setBackgroundColor:ColorZhuTiHongSe];
    [self.infoBtn addTarget:self action:@selector(infoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.topLabel.mas_bottom).offset(30.5);
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view);
    }];
}
#pragma mark 重新认证
-(void)infoBtnClicked{
    if ([self.infoModel.isAuth intValue] == 1 && [self.infoModel.isFaceCheck intValue] == 1) {
        self.tabBarController.selectedIndex = 1;
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if ([self.infoModel.isAuth intValue] == 2) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        for (UIView *subViews in self.normalBackView.subviews) {
            [subViews removeFromSuperview];
        }
        [self configView];
    }
}

//- (void)dealloc {
//}


@end
