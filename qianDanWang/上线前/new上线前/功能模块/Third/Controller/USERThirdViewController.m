//
//  USERThirdViewController.m
//  USERPRODUCT
//
//  Created by 河神 on 2019/5/29.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERThirdViewController.h"
#import "USERThirdTableViewCell.h"
#import "USERLoginViewController.h"
#import "USERAddressViewController.h"
#import "USERTongYongViewController.h"
#import "USERSetUpViewController.h"
#import "USERLiuYanViewController.h"
#import "USERGuanYuViewController.h"
#import "USERHeiMingDanViewController.h"

@interface USERThirdViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong)UITableView *tabView;
@property(nonatomic,strong)UIImageView *tableHeadView;
@property(nonatomic,strong)UIImageView *image;
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UIButton *renzhengBtn;
@property (nonatomic, strong)NSArray *tableDataArr;


@end

@implementation USERThirdViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:TOKEN];
    NSString *phone = [defaults valueForKey:PHONE];
    
    if (token.length == 0) {
        self.nameLab.text = [NSString stringWithFormat:@"注册/登录"];
        self.image.image = [UIImage imageNamed:@"头像"];
    }else{
        
        NSString *tel = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.nameLab.text = [NSString stringWithFormat:@"%@",tel];
        
        if (![SZKImagePickerVC loadImageFromSandbox:@"image"]) {
            self.image.image = [UIImage imageNamed:@"头像"];
        }
        else{
            self.image.image = [SZKImagePickerVC loadImageFromSandbox:@"image"];
        }
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rootGoBackBtn.hidden = YES;
    self.rootNaviBaseLine.hidden = YES;
    self.rootRightBtn.hidden = NO;
    [self.rootRightBtn setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
    [self.rootRightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rootNaviBaseImg removeFromSuperview];
    
    self.tableDataArr = @[@"我的求助订单",@"我的帮助订单",@"我的地址",@"黑名单",@"在线留言",@"关于我们"];
    
    [self.view addSubview:self.tabView];
    [self addHeaderImagToHeaderView];
    
    [self.view addSubview:self.rootNaviBaseImg];
}

#pragma mark ----------- 初始化 ---------------
- (UITableView *)tabView{
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0-getStatusHeight, ScreenWidth, ScreenHeight+getStatusHeight-SafeAreaBottomHEIGHT) style:UITableViewStylePlain];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.sectionHeaderHeight = 0.01f;
        _tabView.sectionFooterHeight = WidthScale(8);
        _tabView.rowHeight = WidthScale(69);
        _tabView.separatorColor = [UIColor clearColor];
        
        self.tableHeadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, WidthScale(168)+getStatusHeight)];
        self.tableHeadView.image = [UIImage imageNamed:@"imgcenterbase"];
        self.tableHeadView.backgroundColor = TEXTSEN_Color;
        self.tableHeadView.userInteractionEnabled = YES;
        self.tabView.tableHeaderView = self.tableHeadView;
    }
    return _tabView;
}

#pragma mark ----------------- UITableViewDataSource ---------------------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    USERThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[USERThirdTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLab.text = self.tableDataArr[indexPath.row];
    cell.iconImg.image = [UIImage imageNamed:self.tableDataArr[indexPath.row]];
    
    return cell;
}

#pragma mark ----------------- UITableViewDelegate ---------------------

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, WidthScale(49))];
    headView.backgroundColor = [UIColor whiteColor];
    
    return headView;
}

// 表格尾视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return WidthScale(0);
}

// 表格头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return WidthScale(15.0f);
}


// 单元格点击的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tabView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:TOKEN];
    if (token.length == 0) {
        [self myLoginAction];
        return;
    }
    if (indexPath.row == 0) {
        
        //我的求助订单
        USERTongYongViewController *VC = [[USERTongYongViewController alloc] init];
        VC.titleStr = @"求助记录";
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if (indexPath.row == 1){
        
        //我的帮助订单
        USERTongYongViewController *VC = [[USERTongYongViewController alloc] init];
        VC.titleStr = @"帮助记录";
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if (indexPath.row == 2) {
        
        //我的地址
        USERAddressViewController *addressVC = [[USERAddressViewController alloc] init];
        addressVC.typeID = 1;
        [self.navigationController pushViewController:addressVC animated:YES];
    }else if (indexPath.row == 3){
        //黑名单
        USERHeiMingDanViewController *VC = [[USERHeiMingDanViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 4){
        //意见反馈
        USERLiuYanViewController *VC = [[USERLiuYanViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 5){
        //关于我们
        USERGuanYuViewController *aboutVC = [[USERGuanYuViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

#pragma mark ---------------------- 自定义的方法 -----------------------
- (void)addHeaderImagToHeaderView{
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WidthScale(60), WidthScale(60))];
    self.image.center = CGPointMake(WidthScale(60), self.tableHeadView.frame.size.height/2 + WidthScale(10));
    if (![SZKImagePickerVC loadImageFromSandbox:@"image"]) {
        self.image.image = [UIImage imageNamed:@"头像"];
    }
    else{
        self.image.image = [SZKImagePickerVC loadImageFromSandbox:@"image"];
    }
    self.image.layer.cornerRadius = WidthScale(60)/2;
    self.image.layer.masksToBounds = YES;
    self.image.userInteractionEnabled = YES;
    
    [self.image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickHeaderImage:)]];
    
    UILabel *showLable = [[UILabel alloc] initWithFrame:CGRectMake(self.image.right+WidthScale(15), self.image.y+WidthScale(8), WidthScale(100), WidthScale(18))];
    showLable.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:WidthScale(18)];
    showLable.textAlignment = NSTextAlignmentLeft;
    showLable.textColor = [UIColor whiteColor];
    showLable.text = [NSString stringWithFormat:@"尊敬的用户"];
    [self.tableHeadView addSubview:showLable];
    
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(self.image.frame.origin.x + self.image.frame.size.width + WidthScale(16), showLable.bottom + WidthScale(10), ScreenWidth/2, WidthScale(15))];
    
    self.nameLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:WidthScale(15)];
    self.nameLab.textAlignment = NSTextAlignmentLeft;
    self.nameLab.numberOfLines = 2;
    self.nameLab.textColor = [UIColor whiteColor];
    self.nameLab.text = [NSString stringWithFormat:@"注册/登录"];
    
    [self.tableHeadView addSubview:self.image];
    [self.tableHeadView addSubview:self.nameLab];
    
   
}


#pragma mark ----------------- 触发方法 ---------------------

// 头视图触发的回调
- (void)ClickHeaderImage:(UITapGestureRecognizer *)tap{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:TOKEN];
    
    if (token.length == 0) {
        
        USERLoginViewController *loginVC = [[USERLoginViewController alloc] init];
        UINavigationController *dengluNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:dengluNav animated:YES completion:nil];
        
    }else{
        
        [self addShowAlertSheet];
    }
    
    
}

// 添加提示框
-(void)addShowAlertSheet{
    
    //创建UIImagePickerController对象，并设置代理和可编辑
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.editing = YES;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    
    //显示弹出框列表选择
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请选择更改头像的方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:RGB(247,83,84) forKey:@"titleTextColor"];
    
    UIAlertAction* NAction = [UIAlertAction actionWithTitle:@"照相" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] && ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            [SVProgressHUD showErrorWithStatus:@"该设备没有相机"];
            return;
        }
        //选择相机时，设置UIImagePickerController对象相关属性
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        //        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //跳转到UIImagePickerController控制器弹出相机
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }];
    
    UIAlertAction* YAction = [UIAlertAction actionWithTitle:@"进入相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"action = %@", action);
        //选择相册时，设置UIImagePickerController对象相关属性
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //跳转到UIImagePickerController控制器弹出相册
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }];
    
    [alert addAction:NAction];
    [alert addAction:YAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - imagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    //获取到的图片
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.image.image = image;
    
    [SZKImagePickerVC saveImageToSandbox:self.image.image andImageNage:@"image" andResultBlock:^(BOOL success) {
        NSLog(@"保存成功");
    }];
}


///保存图片到本地相册
-(void)imageTopicSave:(UIImage *)image{
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image: didFinishSavingWithError: contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        
    }
    else{
        ///图片未能保存到本地
    }
}

- (void)rightBtnClick:(UIButton *)sender{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:TOKEN];
    if (token.length == 0) {
        [self myLoginAction];
        return;
    }
    
    USERSetUpViewController *VC = [[USERSetUpViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
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
