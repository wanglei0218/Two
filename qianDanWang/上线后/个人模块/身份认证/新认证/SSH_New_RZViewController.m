//
//  SSH_New_RZViewController.m
//  qianDanWang
//
//  Created by 小锦鲤 on 2019/8/20.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_New_RZViewController.h"
#import "SSH_GeRenXinXiModel.h"
#import "SSH_ShenFenZhengRenZhengViewController.h"
#import "SSH_New_QiYeViewController.h"
#import "SSH_New_QYZPViewController.h"
#import "SSH_New_BDViewController.h"
#import "SSH_New_QYViewController.h"
#import "SSH_RenZhengPhotoViewController.h"
@interface SSH_New_RZViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSArray *titleArr;
    NSArray *titleHeaderArr;
    NSArray *titleTwoArr;
}
@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) UIView *tabViewHeader;
@property (nonatomic, strong) UIButton *subminBut;

@property (nonatomic, strong) MBProgressHUD *zhuanquan;
@property (nonatomic, strong) SSH_GeRenXinXiModel  *infoModel;
@property (nonatomic, strong) UIImageView *renZhengResultImageView;//认证结果图片
@property (nonatomic, strong) UILabel *topLabel;//认证结果显示的第一行文字
@property (nonatomic, strong) UIButton *infoBtn;//认证结果显示的按钮

@property(strong,nonatomic)NSString *ocrYes;

@end

@implementation SSH_New_RZViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    titleArr = @[@"个人信息认证",@"企业相关照片",@"使用必读"];
    titleTwoArr = @[@"所在区域",@"公司信息"];
    titleHeaderArr = @[@"基本信息",@"企业信息",@"使用必读"];
    self.titleLabelNavi.text = @"实名认证";
    self.view.backgroundColor = COLORWHITE;
    [self getDENGFANGUserInfoData];
    
    //判断认证方式
    [self jumpRenZheng];
}
-(void)jumpRenZheng
{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = [NSString yf_getNowTimestamp];
    dict[@"signs"] = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:@""];
    dict[@"sysTemCode"] = @"OCR_AUTH_SWITCH";
    NSLog(@"dict = %@ == %@",dict,[DENGFANGRequest shareInstance].DENGFANGIDCardSysTemInfo);
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGIDCardSysTemInfo parameters:dict success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"数据 %@",diction);
    
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            if ([SSH_TOOL_GongJuLei isKongWithString:diction[@"data"]]) {
                self.ocrYes = @"NO";
            } else {
                self.ocrYes = @"YES";
            }
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];
     
}

- (void)backBtnClicked {
    [super backBtnClicked];
    [MobClick event:@"my-ID-back"];
}

- (UIView *)tabViewHeader {
    if (!_tabViewHeader) {
        _tabViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
        _tabViewHeader.backgroundColor = COLOR_WITH_HEX(0xffebd8);
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 12, 12)];
        img.image = [UIImage imageNamed:@"tishi"];
        [_tabViewHeader addSubview:img];
        UILabel *lab = [[UILabel alloc] init];
        lab.font = UIFONTTOOL(12);
        lab.textColor = COLOR_WITH_HEX(0xea7302);
        lab.text = @"我们非常注重您的隐私安全，您提交的信息仅限于审核。";
        [_tabViewHeader addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(12.5);
            make.bottom.mas_offset(-12);
            make.left.mas_offset(img.x + 18);
        }];
    }
    return _tabViewHeader;
}

- (UITableView *)tabView {
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, ScreenWidth, ScreenHeight - getRectNavAndStatusHight) style:UITableViewStyleGrouped];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.tableHeaderView = self.tabViewHeader;
    }
    return _tabView;
}
#pragma mark UITableViewDelegate - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 2 ? 1 : 2 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"0820"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"0820"];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            cell.textLabel.text = titleTwoArr[indexPath.section];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:@"upMap"];
            cell.detailTextLabel.text = text.length ==0? @"请选择所在区域": text;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = titleTwoArr[indexPath.section];
            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"com_name"];
            if (str.length == 0) {
                cell.detailTextLabel.text = @"请输入";
            } else {
                cell.detailTextLabel.text = str;
            }
            
        }
    }
    if (indexPath.row == 0 && (indexPath.section == 0 || indexPath.section == 2)) {
        cell.textLabel.text = titleArr[indexPath.section];
        
        UIButton *but = [[UIButton alloc] init];
        [cell addSubview:but];
        [but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(12);
            make.right.mas_offset(-15);
            make.bottom.mas_offset(-13);
            make.width.mas_offset(65);
        }];
        but.backgroundColor = ColorZhuTiHongSe;
        if (indexPath.section == 2) {
            
            BOOL bdOne = [[NSUserDefaults standardUserDefaults] boolForKey:@"bdOne"];
            BOOL bdTwo = [[NSUserDefaults standardUserDefaults] boolForKey:@"bdTwo"];
            BOOL bdThree = [[NSUserDefaults standardUserDefaults] boolForKey:@"bdThree"];
            BOOL bdFour = [[NSUserDefaults standardUserDefaults] boolForKey:@"bdFour"];
            if (bdOne == YES && bdTwo == YES && bdThree == YES && bdFour == YES) {
                [but setTitle:@"已完成" forState:normal];
                but.backgroundColor = COLOR_WITH_HEX(0xbbbbbb);
                but.userInteractionEnabled = NO;
            } else {
                [but setTitle:@"未完成" forState:normal];
            }
        } else {
            NSString *card_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"card_name"];
            NSString *card_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"card_id"];
            NSString *face_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"faceId"];
//            NSString *faceVideoUrl = [[NSUserDefaults standardUserDefaults] objectForKey:DENGFANGRenTiPhotoUrlKey];
            if (card_name.length == 0 || card_id.length == 0 || face_id.length == 0) {
                [but setTitle:@"去上传" forState:normal];
            } else {
                [but setTitle:@"已完成" forState:normal];
                but.backgroundColor = COLOR_WITH_HEX(0xbbbbbb);
                but.userInteractionEnabled = NO;
            }
        }
        [but setTitleColor:[UIColor whiteColor] forState:normal];
        but.tag = indexPath.section + 100;
        but.titleLabel.font = UIFONTTOOL(14);
        but.layer.cornerRadius = 12;
        [but addTarget:self action:@selector(toUpData:) forControlEvents:UIControlEventTouchUpInside];
        
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        cell.textLabel.text = titleArr[indexPath.section];
        UIButton *but = [[UIButton alloc] init];
        [cell addSubview:but];
        [but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(12);
            make.right.mas_offset(-15);
            make.bottom.mas_offset(-13);
            make.width.mas_offset(65);
        }];
        but.backgroundColor = ColorZhuTiHongSe;
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"wancheng"];
        if (str.length == 0) {
            [but setTitle:@"去上传" forState:normal];
        } else {
            [but setTitle:@"已完成" forState:normal];
            but.backgroundColor = COLOR_WITH_HEX(0xbbbbbb);
            but.userInteractionEnabled = NO;
        }
        
        [but setTitleColor:[UIColor whiteColor] forState:normal];
        but.tag = indexPath.section + 100;
        but.titleLabel.font = UIFONTTOOL(14);
        but.layer.cornerRadius = 12;
        [but addTarget:self action:@selector(toUpData:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 2, 16)];
    img.image = [UIImage imageNamed:@"蓝条"];
    UILabel *lab = [[UILabel alloc] init];
    lab.text = titleHeaderArr[section];
    lab.font = UIFONTTOOL(15);
    lab.textColor = ColorZhuTiHongSe;
    [headerV addSubview:img];
    [headerV addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(12);
        make.bottom.mas_offset(-12);
        make.left.mas_offset(img.y+12);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:@"com_name"];
            if (text.length == 0) {
                SSH_New_QiYeViewController *qiye = [[SSH_New_QiYeViewController alloc] init];
                [self.navigationController pushViewController:qiye animated:YES];
            }
        }
    } else if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            NSString *text = [[NSUserDefaults standardUserDefaults] objectForKey:@"upMap"];
            if (text.length == 0) {
                SSH_New_QYViewController *qy = [[SSH_New_QYViewController alloc] init];
                [self.navigationController pushViewController:qy animated:YES];
            }
        }
    }
}

#pragma mark 去上传

- (void)toUpData:(UIButton *)sender {
    if (sender.tag == 100) {
                
        
        NSString *isRen = [[NSUserDefaults standardUserDefaults] valueForKey:@"faceId"];
        if ([isRen isEqualToString:@"1"]) {
            return;
        }
        
        if ([self.ocrYes isEqualToString:@"YES"]) {
            SSH_ShenFenZhengRenZhengViewController *rz = [[SSH_ShenFenZhengRenZhengViewController alloc] init];
            [self.navigationController pushViewController:rz animated:YES];
        } else {
            SSH_RenZhengPhotoViewController *rz = [[SSH_RenZhengPhotoViewController alloc] init];
            [self.navigationController pushViewController:rz animated:YES];
        }
    } else if (sender.tag == 101) {
        SSH_New_QYZPViewController *sc = [[SSH_New_QYZPViewController alloc] init];
        [self.navigationController pushViewController:sc animated:YES];
    } else if (sender.tag == 102) {
        SSH_New_BDViewController *bd = [[SSH_New_BDViewController alloc] init];
        [self.navigationController pushViewController:bd animated:YES];
    }
}

#pragma mark 提交审核
- (void)addSubminBut {
    if (!_subminBut) {
        _subminBut = [[UIButton alloc] init];
        [_subminBut setTitle:@"提交审核" forState:UIControlStateNormal];
        [_subminBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_subminBut setBackgroundColor:ColorZhuTiHongSe];
        _subminBut.layer.cornerRadius = 20;
        [_subminBut addTarget:self action:@selector(submitAllData) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_subminBut];
    [_subminBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-30 - SafeAreaBottomHEIGHT);
        make.height.mas_offset(40);
        make.left.mas_offset(30);
        make.right.mas_offset(-30);
    }];
}

- (void)submitAllData{
    [self getDENGFANGInsertAuthRecordForData];
}
- (void)getDENGFANGInsertAuthRecordForData {
    
    NSString *card_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"card_name"];
    NSString *card_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"card_id"];
    NSString *face_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"faceId"];
    NSString *upMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"upMap"];
    NSString *gongsiName = [[NSUserDefaults standardUserDefaults] objectForKey:@"com_name"];
    NSString *gongsiAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"com_diqu"];
    NSString *companyAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"com_jiedao"];
    NSString *photo1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"mingpian"];
    NSString *photo2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"gongpai"];
    NSString *photo3 = [[NSUserDefaults standardUserDefaults] objectForKey:@"hetong"];
    NSString *photo4 = [[NSUserDefaults standardUserDefaults] objectForKey:@"logoqian"];
    NSString *photo5 = [[NSUserDefaults standardUserDefaults] objectForKey:@"yingyezhizhao"];
    
    NSString *cardFaceUrl = [[NSUserDefaults standardUserDefaults] objectForKey:DENGFANGIdCardFaceUrlKey];
    NSString *idCardBackUrl = [[NSUserDefaults standardUserDefaults] objectForKey:DENGFANGIdCardBackUrlKey];
    NSString *faceVideoUrl = [[NSUserDefaults standardUserDefaults] objectForKey:DENGFANGRenTiPhotoUrlKey];
    if (card_name.length == 0 || card_id.length == 0 || face_id.length == 0) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请完成人脸识别"];
        return;
    } else if (gongsiName.length == 0) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请输入您的公司名"];
        return;
    } else if (gongsiAddress.length == 0) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请输入您的公司地址"];
        return;
    } else if (upMap.length == 0) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请获取您所在位置地址"];
        return;
    }
    
    NSString *wancheng = [[NSUserDefaults standardUserDefaults] objectForKey:@"wancheng"];
    if (wancheng.length == 0) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请上传公司相关照片选项"];
        return;
    }
    
    BOOL bdOne = [[NSUserDefaults standardUserDefaults] boolForKey:@"bdOne"];
    BOOL bdTwo = [[NSUserDefaults standardUserDefaults] boolForKey:@"bdTwo"];
    BOOL bdThree = [[NSUserDefaults standardUserDefaults] boolForKey:@"bdThree"];
    BOOL bdFour = [[NSUserDefaults standardUserDefaults] boolForKey:@"bdFour"];
    if (bdOne == YES && bdTwo == YES && bdThree == YES && bdFour == YES) {
        
    } else {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请先阅读使用必读"];
        return;
    }
    
    self.subminBut.enabled = NO;
    self.zhuanquan = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.zhuanquan.label.text = NSLocalizedString(@"正在上传中...", @"HUD loading title");
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = [NSString yf_getNowTimestamp];
    dict[@"signs"] = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d%@",[DENGFANGSingletonTime shareInstance].useridString,[DENGFANGSingletonTime shareInstance].mobileString]];
    dict[@"userId"] = [NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString];
    dict[@"mobile"] = [DENGFANGSingletonTime shareInstance].mobileString;
    dict[@"realName"] = card_name;
    dict[@"idCard"] = card_id;
    dict[@"userLocation"] = upMap;//定位
    dict[@"enterpriseName"] = gongsiName;
    dict[@"enterpriseAddress"] = gongsiAddress;
    dict[@"companyAddress"] = companyAddress;//企业详细地址
    dict[@"idCardFaceUrl"] = cardFaceUrl;
    dict[@"idCardBackUrl"] = idCardBackUrl;
    dict[@"workCardUrl"] = photo1.length==0?@"":photo1;
    dict[@"businessCardUrl"] = photo2.length==0?@"":photo2;
    dict[@"contractPhoto"] = photo3.length==0?@"":photo3;//合同照片地址
    dict[@"logoPhoto"] = photo4.length==0?@"":photo4;//个人与Logo合照图片地址
    dict[@"businessLicensePhoto"] = photo5.length==0?@"":photo5;//手持营业执照
    dict[@"isFaceCheck"] = face_id.length == 0?@"":@"1";
    dict[@"faceVideoUrl"] = faceVideoUrl;
    
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
        self.subminBut.enabled = YES;
    } fail:^(NSError *error) {
        [self.zhuanquan hideAnimated:YES];
        self.subminBut.enabled = YES;
    }];
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
            
            if([self.infoModel.isAuth intValue] == 0 || [self.infoModel.isFaceCheck intValue] == 0){//0：未认证
                if (self.tabView.superview == self.view) {
                    [self.tabView reloadData];
                } else {
                    [self.view addSubview:self.tabView];
                    [self.tabView reloadData];
                    [self addSubminBut];
                }
                
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
#pragma mark - 认证审核中 和 认证失败 的页面
- (void)configRenZhengZhongAndFail{
    self.normalBackView.hidden = NO;
    
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

#pragma mark 重新认证
-(void)infoBtnClicked{
    if ([self.infoModel.isAuth intValue] == 1 && [self.infoModel.isFaceCheck intValue] == 1) {
        self.tabBarController.selectedIndex = 1;
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if ([self.infoModel.isAuth intValue] == 2) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"card_name"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"card_id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"faceId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"upMap"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com_name"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com_diqu"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com_jiedao"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mingpian"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gongpai"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hetong"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logoqian"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"yingyezhizhao"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bdOne"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bdTwo"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bdThree"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bdFour"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"wancheng"];
        for (UIView *subViews in self.normalBackView.subviews) {
            [subViews removeFromSuperview];
        }
        self.normalBackView.hidden = YES;
        [self.view addSubview:self.tabView];
        [self addSubminBut];
    }
}


@end
