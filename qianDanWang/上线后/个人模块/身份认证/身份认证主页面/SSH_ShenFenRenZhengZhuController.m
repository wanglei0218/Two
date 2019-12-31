//
//  SSH_ShenFenRenZhengZhuController.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ShenFenRenZhengZhuController.h"
#import "SSH_ShenFenRenZhengZhuLieBiaoCell.h"
#import "SSH_ShenFenZhengTiJiaoController.h" //提交身份证
#import "SSH_ZhiYeZhengmingController.h" //提交职业
//#import "DENGFANGAuthFailureViewController.h"//身份认证情况页面
#import "SSH_GeRenXinXiModel.h"

@interface SSH_ShenFenRenZhengZhuController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,assign) BOOL isOnceClick;

@property(nonatomic,strong)UIButton * submitBtn; //提交按钮

@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)NSArray * allHeaderArr;
@property(nonatomic,strong)NSArray * allLeftTextArr;
@property(nonatomic,strong)NSArray * allPlaceholderArr;
@property(nonatomic,strong)NSMutableArray * allTextFieldArr;


@property(nonatomic,strong)UIView * infoView;//认证中或认证失败显示的界面

@property (nonatomic,strong)NSString * IDPhoto1;
@property (nonatomic,strong)NSString * IDPhoto2;
@property (nonatomic,strong)NSString * IDPhoto3;
@property (nonatomic,strong)NSString * gongPhoto;
@property (nonatomic,strong)NSString * mingPhoto;

@property (nonatomic, strong) SSH_GeRenXinXiModel *infoModel;
@property (nonatomic, strong) UIImageView *renZhengResultImageView;//认证结果图片
@property (nonatomic, strong) UILabel *topLabel;//认证结果显示的第一行文字
@property (nonatomic, strong) UIButton *infoBtn;//认证结果显示的按钮

/**
 *  数据源
 */
@property (nonatomic,strong) MBProgressHUD *zhuanquan;
@property(nonatomic, strong) NSMutableArray *contents;
@property(nonatomic, strong) NSMutableArray *contents2;
@property (nonatomic,strong) NSMutableArray *uploadArray;

@end

@implementation SSH_ShenFenRenZhengZhuController
- (NSMutableArray *)uploadArray {
    if (!_uploadArray) {
        _uploadArray = [NSMutableArray arrayWithObjects:@(0),@(0), nil];
    }
    return _uploadArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.goBackButton.hidden = YES;
    
    //导航栏返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"jiantou_zuo_heise"] forState:UIControlStateNormal];
    [self.navigationView addSubview:backButton];
    [backButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(40.5);
        make.height.mas_equalTo(44);
    }];
    
    
    self.titleLabelNavi.text = @"身份认证";
    
    UIView * line = [[UIView alloc]init];
    line.frame = CGRectMake(0, getRectNavAndStatusHight-0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = GrayLineColor;
    [self.view addSubview:line];
    
    self.normalBackView.backgroundColor = ColorBackground_Line;
    
    [self getDENGFANGUserInfoData];
    
}

-(void)backBtnClicked{
    
    [MobClick event:@"my-ID-back"];
    [self.navigationController popViewControllerAnimated:YES];
}



//是否认证（0：未认证  1：已认证   2:认证中   3:认证失败） DENGFANGUserInfoURL
#pragma mark 获取用户信息
-(void)getDENGFANGUserInfoData{
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]};
    
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGUserInfoURL parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"获取用户信息 数据 %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            self.infoModel = [[SSH_GeRenXinXiModel alloc]init];
            [self.infoModel setValuesForKeysWithDictionary:diction[@"data"]];
            self.infoModel.isFinish = NO;
            [self.infoModel addObserver:self forKeyPath:@"isFinish" options:NSKeyValueObservingOptionNew context:nil];
            
            [self setupFailInfoModel];
//            self.infoModel.isAuth = @"1";
            if([self.infoModel.isAuth intValue] == 0){//0：未认证
                
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
    } fail:^(NSError *error) {
        
    }];
    
}
- (void)setupFailInfoModel {
    [DENGFANGSingletonTime shareInstance].headImgUrlString = self.infoModel.photoUrl;
    [DENGFANGSingletonTime shareInstance].realName = self.infoModel.realName;
    [DENGFANGSingletonTime shareInstance].idCard = self.infoModel.idCard;
    [DENGFANGSingletonTime shareInstance].enterpriseName = self.infoModel.enterpriseName;
    [DENGFANGSingletonTime shareInstance].enterpriseAddress = self.infoModel.enterpriseAddress;
    [DENGFANGSingletonTime shareInstance].idCardFaceUrl = self.infoModel.idCardFaceUrl;
    [DENGFANGSingletonTime shareInstance].idCardBackUrl = self.infoModel.idCardBackUrl;
    [DENGFANGSingletonTime shareInstance].idCardPhotoUrl = self.infoModel.idCardPhotoUrl;
    [DENGFANGSingletonTime shareInstance].workCardUrl = self.infoModel.workCardUrl;
    [DENGFANGSingletonTime shareInstance].businessCardUrl = self.infoModel.businessCardUrl;
    
    self.IDPhoto1 = [DENGFANGSingletonTime shareInstance].idCardFaceUrl;
    self.IDPhoto2 = [DENGFANGSingletonTime shareInstance].idCardBackUrl;
    self.IDPhoto3 = [DENGFANGSingletonTime shareInstance].idCardPhotoUrl;
    if (self.IDPhoto1.length > 10 && self.IDPhoto2.length > 10 && self.IDPhoto3.length > 10) {
        [self.uploadArray replaceObjectAtIndex:0 withObject:@(1)];
    }
    
    self.gongPhoto = [DENGFANGSingletonTime shareInstance].workCardUrl;
    self.mingPhoto = [DENGFANGSingletonTime shareInstance].businessCardUrl;
    if (self.gongPhoto.length > 10 || self.mingPhoto.length > 10) {
        [self.uploadArray replaceObjectAtIndex:1 withObject:@(1)];
    }
}

#pragma mark -kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isFinish"]) {
        id newString = change[NSKeyValueChangeNewKey];
        if ([newString integerValue] == 1) {
            self.submitBtn.enabled = YES;
            self.submitBtn.backgroundColor = ColorZhuTiHongSe;
        }else {
            [_submitBtn setBackgroundColor:Colorffb5b7];
        }
    }
}
- (void)judgeModelInfoIsFinish {
    for (NSString *info in self.contents) {
        if ([info isEqualToString:@""]) {
            self.infoModel.isFinish = NO;
            return;
        }
    }
    for (NSString *info in self.contents2) {
        if ([info isEqualToString:@""]) {
            self.infoModel.isFinish = NO;
            return;
        }
    }
    for (NSNumber *number in self.uploadArray) {
        if ([number integerValue] == 0) {
            self.infoModel.isFinish = NO;
            return;
        }
    }
    self.infoModel.isFinish = YES;
}
- (void)dealloc {
    if (self.infoModel != nil) {
        [self.infoModel removeObserver:self forKeyPath:@"isFinish"];
    }
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
            [self setupFailInfoModel];
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

#pragma mark - 初始化配置
- (void)configView{
    NSString * realStr = [NSString stringWithFormat:@"%@",[DENGFANGSingletonTime shareInstance].realName];
    
    if ([realStr isEqual:[NSNull null]] || realStr == nil || realStr.length == 0 || [realStr isEqualToString:@"(null)"]) {
        realStr = @"";
    }
    NSString * idStr = [NSString stringWithFormat:@"%@",[DENGFANGSingletonTime shareInstance].idCard];
    if ([idStr isEqual:[NSNull null]]|| idStr == nil|| idStr.length == 0 || [idStr isEqualToString:@"(null)"]) {
        idStr = @"";
    }
    
    NSString * comNameStr = [NSString stringWithFormat:@"%@",[DENGFANGSingletonTime shareInstance].enterpriseName];
    NSLog(@"%@",comNameStr);
    if ([comNameStr isEqual:[NSNull null]]|| comNameStr == nil|| comNameStr.length == 0 || [comNameStr isEqualToString:@"(null)"]) {
        comNameStr = @"";
    }
    NSString * comAddStr = [NSString stringWithFormat:@"%@",[DENGFANGSingletonTime shareInstance].enterpriseAddress];
    NSLog(@"%@",comAddStr);
    if ([comAddStr isEqual:[NSNull null]]|| comAddStr == nil|| comAddStr.length == 0 || [comAddStr isEqualToString:@"(null)"]) {
        comAddStr = @"";
    }
    self.allTextFieldArr = [[NSMutableArray alloc]initWithObjects:@[realStr,idStr],@[comNameStr,comAddStr], nil];
    self.allHeaderArr = @[@"个人信息",@"职业信息",@"身份证",@"职业证明"];
    self.allLeftTextArr = @[@[@"真实姓名",@"身份证号"],@[@"就职公司",@"所在城市"],@[@"请上传身份证"],@[@"请上传职业证明"]];
    self.allPlaceholderArr = @[@[@"输入姓名需与身份证姓名一致",@"请输入二代身份证号码"],@[@"请输入就职公司名称",@"请输入您所在城市:(例如：北京市)"]];
    
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-26.5);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(40);
    }];
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getRectNavAndStatusHight);
        make.bottom.mas_equalTo(self.submitBtn.mas_top).offset(-10);
        make.left.right.mas_equalTo(0);
    }];
    
}


#pragma mark 用户认证接口 DENGFANGInsertAuthRecordURL
-(void)getDENGFANGInsertAuthRecordForData{
    self.submitBtn.enabled = NO;
    self.zhuanquan = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.zhuanquan.label.text = NSLocalizedString(@"正在上传中...", @"HUD loading title");
//    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d%@",[DENGFANGSingletonTime shareInstance].useridString,[DENGFANGSingletonTime shareInstance].mobileString]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString],@"mobile":[DENGFANGSingletonTime shareInstance].mobileString,@"realName":self.contents[0],@"idCard":self.contents[1],@"enterpriseName":self.contents2[0],@"enterpriseAddress":self.contents2[1],@"idCardFaceUrl":self.IDPhoto1,@"idCardBackUrl":self.IDPhoto2,@"idCardPhotoUrl":self.IDPhoto3,@"workCardUrl":self.gongPhoto,@"businessCardUrl":self.mingPhoto};
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = [NSString yf_getNowTimestamp];
    dict[@"signs"] = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d%@",[DENGFANGSingletonTime shareInstance].useridString,[DENGFANGSingletonTime shareInstance].mobileString]];
    dict[@"userId"] = [NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString];
    dict[@"mobile"] = [DENGFANGSingletonTime shareInstance].mobileString;
    dict[@"realName"] = self.contents[0];
    dict[@"idCard"] = self.contents[1];
    dict[@"enterpriseName"] = self.contents2[0];
    dict[@"enterpriseAddress"] = self.contents2[1];
    dict[@"idCardFaceUrl"] = self.IDPhoto1;
    dict[@"idCardBackUrl"] = self.IDPhoto2;
    dict[@"idCardPhotoUrl"] = self.IDPhoto3;
    dict[@"workCardUrl"] = self.gongPhoto==nil?@"":self.gongPhoto;
    dict[@"businessCardUrl"] = self.mingPhoto==nil?@"":self.mingPhoto;
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGInsertAuthRecordURL parameters:dict success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"用户认证 信息 数据 %@",diction);
        
        [self.zhuanquan hideAnimated:YES];
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [SSH_TOOL_GongJuLei showAlter:SHAREDAPP.window WithMessage:@"上传成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
        self.submitBtn.enabled = YES;
    } fail:^(NSError *error) {
         [self.zhuanquan hideAnimated:YES];
        self.submitBtn.enabled = YES;
    }];
}

#pragma mark 懒加载
- (NSMutableArray *)contents {
    if (!_contents) {
        _contents = [[NSMutableArray alloc]init];
        for (int i = 0; i < 2; i++) {
            [_contents addObject:@""];
        }
        NSString * realStr = [NSString stringWithFormat:@"%@",[DENGFANGSingletonTime shareInstance].realName];
        if ([realStr isEqual:[NSNull null]]|| realStr == nil|| realStr.length == 0 || [realStr isEqualToString:@"(null)"]) {
            realStr = @"";
        }
        [_contents replaceObjectAtIndex:0 withObject:realStr];
        NSString * idStr = [NSString stringWithFormat:@"%@",[DENGFANGSingletonTime shareInstance].idCard];
        if ([idStr isEqual:[NSNull null]]|| idStr == nil|| idStr.length == 0 || [idStr isEqualToString:@"(null)"]) {
            idStr = @"";
        }
        NSLog(@"%@%@",realStr,idStr);
        [_contents replaceObjectAtIndex:1 withObject:idStr];
    }
    return _contents;
}
- (NSMutableArray *)contents2 {
    if (!_contents2) {
        _contents2 = [[NSMutableArray alloc]init];
        for (int i = 0; i < 2; i++) {
            [_contents2 addObject:@""];
        }
        
        NSString * nameStr = [NSString stringWithFormat:@"%@",[DENGFANGSingletonTime shareInstance].enterpriseName];
        if ([nameStr isEqual:[NSNull null]]|| nameStr == nil|| nameStr.length == 0 || [nameStr isEqualToString:@"(null)"]) {
            nameStr = @"";
        }
        [_contents2 replaceObjectAtIndex:0 withObject:nameStr];
        NSString * addStr = [NSString stringWithFormat:@"%@",[DENGFANGSingletonTime shareInstance].enterpriseAddress];
        if ([addStr isEqual:[NSNull null]]|| addStr == nil|| addStr.length == 0 || [addStr isEqualToString:@"(null)"]) {
            addStr = @"";
        }
        NSLog(@"%@%@",nameStr,addStr);
        [_contents2 replaceObjectAtIndex:1 withObject:addStr];
    }
    return _contents2;
}
-(UIView *)infoView{
    if (!_infoView) {
        _infoView = [[UIView alloc]init];
        _infoView.frame = CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREENH_HEIGHT-getRectNavAndStatusHight);
        _infoView.backgroundColor = COLORWHITE;
    }
    return _infoView;
}
-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.backgroundColor = ColorBackground_Line;
    }
    return _myTableView;
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
#pragma mark 提交点击事件
-(void)submitBtnClicked{
    [MobClick event:@"my-ID-sure"];
    if ([self.infoModel.isAuth intValue] == 1 && [self.infoModel.isFaceCheck intValue] == 1) {
        self.submitBtn.enabled = NO;
    }else{
        
        if ([self.contents[0] length] <= 0) {
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请填写真实姓名"];
            return;
        }else if ([self.contents[1] length] <= 0){
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请填写身份证号"];
            return;
        }else if (![SSH_TOOL_GongJuLei checkUserIdCard:self.contents[1]]) {
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请填写正确的身份证号"];
            return;
        }else if ([self.contents2[0] length] <= 0){
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请填写就职公司"];
            return;
        }else if ([self.contents2[1] length] <= 0){
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请填写所在城市"];
            return;
        }else if (self.IDPhoto1.length <= 10){
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请上传身份证正面照"];
            return;
        }else if (self.IDPhoto2.length <= 10){
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请上传身份证反面照"];
            return;
        }else if (self.IDPhoto3.length <= 10){
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请上传与身份证反面照"];
            return;
        }else if (self.gongPhoto.length <= 10 && self.mingPhoto.length <= 10){
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"职业证明"];
            return;
        }
//            else if (self.mingPhoto.length <= 10){
//            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请上传名片"];
//            return;
//        }
        if ([SSH_TOOL_GongJuLei isContainsEmoji:self.contents[0]]) {
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请输入正确的姓名"];
            return;
        }else if ([SSH_TOOL_GongJuLei isContainsEmoji:self.contents2[0]]) {
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请输入正确的公司名称"];
            return;
        }else if ([SSH_TOOL_GongJuLei isContainsEmoji:self.contents2[1]]) {
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请输入正确的城市名称"];
            return;
        }

        self.submitBtn.enabled = YES;
        self.submitBtn.backgroundColor = ColorZhuTiHongSe;
        [self getDENGFANGInsertAuthRecordForData];
    }
}
#pragma mark 确认退出提示语
-(void)logoutInfo{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否退出认证流程？" preferredStyle:UIAlertControllerStyleAlert];
    //默认只有标题 没有操作的按钮:添加操作的按钮 UIAlertAction
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    //添加确定
    UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull   action) {
        
        
    }];
    //设置`确定`按钮的颜色
    [sureBtn setValue:ColorZhuTiHongSe forKey:@"titleTextColor"];
    [cancelBtn setValue:ColorZhuTiHongSe forKey:@"titleTextColor"];
    
    //将action添加到控制器
    [alertVc addAction:cancelBtn];
    [alertVc addAction :sureBtn];
    //展示
    [self presentViewController:alertVc animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.IDPhoto1 = [DENGFANGSingletonTime shareInstance].idCardFaceUrl;
    self.IDPhoto2 = [DENGFANGSingletonTime shareInstance].idCardBackUrl;
    self.IDPhoto3 = [DENGFANGSingletonTime shareInstance].idCardPhotoUrl;
    
    self.gongPhoto = [DENGFANGSingletonTime shareInstance].workCardUrl;
    self.mingPhoto = [DENGFANGSingletonTime shareInstance].businessCardUrl;

    
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2]; //你需要更新的组数
    NSIndexSet *indexSet1=[[NSIndexSet alloc]initWithIndex:3]; //你需要更新的组数

    [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.myTableView reloadSections:indexSet1 withRowAnimation:UITableViewRowAnimationAutomatic];

}


#pragma mark - tableView里的方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allHeaderArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * arr = self.allLeftTextArr[section];
    return arr.count;
}


#pragma mark - CellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    SSH_ShenFenRenZhengZhuLieBiaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
    if (!cell) {
        cell = [[SSH_ShenFenRenZhengZhuLieBiaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listCell"];
    }
    if(indexPath.section > 1){
        cell.leftLabel.frame = CGRectMake(15, 0.5, 120, 54.5);
        cell.myTextField.hidden = YES;
        cell.arrowImageView.hidden = NO;
        cell.myImageView.hidden = NO;
        cell.myTextField.enabled = NO;
        
        if (indexPath.section == 2) {
            if (self.IDPhoto1.length>10&&self.IDPhoto2.length>10&&self.IDPhoto3.length>10) {
                cell.myImageView.image = [UIImage imageNamed:@"ID-2"];
            }else{
                cell.myImageView.image = [UIImage imageNamed:@"ID-1"];
            }
        }else if (indexPath.section == 3){
            if (self.gongPhoto.length>10||self.mingPhoto.length>10) {
                cell.myImageView.image = [UIImage imageNamed:@"zhiye-2"];
            }else{
                cell.myImageView.image = [UIImage imageNamed:@"zhiye-1"];
            }
        }
    }else{
        if ([self.infoModel.isAuth intValue] == 1 && [self.infoModel.isFaceCheck intValue] == 1) {
            cell.myTextField.userInteractionEnabled = NO;
        }
        cell.myTextField.placeholder = self.allPlaceholderArr[indexPath.section][indexPath.row];
        cell.myTextField.text = self.allTextFieldArr[indexPath.section][indexPath.row];
        if (indexPath.row < 2) {
            NSArray *arr = indexPath.section==0?[self.contents copy]:[self.contents2 copy];
            cell.myTextField.text = arr[indexPath.row];
        }
        cell.myTextField.delegate = self;
        cell.arrowImageView.hidden = YES;
        cell.myImageView.hidden = YES;
        
        __weak typeof(self) weakSelf = self;
        if (indexPath.section == 0) {
            cell.block = ^(NSString * text) {
                // 更新数据源
                [weakSelf.contents replaceObjectAtIndex:indexPath.row withObject:text];
                [self judgeModelInfoIsFinish];
            };
        } else if (indexPath.section == 1) {
            // 同上，
            cell.block = ^(NSString * text) {
                // 更新数据源
                [weakSelf.contents2 replaceObjectAtIndex:indexPath.row withObject:text];
                [self judgeModelInfoIsFinish];
            };

        } else {
            // 同上，
        }
    }
    cell.leftLabel.text = self.allLeftTextArr[indexPath.section][indexPath.row];
    cell.selectionStyle = 0;
    return cell;
    
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (indexPath.section < 2) {
//        DENGFANGIDAuthMainListCell *customCell = (DENGFANGIDAuthMainListCell *)cell;
//
//        customCell.myTextField.text = self.allTextFieldArr[indexPath.section][indexPath.row];
//
//        customCell.myTextField.placeholder = self.allPlaceholderArr[indexPath.section][indexPath.row];
//        if (indexPath.section == 0) {
//            customCell.myTextField.text = [self.contents objectAtIndex:indexPath.row];
//            // 必须有else!
//        }else if (indexPath.section == 1) {
//            customCell.myTextField.text = [self.contents2 objectAtIndex:indexPath.row];
//        }else {
//            // 切记：对于cell的重用，有if，就必须有else。因为之前屏幕上出现的cell离开屏幕被缓存起来时候，cell上的内容并没有清空，当cell被重用时，系统并不会给我们把cell上之前配置的内容清空掉，所以我们在else中对contentTextField内容进行重新配置或者清空（根据自己的业务场景而定）
//            customCell.myTextField.text = @"";
//        }
//    }
//
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        
        SSH_ShenFenZhengTiJiaoController * cardVC = [[SSH_ShenFenZhengTiJiaoController alloc]init];
        cardVC.isAuth = [self.infoModel.isAuth intValue];
        cardVC.block = ^(BOOL isUpload) {
            if (isUpload) {
                [self.uploadArray replaceObjectAtIndex:0 withObject:@(1)];
                [self judgeModelInfoIsFinish];
            }
        };
        [self.navigationController pushViewController:cardVC animated:YES];
    }else if (indexPath.section == 3){
        
        SSH_ZhiYeZhengmingController * zhiyeVC = [[SSH_ZhiYeZhengmingController alloc]init];
        zhiyeVC.isAuth = [self.infoModel.isAuth intValue];
        zhiyeVC.block = ^(BOOL isUpload) {
            if (isUpload) {
                [self.uploadArray replaceObjectAtIndex:1 withObject:@(1)];
                [self judgeModelInfoIsFinish];
            }
        };
        [self.navigationController pushViewController:zhiyeVC animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]init];
    footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.1f);
    return footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc]init];
    headerView.backgroundColor = ColorBackground_Line;
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    
    //文字
    UILabel *headerLabel = [[UILabel alloc]init];
    [headerView addSubview:headerLabel];
    headerLabel.text = self.allHeaderArr[section];
    headerLabel.textColor = ColorBlack999;
    headerLabel.font = UIFONTTOOL15;
    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55.5;
}


@end
