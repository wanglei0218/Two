//
//  SSH_New_QYZPViewController.m
//  qianDanWang
//
//  Created by 小锦鲤 on 2019/8/21.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_New_QYZPViewController.h"
#import "SSH_New_QYZPTableViewCell.h"
#import "UIImage+DENGFANGCompressImage.h"


static NSString *cellId = @"SSH_New_QYZPTableViewCell.h";
@interface SSH_New_QYZPViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *imgArr;
    NSInteger buttonTag;
    NSString *photo1;
    NSString *photo2;
    NSString *photo3;
    NSString *photo4;
    NSString *photo5;
    NSArray *titleHeaderArr;
}
@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) UIView *tabViewHeader;
@property (nonatomic, strong) UIView *tabViewFooter;

@end

@implementation SSH_New_QYZPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleHeaderArr = @[@"与LOGO墙的合照（必传）",@"名片和工牌（二选一）",@"手持营业执照和合同签字页（二选一）"];
    
    self.titleLabelNavi.text = @"企业相关照片";
    
    [self getLastPhoto];
    
    [self.view addSubview:self.tabView];
    
}

- (UIView *)tabViewHeader {
    if (!_tabViewHeader) {
        _tabViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.1)];
        _tabViewHeader.backgroundColor = COLOR_WITH_HEX(0xffebd8);
//        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 12, 12)];
//        img.image = [UIImage imageNamed:@"tishi"];
//        [_tabViewHeader addSubview:img];
//        UILabel *lab = [[UILabel alloc] init];
//        lab.font = UIFONTTOOL(12);
//        lab.textColor = COLOR_WITH_HEX(0xea7302);
//        lab.text = @"以下证明方式任选二项上传即可！";
//        [_tabViewHeader addSubview:lab];
//        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_offset(12.5);
//            make.bottom.mas_offset(-12);
//            make.left.mas_offset(img.x + 18);
//        }];
    }
    return _tabViewHeader;
}

- (void)getLastPhoto {
    
    
    photo1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"logoqian"];//logo墙
    photo2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"hetong"];//合同
    photo3 = [[NSUserDefaults standardUserDefaults] objectForKey:@"yingyezhizhao"];//执照
    photo4 = [[NSUserDefaults standardUserDefaults] objectForKey:@"mingpian"];//名片
    photo5 = [[NSUserDefaults standardUserDefaults] objectForKey:@"gongpai"];//工牌
    
    
    NSDictionary *dic1 = @{
                           //                          @"url":photo1,
                           @"url":photo1.length==0?@"":photo1,
                           @"tag":[NSNumber numberWithInt:0],
                           @"img":@"logo_hezhao"
                           };
    NSDictionary *dic2 = @{
                           //                           @"url":photo2,
                           @"url":photo2.length==0?@"":photo2,
                           @"tag":[NSNumber numberWithInt:1],
                           @"img":@"gongpai"
                           };
    NSDictionary *dic3 = @{
                           //                           @"url":photo3,
                           @"url":photo3.length==0?@"":photo3,
                           @"tag":[NSNumber numberWithInt:2],
                           @"img":@"shangchuan_mingpian"
                           };
    NSDictionary *dic4 = @{
                           //                           @"url":photo4,
                           @"url":photo4.length==0?@"":photo4,
                           @"tag":[NSNumber numberWithInt:3],
                           @"img":@"hetong_qianzi"
                           };
    NSDictionary *dic5 = @{
                           //                           @"url":photo5,
                           @"url":photo5.length==0?@"":photo5,
                           @"tag":[NSNumber numberWithInt:4],
                           @"img":@"shouchi_zhizhao"
                           };
    NSArray *arr1 = @[dic1];
    NSArray *arr2 = @[dic2,dic3];
    NSArray *arr3 = @[dic4,dic5];
    imgArr = @[arr1,arr2,arr3];
}

- (UIView *)tabViewFooter {
    if (!_tabViewFooter) {
        _tabViewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
        UIButton *but = [[UIButton alloc] init];
        [_tabViewFooter addSubview:but];
        [but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(25);
            make.height.mas_offset(40);
            make.left.mas_offset(29);
            make.right.mas_offset(-29);
        }];
        [but setTitle:@"提交" forState:UIControlStateNormal];
        but.backgroundColor = TEXTREDCOLOR;
        but.layer.cornerRadius = 20;
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(submitMessage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tabViewFooter;
}

- (void)submitMessage {
    if (photo1.length == 0) {
        [MBProgressHUD showError:@"请按照提示拍取相关必选照片"];
    } else if (photo2.length == 0 && photo3.length == 0) {
        [MBProgressHUD showError:@"请按照提示拍取相关照片"];
    } else if (photo4.length == 0 && photo5.length == 0) {
        [MBProgressHUD showError:@"请按照提示拍取相关照片"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"11" forKey:@"wancheng"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UITableView *)tabView {
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, ScreenWidth, ScreenHeight - getRectNavAndStatusHight - SafeAreaAllBottomHEIGHT) style:UITableViewStyleGrouped];
        _tabView.tableFooterView = self.tabViewFooter;
        _tabView.tableHeaderView = self.tabViewHeader;
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.estimatedRowHeight = 40;
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tabView registerNib:[UINib nibWithNibName:@"SSH_New_QYZPTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    }
    return _tabView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0?1:2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SSH_New_QYZPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = imgArr[indexPath.section];
    NSDictionary *dic = arr[indexPath.row];
    NSString *url = dic[@"url"];
    if (url.length == 0) {
        cell.bgImagView.image = [UIImage imageNamed:dic[@"img"]];
    } else {
        [cell.bgImagView sd_setImageWithURL:[NSURL URLWithString:url]];
    }
    
    cell.blackDidButton = ^(UIButton * sender) {
        NSNumber *tag = dic[@"tag"];
        [self getPhotoWithQiYe:[tag intValue]];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = titleHeaderArr[section];
    lab.font = UIFONTTOOL(15);
    lab.textColor = ColorZhuTiHongSe;
    [headerV addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(12);
        make.bottom.mas_offset(-12);
        make.left.mas_offset(15);
    }];
    
    return headerV;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @" ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @" ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}


- (void)getPhotoWithQiYe:(NSInteger)index {
    buttonTag = index + 50;
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
            
            if (self->buttonTag == 50) {
                self->photo1 = dictionary[@"url"][0];
                [[NSUserDefaults standardUserDefaults] setValue:self->photo1 forKey:@"logoqian"];
            } else if (self->buttonTag == 51) {
                self->photo2 = dictionary[@"url"][0];
                [[NSUserDefaults standardUserDefaults] setValue:self->photo2 forKey:@"hetong"];
            }  else if (self->buttonTag == 52) {
                self->photo3 = dictionary[@"url"][0];
                [[NSUserDefaults standardUserDefaults] setValue:self->photo3 forKey:@"yingyezhizhao"];
            }  else if (self->buttonTag == 53) {
                self->photo4 = dictionary[@"url"][0];
                [[NSUserDefaults standardUserDefaults] setValue:self->photo4 forKey:@"mingpian"];
            }  else if (self->buttonTag == 54) {
                self->photo5 = dictionary[@"url"][0];
                [[NSUserDefaults standardUserDefaults] setValue:self->photo5 forKey:@"gongpai"];
            }
            [self getLastPhoto];
            [self.tabView reloadData];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:dictionary[@"message"]];
        }
        
        
    } failure:^(NSError *failure) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"图片上传失败，请重试"];
    }];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //通过key值获取到图片
    UIImage * image =info[UIImagePickerControllerOriginalImage];
    NSLog(@"image=%@  info=%@",image, info);
    
    //判断数据源类型
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        UIImage *newImage = [image imageCompressForSize:image targetSize:CGSizeMake(image.size.width*0.2, image.size.height*0.2)];
        NSData *imgData = UIImageJPEGRepresentation(newImage, 1);
        
//        self.submitBtn.enabled = YES;
        
        //串行队列
        dispatch_queue_t queue = dispatch_queue_create("kk", DISPATCH_QUEUE_SERIAL);
        
        
        // 防止循环引用 使用 __weak 修饰
        __weak typeof(self)weakSelf = self;
        //设置图片背景
        //异步任务
        dispatch_async(queue, ^{
            [weakSelf uploadOnlyImage:imgData];
        });
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        UIImage *newImage = [image imageCompressForSize:image targetSize:CGSizeMake(image.size.width*0.6, image.size.height*0.6)];
        NSData *imgData = UIImageJPEGRepresentation(newImage, 1.0);
        
        
        //串行队列
        dispatch_queue_t queue = dispatch_queue_create("kk", DISPATCH_QUEUE_SERIAL);
        // 防止循环引用 使用 __weak 修饰
        __weak typeof(self)weakSelf = self;
        //异步任务
        dispatch_async(queue, ^{
            
            [weakSelf uploadOnlyImage:imgData];
        });
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

@end
