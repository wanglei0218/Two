//
//  SSH_ZhiYeZhengmingController.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ZhiYeZhengmingController.h"
#import "SSH_ShenFenUploadView.h"
#import "UIImage+DENGFANGCompressImage.h"
#import "SSH_ShenFenZhengTiJiaoTopView.h"


@interface SSH_ZhiYeZhengmingController ()<SSH_ShenFenUploadViewlDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)SSH_ShenFenUploadView * gongpaiView;//工牌
@property (nonatomic,strong)SSH_ShenFenUploadView * mingpianView;//名片
@property (nonatomic,strong)UIButton * submitBtn;//确认上传按钮

@property (nonatomic,assign)NSInteger btnTag;//按钮的tag值

@property (nonatomic,strong)NSMutableDictionary * dataDic;//上传的字典
@property (nonatomic,strong)NSMutableArray * tagArr;

@property (nonatomic,strong)NSString * photo1;
@property (nonatomic,strong)NSString * photo2;
@property (nonatomic,strong) MBProgressHUD *zhuanquan;

@end

@implementation SSH_ZhiYeZhengmingController
#pragma mark 上传照片接口
-(void)getGongImageUrlStr:(NSMutableArray *)dataArr{
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
                    [[NSUserDefaults standardUserDefaults] setValue:self.photo1 forKey:DENGFANGWorkCardUrlKey];
                    [DENGFANGSingletonTime shareInstance].workCardUrl = self.photo1;
                }else if ([self.tagArr[i] intValue] == 2){
                    self.photo2 = dictionary[@"url"][i];
                    [[NSUserDefaults standardUserDefaults] setValue:self.photo2 forKey:DENGFANGBusinessCardUrlKey];
                    [DENGFANGSingletonTime shareInstance].businessCardUrl = self.photo2;
                }
            }

//            [[NSUserDefaults standardUserDefaults] setValue:self.photo1 forKey:DENGFANGWorkCardUrlKey];
//            [[NSUserDefaults standardUserDefaults] setValue:self.photo2 forKey:DENGFANGBusinessCardUrlKey];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//
//            [DENGFANGSingletonTime shareInstance].workCardUrl = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGWorkCardUrlKey];
//            [DENGFANGSingletonTime shareInstance].businessCardUrl = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGBusinessCardUrlKey];
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
    }];
    
    
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
        _submitBtn.enabled = NO;
        [_submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}
-(void)submitBtnClicked{
    
    
    
    self.tagArr = [[NSMutableArray alloc]init];
    NSMutableArray * dataArr = [[NSMutableArray alloc]init];
    
    if ([[self.dataDic allKeys] containsObject:@"gongpai"]) {
        [dataArr addObject:self.dataDic[@"gongpai"]];
        [self.tagArr addObject:@"1"];
    }
    if ([[self.dataDic allKeys] containsObject:@"mingpian"]){
        [dataArr addObject:self.dataDic[@"mingpian"]];
        [self.tagArr addObject:@"2"];
    }

    
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
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = COLORWHITE;
    
    self.titleLabelNavi.text = @"职业证明上传";
    
    self.dataDic = [[NSMutableDictionary alloc]init];
    
    UIView * line = [[UIView alloc]init];
    line.frame = CGRectMake(0, getRectNavAndStatusHight-0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = GrayLineColor;
    [self.view addSubview:line];
    
    SSH_ShenFenZhengTiJiaoTopView *topView = [SSH_ShenFenZhengTiJiaoTopView creatView];
    topView.frame = CGRectMake(0, getRectNavAndStatusHight, ScreenWidth, 34);
    [self.view addSubview:topView];
    
    NSMutableArray * viewArr = [[NSMutableArray alloc]init];
    NSArray * textArr = @[@"请上传您的工牌或者名片照片",@"请上传与公司LOGO合影"];
    NSArray * imgArr = @[@"zhiye-gongpai",@"zhiye-mingpian"];
    for (int i = 0; i < 2; i++) {
        SSH_ShenFenUploadView * baseView = [[SSH_ShenFenUploadView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHight+topView.height+170*i, SCREEN_WIDTH, 170)];
        baseView.myLabel.text = textArr[i];
        baseView.bgImgView.image = [UIImage imageNamed:imgArr[i]];
        baseView.delegate = self;
        [baseView setChildBtnTag:50+i];
        [self.view addSubview:baseView];
        [viewArr addObject:baseView];
    }
    
    self.gongpaiView = viewArr[0];
    self.mingpianView = viewArr[1];
    
    
    [self.view addSubview:self.submitBtn];
    self.submitBtn.frame = CGRectMake(30, self.mingpianView.mj_h+self.mingpianView.mj_y+30, SCREEN_WIDTH-60, 40);
    
    
    if ([DENGFANGSingletonTime shareInstance].workCardUrl.length > 10) {
        self.photo1 = [DENGFANGSingletonTime shareInstance].workCardUrl;
        [self.gongpaiView.bgImgView sd_setImageWithURL:[NSURL URLWithString:[DENGFANGSingletonTime shareInstance].workCardUrl] placeholderImage:[UIImage imageNamed:@"zhiye-gongpai"]];
        self.gongpaiView.myLabel.hidden = YES;
        [self.dataDic setValue:self.photo1 forKey:@"gongpai"];
    }
    
    if ([DENGFANGSingletonTime shareInstance].businessCardUrl.length > 10) {
        self.photo2 = [DENGFANGSingletonTime shareInstance].businessCardUrl;
        [self.mingpianView.bgImgView sd_setImageWithURL:[NSURL URLWithString:[DENGFANGSingletonTime shareInstance].businessCardUrl] placeholderImage:[UIImage imageNamed:@"zhiye-mingpian"]];
        self.mingpianView.myLabel.hidden = YES;
        [self.dataDic setValue:self.photo2 forKey:@"mingpian"];
    }
    
}
-(void)shangChuanZhengBtnClicked:(UIButton *)btn{
    NSLog(@"000000=====tag = %ld",btn.tag);
    
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
//
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
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //通过key值获取到图片
    UIImage * image =info[UIImagePickerControllerOriginalImage];
    NSLog(@"image=%@  info=%@",image, info);
    
    //判断数据源类型
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        UIImage *newImage = [image imageCompressForSize:image targetSize:CGSizeMake(image.size.width*0.2, image.size.height*0.2)];
        NSData *imgData = UIImageJPEGRepresentation(newImage, 1);
//        NSData* imgData = UIImageJPEGRepresentation(image, 0.4);
        
        self.submitBtn.enabled = YES;
//        self.submitBtn.backgroundColor = ColorZhuTiHongSe;
        //设置图片背景
        if(self.btnTag == 50){
            [self.gongpaiView.bgImgView setImage:image];
            self.gongpaiView.myLabel.hidden = YES;
            [self.dataDic setValue:imgData forKey:@"gongpai"];
        }else if (self.btnTag == 51){
            [self.mingpianView.bgImgView setImage:image];
            self.mingpianView.myLabel.hidden = YES;
            [self.dataDic setValue:imgData forKey:@"mingpian"];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        NSLog(@"在相机中选择图片");
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        UIImage *newImage = [image imageCompressForSize:image targetSize:CGSizeMake(image.size.width*0.1, image.size.height*0.1)];
        //        NSData* imgData = UIImageJPEGRepresentation(image, 0.1);
        NSData *imgData = UIImageJPEGRepresentation(newImage, 1);
        
        self.submitBtn.enabled = YES;
//        self.submitBtn.backgroundColor = ColorZhuTiHongSe;
        //设置图片背景
        if(self.btnTag == 50){
            [self.gongpaiView.bgImgView setImage:image];
            [self.dataDic setValue:imgData forKey:@"gongpai"];
            self.gongpaiView.myLabel.hidden = YES;
        }else if (self.btnTag == 51){
            [self.mingpianView.bgImgView setImage:image];
            [self.dataDic setValue:imgData forKey:@"mingpian"];
            self.mingpianView.myLabel.hidden = YES;
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    [self judgeImageIsSelected];
}
#pragma mark -判断按钮是否显示亮色
- (void)judgeImageIsSelected {
    if (self.dataDic.allKeys.count > 0) {
        self.submitBtn.backgroundColor = ColorZhuTiHongSe;
    }else {
        self.submitBtn.backgroundColor = Colorffb5b7;
    }
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
