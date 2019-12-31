//
//  SSH_TuiDanViewController.m
//  DENGFANGSC
//
//  Created by 河神 on 2019/5/10.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_TuiDanViewController.h"
#import "SSH_TDSubmitImgView.h"
#import "SSH_TuiDanYuanYinChoose.h"
#import "SSH_TuiDanWanChengViewController.h"
#import "SSH_TuiDanExplainViewController.h"

@interface SSH_TuiDanViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSInteger btnTag;
}

@property (nonatomic, strong) UIScrollView *tuidanScrView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) SSH_TDSubmitImgView *xinxiView;
@property (nonatomic,strong) NSMutableArray *imageArr;
@property (nonatomic,strong) NSMutableArray *imageUrlArr;

@property (nonatomic,strong) NSArray *chooseTdyyArr;

@property (nonatomic,strong) UILabel *bianhaoLabel;

@end

@implementation SSH_TuiDanViewController


#pragma mark --------- 控件初始化 ---------
- (UIScrollView *)tuidanScrView{
    if (!_tuidanScrView) {
        _tuidanScrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, ScreenWidth, ScreenHeight-getRectNavAndStatusHight-SafeAreaBottomHEIGHT)];
        _tuidanScrView.contentSize = CGSizeMake(ScreenWidth, getRectNavAndStatusHight+WidthScale(550));
        _tuidanScrView.delegate = self;
    }
    return _tuidanScrView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text = @"申请退单";
    self.lineView.hidden = NO;
    
    //退单说明
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:WidthScale(12)];
    [rightBtn setTitle:@"退单说明" forState:UIControlStateNormal];
    [rightBtn setTitleColor:ColorBlack999 forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(returnOrderDescription) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationView addSubview:rightBtn];
    rightBtn.sd_layout.rightSpaceToView(self.navigationView, WidthScale(15)).heightIs(WidthScale(12)).widthIs(65).centerYEqualToView(self.titleLabelNavi);
   
    self.imageUrlArr = [NSMutableArray array];
    
    [self.view addSubview:self.tuidanScrView];
    
    [self creatHeaderView];
    [self loadRequestDataRules:@"2"];
    [self creatXinxiView];

}

#pragma mark ------ 信息展示
- (void)creatHeaderView{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, WidthScale(200))];
    self.headerView.backgroundColor = COLORWHITE;
    self.headerView.userInteractionEnabled = YES;
    [self.tuidanScrView addSubview:self.headerView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(WidthScale(15), WidthScale(17.5), WidthScale(150), WidthScale(15))];
    nameLabel.textColor = ColorBlack222;
    nameLabel.font = [UIFont systemFontOfSize:WidthScale(15)];
    [self.headerView addSubview:nameLabel];
    [nameLabel setSingleLineAutoResizeWithMaxWidth:WidthScale(100)];
    nameLabel.text = self.nameStr;
    
    UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-(ScreenWidth-nameLabel.width)-WidthScale(15), nameLabel.y, ScreenWidth-nameLabel.width, WidthScale(15))];
    timeLable.textAlignment = NSTextAlignmentRight;
    timeLable.textColor = ColorBlack999;
    timeLable.font = [UIFont systemFontOfSize:WidthScale(12)];
    timeLable.text = self.shenQingTimeStr;
    [self.headerView addSubview:timeLable];
    
    self.bianhaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(WidthScale(15), nameLabel.bottom+WidthScale(17.5), WidthScale(45), WidthScale(15))];
    self.bianhaoLabel.textColor = ColorBlack222;
    self.bianhaoLabel.font = [UIFont systemFontOfSize:WidthScale(15)];
    [self.headerView addSubview:self.bianhaoLabel];
    [self.bianhaoLabel setSingleLineAutoResizeWithMaxWidth:WidthScale(100)];
    self.bianhaoLabel.text = @"订单编号：";
    
    UILabel *bianhao = [[UILabel alloc] initWithFrame:CGRectMake(self.bianhaoLabel.right, self.bianhaoLabel.y, WidthScale(200), WidthScale(15))];
    bianhao.textColor = ColorBlack222;
    bianhao.font = [UIFont systemFontOfSize:WidthScale(15)];
    [self.headerView addSubview:bianhao];
    [bianhao setSingleLineAutoResizeWithMaxWidth:WidthScale(180)];
    bianhao.text = self.orderNo;
    
}

- (void)creatTuiDanYuanYin{
    
    UILabel *chooseLable = [[UILabel alloc] initWithFrame:CGRectMake(WidthScale(15), self.bianhaoLabel.bottom+WidthScale(17.5), WidthScale(200), WidthScale(15))];
    chooseLable.textColor = ColorBlack222;
    chooseLable.font = [UIFont systemFontOfSize:WidthScale(15)];
    [self.headerView addSubview:chooseLable];
    [chooseLable setSingleLineAutoResizeWithMaxWidth:WidthScale(200)];
    chooseLable.text = @"选择退单原因（单选）";
    
    //按钮的宽度
    CGFloat btnWidth1 = WidthScale(100);
    //按钮的高度
    CGFloat btnHeight1 = WidthScale(32);
    //按钮距离
    CGFloat dis = ( ScreenWidth - WidthScale(30) ) / 3;
    //使用for循环建立按钮
    for (int i = 0; i < self.chooseTdyyArr.count; i++) {
        
        SSH_TuiDanYuanYinChoose *model = self.chooseTdyyArr[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i<3) {
            btn.frame = CGRectMake(WidthScale(15)+dis*i, chooseLable.bottom+WidthScale(15), btnWidth1, btnHeight1);
        }else if (i>=3 && i<6){
            btn.frame = CGRectMake(WidthScale(15)+dis*(i-3), chooseLable.bottom+WidthScale(15+12.5)+btnHeight1, btnWidth1, btnHeight1);
        }
        
        btn.tag = model.ID;
        [btn setTitle:model.refundRules forState:UIControlStateNormal];
        [btn setTitleColor:ColorBlack222 forState:UIControlStateNormal];
        [btn setTitleColor:COLORWHITE forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"yuanyin_no_tuidan"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"yuanyin_sel_tuidan"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(tdYuanYinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:WidthScale(13)];
        
        [self.headerView addSubview:btn];
        
    }
    
    CGFloat headerHeight = WidthScale(112.5)+(self.chooseTdyyArr.count/3+1)*(btnHeight1+WidthScale(17.5));
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth, headerHeight);
}

- (void)creatXinxiView{
    
    UIImage *image = [UIImage imageNamed:@"addImage_tuidan"];
    //照片数组
    self.imageArr = [[NSMutableArray alloc]initWithArray:@[image]];

    self.xinxiView = [[SSH_TDSubmitImgView alloc] initWithFrame:CGRectMake(WidthScale(0), self.headerView.height, ScreenWidth, WidthScale(310))];
    self.xinxiView.imageArr = self.imageArr;
    __weak typeof(self) weakSelf = self;
    
    self.xinxiView.removerImage = ^(NSInteger tag) {
        
        if(weakSelf.imageUrlArr != nil){
            [weakSelf.imageUrlArr removeObjectAtIndex:tag];
        }
    };
    
    self.xinxiView.didSelectTheAddImageBtn = ^{
        UIAlertController *alert = [[UIAlertController alloc]init];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf getImageWithType:0];
            });
        }];
        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf getImageWithType:1];
            });
        }];
        
        [alert addAction:cameraAction];
        [alert addAction:photoAction];
        [alert addAction:cancelAction];
        
        [weakSelf presentViewController:alert animated:YES completion:nil];
        
    };
    [self.tuidanScrView addSubview:self.xinxiView];
    
    UIButton *tijiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tijiaoBtn.frame = CGRectMake(WidthScale(30), self.xinxiView.bottom+WidthScale(15), ScreenWidth-WidthScale(60), WidthScale(40));
    tijiaoBtn.layer.cornerRadius = WidthScale(40/2);
    tijiaoBtn.layer.masksToBounds = YES;
    tijiaoBtn.backgroundColor = RGB(247, 22, 49);
    tijiaoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [tijiaoBtn setTitle:@"申请退单" forState:UIControlStateNormal];
    [tijiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tijiaoBtn addTarget:self action:@selector(sqTuiDanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.tuidanScrView addSubview:tijiaoBtn];
}

#pragma mark ---- 退单说明 ----
- (void)returnOrderDescription{
    
    SSH_TuiDanExplainViewController *shuoMingVC = [[SSH_TuiDanExplainViewController alloc] init];
    [self.navigationController pushViewController:shuoMingVC animated:YES];
    
}

#pragma mark ------- 退单选择 -------
- (void)tdYuanYinBtnClick:(UIButton *)sender{
    
    btnTag = sender.tag;
    
    if (sender!=self.selectBtn) {
        self.selectBtn.selected = NO;
        sender.selected = YES;
        self.selectBtn = sender;
    }else{
        self.selectBtn.selected = YES;
    }
}

#pragma mark ----------申请退单
- (void)sqTuiDanBtnClick:(UIButton *)sender{
    
    if (self.selectBtn.titleLabel.text==nil||[self.selectBtn.titleLabel.text isEqualToString:@""]) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请选择退单原因"];
        return;
    }
    
    if (self.imageUrlArr.count == 0) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请提供证明图片"];
        return;
    }
    
    if (self.xinxiView.textView.text.length == 0) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请补充退单说明"];
        return;
    }
    
    static NSTimeInterval time = 0.0;
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    //限制用户点击按钮的时间间隔大于1秒钟
    
    if (currentTime - time > 1) {
        //处理逻辑
        [self loadRequestData];
    }
    time = currentTime;
    
    
}

#pragma mark ================上传单张图片接口===============
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
            
            [self.imageUrlArr addObject:dictionary[@"url"][0]];
    
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:dictionary[@"message"]];
        }
        
    } failure:^(NSError *failure) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"图片上传失败，请重试"];
    }];
    
}

#pragma mark ================ 退单原因接口 ===============
- (void)loadRequestDataRules:(NSString *)rules{
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGTuiDanYuanYinURL parameters:@{@"userId":[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString],@"rules":rules,@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]]} success:^(id responsObject) {
        
        NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        if ([dictionary[@"code"] integerValue] == 200) {
            
            self.chooseTdyyArr = [SSH_TuiDanYuanYinChoose creatArrayWithArray:dictionary[@"data"]];
            [self creatTuiDanYuanYin];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark ------------- 数据加载 --------------
//请求会数据
- (void)loadRequestData{
    
    //图片字符串
    NSMutableString *mStr = [NSMutableString string];
    
    if(self.imageUrlArr.count == 1){
        mStr = self.imageUrlArr[0];
    }else{
        for (int i = 0; i < self.imageUrlArr.count; i++) {
            NSString *imageUrl = self.imageUrlArr[i];
            if(i < self.imageUrlArr.count - 1){
                [mStr appendString:[NSString stringWithFormat:@"%@,",imageUrl]];
            }else{
                [mStr appendString:[NSString stringWithFormat:@"%@",imageUrl]];
            }
        }
    }
    
    NSDictionary *dic = @{@"userId":[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString],@"orderNo":self.orderNo,@"refundId":@(btnTag),@"proveImgUrl":mStr,@"refundSupplement":self.xinxiView.textView.text,@"singleState":self.singleState,@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]]};
    
    NSLog(@"%@",dic);
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGTuiDanURL parameters:dic success:^(id responsObject) {
        
        NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dictionary[@"code"] integerValue] == 200) {
            
            SSH_TuiDanWanChengViewController *tuidanwancVC = [[SSH_TuiDanWanChengViewController alloc] init];
            self.remindTuiDan();
            [self.navigationController pushViewController:tuidanwancVC animated:YES];
            
            NSArray *childArray = self.navigationController.viewControllers;
            NSMutableArray *newChildArray = [NSMutableArray array];
            for (UIViewController *vc in childArray) {
                if (![vc isKindOfClass:self.class]) {
                    [newChildArray addObject:vc];
                }
            }
            self.navigationController.viewControllers = [newChildArray copy];
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"申请失败请重试"];
        }
        
    } fail:^(NSError *error) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"申请失败请重试"];
    }];
    
    
}


#pragma mark =================获取图片===============
//拍摄
- (void)getImageWithType:(int )type{
    //初始化相机控制器
    UIImagePickerController *pickerC = [[UIImagePickerController alloc]init];
    //设置代理
    pickerC.delegate = self;
    //是否启用剪辑
    pickerC.allowsEditing = NO;
    // 设置照片来源为相机
    switch (type) {
        case 0:{
            pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 设置进入相机时使用前置或后置摄像头
            pickerC.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }
            break;
        case 1:{
            pickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            break;
            
        default:
            break;
    }
    // 展示选取照片控制器
    [self presentViewController:pickerC animated:YES completion:nil];
}


#pragma mark ==============相机代理方法==============
// 完成图片的选取后调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 选取完图片后跳转回原控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 从info中将图片取出，并加载到imageView当中
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //串行队列
    dispatch_queue_t queue = dispatch_queue_create("kk", DISPATCH_QUEUE_SERIAL);
    
    // 防止循环引用 使用 __weak 修饰
    __weak typeof(self)weakSelf = self;
    //异步任务
    dispatch_async(queue, ^{
        [weakSelf uploadOnlyImage:[self resetSizeOfImageData:image maxSize:1024]];
    });
    
    [self.imageArr insertObject:image atIndex:self.imageArr.count - 1];
    
    self.xinxiView.imageArr = self.imageArr;
    
}

#pragma mark - 图片压缩
- (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize {
    //先判断当前质量是否满足要求，不满足再进行压缩
    __block NSData *finallImageData = UIImageJPEGRepresentation(sourceImage,1.0);
    NSUInteger sizeOrigin   = finallImageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1000;
    
    if (sizeOriginKB <= maxSize) {
        return finallImageData;
    }
    
    //获取原图片宽高比
    CGFloat sourceImageAspectRatio = sourceImage.size.width/sourceImage.size.height;
    //先调整分辨率
    CGSize defaultSize = CGSizeMake(1024, 1024/sourceImageAspectRatio);
    UIImage *newImage = [self newSizeImage:defaultSize image:sourceImage];
    
    finallImageData = UIImageJPEGRepresentation(newImage,1.0);
    
    //保存压缩系数
    NSMutableArray *compressionQualityArr = [NSMutableArray array];
    CGFloat avg   = 1.0/250;
    CGFloat value = avg;
    for (int i = 250; i >= 1; i--) {
        value = i*avg;
        [compressionQualityArr addObject:@(value)];
    }
    
    /*
     调整大小
     说明：压缩系数数组compressionQualityArr是从大到小存储。
     */
    //思路：使用二分法搜索
    finallImageData = [self halfFuntion:compressionQualityArr image:newImage sourceData:finallImageData maxSize:maxSize];
    //如果还是未能压缩到指定大小，则进行降分辨率
    while (finallImageData.length == 0) {
        //每次降100分辨率
        CGFloat reduceWidth = 100.0;
        CGFloat reduceHeight = 100.0/sourceImageAspectRatio;
        if (defaultSize.width-reduceWidth <= 0 || defaultSize.height-reduceHeight <= 0) {
            break;
        }
        defaultSize = CGSizeMake(defaultSize.width-reduceWidth, defaultSize.height-reduceHeight);
        UIImage *image = [self newSizeImage:defaultSize
                                      image:[UIImage imageWithData:UIImageJPEGRepresentation(newImage,[[compressionQualityArr lastObject] floatValue])]];
        finallImageData = [self halfFuntion:compressionQualityArr image:image sourceData:UIImageJPEGRepresentation(image,1.0) maxSize:maxSize];
    }
    return finallImageData;
}
#pragma mark 调整图片分辨率/尺寸（等比例缩放）
- (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage {
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark 二分法
- (NSData *)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(NSInteger)maxSize {
    NSData *tempData = [NSData data];
    NSUInteger start = 0;
    NSUInteger end = arr.count - 1;
    NSUInteger index = 0;
    
    NSUInteger difference = NSIntegerMax;
    while(start <= end) {
        index = start + (end - start)/2;
        
        finallImageData = UIImageJPEGRepresentation(image,[arr[index] floatValue]);
        
        NSUInteger sizeOrigin = finallImageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1024;
        NSLog(@"当前降到的质量：%ld", (unsigned long)sizeOriginKB);
        NSLog(@"\nstart：%zd\nend：%zd\nindex：%zd\n压缩系数：%lf", start, end, (unsigned long)index, [arr[index] floatValue]);
        
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize-sizeOriginKB < difference) {
                difference = maxSize-sizeOriginKB;
                tempData = finallImageData;
            }
            if (index<=0) {
                break;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    return tempData;
}

@end
