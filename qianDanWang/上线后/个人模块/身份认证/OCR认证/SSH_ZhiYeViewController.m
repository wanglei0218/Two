//
//  SSH_ZhiYeViewController.m
//  DENGFANGSC
//
//  Created by 河神 on 2019/5/15.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_ZhiYeViewController.h"
#import "SSH_ShenFenUploadView.h"
#import "UIImage+DENGFANGCompressImage.h"

#import "SSH_ShenFenZhengTiJiaoTopView.h" //顶部提示view


@interface SSH_ZhiYeViewController ()<UITextFieldDelegate,SSH_ShenFenUploadViewlDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate>
{
    CGFloat _lastLineBottom;
}

@property (nonatomic,strong)UIScrollView * bgScrollView;
@property (nonatomic,strong)UIButton * submitBtn;//确认上传按钮
@property (nonatomic,strong)UIView *xinxiView;

@property (nonatomic,strong)UITextField *gongsiName;
@property (nonatomic,strong)UITextField *gongsiAddress;

@property (nonatomic,strong)SSH_ShenFenUploadView * gongpaiView;//正面view
@property (nonatomic,strong)SSH_ShenFenUploadView * mingpianView;//反面view

@property (nonatomic,assign)NSInteger btnTag;//按钮的tag值

@property (nonatomic,strong)NSMutableDictionary * dataDic;//上传的字典
@property (nonatomic,strong)NSMutableArray * tagArr;

@property (nonatomic,strong)NSString * photo1;
@property (nonatomic,strong)NSString * photo2;
@property (nonatomic,strong) MBProgressHUD *zhuanquan;


@end

@implementation SSH_ZhiYeViewController

#pragma mark -------- 上传单张接口 -----------
- (void)uploadOnlyImage:(NSData *)image{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *timestamp = [NSString yf_getNowTimestamp];
    NSString *signs = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:@"" timesTamp:timestamp];
    [param setValue:timestamp forKey:@"timestamp"];
    [param setValue:signs forKey:@"signs"];
    
    
    [DENGFANGRequest uploadImageWithURLString:UploadImgUrl parameters:param uploadDatas:image progress:^(float progress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    } success:^(id reponse) {
        NSMutableDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dictionary[@"result"] integerValue] == 200) {
            
            if (self.btnTag == 50) {
                self.photo1 = dictionary[@"url"][0];
                [[NSUserDefaults standardUserDefaults] setValue:self.photo1 forKey:DENGFANGWorkCardUrlKey];
                [DENGFANGSingletonTime shareInstance].workCardUrl = self.photo1;
            }else if (self.btnTag == 51){
                self.photo2 = dictionary[@"url"][0];
                [[NSUserDefaults standardUserDefaults] setValue:self.photo2 forKey:DENGFANGBusinessCardUrlKey];
                [DENGFANGSingletonTime shareInstance].businessCardUrl = self.photo2;
            }
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:dictionary[@"message"]];
        }
        
        [self judgeImageIsSelected];
        
    } failure:^(NSError *failure) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"图片上传失败，请重试"];
    }];
    
}


#pragma mark  懒加载
-(UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREENH_HEIGHT-getRectNavAndStatusHight)];
        _bgScrollView.backgroundColor = COLORWHITE;
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.scrollEnabled = YES;

        
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
        [_submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (UITextField *)gongsiName{
    if (!_gongsiName) {
        _gongsiName = [[UITextField alloc] init];
        _gongsiName.textColor = COLOR_WITH_HEX(0x222222);
        _gongsiName.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:WidthScale(13)];
        _gongsiName.userInteractionEnabled = YES;
        _gongsiName.keyboardType = UIKeyboardTypeNamePhonePad;
        _gongsiName.textAlignment = NSTextAlignmentLeft;
        _gongsiName.delegate = self;
        _gongsiName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入就职公司名称" attributes:@{NSForegroundColorAttributeName:ColorBlack999,NSFontAttributeName:[UIFont systemFontOfSize:WidthScale(13)]}];
    }
    return _gongsiName;
}

- (UITextField *)gongsiAddress{
    if (!_gongsiAddress) {
        _gongsiAddress = [[UITextField alloc] init];
        _gongsiAddress.textColor = COLOR_WITH_HEX(0x222222);
        _gongsiAddress.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:WidthScale(13)];
        _gongsiAddress.userInteractionEnabled = YES;
        _gongsiAddress.keyboardType = UIKeyboardTypeNamePhonePad;
        _gongsiAddress.textAlignment = NSTextAlignmentLeft;
        _gongsiAddress.delegate = self;
        _gongsiAddress.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您所在城市地址" attributes:@{NSForegroundColorAttributeName:ColorBlack999,NSFontAttributeName:[UIFont systemFontOfSize:WidthScale(13)]}];
    }
    return _gongsiAddress;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLORWHITE;
    self.lineView.hidden = NO;
    self.titleLabelNavi.text = @"身份证上传";
    
    [self.view addSubview:self.bgScrollView];
    
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, WidthScale(62+25))];
//    topView.backgroundColor = COLORWHITE;
//    [self.bgScrollView addSubview:topView];
//
//    UIImageView *topimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"职业认证_top"]];
//    topimage.frame = CGRectMake(WidthScale(35), WidthScale(12.5), ScreenWidth-WidthScale(70), WidthScale(62));
//    [topView addSubview:topimage];
    
    UIView * lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, WidthScale(7.5));
    lineView.backgroundColor = COLOR_With_Hex(0xf3f3f3);
    [self.bgScrollView addSubview:lineView];
    
    self.xinxiView = [[UIView alloc] initWithFrame:CGRectMake(0, lineView.bottom, ScreenWidth, WidthScale(645))];
    self.xinxiView.userInteractionEnabled = YES;
    [self.bgScrollView addSubview:self.xinxiView];
    
    [self creatXinxiView];
    
}

#pragma mark ------- 信息界面 --------
- (void)creatXinxiView{
    NSArray *xinxiArr = @[@"职业信息",@"就职公司",@"所在城市",@"职业证明"];

    for (int i=0; i<4; i++) {
        UIView * fengeline = [[UIView alloc]init];
        UILabel *xinxiLable = [[UILabel alloc] init];
        xinxiLable.text = xinxiArr[i];
        xinxiLable.textColor = ColorBlack222;
        if (i==0) {
            fengeline.frame = CGRectMake(0, (WidthScale(55)*(i+1)), SCREEN_WIDTH, WidthScale(0.5f));
            xinxiLable.font = [UIFont systemFontOfSize:WidthScale(15)];
            xinxiLable.frame = CGRectMake(WidthScale(15), WidthScale(20), WidthScale(85), HeightScale(15));
        }else if (i==3){
            fengeline.frame = CGRectMake(0, (WidthScale(55)*(i+1)), SCREEN_WIDTH, WidthScale(0.5f));
            xinxiLable.font = [UIFont systemFontOfSize:WidthScale(15)];
            xinxiLable.frame = CGRectMake(WidthScale(15), fengeline.top-WidthScale(35), WidthScale(85), HeightScale(15));
            _lastLineBottom = xinxiLable.bottom;
            
        }else if (i==1){
            fengeline.frame = CGRectMake(WidthScale(15), (WidthScale(53)*(i+1)), SCREEN_WIDTH, WidthScale(0.5f));
            xinxiLable.font = [UIFont systemFontOfSize:WidthScale(13)];
            xinxiLable.frame = CGRectMake(WidthScale(15), fengeline.top-WidthScale(33), WidthScale(85), HeightScale(13));
            
            self.gongsiName.frame = CGRectMake(xinxiLable.right ,fengeline.top-WidthScale(51.5f),ScreenWidth-xinxiLable.width-WidthScale(30) ,WidthScale(50) );
            [self.xinxiView addSubview:self.gongsiName];
        }else{
            fengeline.frame = CGRectMake(WidthScale(15), (WidthScale(53)*(i+1)), SCREEN_WIDTH, WidthScale(0.5f));
            xinxiLable.font = [UIFont systemFontOfSize:WidthScale(13)];
            xinxiLable.frame = CGRectMake(WidthScale(15), fengeline.top-WidthScale(33), WidthScale(85), HeightScale(13));
            
            self.gongsiAddress.frame = CGRectMake(xinxiLable.right ,fengeline.top-WidthScale(51.5f),ScreenWidth-xinxiLable.width-WidthScale(30) ,WidthScale(50) );
            [self.xinxiView addSubview:self.gongsiAddress];
        }
        fengeline.backgroundColor = GrayLineColor;
        [self.xinxiView addSubview:fengeline];
        [self.xinxiView addSubview:xinxiLable];
    }
    
    NSMutableArray * viewArr = [[NSMutableArray alloc]init];
    NSArray * textArr = @[@"请上传您的工牌",@"请上传名片"];
    NSArray * imgArr = @[@"zhiye-gongpai",@"zhiye-mingpian"];
    for (int i = 0; i < 2; i++) {
        SSH_ShenFenUploadView * baseView = [[SSH_ShenFenUploadView alloc]initWithFrame:CGRectMake(0, _lastLineBottom+20+170*i, SCREEN_WIDTH, 170)];
        baseView.myLabel.text = textArr[i];
        baseView.bgImgView.image = [UIImage imageNamed:imgArr[i]];
        baseView.delegate = self;
        [baseView setChildBtnTag:50+i];
        [self.xinxiView addSubview:baseView];
        [viewArr addObject:baseView];
        
    }
    self.gongpaiView = viewArr[0];
    self.mingpianView = viewArr[1];
    
    [self.xinxiView addSubview:self.submitBtn];
    self.submitBtn.frame = CGRectMake(30, self.mingpianView.bottom+WidthScale(30), SCREEN_WIDTH-WidthScale(60), WidthScale(40));
    
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, getRectNavAndStatusHight+WidthScale(750));

}

#pragma mark -------- 确认上传 ---------
- (void)submitBtnClicked{
    
    if (self.gongsiName.text.length == 0) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请输入公司名称"];
        return;
    }
    if (self.gongsiAddress.text.length == 0) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请输入您所在城市地址"];
        return;
    }
//    if (self.photo1.length == 0) {
//        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请上传您的工牌"];
//        return;
//    }
    if (self.photo2.length == 0 && self.photo1.length == 0) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请上传您的工牌或名片"];
        return;
    }
    
    [self getDENGFANGInsertAuthRecordForData];
    
}

-(void)shangChuanZhengBtnClicked:(UIButton *)btn{
    NSLog(@"000000=====tag = %ld",btn.tag);
    
    if (self.isAuth == 1) {
        btn.userInteractionEnabled = NO;
        
    }else{
        btn.userInteractionEnabled = YES;
        
        self.btnTag = btn.tag;
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"请选择相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                //图片选择是相机
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                //设置代理
                picker.delegate=self;
                //模态显示界面
                [self presentViewController:picker animated:YES completion:nil];
                
            }else {
                [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"不支持相机"];
            }
            
        }];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        
        [alertVc addAction:action];
        [alertVc addAction:actionCancel];
        [self presentViewController:alertVc animated:YES completion:nil];
        
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //通过key值获取到图片
    UIImage * image =info[UIImagePickerControllerOriginalImage];
    NSLog(@"image=%@  info=%@",image, info);
    
    //判断数据源类型
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        UIImage *newImage = [image imageCompressForSize:image targetSize:CGSizeMake(image.size.width*0.2, image.size.height*0.2)];
        NSData *imgData = UIImageJPEGRepresentation(newImage, 1);
        
        self.submitBtn.enabled = YES;

        //串行队列
        dispatch_queue_t queue = dispatch_queue_create("kk", DISPATCH_QUEUE_SERIAL);
        
        NSMutableArray * dataArr = [[NSMutableArray alloc]init];
        self.tagArr = [[NSMutableArray alloc]init];

        // 防止循环引用 使用 __weak 修饰
        __weak typeof(self)weakSelf = self;
        //设置图片背景
        if(self.btnTag == 50){
            [self.gongpaiView.bgImgView setImage:image];
            self.gongpaiView.myLabel.hidden = YES;
            [self.dataDic setValue:imgData forKey:@"gongpai"];
            
            if ([[self.dataDic allKeys] containsObject:@"gongpai"]) {
                [dataArr addObject:self.dataDic[@"gongpai"]];
                [self.tagArr addObject:@"1"];
            }
            
            //异步任务
            dispatch_async(queue, ^{
                
                [weakSelf uploadOnlyImage:imgData];
            });
            
        }else if (self.btnTag == 51){
            [self.mingpianView.bgImgView setImage:image];
            self.mingpianView.myLabel.hidden = YES;
            [self.dataDic setValue:imgData forKey:@"mingpian"];
            
            if ([[self.dataDic allKeys] containsObject:@"mingpian"]){
                [dataArr addObject:self.dataDic[@"mingpian"]];
                [self.tagArr addObject:@"2"];
            }
            
            //异步任务
            dispatch_async(queue, ^{
                
                [weakSelf uploadOnlyImage:imgData];
            });
        }
        
        /**
        if (dataArr.count>0) {
            NSMutableArray *willUploadArray = [NSMutableArray array];
            NSMutableArray *deleteArray = [NSMutableArray array];
            for (NSInteger i = 0; i < dataArr.count; i++) {
                id child = dataArr[i];
                if ([child isKindOfClass:[NSData class]]) {
                    [willUploadArray addObject:child];
                }else {
                    [deleteArray addObject:self.tagArr[i]];
                }
            }
            [self.tagArr removeObjectsInArray:[deleteArray copy]];
            if (willUploadArray.count) {
                [self getGongImageUrlStr:willUploadArray];
            }
            
            
        }else {
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请将照片上传完整"];
        }
        
         */
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        UIImage *newImage = [image imageCompressForSize:image targetSize:CGSizeMake(image.size.width*0.1, image.size.height*0.1)];
        NSData *imgData = UIImageJPEGRepresentation(newImage, 1);
        
        self.submitBtn.enabled = YES;
        
        //串行队列
        dispatch_queue_t queue = dispatch_queue_create("kk", DISPATCH_QUEUE_SERIAL);
        
        NSMutableArray * dataArr = [[NSMutableArray alloc]init];
        self.tagArr = [[NSMutableArray alloc]init];
        
        // 防止循环引用 使用 __weak 修饰
        __weak typeof(self)weakSelf = self;
        
        //设置图片背景
        if(self.btnTag == 50){
            [self.gongpaiView.bgImgView setImage:image];
            [self.dataDic setValue:imgData forKey:@"gongpai"];
            self.gongpaiView.myLabel.hidden = YES;
            if ([[self.dataDic allKeys] containsObject:@"gongpai"]) {
                [dataArr addObject:self.dataDic[@"gongpai"]];
                [self.tagArr addObject:@"1"];
            }
            
            //异步任务
            dispatch_async(queue, ^{
                
                [weakSelf uploadOnlyImage:imgData];
            });
            
        }else if (self.btnTag == 51){
            [self.mingpianView.bgImgView setImage:image];
            [self.dataDic setValue:imgData forKey:@"mingpian"];
            self.mingpianView.myLabel.hidden = YES;
            
            if ([[self.dataDic allKeys] containsObject:@"mingpian"]){
                [dataArr addObject:self.dataDic[@"mingpian"]];
                [self.tagArr addObject:@"2"];
            }
            
            //异步任务
            dispatch_async(queue, ^{
                
                [weakSelf uploadOnlyImage:imgData];
            });
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    [self judgeImageIsSelected];
}

#pragma mark ==================textField代理方法==============
- (void)textFieldDidEndEditing:(UITextField *)textField{

    [self judgeImageIsSelected];
}

#pragma mark -判断按钮是否显示亮色
- (void)judgeImageIsSelected {
    
    if (self.gongsiName.text.length>0 && self.gongsiAddress.text.length>0 && (self.photo1.length != 0 || self.photo2.length != 0)) {
        self.submitBtn.backgroundColor = ColorZhuTiHongSe;
    }else{
        self.submitBtn.backgroundColor = Colorffb5b7;
    }
    
}


#pragma mark 用户认证接口 DENGFANGInsertAuthRecordURL
-(void)getDENGFANGInsertAuthRecordForData{
    self.submitBtn.enabled = NO;
    self.zhuanquan = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.zhuanquan.label.text = NSLocalizedString(@"正在上传中...", @"HUD loading title");
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = [NSString yf_getNowTimestamp];
    dict[@"signs"] = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d%@",[DENGFANGSingletonTime shareInstance].useridString,[DENGFANGSingletonTime shareInstance].mobileString]];
    dict[@"userId"] = [NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString];
    dict[@"mobile"] = [DENGFANGSingletonTime shareInstance].mobileString;
    dict[@"realName"] = self.card_name;
    dict[@"idCard"] = self.card_id;
    dict[@"enterpriseName"] = self.gongsiName.text;
    dict[@"enterpriseAddress"] = self.gongsiAddress.text;
    dict[@"idCardFaceUrl"] = [DENGFANGSingletonTime shareInstance].idCardFaceUrl;
    dict[@"idCardBackUrl"] = [DENGFANGSingletonTime shareInstance].idCardBackUrl;
    dict[@"workCardUrl"] = self.photo1.length==0?@"":self.photo1;
    dict[@"businessCardUrl"] = self.photo2.length==0?@"":self.photo2;
    dict[@"isFaceCheck"] = @"1";
    dict[@"faceVideoUrl"] = [DENGFANGSingletonTime shareInstance].renTiShiBieUrl;
    
    NSLog(@"%@",dict);
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGInsertAuthRecordURL parameters:dict success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"用户认证 信息 数据 %@",diction);
        
        [self.zhuanquan hideAnimated:YES];
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [SSH_TOOL_GongJuLei showAlter:SHAREDAPP.window WithMessage:@"上传成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
        self.submitBtn.enabled = YES;
    } fail:^(NSError *error) {
        [self.zhuanquan hideAnimated:YES];
        self.submitBtn.enabled = YES;
    }];
}



@end
