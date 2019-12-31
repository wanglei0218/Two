//
//  SSH_TuiSongSheZhiController.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/12.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_TuiSongSheZhiController.h"
#import "SSH_TuiSongKaiGuanCell.h"
#import "SSH_TuiSongDatePickerView.h"
#import "SSH_TuiSongSheZhiModel.h"
#import "SSH_TuiSongDingWeiController.h"
#import <UserNotifications/UserNotifications.h>

@interface SSH_TuiSongSheZhiController ()<UITableViewDelegate,UITableViewDataSource,SSH_TuiSongDataPickerViewDelegate,SSH_TuiSongDingWeiControllerDelegate>
{
    UIWindow * _MyWindow;
}


@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSMutableArray *detailArray;

@property(nonatomic,strong)SSH_TuiSongSheZhiModel *tuiSongM;

@property(nonatomic,copy) NSString *fanChan;
@property(nonatomic,copy) NSString *cheChan;
@property(nonatomic,copy) NSString *sheBao;
@property(nonatomic,copy) NSString *gongJiJin;
@property(nonatomic,copy) NSString *weiLiDai;
@property(nonatomic,copy) NSString *zhiMaFen;

@property(nonatomic,copy) NSString *isOpen;

@property(nonatomic,copy) NSString *moneyString;
@property(nonatomic,copy) NSString *starTime;
@property(nonatomic,copy) NSString *endTime;
@property(nonatomic,copy) NSString *cityString;

//是否刷新首页
//@property(nonatomic,assign)BOOL isRefreshHome;
//
@property(nonatomic,strong)NSDictionary *dictionary;

@property(nonatomic,assign)BOOL isOpenPush; //是否开启推送
@property(nonatomic,assign)BOOL isClickBaoCun;

@end

@implementation SSH_TuiSongSheZhiController

-(NSMutableArray *)detailArray{
    if (!_detailArray) {
        _detailArray = [NSMutableArray array];
    }
    return _detailArray;
}

-(void)showAlertView{
    
    //系统没有开启推送
    self.isOpenPush = YES;
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请打开系统通知服务" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([application canOpenURL:url]) {
            if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [application openURL:url options:@{} completionHandler:nil];
            } else {
                [application openURL:url];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alert addAction:actionConfirm];
    [alert addAction:actionCancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)isOpenNotification{
    
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
            // 用户未授权通知
            if (settings.authorizationStatus == UNAuthorizationStatusDenied) {
                
                [self showAlertView];
            }
        }];
    } else {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types==UIRemoteNotificationTypeNone) {
            
            [self showAlertView];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isOpen = @"0";
    self.isOpenPush = NO;
    
    self.titleLabelNavi.text = @"消息推送设置";
    
    //判断是否开启通知
    [self isOpenNotification];
    
    [self setupTableView];
    
    [self loadUserPushData];
}

-(void)setupTableView{

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = ColorBackground_Line;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getRectNavAndStatusHight);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    self.tableView.tableFooterView = bottomView;
    
    UIImageView *tiShiImageView = [[UIImageView alloc] init];
    tiShiImageView.image = [UIImage imageNamed:@"消息推送说明"];
    tiShiImageView.frame = CGRectMake(15, 7, 12, 12);
    [bottomView addSubview:tiShiImageView];
    
    UILabel *tiShiLabel = [[UILabel alloc] init];
    tiShiLabel.text = @"选择的条件越严格，推送的订单越精准，数量也越少哦！";
    tiShiLabel.font = [UIFont systemFontOfSize:12];
    tiShiLabel.textColor = COLOR_WITH_HEX(0x999999);
    [bottomView addSubview:tiShiLabel];
    [tiShiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tiShiImageView.mas_right).offset(5);
        make.centerY.mas_equalTo(tiShiImageView.mas_centerY);
    }];
    
    UIButton *baoCunBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    baoCunBtn.backgroundColor = ColorZhuTiHongSe;
    [baoCunBtn setTitle:@"提交" forState:UIControlStateNormal];
    
    baoCunBtn.layer.masksToBounds = YES;
    baoCunBtn.layer.cornerRadius = 20;
    [baoCunBtn addTarget:self action:@selector(baoCunButton:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:baoCunBtn];
    [baoCunBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(tiShiLabel.mas_bottom).offset(17);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(40);
    }];
    
    NSString *daiKuanJinE = [NSString stringWithFormat:@"%@款金额",[DENGFANGSingletonTime shareInstance].name[1]];
    NSString *weiLiDai = [NSString stringWithFormat:@"微粒%@",[DENGFANGSingletonTime shareInstance].name[1]];
    
    self.titleArray = @[@"城市",@"接受时段",daiKuanJinE,@"房产情况",@"车产情况",@"社保",@"公积金",weiLiDai,@"芝麻信用"];
    [self.detailArray addObjectsFromArray:@[@"请选择",@"请选择",@"请选择",@"请选择",@"请选择",@"请选择",@"请选择",@"请选择",@"请选择"]];
}

-(void)loadUserPushData{
    
    NSString *userId = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
    
    NSString *url = @"push/getUserSetting";
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = [NSString yf_getNowTimestamp];
    dict[@"userId"] = userId;
    dict[@"signs"] = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:userId];
    
    [[DENGFANGRequest shareInstance] postWithUrlString:url parameters:dict success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            if ([SSH_TOOL_GongJuLei isKongWithString:diction[@"data"]]) {
                
            } else {
                self.tuiSongM = [SSH_TuiSongSheZhiModel mj_objectWithKeyValues:diction[@"data"]];
            }
            
            //NSLog(@"%@",self.tuiSongM);
            [self.detailArray removeAllObjects];
            [self.detailArray addObject:[self isNull:self.tuiSongM.pushCity placehoder:@"请选择"]];
            
            NSString *timeString = [NSString stringWithFormat:@"%@-%@",self.tuiSongM.pushStartTime,self.tuiSongM.pushEndTime];
            
            if (self.tuiSongM.pushEndTime==nil||self.tuiSongM.pushStartTime==nil||[self.tuiSongM.pushEndTime isEqualToString:@""]||[self.tuiSongM.pushStartTime isEqualToString:@""]) {
                [self.detailArray addObject:@"请选择"];
            }else{
                
                [self.detailArray addObject:timeString];
            }
        
            
            [self.detailArray addObject:[self isNull:self.tuiSongM.loanMoney placehoder:@"请选择"]];
            //房产（0:无 1:有，不接受抵押  2:有,接受抵押）
            NSString *estateString = nil;
            if ([self.tuiSongM.estateType isEqualToString:@"0"]) {
                estateString = @"无房产";
            }else if ([self.tuiSongM.estateType isEqualToString:@"1"]){
                estateString = @"有房产";
            }else if([self.tuiSongM.estateType isEqualToString:@"3"]){
                estateString = @"有房产";
            }
            [self.detailArray addObject:[self isNull:estateString placehoder:@"请选择"]];
            
            //车产
            NSString *carString = nil;
            if ([self.tuiSongM.carProductionType isEqualToString:@"0"]) {
                carString = @"无";
            }else if ([self.tuiSongM.carProductionType isEqualToString:@"1"] || [self.tuiSongM.carProductionType isEqualToString:@"2"]){
                carString = @"有车产";
            }
            [self.detailArray addObject:[self isNull:carString placehoder:@"请选择"]];
            
            //社保 0：无 1:有
            NSString *sheBaoString = nil;
            NSLog(@"%@",self.tuiSongM.isSecurity);
            if ([self.tuiSongM.isSecurity isEqualToString:@"0"]) {
                sheBaoString = @"无社保";
            }else if ([self.tuiSongM.isSecurity isEqualToString:@"1"]){
                sheBaoString = @"有社保";
            }
            [self.detailArray addObject:[self isNull:sheBaoString placehoder:@"请选择"]];
            
            //公积金
            NSString *gongJiJinString = nil;
            if ([self.tuiSongM.isFund isEqualToString:@"0"]) {
                gongJiJinString = @"无公积金";
            }else if ([self.tuiSongM.isFund isEqualToString:@"1"]){
                gongJiJinString = @"有公积金";
            }
            [self.detailArray addObject:[self isNull:gongJiJinString placehoder:@"请选择"]];
            
            //微粒贷
            NSString *weiLiDaiString = nil;
            if ([self.tuiSongM.isWeiliD isEqualToString:@"0"]) {
                weiLiDaiString = @"无";
            }else if ([self.tuiSongM.isWeiliD isEqualToString:@"1"]){
                weiLiDaiString = @"有";
            }
            [self.detailArray addObject:[self isNull:weiLiDaiString placehoder:@"请选择"]];
            
            //芝麻分 0:无 1:550以下  2:550-600 3:600以上
            NSString *zhiMaString = nil;
            if ([self.tuiSongM.sesameCredit isEqualToString:@"1"]) {
                zhiMaString = @"600分以下";
            }else if ([self.tuiSongM.sesameCredit isEqualToString:@"2"]){
                zhiMaString = @"600-650分";
            }else if ([self.tuiSongM.sesameCredit isEqualToString:@"3"]){
                zhiMaString = @"650-700分";
            }else if ([self.tuiSongM.sesameCredit isEqualToString:@"4"]){
                zhiMaString = @"700以上";
            }
            [self.detailArray addObject:[self isNull:zhiMaString placehoder:@"请选择"]];
            
            self.cityString = self.tuiSongM.pushCity;
            self.starTime = self.tuiSongM.pushStartTime;
            self.endTime = self.tuiSongM.pushEndTime;
            self.moneyString = self.tuiSongM.loanMoney;
            self.fanChan = self.tuiSongM.estateType;
            self.cheChan = self.tuiSongM.carProductionType;
            self.sheBao = self.tuiSongM.isSecurity;
            self.gongJiJin = self.tuiSongM.isFund;
            self.weiLiDai = self.tuiSongM.isWeiliD;
            self.zhiMaFen = self.tuiSongM.sesameCredit;
            self.isOpen = self.tuiSongM.isOpen;
            
            self.tableView.tableFooterView.hidden = ([self.isOpen isEqualToString:@"0"]||self.isOpenPush)?YES:NO;
            [self.tableView reloadData];
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:diction[@"msg"]];
        }
        
    } fail:^(NSError *error) {
//        NSLog(@"error == %@",error);
    }];
}

-(NSString *)isNull:(NSString *)text placehoder:(NSString *)hoder{
    
    if ([text isEqualToString:@""] || text == nil) {
        return hoder;
    }
    return text;
}

-(void)baoCunButton:(UIButton *)btn{
    
    NSString *url = @"push/setUserPush";
    NSString *userId = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"timestamp"] = [NSString yf_getNowTimestamp];
    dict[@"signs"] = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:userId];
    dict[@"userId"] = userId;
    
    dict[@"pushCity"] = self.cityString;
    dict[@"pushStartTime"] = self.starTime;
    dict[@"pushEndTime"] = self.endTime;
    dict[@"loanMoney"] = self.moneyString;
    
    dict[@"estateType"] = self.fanChan;
    dict[@"carProductionType"] = self.cheChan;
    dict[@"isSecurity"] = self.sheBao;
    dict[@"isFund"] = self.gongJiJin;
    dict[@"isWeiliD"] = self.weiLiDai;
    dict[@"sesameCredit"] = self.zhiMaFen;
    dict[@"isOpen"] = self.isOpen;
    
//    NSLog(@"dict == %@",dict);
    
    [[DENGFANGRequest shareInstance] postWithUrlString:url parameters:dict success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:diction[@"msg"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self.isOpen isEqualToString:@"0"] || !self.isClickBaoCun) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                self.isClickBaoCun = NO;
                
            });
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:diction[@"msg"]];
        }
        
    } fail:^(NSError *error) {
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([self.isOpen isEqualToString:@"0"] || self.isOpenPush)?1:2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
        return 9;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        SSH_TuiSongKaiGuanCell *cell = [SSH_TuiSongKaiGuanCell cellWithTableView:tableView IndexPath:indexPath];
        cell.tongZhiSwitch.on = ([self.isOpen isEqualToString:@"0"]||self.isOpenPush)?NO:YES;
        
        NSLog(@"%d",cell.tongZhiSwitch.on);
        
        [cell.tongZhiSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        static NSString *ID = @"CellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        
        
        cell.textLabel.text = self.titleArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = COLOR_WITH_HEX(0x222222);
        cell.detailTextLabel.text = self.detailArray[indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = COLOR_WITH_HEX(0x999999);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//添加箭头
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            
            SSH_TuiSongDingWeiController *locationVC = [[SSH_TuiSongDingWeiController alloc]init];
            locationVC.hidesBottomBarWhenPushed = YES;
            locationVC.delegate = self;
            locationVC.citysString = self.cityString;// self.tuiSongM.pushCity;
            [self.navigationController pushViewController:locationVC animated:YES];
            
        }else if (indexPath.row==1){
            NSArray *arr1 = @[@"00:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00"];
            NSArray *arr2 = @[@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00"];
            
            [self setupPickerView:arr1 textArray:arr2 Tag:1];
            
        }else if (indexPath.row==2){
            
            NSArray *arr1 = @[@"1000",@"2000",@"5000",@"10000",@"20000",@"50000",@"100000",@"200000"];
            NSArray *arr2 = @[@"2000",@"5000",@"10000",@"20000",@"50000",@"100000",@"200000",@"500000",@"1000000"];
            
            [self setupPickerView:arr1 textArray:arr2 Tag:2];
            
        }else if (indexPath.row==3){
            
            [self showAlertActionSheetIndex:indexPath.row Title:@"房产情况" indexArray:@[@"请选择",@"无房产",@"有房产"]];
        
        }else if (indexPath.row==4){
            
            [self showAlertActionSheetIndex:indexPath.row Title:@"车产情况" indexArray:@[@"请选择",@"无车产",@"有车产"]];
            
        }else if (indexPath.row==5){
            
            [self showAlertActionSheetIndex:indexPath.row Title:@"社保" indexArray:@[@"请选择",@"无社保",@"有社保"]];
            
        }else if (indexPath.row==6){
            
            [self showAlertActionSheetIndex:indexPath.row Title:@"公积金" indexArray:@[@"请选择",@"无社保",@"有公积金"]];
            
        }else if (indexPath.row==7){
             NSString *weiLiDai = [NSString stringWithFormat:@"微粒%@",[DENGFANGSingletonTime shareInstance].name[1]];
            [self showAlertActionSheetIndex:indexPath.row Title:weiLiDai indexArray:@[@"请选择",@"无",@"有"]];
            
        }else{
            [self showAlertActionSheetIndex:indexPath.row Title:@"芝麻信用" indexArray:@[@"请选择",@"600分以下",@"600-650分",@"650-700分",@"700以上"]];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    sectionHeaderView.backgroundColor = ColorBackground_Line;
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)showAlertActionSheetIndex:(NSInteger)row Title:(NSString *)title indexArray:(NSArray *)array{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i=0; i<array.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:array[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.detailArray replaceObjectAtIndex:row withObject:array[i]];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:1];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
            if (row==3) {
                if (i==0) {
                    self.fanChan = @"";
                }else{
                    self.fanChan = [NSString stringWithFormat:@"%d",i-1];
                }
            }else if (row==4){
                if (i==0) {
                    self.cheChan = @"";
                }else{
                    self.cheChan = [NSString stringWithFormat:@"%d",i-1];
                }
            }else if (row==5){
                if (i==0) {
                    self.sheBao = @"";
                }else{
                    self.sheBao = [NSString stringWithFormat:@"%d",i-1];
                }
            }else if (row==6){
                if (i==0) {
                    self.gongJiJin = @"";
                }else{
                    self.gongJiJin = [NSString stringWithFormat:@"%d",i-1];
                }
            }else if (row==7){
                if (i==0) {
                    self.weiLiDai = @"";
                }else{
                    self.weiLiDai = [NSString stringWithFormat:@"%d",i-1];
                }
            }else{
                if (i==0) {
                    self.zhiMaFen = @"";
                }else{
                    self.zhiMaFen = [NSString stringWithFormat:@"%d",i];
                }
            }
        }];
        [alertVc addAction:action];
        [action setValue:COLOR_WITH_HEX(0x222222) forKey:@"titleTextColor"];
    }
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [actionCancel setValue:COLOR_WITH_HEX(0xe63c3f) forKey:@"titleTextColor"];
    [alertVc addAction:actionCancel];
    [self presentViewController:alertVc animated:YES completion:nil];
}

-(void)setupPickerView:(NSArray *)array1 textArray:(NSArray *)array2 Tag:(NSInteger)tag{
    
    // 背景图
    UIView *backView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.3;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPickerWindowAction)];
    [backView addGestureRecognizer:backTap];
    
    SSH_TuiSongDatePickerView *pickerView = [[SSH_TuiSongDatePickerView alloc] initWithFrame:CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, 284)];
    pickerView.letter1 = array1;
    pickerView.letter2 = array2;
    pickerView.delegate = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.tag = tag;
    
    // 创建窗口
    _MyWindow = [[UIWindow alloc] init];
    // 窗口背景
    _MyWindow.backgroundColor = [UIColor clearColor];
    _MyWindow.windowLevel = UIWindowLevelAlert;
    _MyWindow.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT);
    [_MyWindow addSubview:backView];
    [_MyWindow addSubview:pickerView];
    _MyWindow.hidden = NO;
    
    // 动画
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = CGRectMake(0, SCREENH_HEIGHT - 284, SCREEN_WIDTH, 284);
        pickerView.frame = frame;
    } completion:^(BOOL finished) {
    }];
}

-(void)hiddenPickerWindowAction{
    UIView *pickerView = [_MyWindow viewWithTag:100];
    
    [UIView animateWithDuration:0.238 animations:^{
        CGRect frame = CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, 284);
        pickerView.frame = frame;
    }completion:^(BOOL finished) {
        self->_MyWindow = nil;
    }];
}
//自定义的pickerViewDelegate代理方法
-(void)pickerView:(UIView *)pickerView result1:(nonnull NSString *)string1 result2:(nonnull NSString *)string2{
    
    if (pickerView.tag == 1) {
//        NSLog(@"%@---%@",string1,string2);
        self.starTime = string1;
        self.endTime = string2;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *str = [NSString stringWithFormat:@"%@-%@",string1,string2];
        
        NSLog(@"str == %@",str);
        NSLog(@"starTime == %@",self.starTime);
        NSLog(@"endTime == %@",self.endTime);
        
        [self.detailArray replaceObjectAtIndex:indexPath.row withObject:str];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        NSString *str = [NSString stringWithFormat:@"%@-%@",string1,string2];
        self.moneyString = str;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [self.detailArray replaceObjectAtIndex:indexPath.row withObject:str];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self hiddenPickerWindowAction];
}

- (void)cancelBtnClick:(UIView *)pickerView{
    
    if (pickerView.tag == 100) {
        [self hiddenPickerWindowAction];
    }
}

-(void)switchChange:(id)sender{
    UISwitch *openbutton = (UISwitch *)sender;
    if(openbutton.isOn){
        self.tableView.tableFooterView.hidden = NO;
        self.isOpen = @"1";
        //发送数据请求
        self.isClickBaoCun = YES;
        [self baoCunButton:nil];
        [MobClick event:@"my-personal-on"];
    }else{
        self.tableView.tableFooterView.hidden = YES;
        self.isOpen = @"0";
        
        //发送数据请求
        [self baoCunButton:nil];
        [MobClick event:@"my-personal-off"];
    }
    [self.tableView reloadData];
}

#pragma mark - 城市选择delegate
- (void)chooseCityString:(NSString *)selectedCity{
    self.cityString = selectedCity;
    [self.detailArray replaceObjectAtIndex:0 withObject:selectedCity];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

@end
