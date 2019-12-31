//
//  SSH_TJDZViewController.m
//  qianDanWang
//
//  Created by 畅轻 on 2019/9/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_TJDZViewController.h"
#import "SSH_TJDZTableViewCell.h"
#import "SSH_TJDZCollectionViewCell.h"
#import "SSH_XZCSViewController.h"

@interface SSH_TJDZViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,SSH_LocationViewControllerDelegate>
{
    NSArray *titleArr;
    NSArray *contentArr;
    NSArray *collectionArr;
    UIButton *saveBut;
    int a;
    int b;
    int c;
    int d;
    /**
     是否选中
     */
    //工作类型
    NSMutableArray *jobArr;
    NSArray *jobSelectArr;
    //抵押类型
    NSMutableArray *morArr;
    NSArray *morSelectArr;
    //金额
    NSDictionary *amoDic;
    //选中城市
    NSString *cityStr;
}
@property (nonatomic, strong)UITableView *tabView;
@property (nonatomic, strong) MBProgressHUD *zhuanquan;

@end

@implementation SSH_TJDZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text = @"设置条件";
    
    saveBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBut setImage:[UIImage imageNamed:@"保存灰色"] forState:UIControlStateDisabled];
    [saveBut setImage:[UIImage imageNamed:@"保存"] forState:UIControlStateNormal];
    saveBut.enabled = NO;
    [saveBut addTarget:self action:@selector(saveButtonDidSelection) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:saveBut];
    [saveBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30.5);
        make.right.mas_equalTo(-13.5);
        make.bottom.mas_equalTo(12);
        make.width.mas_equalTo(47);
    }];
    
    [self.view addSubview:self.tabView];
    a = 0;
    b = 0;
    c = 0;
    d = 0;
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    if (dataDic) {
        titleArr = @[@"选择城市",@"职业类型",@"资金抵押类型",[NSString stringWithFormat:@"%@款金额（元）",[DENGFANGSingletonTime shareInstance].name[1]]];
        cityStr = dataDic[@"city"];
        NSArray *Arr1 = [cityStr componentsSeparatedByString:@","];
        //检测是否存在已经选择的条件如果没有不进行操作
        //identityType
        NSString *identityTypeStr = dataDic[@"identityType"];
        jobArr = [NSMutableArray arrayWithArray:@[@"",@"",@"",@""]];
        NSArray *jobStatusArr = [identityTypeStr componentsSeparatedByString:@","];
        for (NSString *str in jobStatusArr) {
            [jobArr replaceObjectAtIndex:[str integerValue] withObject:str];
        }
        
        NSArray *Arr2 = @[@"上班族",@"公务员",@"企业主",@"自由职业"];
        
        morArr = [NSMutableArray arrayWithArray:@[dataDic[@"isFund"],dataDic[@"carProduction"],dataDic[@"isSecurity"],dataDic[@"property"],dataDic[@"isWeiliD"]]];
        amoDic = @{@"begin":[NSString stringWithFormat:@"%@",dataDic[@"satrtLoanAmount"]],@"end":[NSString stringWithFormat:@"%@",dataDic[@"endLoanAmount"]]};
        
        
        NSArray *Arr3 = @[@"公积金",[NSString stringWithFormat:@"车产%@",[DENGFANGSingletonTime shareInstance].name[1]],[NSString stringWithFormat:@"社保%@",[DENGFANGSingletonTime shareInstance].name[1]],[NSString stringWithFormat:@"房产%@",[DENGFANGSingletonTime shareInstance].name[1]],[NSString stringWithFormat:@"微粒%@",[DENGFANGSingletonTime shareInstance].name[1]]];
        NSArray *Arr4 = @[@"1万-20万",@"20万以上"];
        contentArr = @[Arr1,Arr2,Arr3,Arr4];
    } else {
        titleArr = @[@"选择城市",@"职业类型",@"资金抵押类型",[NSString stringWithFormat:@"%@款金额（元）",[DENGFANGSingletonTime shareInstance].name[1]]];
        cityStr = @"请选择";
        NSArray *Arr1 = [cityStr componentsSeparatedByString:@","];
        jobArr = [NSMutableArray arrayWithArray:@[@"",@"",@"",@""]];
        NSArray *Arr2 = @[@"上班族",@"公务员",@"企业主",@"自由职业"];
        
        morArr = [NSMutableArray arrayWithArray:@[@"0",@"0",@"0",@"0",@"0"]];
        amoDic = @{@"begin":@"",@"end":@""};
        
        NSArray *Arr3 = @[@"公积金",[NSString stringWithFormat:@"车产%@",[DENGFANGSingletonTime shareInstance].name[1]],[NSString stringWithFormat:@"社保%@",[DENGFANGSingletonTime shareInstance].name[1]],[NSString stringWithFormat:@"房产%@",[DENGFANGSingletonTime shareInstance].name[1]],[NSString stringWithFormat:@"微粒%@",[DENGFANGSingletonTime shareInstance].name[1]]];
        NSArray *Arr4 = @[@"1万-20万",@"20万以上"];
        contentArr = @[Arr1,Arr2,Arr3,Arr4];
    }
}

- (void)saveButtonDidSelection {
    NSString *identityType = @"";
    for (NSString *str in jobArr) {
        if (identityType.length == 0) {
            identityType = str;
        } else {
            if (str.length == 0) {
                
            } else {
                identityType = [NSString stringWithFormat:@"%@,%@",identityType,str];
            }
        }
    };
    self.zhuanquan = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.zhuanquan.label.text = NSLocalizedString(@"正在上传中...", @"HUD loading title");
    
    NSDictionary *paramDic = @{
                               @"isAuto":self.isAuto,
                               @"grabNum":self.grabNum,
                               @"orderAmxCoin":self.maxCoin,
                               @"city":cityStr,
                               @"identityType":identityType,
                               @"isFund":morArr[0],
                               @"carProduction":morArr[1],
                               @"isSecurity":morArr[2],
                               @"property":morArr[3],
                               @"isWeiliD":morArr[4],
                               @"satrtLoanAmount":amoDic[@"begin"],
                               @"endLoanAmount":amoDic[@"end"],
                               @"userId":@([DENGFANGSingletonTime shareInstance].useridString),
                               @"mobile":[DENGFANGSingletonTime shareInstance].mobileString,
                               @"timestamp":[NSString yf_getNowTimestamp],
                               @"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d%@",[DENGFANGSingletonTime shareInstance].useridString,[DENGFANGSingletonTime shareInstance].mobileString]]
                               };
    
    [[DENGFANGRequest shareInstance] postWithUrlString:@"vip/autoGrab/saveAutoGrab" parameters:paramDic success:^(id responsObject) {
        [self.zhuanquan hideAnimated:YES];
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [MBProgressHUD showError:@"保存成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        } else {
            
        }
    } fail:^(NSError *error) {
        [self.zhuanquan hideAnimated:YES];
        [MBProgressHUD showError:@"保存失败,请重试"];
    }];
}

- (UITableView *)tabView {
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHightOnew, SCREEN_WIDTH, SCREENH_HEIGHT - getRectNavAndStatusHightOnew) style:UITableViewStyleGrouped];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        [_tabView registerClass:[SSH_TJDZTableViewCell class] forCellReuseIdentifier:@"SSH_TJDZTableViewCell"];
    }
    return _tabView;
}
#pragma mark ------------------------------tableViewDelegate && tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SSH_TJDZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SSH_TJDZTableViewCell"];
    cell.titleStr = titleArr[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    collectionArr = contentArr[indexPath.section];
    cell.number = collectionArr.count;
    if (indexPath.section == 3) {
        cell.collecView.allowsMultipleSelection = NO;
    } else {
        cell.collecView.allowsMultipleSelection = YES;
    }
    cell.collecView.delegate = self;
    cell.collecView.dataSource = self;
    cell.collecView.tag = 1200+indexPath.section;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = contentArr[indexPath.section];
    NSInteger intA = arr.count/3;
    float a = (float)intA;
    float b = ((float)arr.count)/3.;
    if (a < b) {
        intA = intA + 1;
    }
    return 45*(intA + 1);
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @" ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @" ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9.9;
}

#pragma mark ------------------------------collectionViewDelegate && collectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger index = collectionView.tag - 1200;
    NSArray *arr = contentArr[index];
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SSH_TJDZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SSH_TJDZCollectionViewCell" forIndexPath:indexPath];
    NSArray *cellArray = contentArr[collectionView.tag - 1200];
    cell.titleStr = cellArray[indexPath.row];
    
    if (collectionView.tag == 1200) {
        NSArray *arr = [cityStr componentsSeparatedByString:@","];
        if ([arr[indexPath.row] isEqualToString:@"请选择"]) {
            cell.selected = NO;
        } else {
            cell.titleStr = arr[indexPath.row];
            [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            cell.selected = YES;
            a++;
        }
    } else if (collectionView.tag == 1201) {
        if (![jobArr[indexPath.row] isEqualToString:@""]) {
            cell.selected = YES;
            [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            b++;
        } else {
            cell.selected = NO;
        }
    } else if (collectionView.tag == 1202) {
        if ([morArr[indexPath.row] isEqualToString:@"1"]) {
            cell.selected = YES;
            [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            c++;
        } else {
            cell.selected = NO;
        }
    } else {
        
        if ([amoDic[@"begin"] isEqualToString:@"10000"]) {
            if (indexPath.row == 0) {
                cell.selected = YES;
                d++ ;
            }
        } else if ([amoDic[@"begin"] isEqualToString:@"200000"]) {
            if (indexPath.row == 1) {
                cell.selected = YES;
                d++ ;
            }
        }
    }
    
    if (a != 0 && b != 0 && c != 0 && d != 0) {
        saveBut.enabled = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *status = @"1";
    if (collectionView.tag == 1201) {
        status = [NSString stringWithFormat:@"%ld",indexPath.row];
    }
    [self didSelectedItemAtIndexPath:indexPath Status:status collectionViewTag:collectionView.tag];
    if (collectionView.tag == 1201) {
        b=0;
    } else if (collectionView.tag == 1200) {
        a=0;
    } else if (collectionView.tag == 1202) {
        c=0;
    } else {
        d=0;
    }
    [collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *status = @"0";
    if (collectionView.tag == 1201) {
        status = @"";
        b--;
    } else if (collectionView.tag == 1200) {
        a--;
    } else if (collectionView.tag == 1202) {
        c--;
    } else {
        d--;
    }
    if (a < 0 || b < 0 || c < 0 || d < 0) {
        saveBut.enabled = YES;
    } else {
        saveBut.enabled = NO;
    }
    [self didSelectedItemAtIndexPath:indexPath Status:status collectionViewTag:collectionView.tag];
    if (collectionView.tag == 1201) {
        b=0;
    } else if (collectionView.tag == 1200) {
        a=0;
    } else if (collectionView.tag == 1202) {
        c=0;
    } else {
        d=0;
    }
    [collectionView reloadData];
}

- (void)didSelectedItemAtIndexPath:(NSIndexPath *)indexPath Status:(NSString *)status collectionViewTag:(NSInteger)tag {
    if (tag == 1200) {
        [MobClick event:@"choiceofcity"];
        SSH_XZCSViewController *locationVC = [[SSH_XZCSViewController alloc]init];
        locationVC.hidesBottomBarWhenPushed = YES;
        locationVC.delegate = self;
        DENGFANGLocationCity *cityM = [[DENGFANGLocationCity alloc] init];
        cityM.name = [contentArr[0][0] isEqualToString:@"请选择"]?@"全国":contentArr[0][0];
        locationVC.oneCityM = cityM;
        [self.navigationController pushViewController:locationVC animated:YES];
    } else if (tag == 1201) {
        //职业类型
        if (indexPath.row == 0) {
            [MobClick event:@"office worker"];
        } else if (indexPath.row == 1) {
            [MobClick event:@"civil servant"];
        } else if (indexPath.row == 2) {
            [MobClick event:@"business"];
        } else {
            [MobClick event:@"liberalporfessions"];
        }
        jobSelectArr = jobArr;
        NSMutableArray *mArr = [jobSelectArr mutableCopy];
        [mArr replaceObjectAtIndex:indexPath.row withObject:status];
        jobArr = mArr;
    } else if (tag == 1202) {
        if (indexPath.row == 0) {
            [MobClick event:@"Accumulationfund"];
        } else if (indexPath.row == 1) {
            [MobClick event:@"Vehicleproductionloan"];
        } else if (indexPath.row == 2) {
            [MobClick event:@"socialsecurity"];
        } else if (indexPath.row == 3) {
            [MobClick event:@"Realesteteloan"];
        } else {
            [MobClick event:@"Particulateloan"];
        }
        [morArr replaceObjectAtIndex:indexPath.row withObject:status];
    } else {
        //贷款金额
        [MobClick event:@"loanamount"];
        if (indexPath.row == 0) {
            amoDic = @{@"begin":@"10000",@"end":@"200000"};
        } else {
            amoDic = @{@"begin":@"200000",@"end":@""};
        }
    }
}
#pragma mark 定位界面传过来的值
- (void)sl_cityListSelectedCity:(NSString *)selectedCity Id:(NSInteger)Id displayCity:(NSString *)displayCity cityArray:(NSArray *)cityArray CityArrayString:(NSString *)cityArrayString{
    
    [[NSUserDefaults standardUserDefaults] setObject:cityArrayString forKey:@"111111"];
    cityStr = cityArrayString;
    [self.tabView reloadData];
    NSMutableArray *mArr = [contentArr mutableCopy];
    NSArray *arr = [cityArrayString componentsSeparatedByString:@","];
    [mArr replaceObjectAtIndex:0 withObject:arr];
    contentArr = mArr;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0  inSection:0];
    SSH_TJDZTableViewCell *cell = [self.tabView cellForRowAtIndexPath:indexPath];
    [cell.collecView reloadData];
    
}

@end
