//
//  SSH_RenZhengPhotoViewController.m
//  qianDanWang
//
//  Created by 畅轻 on 2019/12/30.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_RenZhengPhotoViewController.h"
#import "SSH_RenZhengPhotoTableViewCell.h"
#import "SSH_RenZhengWlView.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "UIImage+DENGFANGCompressImage.h"



@interface SSH_RenZhengPhotoViewController ()<SSH_ShenFenUploadViewlDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    NSString *_realName;
    NSString *_realNumber;
    NSInteger _selectIndex;
    
    NSString *_strUrl1;
    NSString *_strUrl2;
    NSString *_strUrl3;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (strong, nonatomic) IBOutlet UITableView *renZhengTabView;
@property (strong, nonatomic) IBOutlet UIView *renZhengFootView;

@property (nonatomic,strong)SSH_RenZhengWlView * zhengView;//正面view
@property (nonatomic,strong)SSH_RenZhengWlView * fanView;//反面view
@property (nonatomic,strong)SSH_RenZhengWlView * shouChiView;//手持view


@property(strong,nonatomic)NSArray *arrTitle;
@property(strong,nonatomic)NSArray *arrContent;


@property (nonatomic,strong)UIButton * submitBtn;//确认上传按钮
@property (nonatomic,strong)UILabel * remindLab;
@property(strong,nonatomic)UIImagePickerController *coinBusCerPicker;

@end

@implementation SSH_RenZhengPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.normalBackView.hidden = YES;
    self.titleLabelNavi.text = @"身份证认证";
    
    self.arrTitle = @[@"真实姓名",@"身份证号码"];
    self.arrContent = @[@"请输入您的真实姓名",@"请输入您的身份证号码"];
    self.topHeight.constant = 44;
    [self.renZhengTabView registerNib:[UINib nibWithNibName:NSStringFromClass(SSH_RenZhengPhotoTableViewCell.class) bundle:nil] forCellReuseIdentifier:@"cell"];
    self.renZhengTabView.tableFooterView = self.renZhengFootView;
 
    [self creatFootViewSubView];
}
-(void)creatFootViewSubView
{
    NSMutableArray * viewArr = [[NSMutableArray alloc]init];
    NSArray * imgArr = @[@"ID-paishe1",@"ID-paishe2",@"ID-shouchi"];
    for (int i = 0; i < 3; i++) {
        SSH_RenZhengWlView * baseView = [[SSH_RenZhengWlView alloc]initWithFrame:CGRectMake(0, 20+170*i, SCREEN_WIDTH, 170)];
        baseView.bgImgView.image = [UIImage imageNamed:imgArr[i]];
        baseView.delegate = self;
        [baseView setChildBtnTag:1560+i];
        [self.renZhengFootView addSubview:baseView];
        [viewArr addObject:baseView];
    }
    self.zhengView = viewArr[0];
    self.fanView = viewArr[1];
    self.shouChiView = viewArr[2];
    
    [self.renZhengFootView addSubview:self.submitBtn];
    [self.renZhengFootView addSubview:self.remindLab];
    self.submitBtn.frame = CGRectMake(30, self.shouChiView.bottom+WidthScale(30), SCREEN_WIDTH-WidthScale(60), WidthScale(40));
    self.remindLab.frame = CGRectMake(35, self.shouChiView.bottom+WidthScale(75), SCREEN_WIDTH-WidthScale(60), WidthScale(40));
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionVw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    sectionVw.backgroundColor = RGB(237, 237, 237);
    
    UIView *vie = [[UIView alloc] init];
    [sectionVw addSubview:vie];
    [vie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sectionVw);
        make.left.mas_equalTo(sectionVw.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(2, 15));
    }];
    vie.backgroundColor = COLOR_With_Hex(0xe63c3f);
    
    UILabel *sectionLab = [[UILabel alloc] init];
    [sectionVw addSubview:sectionLab];
    [sectionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(vie.mas_right).offset(10);
        make.centerY.equalTo(sectionVw);
        make.height.mas_equalTo(30);
    }];
    sectionLab.font = [UIFont systemFontOfSize:15];
    sectionLab.textColor = COLOR_With_Hex(0xe63c3f);
    
    if (section == 0) {
        sectionLab.text = @"本人身份信息";
    } else {
        sectionLab.text = @"上传身份证照片";
    }
    
    return sectionVw;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else {
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSH_RenZhengPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.cellTitle.text = self.arrTitle[indexPath.row];
        cell.cellContent.placeholder = self.arrContent[indexPath.row];
        [cell.cellContent addTarget:self action:@selector(cellContentDidChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.cellContent.tag = 1750+indexPath.row;
    }
    cell.preservesSuperviewLayoutMargins = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
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

#pragma mark 确认上传
-(void)submitBtnClicked
{
    if (_realName == 0) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请填写您的真实姓名"];
        return;
    } else if (![SSH_TOOL_GongJuLei checkUserIdCard:_realNumber]) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请正确填写您的身份证号"];
        return;
    } else  if (_strUrl1.length == 0) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请上传身份证正面"];
        return;
    }else if (_strUrl2.length == 0) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请上传身份证反面"];
        return;
    }else if (_strUrl3.length == 0) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请上传手持身份证照片"];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:_realName forKey:@"card_name"];
    [[NSUserDefaults standardUserDefaults] setValue:_realNumber forKey:@"card_id"];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"faceId"];
    [self.navigationController popViewControllerAnimated:YES];
}
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
            NSMutableArray *arr = dictionary[@"url"];
            if (self->_selectIndex == 1) {
                self->_strUrl1 = arr[0];
                [self.zhengView.bgImgView sd_setImageWithURL:[NSURL URLWithString:arr[0]] placeholderImage:[UIImage imageNamed:@"ID-paishe1"]];
                [[NSUserDefaults standardUserDefaults] setValue:arr[0] forKey:DENGFANGIdCardFaceUrlKey];
            } else if (self->_selectIndex == 2) {
                self->_strUrl2 = arr[0];
                [self.fanView.bgImgView sd_setImageWithURL:[NSURL URLWithString:arr[0]] placeholderImage:[UIImage imageNamed:@"ID-paishe2"]];
                [[NSUserDefaults standardUserDefaults] setValue:arr[0] forKey:DENGFANGIdCardBackUrlKey];
            } else if (self->_selectIndex == 3) {
                self->_strUrl3 = arr[0];
                [self.shouChiView.bgImgView sd_setImageWithURL:[NSURL URLWithString:arr[0]] placeholderImage:[UIImage imageNamed:@"ID-shouchi"]];
                [[NSUserDefaults standardUserDefaults] setValue:arr[0] forKey:DENGFANGRenTiPhotoUrlKey];
            }
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:dictionary[@"message"]];
        }
        
        
    } failure:^(NSError *failure) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"图片上传失败，请重试"];
    }];
}

-(void)cellContentDidChanged:(UITextField *)textfield
{
    if (textfield.tag == 1750) {
        NSLog(@"姓名");
        _realName = textfield.text;
    } else {
        NSLog(@"身份证号");
        _realNumber = textfield.text;
    }
}

-(void)shangChuanZhengBtnClicked:(UIButton *)btn
{
    if (btn.tag == 1560) {
        NSLog(@"111");
        _selectIndex = 1;
    } else if (btn.tag == 1561) {
        NSLog(@"222");
        _selectIndex = 2;
    } else if (btn.tag == 1562) {
        NSLog(@"333");
        _selectIndex = 3;
    }
    [self coinSelectSystemPhoto];
}


#pragma mark 选择照片
-(void)coinSelectSystemPhoto
{
    //选择头像
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        //响应事件
    }];
    UIAlertAction* xiangji = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //响应事件
        [self selectWalletJiPhoto];
    }];
    UIAlertAction* xiangce = [UIAlertAction actionWithTitle:@"打开手机相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //响应事件
        [self selectWalletAblumLocalPhoto];
    }];
    [alert addAction:cancelAction];
    [alert addAction:xiangji];
    [alert addAction:xiangce];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)selectWalletJiPhoto
{
    AVAuthorizationStatus  status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (self.coinBusCerPicker == nil) {
        self.coinBusCerPicker = [[UIImagePickerController alloc] init];
    }
    self.coinBusCerPicker.delegate = self;
    self.coinBusCerPicker.allowsEditing = YES;
    self.coinBusCerPicker.sourceType = sourceType;
    if(status == AVAuthorizationStatusAuthorized ) {
        /*********************   打开相机    ***************/
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            [self presentViewController:self.coinBusCerPicker animated:YES completion:nil];
        }
    }else if (status == AVAuthorizationStatusNotDetermined){
        //AVAuthorizationStatusNotDetermined  指示用户尚未作出关于客户端是否可以访问硬件的选择。
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
            if (granted) {
                //第一次用户接受
                [self presentViewController:self.coinBusCerPicker animated:YES completion:nil];
            }else{
                //用户拒绝
                [self.coinBusCerPicker dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }else if (status == AVAuthorizationStatusRestricted){
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的相机权限受限!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            //响应事件
            NSLog(@"action = %@", action);
            
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        NSLog(@"该设备无摄像头");
    }
}
-(void)selectWalletAblumLocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    //相册的权限
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus == PHAuthorizationStatusAuthorized) {
        [self presentViewController:picker animated:YES completion:nil];
    } else if(photoAuthorStatus == PHAuthorizationStatusDenied){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设备的\"设置-隐私-相册\"中允许访问相册。" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            //响应事件
            NSLog(@"action = %@", action);
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (photoAuthorStatus == PHAuthorizationStatusNotDetermined){
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self presentViewController:picker animated:YES completion:nil];
            }else{
                //用户拒绝
                [self.coinBusCerPicker dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}
#pragma mark  当选择一张图片进入这里
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (image != nil) {
        
        UIImage *newImage = [image imageCompressForSize:image targetSize:CGSizeMake(image.size.width*0.2, image.size.height*0.2)];
        NSData *imgData1 = UIImageJPEGRepresentation(newImage, 1);
        //串行队列
        dispatch_queue_t queue = dispatch_queue_create("kk", DISPATCH_QUEUE_SERIAL);
        // 防止循环引用 使用 __weak 修饰
        __weak typeof(self)weakSelf = self;
        //设置图片背景
        //异步任务
        dispatch_async(queue, ^{
            [weakSelf uploadOnlyImage:imgData1];
        });
        
        if (_realName == 0) {
            return;
        } else if (![SSH_TOOL_GongJuLei checkUserIdCard:_realNumber]) {
            return;
        }else{
            [_submitBtn setBackgroundColor:COLOR_With_Hex(0xe63c3f)];
        }
    }
}



@end
