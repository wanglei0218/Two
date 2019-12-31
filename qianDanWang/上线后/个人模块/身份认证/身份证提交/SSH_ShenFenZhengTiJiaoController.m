//
//  SSH_ShenFenZhengTiJiaoController.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ShenFenZhengTiJiaoController.h"
#import "SSH_ShenFenUploadView.h"
#import "UIImage+DENGFANGCompressImage.h"

#import "SSH_ShenFenZhengTiJiaoTopView.h" //顶部提示view
#import "SSH_ShenFenZhengPopView.h"    //弹窗

@interface SSH_ShenFenZhengTiJiaoController ()<SSH_ShenFenUploadViewlDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (nonatomic,strong)UIScrollView * bgScrollView;//

@property (nonatomic,strong)SSH_ShenFenUploadView * zhengView;//正面view
@property (nonatomic,strong)SSH_ShenFenUploadView * fanView;//反面view
@property (nonatomic,strong)SSH_ShenFenUploadView * meView;//合影面view

@property (nonatomic,strong)UIButton * submitBtn;//确认上传按钮

@property (nonatomic,assign)NSInteger btnTag;//按钮的tag值

@property (nonatomic,strong)NSMutableDictionary * dataDic;//上传的字典
@property (nonatomic,strong)NSMutableArray * tagArr;

@property (nonatomic,strong)NSString * photo1;
@property (nonatomic,strong)NSString * photo2;
@property (nonatomic,strong)NSString * photo3;

@property (nonatomic,strong) MBProgressHUD *zhuanquan;

@property (nonatomic, strong) UIView *grayView; //蒙版
@property (nonatomic, strong) SSH_ShenFenZhengPopView *whiteView; //提示窗

@end

@implementation SSH_ShenFenZhengTiJiaoController
#pragma mark 上传照片接口
-(void)getImageUrlStr:(NSMutableArray *)dataArr{
    self.zhuanquan = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.zhuanquan.label.text = NSLocalizedString(@"正在上传中...", @"HUD loading title");
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *timestamp = [NSString yf_getNowTimestamp];
    NSString *signs = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:@"" timesTamp:timestamp];
    [param setValue:timestamp forKey:@"timestamp"];
    [param setValue:signs forKey:@"signs"];
    
    
    [DENGFANGRequest uploadImagesWithURLString:UploadImgUrl parameters:param uploadDataArrs:dataArr progress:^(float progress) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    } success:^(id reponse) {
        NSMutableDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dictionary[@"result"] integerValue] == 200) {
            
            for (int i = 0; i < self.tagArr.count; i++) {
                if ([self.tagArr[i] intValue] == 1) {
                    self.photo1 = dictionary[@"url"][i];
                    [[NSUserDefaults standardUserDefaults] setValue:self.photo1 forKey:DENGFANGIdCardFaceUrlKey];
                    [DENGFANGSingletonTime shareInstance].idCardFaceUrl = self.photo1;
                }else if ([self.tagArr[i] intValue] == 2){
                    self.photo2 = dictionary[@"url"][i];
                    [[NSUserDefaults standardUserDefaults] setValue:self.photo2 forKey:DENGFANGIdCardBackUrlKey];
                    [DENGFANGSingletonTime shareInstance].idCardBackUrl = self.photo2;
                }else if ([self.tagArr[i] intValue] == 3){
                    self.photo3 = dictionary[@"url"][i];
                    [[NSUserDefaults standardUserDefaults] setValue:self.photo3 forKey:DENGFANGIdCardPhotoUrlKey];
                    [DENGFANGSingletonTime shareInstance].idCardPhotoUrl = self.photo3;
                }
            }
            
//            [[NSUserDefaults standardUserDefaults] setValue:self.photo1 forKey:DENGFANGIdCardFaceUrlKey];
//            [[NSUserDefaults standardUserDefaults] setValue:self.photo2 forKey:DENGFANGIdCardBackUrlKey];
//            [[NSUserDefaults standardUserDefaults] setValue:self.photo3 forKey:DENGFANGIdCardPhotoUrlKey];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//
//            [DENGFANGSingletonTime shareInstance].idCardFaceUrl = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGIdCardFaceUrlKey];
//            [DENGFANGSingletonTime shareInstance].idCardBackUrl = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGIdCardBackUrlKey];
//            [DENGFANGSingletonTime shareInstance].idCardPhotoUrl = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGIdCardPhotoUrlKey];
            [self.zhuanquan hideAnimated:YES];
            [SSH_TOOL_GongJuLei showAlter:SHAREDAPP.window WithMessage:@"上传成功"];
            self.block(YES);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.zhuanquan hideAnimated:YES];
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:dictionary[@"message"]];

        }
        
    } failure:^(NSError *failure) {
        [self.zhuanquan hideAnimated:YES];
        NSLog(@"%@",failure);
    }];
    
    
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
-(void)submitBtnClicked{
    self.tagArr = [[NSMutableArray alloc]init];
    NSMutableArray * dataArr = [[NSMutableArray alloc]init];
    
    if ([[self.dataDic allKeys] containsObject:@"zheng"]) {
        [dataArr addObject:self.dataDic[@"zheng"]];
        [self.tagArr addObject:@"1"];
    }
    if ([[self.dataDic allKeys] containsObject:@"fan"]){
            [dataArr addObject:self.dataDic[@"fan"]];
            [self.tagArr addObject:@"2"];
    }
    if ([[self.dataDic allKeys] containsObject:@"he"]){
            [dataArr addObject:self.dataDic[@"he"]];
            [self.tagArr addObject:@"3"];
    }
    
    
    
    
    if (dataArr.count>2) {
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
            [self getImageUrlStr:willUploadArray];
        }
    }else {
        [SSH_TOOL_GongJuLei showAlter:SHAREDAPP.window WithMessage:@"请将其他身份照片上传完整"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLORWHITE;
    
    self.titleLabelNavi.text = @"身份证上传";
    
    //弹窗
    [self setupPopView];
    
    UIView * line = [[UIView alloc]init];
    line.frame = CGRectMake(0, getRectNavAndStatusHight-0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = GrayLineColor;
    [self.view addSubview:line];
    
    self.dataDic = [[NSMutableDictionary alloc]init];
    
    [self.view addSubview:self.bgScrollView];
    if (!IS_IPHONE5) {
        self.bgScrollView.scrollEnabled = NO;
    }

    SSH_ShenFenZhengTiJiaoTopView *topView = [SSH_ShenFenZhengTiJiaoTopView creatView];
    topView.frame = CGRectMake(0, 0, ScreenWidth, 34);
    [self.bgScrollView addSubview:topView];
    
    NSMutableArray * viewArr = [[NSMutableArray alloc]init];
    NSArray * textArr = @[@"请上传身份证正面",@"请上传身份证反面",@"请上传您与身份证的合影"];
    NSArray * imgArr = @[@"ID-zheng",@"ID-fan",@"ID-me"];
    for (int i = 0; i < 3; i++) {
        SSH_ShenFenUploadView * baseView = [[SSH_ShenFenUploadView alloc]initWithFrame:CGRectMake(0, topView.height+170*i, SCREEN_WIDTH, 170)];
        baseView.myLabel.text = textArr[i];
        baseView.bgImgView.image = [UIImage imageNamed:imgArr[i]];
        baseView.delegate = self;
        [baseView setChildBtnTag:30+i];
        [self.bgScrollView addSubview:baseView];
        [viewArr addObject:baseView];
        
    }
    self.zhengView = viewArr[0];
    self.fanView = viewArr[1];
    self.meView = viewArr[2];
    
    [self.bgScrollView addSubview:self.submitBtn];
    self.submitBtn.frame = CGRectMake(30, self.meView.mj_h+self.meView.mj_y+15, SCREEN_WIDTH-60, 40);
    
    if ([DENGFANGSingletonTime shareInstance].idCardFaceUrl.length > 10) {
        self.photo1 = [DENGFANGSingletonTime shareInstance].idCardFaceUrl;
        [self.zhengView.bgImgView sd_setImageWithURL:[NSURL URLWithString:[DENGFANGSingletonTime shareInstance].idCardFaceUrl] placeholderImage:[UIImage imageNamed:@"ID-zheng"]];
        self.zhengView.myLabel.hidden = YES;
        //认证失败将原来的照片添加到字典中
        [self.dataDic setValue:self.photo1 forKey:@"zheng"];
    }
    
    if ([DENGFANGSingletonTime shareInstance].idCardBackUrl.length > 10) {
        self.photo2 = [DENGFANGSingletonTime shareInstance].idCardBackUrl;
        [self.fanView.bgImgView sd_setImageWithURL:[NSURL URLWithString:[DENGFANGSingletonTime shareInstance].idCardBackUrl] placeholderImage:[UIImage imageNamed:@"ID-fan"]];
        self.fanView.myLabel.hidden = YES;

        [self.dataDic setValue:self.photo2 forKey:@"fan"];

    }
    
    if ([DENGFANGSingletonTime shareInstance].idCardPhotoUrl.length > 10) {
        self.photo3 = [DENGFANGSingletonTime shareInstance].idCardPhotoUrl;
        [self.meView.bgImgView sd_setImageWithURL:[NSURL URLWithString:[DENGFANGSingletonTime shareInstance].idCardPhotoUrl] placeholderImage:[UIImage imageNamed:@"ID-me"]];
        self.meView.myLabel.hidden = YES;
        [self.dataDic setValue:self.photo3 forKey:@"he"];

    }
    
}
-(void)shangChuanZhengBtnClicked:(UIButton *)btn{
    
    if (self.isAuth == 1) {
        btn.userInteractionEnabled = NO;
        
    }else{
        btn.userInteractionEnabled = YES;
        self.btnTag = btn.tag;
        
//        //定义消息框
//
//        UIActionSheet * act =[[UIActionSheet alloc]initWithTitle:@"请选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择相机", nil];
//
//        //显示消息框
//        [act showInView:self.view];
        
        
        
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
//消息框代理实现

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //定义图片选择器
    
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];

    
//判断
//    switch (buttonIndex) {
//
//        case 0: //判断系统是否允许选择 相册
//
//            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//
//                //图片选择是相册（图片来源自相册）
//                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                //设置代理
//                picker.delegate=self;
//                //模态显示界面
//                [self presentViewController:picker animated:YES completion:nil];
//            }
//            break;
//
//        case 1://判断系统是否允许选择 相机
    
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                //图片选择是相机
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                //设置代理
                picker.delegate=self;
                //模态显示界面
                [self presentViewController:picker animated:YES completion:nil];
                
            }else {
                [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"不支持相机"];
            }
//            break;
//
//        default:
//            break;
//    }
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
//        self.submitBtn.backgroundColor = ColorZhuTiHongSe;
        //设置图片背景
        if(self.btnTag == 30){
            [self.zhengView.bgImgView setImage:image];
            [self.dataDic setValue:imgData forKey:@"zheng"];
            self.zhengView.myLabel.hidden = YES;
        }else if (self.btnTag == 31){
            [self.fanView.bgImgView setImage:image];
            [self.dataDic setValue:imgData forKey:@"fan"];
            self.fanView.myLabel.hidden = YES;

        }else if (self.btnTag == 32){
            self.meView.bgImgView.image = image;
            [self.dataDic setValue:imgData forKey:@"he"];
            self.meView.myLabel.hidden = YES;
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        NSLog(@"在相机中选择图片");
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

        UIImage *newImage = [image imageCompressForSize:image targetSize:CGSizeMake(image.size.width*0.1, image.size.height*0.1)];
        NSData *imgData = UIImageJPEGRepresentation(newImage, 1);

        self.submitBtn.enabled = YES;
//        self.submitBtn.backgroundColor = ColorZhuTiHongSe;
        //设置图片背景
        if(self.btnTag == 30){
            [self.zhengView.bgImgView setImage:image];
            self.zhengView.myLabel.hidden = YES;
            [self.dataDic setValue:imgData forKey:@"zheng"];
        }else if (self.btnTag == 31){
            [self.fanView.bgImgView setImage:image];
            self.fanView.myLabel.hidden = YES;
            [self.dataDic setValue:imgData forKey:@"fan"];
        }else if (self.btnTag == 32){
            self.meView.bgImgView.image = image;
            self.meView.myLabel.hidden = YES;
            [self.dataDic setValue:imgData forKey:@"he"];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    [self judgeImageIsSelected];
}

#pragma mark -判断按钮是否显示亮色
- (void)judgeImageIsSelected {
    if (self.dataDic.allKeys.count > 2) {
        self.submitBtn.backgroundColor = ColorZhuTiHongSe;
    }else {
        self.submitBtn.backgroundColor = Colorffb5b7;
    }
}

-(void)setupPopView{
    
    self.grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self.grayView];
    self.grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    self.whiteView = [SSH_ShenFenZhengPopView creatView];
    [self.grayView addSubview:self.whiteView];
    [self.whiteView.knowButton addTarget:self action:@selector(clickKnowButton) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getRectNavAndStatusHight+44.5);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-28.5);
    }];
}

-(void)clickKnowButton{
    [self.grayView removeFromSuperview];
    [self.whiteView removeFromSuperview];
}

@end
