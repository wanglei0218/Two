//
//  SSH_ShuaLianRenZhengViewController.m
//  DENGFANGSC
//
//  Created by 河神 on 2019/5/15.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_ShuaLianRenZhengViewController.h"
#import "SSH_ZhiYeViewController.h"
#import <WBOCRService/WBOCRService.h>
#import <WBCloudReflectionFaceVerify/WBFaceVerifyCustomerService.h>


#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
@interface SSH_ShuaLianRenZhengViewController ()<WBFaceVerifyCustomerServiceDelegate>

@property (nonatomic,strong)UIScrollView * bgScrollView;
@property (nonatomic,strong)UIButton * submitBtn;//确认上传按钮
@property (nonatomic,strong)UIButton *startBrushBtn;//开始刷脸认证按钮

@property (nonatomic,strong)UIView *brushView;//开始刷脸认证view
@property(nonatomic,strong)NSString *Fid;
@property(nonatomic,strong)NSMutableArray *uploadImageArray;
@property (nonatomic,strong) MBProgressHUD *zhuanquan;
@property (nonatomic,strong)NSString * photo1;
@end

@implementation SSH_ShuaLianRenZhengViewController

-(NSMutableArray *)uploadImageArray{
    if (!_uploadImageArray) {
        _uploadImageArray = [NSMutableArray array];
    }
    return _uploadImageArray;
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
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn setBackgroundColor:ColorZhuTiHongSe];
        [_submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

-(UIButton *)startBrushBtn{
    if (!_startBrushBtn) {
        _startBrushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBrushBtn.layer.cornerRadius = 20;
        _startBrushBtn.clipsToBounds = YES;
        _startBrushBtn.titleLabel.font = UIFONTTOOL15;
        [_startBrushBtn setTitleColor:Colorfefefe forState:UIControlStateNormal];
        [_startBrushBtn setTitle:@"开始刷脸认证" forState:UIControlStateNormal];
        [_startBrushBtn setBackgroundColor:ColorZhuTiHongSe];
        [_startBrushBtn addTarget:self action:@selector(startBrushBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBrushBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLORWHITE;
    self.lineView.hidden = NO;
    self.titleLabelNavi.text = @"身份认证";
    
    [self.view addSubview:self.bgScrollView];
    if (!IS_IPHONE5) {
        self.bgScrollView.scrollEnabled = NO;
    }
    
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, WidthScale(62+25))];
//    topView.backgroundColor = COLORWHITE;
//    [self.bgScrollView addSubview:topView];
//
//    UIImageView *topimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"刷脸认证_top"]];
//    topimage.frame = CGRectMake(WidthScale(35), WidthScale(12.5), ScreenWidth-WidthScale(70), WidthScale(62));
//    [topView addSubview:topimage];
    
    UIView * lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, WidthScale(7.5));
    lineView.backgroundColor = COLOR_With_Hex(0xf3f3f3);
    [self.bgScrollView addSubview:lineView];
    
    [self startBrushVerificationView];
}

#pragma mark ------ 开始刷脸页面 -------
- (void)startBrushVerificationView{
    
    [self.brushView removeFromSuperview];
    
    self.brushView = [[UIView alloc] initWithFrame:CGRectMake(0, WidthScale(87+7.5), ScreenWidth, WidthScale(350))];
    [self.bgScrollView addSubview:self.brushView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WidthScale(230), WidthScale(230))];
    bgView.center = CGPointMake(ScreenWidth/2, WidthScale(37.5f+230/2));
    bgView.layer.cornerRadius = 7.5;
    bgView.layer.masksToBounds = YES;
    [bgView borderForColor:Colorbdbdbd borderWidth:1.0f borderType:UIBorderSideTypeAll];
    [self.brushView addSubview:bgView];
    
    UIImageView *renzhengImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"开始刷脸"]];
    renzhengImg.contentMode = UIViewContentModeScaleAspectFit;
    renzhengImg.frame = CGRectMake(WidthScale(20.5f), WidthScale(20.5f), bgView.width-WidthScale(41), bgView.width-WidthScale(41));
    [bgView addSubview:renzhengImg];
    
    self.startBrushBtn.frame = CGRectMake(WidthScale(30), bgView.bottom+WidthScale(30), ScreenWidth-WidthScale(60), WidthScale(40));
    [self.brushView addSubview:self.startBrushBtn];
    
}

#pragma mark ------ 刷脸完成页面 -------
- (void)brushVerificationCompletedView{
    
    [self.brushView removeFromSuperview];
    
    self.brushView = [[UIView alloc] initWithFrame:CGRectMake(0, WidthScale(87+7.5), ScreenWidth, WidthScale(350))];
    [self.bgScrollView addSubview:self.brushView];
    
    UIImageView *duihaoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chenggong_tuidan"]];
    duihaoImg.frame = CGRectMake(self.bgScrollView.centerX-WidthScale(55), WidthScale(37.5), WidthScale(110), WidthScale(110));
    [self.brushView addSubview:duihaoImg];
    
    UILabel *showLable = [[UILabel alloc] initWithFrame:CGRectMake(0, duihaoImg.bottom+WidthScale(25), ScreenWidth, WidthScale(15))];
    showLable.font = [UIFont systemFontOfSize:WidthScale(15)];
    showLable.textColor = ColorBlack222;
    showLable.textAlignment = NSTextAlignmentCenter;
    showLable.text = @"刷脸认证已完成，请进行下一步";
    [self.brushView addSubview:showLable];
    
    self.submitBtn.frame = CGRectMake(WidthScale(30), showLable.bottom+WidthScale(60), ScreenWidth-WidthScale(60), WidthScale(40));
    [self.brushView addSubview:self.submitBtn];
    
}

#pragma mark ------ 开始刷脸 -------
- (void)startBrushBtnClicked{
    
    self.startBrushBtn.userInteractionEnabled = NO;
    NSString *userId = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]];
    
    [[DENGFANGRequest shareInstance] postWithUrlString:@"auth/getSign" parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil],@"status":@"2",@"userId":userId} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            NSDictionary *dic = diction[@"data"];
            
            [self getFaceIDWithDiction:dic];
        }
        self.startBrushBtn.userInteractionEnabled = YES;
    } fail:^(NSError *error) {
        self.startBrushBtn.userInteractionEnabled = YES;
    }];
    
}

#pragma mark - WBFaceVerifyCustomerServiceDelegate
-(void)wbSDKServiceDidFinishedNotification:(NSNotification *)noti {
    WBFaceVerifyResult *faceVerifyResult = (WBFaceVerifyResult *)[noti.userInfo objectForKey:@"faceVerifyResult"];
    NSString *userImageString = faceVerifyResult.userImageString;
    UIImage *decodedImage;
    NSData *data;
    if (userImageString) {
        data = [[NSData alloc] initWithBase64EncodedString:userImageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
        decodedImage = [UIImage imageWithData:data];
    }
    
    
    if (faceVerifyResult.isSuccess) {
        if (iOS8Later) {
            [self getImageUrlStr:data];
            NSLog(@"成功");
        }
    }else {
        if (iOS8Later) {
//            WBFaceError *errorDic = faceVerifyResult.error;
            [MBProgressHUD showError:faceVerifyResult.error.desc];
//            NSLog(@"error: %@", faceVerifyResult.error.desc);
//            NSLog(@"失败");
        }
    }
}

- (void)getFaceIDWithDiction:(NSDictionary *)dic {
    NSString *userId = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]];
    NSDictionary *paramaDic = @{
                                @"webankAppId":dic[@"appId"],
                                @"orderNo":dic[@"orderNO"],
                                @"name":self.card_name,
                                @"idNo":self.card_id,
                                @"userId":userId,
                                @"sourcePhotoStr":@"",
                                @"sourcePhotoType":@"1",
                                @"version":dic[@"version"],
                                @"sign":dic[@"sign"],
                                };
    [[DENGFANGRequest shareInstance] postJsonWithparameters:paramaDic success:^(id responsObject) {
        NSLog(@"responsObject = %@",responsObject);
        NSDictionary *diction = responsObject;
        NSDictionary *faceIdDic = diction[@"result"];
        WBFaceVerifyCustomerService *service = [WBFaceVerifyCustomerService sharedInstance];
        WBFaceVerifySDKConfig *sdkConfig = [WBFaceVerifySDKConfig sdkConfig];
        
        [service loginInLiveCheckAndCompareWithIdImageService:userId nonce:dic[@"nonce"] sign:dic[@"sign"] appid:dic[@"appId"] orderNo:dic[@"orderNO"] apiVersion:dic[@"version"] licence:dic[@"license"] faceType:WBFaceVerifyLivingType_Light faceId:faceIdDic[@"faceId"] sdkConfig:sdkConfig success:^{
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wbSDKServiceDidFinishedNotification:) name:WBFaceVerifyCustomerServiceDidFinishedNotification object:nil];
            
        } failure:^(WBFaceError * _Nonnull error) {
            
            NSLog(@"错了");
            
        }];
    } fail:^(NSError *error) {
        
    }];
}

////活体识别成功的回调
//- (void)receiveLivenessResult:(NSArray *)arrMXImage mxVideoData:(NSData *)mxVideoData {
//    NSLog(@"活体检测成功");
//    self.zhuanquan = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    self.zhuanquan.label.text = NSLocalizedString(@"正在比对中...", @"HUD loading title");
//
//    NSString *url = @"https://res.51datakey.com/resource/api/v1/upload/file";
//
//    MXLivenessResult *result = arrMXImage.firstObject;
//
//    NSData *imageData = UIImageJPEGRepresentation(result.image, 1);
//
//    //添加上传的图片到数组
//    [self.uploadImageArray addObject:imageData];
//
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"file"] = imageData;
//    dict[@"type"] = @3;
//    dict[@"app_id"] = [DENGFANGSingletonTime shareInstance].moJieIDStr;
//
//
//    [DENGFANGRequest uploadImageWithURLString:url parameters:dict uploadDatas:imageData progress:nil success:^(id reponse) {
//        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingAllowFragments error:nil];
//
//        NSLog(@"%@",diction);
//        if ([diction[@"code"] isEqualToString:@"0000"]) {
//
//
//            self.Fid = diction[@"data"][@"fid"];
//
//            //人证比对
//            [self getAuthFaceData];
//
//        }
//    } failure:^(NSError *failure) {
//
//    }];
//}

#pragma mark - 人证比对
-(void)getAuthFaceData{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = [NSString yf_getNowTimestamp];
    dict[@"signs"] = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%@%@%d",self.card_id,self.card_name,[DENGFANGSingletonTime shareInstance].useridString]];
    dict[@"userId"] = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
    dict[@"fid"] = self.Fid;
    dict[@"id_card"] = self.card_id;
    dict[@"name"] = self.card_name;
    
    NSLog(@"%@",dict);
    
    NSString *url = @"auth/faceAuth";
    
    [[DENGFANGRequest shareInstance] postWithUrlString:url parameters:dict success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
//            [self getImageUrlStr:self.uploadImageArray];
           
        }else{  //10031 超出活体检验次数
            [self.zhuanquan hideAnimated:YES];
            [SSH_TOOL_GongJuLei showAlter:SHAREDAPP.window WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
         [self.zhuanquan hideAnimated:YES];
        NSLog(@"%@",error);
    }];
}
// 取消活体检测指令回调方法.
- (void)receiveLivenessCancel {
    NSLog(@"活体检测取消");
}

#pragma mark ------ 下一步 -------
- (void)submitBtnClicked{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"faceId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] - 3)] animated:YES];
}
#pragma mark 上传照片接口
-(void)getImageUrlStr:(NSData *)data{
//    self.zhuanquan = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    self.zhuanquan.label.text = NSLocalizedString(@"中...", @"HUD loading title");
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *timestamp = [NSString yf_getNowTimestamp];
    NSString *signs = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:@"" timesTamp:timestamp];
    [param setValue:timestamp forKey:@"timestamp"];
    [param setValue:signs forKey:@"signs"];
    [DENGFANGRequest uploadImageWithURLString:UploadImgUrl parameters:param uploadDatas:data progress:^(float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{});
    } success:^(id reponse) {
        NSMutableDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dictionary[@"result"] integerValue] == 200) {
            self.photo1 = dictionary[@"url"][0];
            [[NSUserDefaults standardUserDefaults] setValue:self.photo1 forKey:DENGFANGRenTiPhotoUrlKey];
            [DENGFANGSingletonTime shareInstance].renTiShiBieUrl = self.photo1;
            [self.zhuanquan hideAnimated:YES];
            [SSH_TOOL_GongJuLei showAlter:SHAREDAPP.window WithMessage:@"人证比对成功"];
            [self brushVerificationCompletedView];
        }else{
            [self.zhuanquan hideAnimated:YES];
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:dictionary[@"message"]];
            
        }
    } failure:^(NSError *failure) {
        
    }];
}

@end
