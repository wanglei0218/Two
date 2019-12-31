//
//  DENGFANGChongZhiPageViewController.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ChargeActionViewController.h"
#import "SSH_ChargeDingBuView.h"
#import "SSH_ChongZhiLieBiaoCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "SSH_ZFCGViewController.h"
#import "WXApi.h"
#import "SSH_ChongZhiJinEModel.h"
#import "SSH_ChongZhiFangShiModel.h"
#import "SSH_WangYeViewController.h"

@interface SSH_ChargeActionViewController ()<UITableViewDelegate,UITableViewDataSource,DENGFANGChongZhiListCellDelegate>


@property(nonatomic,strong)UITableView * myTableView;

@property (nonatomic,strong) NSMutableArray * allView;
@property (nonatomic,strong) SSH_ChargeDingBuView * firstView;
@property (nonatomic,strong) SSH_ChargeDingBuView * secondView;
@property (nonatomic,strong) SSH_ChargeDingBuView * thressView;
@property (nonatomic,strong) SSH_ChargeDingBuView * fourView;

@property (nonatomic,strong) NSMutableArray * btnArr; //cell中的选择按钮
@property (nonatomic, strong) NSString *orderNoString;//订单号
@property (nonatomic, strong) NSString *rechargeId;
@property (nonatomic, strong) NSString *zhifuJine;//支付金额
@property (nonatomic, strong) NSMutableArray *moneyDataArray;
@property (nonatomic, strong) NSMutableArray *methodDataArray;
@property (nonatomic, assign) int payType;//支付方式
@property (nonatomic, strong) SSH_ChongZhiJinEModel *moneyModel ;

@end

@implementation SSH_ChargeActionViewController


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*这个是上线后的key*/
    [WXApi registerApp:@"wx9d79a0c941602bb0"];
    
    self.moneyDataArray = [NSMutableArray array];
    self.methodDataArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhifuSuccess) name:DENGFANGPayFinishName object:nil];
    
    [self loadChargePageData];
    
    self.titleLabelNavi.text = @"充值";
    self.allView = [[NSMutableArray alloc]init];
    self.btnArr = [[NSMutableArray alloc]init];
    
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getRectNavAndStatusHight);
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    
    UIButton * infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn setTitle:@"充值说明" forState:UIControlStateNormal];
    [infoBtn addTarget:self action:@selector(chargeDescribAction) forControlEvents:UIControlEventTouchUpInside];
    [infoBtn setTitleColor:GrayColor666 forState:UIControlStateNormal];
    infoBtn.titleLabel.font = UIFONTTOOL12;
    [self.navigationView addSubview:infoBtn];
    [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(50);
    }];
    
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
    
}

-(void)backBtnClicked{
    [MobClick event:@"my-account-recharge-back"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 支付宝支付成功之后请求数据给后台
- (void)updatePayResultSuccess:(BOOL)isSuccess{
    NSString *resultString;
    if (isSuccess) {
        resultString = @"success";
    }else{
        resultString = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].aliResultStatus];
    }
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGUpdateAliPayResult parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:self.orderNoString],@"orderNo":self.orderNoString,@"synchronizationResult":resultString} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
    } fail:^(NSError *error) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (BOOL)isKongString:(NSString *)string {
    
    if (string == nil || [string isEqualToString:@""] || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}

#pragma mark - 跳转成功页
- (void)jumpToSuccessPage{
    
    SSH_ZFCGViewController *successVC = [[SSH_ZFCGViewController alloc] init];
    
    successVC.zhifuMoney = [NSString stringWithFormat:@"%@元",self.moneyModel.relMoney];
    successVC.mianzhiJinbi = [NSString stringWithFormat:@"%@金币",self.moneyModel.coin];
    
    successVC.huozengJinbi = [NSString stringWithFormat:@"获赠%d金币",[self.moneyModel.discount intValue]];
    if (self.payType == 1) {
        successVC.zhifuStyle = @"支付宝";
    }else if (self.payType == 2){
        successVC.zhifuStyle = @"微信";
    }
    successVC.orderNumber = self.orderNoString;
    [self.navigationController pushViewController:successVC animated:YES];
}

#pragma mark - 支付结束后执行的方法
- (void)zhifuSuccess{
    
    if (self.payType == 1) {//支付宝支付
        if ([DENGFANGSingletonTime shareInstance].aliResultStatus == 9000) {
            
            [self updatePayResultSuccess:1];
            [self jumpToSuccessPage];
        }else{
            [self updatePayResultSuccess:0];
        }
    }else if (self.payType == 2){//微信支付
        if ([DENGFANGSingletonTime shareInstance].wxRetCode == 0) {
            [self jumpToSuccessPage];
        }
        [self updateWeChatPayResult];
    }
}

#pragma mark - 微信支付后返回后台的数据请求
- (void)updateWeChatPayResult{
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGWeiXinPayStatusUpdateURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:self.orderNoString],@"orderNo":self.orderNoString,@"payStatus":@([DENGFANGSingletonTime shareInstance].wxRetCode)} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
    } fail:^(NSError *error) {
        
    }];
    
}


#pragma mark - 充值说明
- (void)chargeDescribAction{
    
    SSH_WangYeViewController *secondWebViewVC = [[SSH_WangYeViewController alloc] init];
    secondWebViewVC.webUrl = [NSString stringWithFormat:@"http://%@/czexplain.html",[DENGFANGSingletonTime shareInstance].lianJieArr[1]];
    secondWebViewVC.titleString = @"充值说明";
    [self.navigationController pushViewController:secondWebViewVC animated:YES];
}

#pragma mark - 充值页面金额和充值方式的请求
- (void)loadChargePageData{
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGPaymentMethodListURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil]} success:^(id responseObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"loadChargePageData--%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            for (NSDictionary *dic1 in diction[@"tydPayDiscount"]) {
                SSH_ChongZhiJinEModel *model = [[SSH_ChongZhiJinEModel alloc] init];
                [model setValuesForKeysWithDictionary:dic1];
                [self.moneyDataArray addObject:model];
            }
            for (NSDictionary *dic2 in diction[@"tydPaymentMethod"]) {
                SSH_ChongZhiFangShiModel *model = [[SSH_ChongZhiFangShiModel alloc] init];
                [model setValuesForKeysWithDictionary:dic2];
                [self.methodDataArray addObject:model];
            }
            
            [self.myTableView reloadData];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark 选择充值金额 tag 从200开始
-(void)moneyViewTapClicked:(UITapGestureRecognizer *)tap{
    for (SSH_ChargeDingBuView * sView in self.allView) {
        sView.bgImgView.image = [UIImage imageNamed:@"chongzhi_no"];
        sView.jinbiLabel.textColor = ColorBlack222;
        sView.moneyLabel.textColor = GrayColor666;
    }
    
    SSH_ChargeDingBuView * selView = (SSH_ChargeDingBuView *)self.allView[tap.view.tag-200];
    selView.bgImgView.image = [UIImage imageNamed:@"chongzhi_sel"];
    selView.jinbiLabel.textColor = COLORWHITE;
    selView.moneyLabel.textColor = COLORWHITE;
    self.moneyModel = self.moneyDataArray[tap.view.tag-200];
    self.rechargeId = [NSString stringWithFormat:@"%@",self.moneyModel.rechargeId];
    self.zhifuJine = [NSString stringWithFormat:@"%@",self.moneyModel.relMoney];
}
#pragma mark 选择充值方式按钮
-(void)chongZhiRightBtnClicked:(UIButton *)btn{
    for (UIButton * sBtn in self.btnArr) {
        sBtn.selected = NO;
    }
    btn.selected = YES;
    self.payType = (int)btn.tag-555;
    
    
}
#pragma mark 最下面的充值按钮：数据请求获取充值订单号
-(void)chongBtnClicked{
    [MobClick event:@"my-account-recharge-recharge"];
    if (self.payType== 1) {
        [MobClick event:@"my-account-recharge-recha"];
        NSString *userString = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
        [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGInsertPayRecordURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:userString],@"rechargeId":self.rechargeId} success:^(id responsObject) {
            NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",diction);
            self.orderNoString = diction[@"orderNo"];
            
            [self getAliPayQianMing];
            
        } fail:^(NSError *error) {
            
        }];
    }else if (self.payType == 2){
        if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
            [MBProgressHUD showError:@"您未安装微信"];
            return;
        }
        
        [MobClick event:@"my-account-recharge-recha"];
        NSString *userString = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
        [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGInsertPayRecordURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:userString],@"rechargeId":self.rechargeId} success:^(id responsObject) {
            NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",diction);
            self.orderNoString = diction[@"orderNo"];
            
            [self getWeChatPayAction];
            
        } fail:^(NSError *error) {
            
        }];
    }
    
}
//微信支付
#pragma mark - 微信支付时从后台请求所需签名
- (void)getWeChatPayAction{
    if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [MBProgressHUD showError:@"您未安装微信"];
        return;
    } else {
        NSString *sings = [NSString stringWithFormat:@"%@%@",[DENGFANGSingletonTime shareInstance].mobileString,self.rechargeId];
        [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGWeiXinPayURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:sings],@"mobile":[DENGFANGSingletonTime shareInstance].mobileString,@"rechargeId":self.rechargeId,@"flag":@"1"} success:^(id responsObject) {
            NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",diction);
            NSString *timeSting= [NSString stringWithFormat:@"%@",diction[@"data"][@"timestamp"]];
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = diction[@"data"][@"partnerid"];
            request.prepayId= diction[@"data"][@"prepayid"];
            request.package = diction[@"data"][@"package"];
            request.nonceStr= diction[@"data"][@"noncestr"];
            request.timeStamp = timeSting.intValue;
            request.sign= diction[@"data"][@"sign"];
            [WXApi sendReq:request];
        } fail:^(NSError *error) {
            
        }];
    }
}



#pragma mark - 支付宝支付
- (void)getAliPayQianMing{
    
    NSString *bodyString = [NSString stringWithFormat:@"%d,%@",[DENGFANGSingletonTime shareInstance].useridString,[DENGFANGSingletonTime shareInstance].mobileString];
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGGetAliPayValidCodeURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:self.orderNoString],@"out_trade_no":self.orderNoString,@"subject":@"充值金币",@"total_fee":self.zhifuJine,@"body":bodyString,@"rechargeId":self.rechargeId} success:^(id responseObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        [[AlipaySDK defaultService] payOrder:diction[@"data"][@"body"] fromScheme:@"taoyoudan" callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            [DENGFANGSingletonTime shareInstance].aliResultStatus = [resultDic[@"resultStatus"] intValue];
            NSLog(@"%d",[resultDic[@"resultStatus"] intValue]);
            NSLog(@"%d",[DENGFANGSingletonTime shareInstance].aliResultStatus);
            [[NSNotificationCenter defaultCenter] postNotificationName:DENGFANGPayFinishName object:nil];
        }];
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - tableView里的方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return self.methodDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SSH_ChongZhiLieBiaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chongzhiCell"];
    if (!cell) {
        cell = [[SSH_ChongZhiLieBiaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chongzhiCell"];
    }
    
    if (indexPath.section == 1) {
        SSH_ChongZhiFangShiModel *model = self.methodDataArray[indexPath.row];
        if (model.payType == 1) {
            cell.leftImgView.image = [UIImage imageNamed:@"chongzhi_zhifubao"];
        }else if (model.payType == 2){
            cell.leftImgView.image = [UIImage imageNamed:@"chongzhi_weixin"];
        }
        cell.cellTitle.text = model.paymentName;
        
        if (indexPath.row == 0) {
            cell.rightBtn.selected = YES;
            self.payType = model.payType;
        }
        cell.delegate = self;
        [cell setChildBtnTag:555+model.payType];
        [self.btnArr addObject:cell.rightBtn];
    }
   
    cell.selectionStyle = 0;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]init];
    footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.1f);
    footView.backgroundColor = ColorBackground_Line;
    if (section == 1) {
        footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 65);

       UIButton * chongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [footView addSubview:chongBtn];
        chongBtn.layer.cornerRadius = 20;
        chongBtn.clipsToBounds = YES;
        chongBtn.titleLabel.font = UIFONTTOOL15;
        [chongBtn setTitleColor:COLORWHITE forState:UIControlStateNormal];
        [chongBtn setTitle:@"去充值" forState:UIControlStateNormal];
        [chongBtn setBackgroundColor:ColorZhuTiHongSe];
        [chongBtn addTarget:self action:@selector(chongBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [chongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(25);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(40);
        }];
    }
    return footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 65;
    }
    return 0.1f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc]init];
    headerView.backgroundColor = ColorBackground_Line;
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 52);

    UIView * titleBgView = [[UIView alloc]init];
    titleBgView.frame = CGRectMake(0, 8, SCREEN_WIDTH, 44);
    titleBgView.backgroundColor = COLORWHITE;
    [headerView addSubview:titleBgView];
    [titleBgView borderForColor:ColorBackground_Line borderWidth:0.5f borderType:UIBorderSideTypeBottom];
    
    //文字
    UILabel *headerLabel = [[UILabel alloc]init];
    [titleBgView addSubview:headerLabel];
    headerLabel.text = @"选择充值金额";
    headerLabel.textColor = ColorBlack222;
    headerLabel.font = UIFONTTOOL13;
    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    
    
    
    
    if(section == 0){
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH*174/375)*97/174*2+10*2+3+52); //272
        headerLabel.text = @"选择充值金额";
        
        UIView * bigView = [[UIView alloc]init];
        bigView.backgroundColor = COLORWHITE;
        [headerView addSubview:bigView];
        [bigView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleBgView.mas_bottom).offset(0);
            make.left.right.bottom.mas_equalTo(0);
        }];
        
        [self.allView removeAllObjects];
        for (int i = 0; i < 4; i++) {
            SSH_ChargeDingBuView * baseView = [[SSH_ChargeDingBuView alloc]init];
            if (i < 2) {
                baseView.frame = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH*174/375*2-7)/2+7*i+SCREEN_WIDTH*174/375*i, 10, SCREEN_WIDTH*174/375, (SCREEN_WIDTH*174/375)*97/174);

            }else{
                baseView.frame = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH*174/375*2-7)/2+7*(i-2)+SCREEN_WIDTH*174/375*(i-2), 10+(SCREEN_WIDTH*174/375)*97/174+3, SCREEN_WIDTH*174/375, (SCREEN_WIDTH*174/375)*97/174);
                
            }
            [bigView addSubview:baseView];
            
            baseView.tag = 200+i;
            baseView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moneyViewTapClicked:)];
            [baseView addGestureRecognizer:tapGes];
            
            
            [self.allView addObject:baseView];
        }
        self.firstView = self.allView[0];
        self.secondView = self.allView[1];
        self.thressView = self.allView[2];
        self.fourView = self.allView[3];
    
        

        if (self.moneyDataArray.count <= self.allView.count) {
            
            int i = 0;
            for (SSH_ChargeDingBuView * sView in self.allView) {
                if (i >= self.moneyDataArray.count) {
                } else {
                    SSH_ChongZhiJinEModel *model = self.moneyDataArray[i];
                    if (self.chongzhiYouliSelectID == nil) {
                        
                        self.secondView.bgImgView.image = [UIImage imageNamed:@"chongzhi_sel"];
                        self.secondView.jinbiLabel.textColor = COLORWHITE;
                        self.secondView.moneyLabel.textColor = COLORWHITE;
                        
                        if (i==1) {
                            self.rechargeId = [NSString stringWithFormat:@"%@",model.rechargeId];
                            self.moneyModel = model;
                            self.zhifuJine = [NSString stringWithFormat:@"%@",model.relMoney];
                        }
                    }else{
                        if ([self.chongzhiYouliSelectID isEqualToString: [NSString stringWithFormat:@"%@",model.rechargeId]]) {
                            
                            sView.bgImgView.image = [UIImage imageNamed:@"chongzhi_sel"];
                            sView.jinbiLabel.textColor = COLORWHITE;
                            sView.moneyLabel.textColor = COLORWHITE;
                            
                            self.rechargeId = [NSString stringWithFormat:@"%@",model.rechargeId];
                            self.moneyModel = model;
                            self.zhifuJine = [NSString stringWithFormat:@"%@",model.relMoney];
                        }
                    }
                    
                    i++;
                    sView.jinbiLabel.text = [NSString stringWithFormat:@"%@ 金币",model.coin];
                    sView.moneyLabel.text = [NSString stringWithFormat:@"售价 %@ 元",model.relMoney];
                    NSString *disString = [NSString stringWithFormat:@"%@",model.discount];
                    if ([disString isEqualToString:@"0"] || model.discount == nil) {
                        sView.songImgView.hidden = YES;
                    }else{
                        sView.songLabel.text = model.labelExplain;
                    }
                }
            }
            
        }
        
    }else if (section == 1){
       
        headerLabel.text = @"选择充值方式";
      
    }
    
   
    
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return (SCREEN_WIDTH*174/375)*97/174*2+10*2+3+52; //272
    }
    return 52;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55.5;
}

- (void)configAttributeString:(NSString *)configString rangeString:(NSString *)rangeString withLabel:(UILabel *)label{
    
    NSString *jineString = configString;
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] initWithString:jineString];
    NSRange range = [jineString rangeOfString:rangeString];
    [mutableAttString addAttributes:@{NSFontAttributeName:UIFONTTOOL20,NSForegroundColorAttributeName:label.textColor} range:range];
    [mutableAttString beginEditing];
    label.attributedText = mutableAttString;
}

#pragma mark - tableView懒加载初始化
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
