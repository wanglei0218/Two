//
//  RechargeViewController.m
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_RechargeViewController.h"
#import "SSH_RechargeFristTableViewCell.h"
#import "SSH_RechargeSecondeTableViewCell.h"
#import "SSH_MemberModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "SSH_PayTypeModel.h"

@interface SSH_RechargeViewController ()<UITableViewDelegate,UITableViewDataSource,SSH_RechargeFristTableViewCellDelegate>

@property (nonatomic,strong)UITableView *rechargeTable;
@property (nonatomic,strong)NSArray *rechargeData;
@property (nonatomic,strong)NSArray *fristerData;
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)NSMutableArray *indexArr;
@property (nonatomic,strong)NSString *payMoney;             ///<支付金额
@property (nonatomic,assign)NSInteger payType;              ///<支付方式
@property (nonatomic,strong)NSString *orderNoString;        ///<订单号
@property (nonatomic,strong)NSString *payId;                ///<支付id
@property (nonatomic,strong)NSString *vipId;                ///<会员id

@end

@implementation SSH_RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabelNavi.text = @"确认开通";
    
    self.indexArr = [NSMutableArray array];
    
    [self getVipData];
    [self getPayType];
    [self rechargeTable];
    [self bottomBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhifuSuccess) name:DENGFANGPayFinishName object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    [self.rechargeTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone]; //  设置默认选中的行
    [self tableView:self.rechargeTable didSelectRowAtIndexPath:indexPath];
}

- (void)backBtnClicked {
    [super backBtnClicked];
    
    [MobClick event:@"Return of membership"];
    
}

#pragma mark ===================懒加载===============
- (UITableView *)rechargeTable{
    if(!_rechargeTable){
        _rechargeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREENH_HEIGHT - getRectNavAndStatusHight - SafeAreaBottomHEIGHT - WidthScale(55)) style:UITableViewStyleGrouped];
        _rechargeTable.delegate = self;
        _rechargeTable.dataSource = self;
        
        [_rechargeTable registerClass:[SSH_RechargeFristTableViewCell class] forCellReuseIdentifier:@"rechargeFristerTableCell"];
        [_rechargeTable registerNib:[UINib nibWithNibName:@"SSH_RechargeSecondeTableViewCell" bundle:nil] forCellReuseIdentifier:@"rechargeSecondeTableCell"];
        
        [self.view addSubview:_rechargeTable];
        
    }
    return _rechargeTable;
}

- (UIButton *)bottomBtn{
    if(!_bottomBtn){
        _bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREENH_HEIGHT - WidthScale(55) - SafeAreaBottomHEIGHT, SCREEN_WIDTH, WidthScale(55))];
        [_bottomBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"确认付款" attributes:@{
                                                            NSForegroundColorAttributeName:COLOR_WITH_HEX(0xffffff),
                                                            NSFontAttributeName:[UIFont systemFontOfSize:17]
                                                                                                  }];
        [_bottomBtn setAttributedTitle:attr forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(didSelecteTheBottomEnter) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bottomBtn];
        
    }
    return _bottomBtn;
}

#pragma mark ================按钮点击方法============
- (void)didSelecteTheBottomEnter{
    [self chongBtnClicked];
}

#pragma mark ================表格数据源==============
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }else{
        return self.rechargeData.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemCell"];
            if (!cell){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"systemCell "];
            }
            
            cell.textLabel.text = @"选择会员套餐";
            
            return cell;
        }
        
        SSH_RechargeFristTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rechargeFristerTableCell" forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.type = self.type;
        cell.collectData = self.fristerData;
        SSH_MemberModel *model = self.fristerData[self.type];
        self.vipId = model.ID;
        
        return cell;
    }else{
        
        [self.indexArr addObject:indexPath];
        
        if(indexPath.row == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemCell"];
            if (!cell){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"systemCell "];
            }
            
            SSH_MemberModel *model = self.fristerData[self.type];
            self.payMoney = model.vipAmount;
            cell.textLabel.text = [NSString stringWithFormat:@"需支付:%@元",model.vipAmounts];
            
            return cell;
        }
        
        SSH_RechargeSecondeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rechargeSecondeTableCell" forIndexPath:indexPath];
        
        SSH_PayTypeModel *model = self.rechargeData[indexPath.row - 1];
        
        cell.leftImage.image = [UIImage imageNamed:model.paymentName];
        cell.titleLabel.text = model.paymentName;
        cell.selectionButton = ^(UIButton * sender) {
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
        };
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.row == 0){
        return;
    }
    
    SSH_PayTypeModel *model = self.rechargeData[indexPath.row - 1];
    
    self.payId = model.payType;
    self.payType = indexPath.row;
    
    if(indexPath.section == 1 && indexPath.row != 0){
        
        for (NSIndexPath *index in self.indexArr) {
            
            if(index.row != 0){
                SSH_RechargeSecondeTableViewCell *cell = [self.rechargeTable cellForRowAtIndexPath:index];
                
                if(index.row == indexPath.row){
                    cell.rightBtn.selected = YES;
                }else{
                    cell.rightBtn.selected = NO;
                }
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            return WidthScale(43);
        }else{
            return WidthScale(185);
        }
    }else{
        if (indexPath.row == 0){
            return WidthScale(43);
        }else{
            return 55;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return WidthScale(10);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
    
#pragma mark ======================获取数据===================
- (void)getVipData{
    NSDictionary *params = @{
                             @"timestamp":[NSString yf_getNowTimestamp],
                             @"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil]
                             };
    
    [[DENGFANGRequest shareInstance] postWithUrlString:@"vip/queryVipGradeList" parameters:params success:^(id responsObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
        if(![[dic objectForKey:@"code"] isEqualToString:@"200"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:dic[@"msg"]];
            });
            return ;
        }
        
        NSArray *dataDic = [dic objectForKey:@"data"];
        self.fristerData = [[SSH_MemberModel shardeInstance]getvipModelWithData:dataDic];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rechargeTable reloadData];
        });
        
        
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark ====================自定义代理=================
- (void)didSelecteTheRechargeItemWithModel:(SSH_MemberModel *)model{
    
    self.payMoney = model.vipAmount;
    self.vipId = model.ID;
    
    for (NSIndexPath *index in self.indexArr) {
        UITableViewCell *cell = [self.rechargeTable cellForRowAtIndexPath:index];
        
        if(index.row == 0){
            cell.textLabel.text = [NSString stringWithFormat:@"需支付:%@元",model.vipAmounts];
        }
        
    }
}

#pragma mark ===================支付接口调用==================
//支付方式获取
- (void)getPayType{
    //POST /
    NSDictionary *params = @{
                             @"timestamp":[NSString yf_getNowTimestamp],
                             @"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil]
                             };
    [[DENGFANGRequest shareInstance] postWithUrlString:@"vip/Payment/queryPaymentMethod" parameters:params success:^(id responsObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
        if(![[dic objectForKey:@"code"] isEqualToString:@"200"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:dic[@"msg"]];
            });
            return ;
        }
        
        NSArray *typeArr = [dic objectForKey:@"data"];
        self.rechargeData = [[SSH_PayTypeModel shardeInstance]getPayTypeWithData:typeArr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.rechargeTable reloadData];
        });
        
    } fail:^(NSError *error) {
        
    }];
    
}

//获取订单号
-(void)chongBtnClicked{
    [MobClick event:@"my-account-recharge-recha"];
    NSString *userString = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];

    NSDictionary *dic = @{
                          @"timestamp":[NSString yf_getNowTimestamp],
                          @"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:userString],
                          @"rechargeId":self.vipId,
                          @"paymentFunc":@"3"
                          };

    [[DENGFANGRequest shareInstance] postWithUrlString:@"vip/alipay/insertPayRecord" parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        self.orderNoString = diction[@"orderNo"];

        if (self.payType== 1) {
            [self getAliPayQianMing];
        }else if (self.payType == 2){
            [self getWeChatPayAction];
        }

    } fail:^(NSError *error) {

    }];
}

//支付宝支付
- (void)getAliPayQianMing{

    NSString *bodyString = [NSString stringWithFormat:@"%d,%@,%@",[DENGFANGSingletonTime shareInstance].useridString,[DENGFANGSingletonTime shareInstance].mobileString,self.vipId];

    NSDictionary *params = @{@"timestamp":[NSString yf_getNowTimestamp],
                             @"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:self.orderNoString],
                             @"out_trade_no":self.orderNoString,
                             @"subject":@"vip充值",
                             @"total_fee":self.payMoney,
                             @"body":bodyString,
                             @"rechargeId":self.vipId,
                             @"paymentFunc":@"3"
                             };

    [[DENGFANGRequest shareInstance] postWithUrlString:@"vip/alipay/getAlipayValidCode" parameters:params success:^(id responseObject) {

        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"333333333333%@",diction);
        [[AlipaySDK defaultService] payOrder:diction[@"data"][@"body"] fromScheme:@"taoyoudan" callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
//            self.orderNoString = resultDic[@"out_trade_no"];
            [DENGFANGSingletonTime shareInstance].aliResultStatus = [resultDic[@"resultStatus"] intValue];
            NSLog(@"11111111111%d",[resultDic[@"resultStatus"] intValue]);
            NSLog(@"222222222222%d",[DENGFANGSingletonTime shareInstance].aliResultStatus);
//            [[NSNotificationCenter defaultCenter] postNotificationName:DENGFANGPayFinishName object:nil];
            [self zhifuSuccess];
            
        }];

    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//支付宝支付成功之后请求数据给后台
- (void)updatePayResultSuccess:(BOOL)isSuccess{
    NSString *resultString;
    if (isSuccess) {
        resultString = @"success";
        NSDictionary *params = @{
                                 @"timestamp":[NSString yf_getNowTimestamp],
                                 @"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:self.orderNoString],
                                 @"orderNo":self.orderNoString,
                                 @"synchronizationResult":resultString
                                 };
        
        [[DENGFANGRequest shareInstance] postWithUrlString:@"vip/alipay/updateSynchronizationResult" parameters:params success:^(id responsObject) {
            NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
            
        } fail:^(NSError *error) {
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:[NSString stringWithFormat:@"%@",error]];
        }];
    }else{
        resultString = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].aliResultStatus];
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"支付失败,请重试"];
        return;
    }
}

//微信支付
- (void)getWeChatPayAction{
    
    NSString *sings = [NSString stringWithFormat:@"%@%@",[DENGFANGSingletonTime shareInstance].mobileString,self.vipId];
    
    NSDictionary *params = @{
                             @"timestamp":[NSString yf_getNowTimestamp],
                             @"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:sings],
                             @"mobile":[DENGFANGSingletonTime shareInstance].mobileString,
                             @"rechargeId":self.vipId,
                             @"flag":@"1",
                             @"paymentFunc":@"3"
                             };
    if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [MBProgressHUD showError:@"您未安装微信"];
        return;
    }
    [[DENGFANGRequest shareInstance] postWithUrlString:@"vip/weixin/vipWXPay" parameters:params success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            NSString *timeSting= [NSString stringWithFormat:@"%@",diction[@"data"][@"timestamp"]];
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = diction[@"data"][@"partnerid"];
            request.prepayId= diction[@"data"][@"prepayid"];
            request.package = diction[@"data"][@"package"];
            request.nonceStr= diction[@"data"][@"noncestr"];
            request.timeStamp = timeSting.intValue;
            request.sign= diction[@"data"][@"sign"];
            [WXApi sendReq:request];
            [[NSNotificationCenter defaultCenter] postNotificationName:DENGFANGPayFinishName object:nil];
        } else {
            [MBProgressHUD showError:diction[@"msg"]];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

//微信支付成功后的请求
- (void)updateWeChatPayResult{
    
//    NSDictionary *params = @{
//                             @"timestamp":[NSString yf_getNowTimestamp],
//                             @"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:self.orderNoString],
//                             @"orderNo":self.orderNoString,
//                             @"payStatus":@([DENGFANGSingletonTime shareInstance].wxRetCode)
//                             };
//
//    [[DENGFANGRequest shareInstance] postWithUrlString:@"vip/weixin/vip_wxPay_notify" parameters:params success:^(id responsObject) {
//        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
//
//    } fail:^(NSError *error) {
//
//    }];
    
}

//支付宝支付成功之后方法
- (void)zhifuSuccess{
    
    if (self.payType == 1) {//支付宝支付
        if ([DENGFANGSingletonTime shareInstance].aliResultStatus == 9000) {
            
            [self updatePayResultSuccess:1];
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"支付成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            [self updatePayResultSuccess:0];
        }
    }else if (self.payType == 2){//微信支付
        if ([DENGFANGSingletonTime shareInstance].wxRetCode == 0) {
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"支付成功"];
            [self updateWeChatPayResult];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
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
