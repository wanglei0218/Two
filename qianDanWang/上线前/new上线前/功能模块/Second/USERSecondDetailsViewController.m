//
//  USERSecondDetailsViewController.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/18.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERSecondDetailsViewController.h"
#import "USERModel.h"
#import "USERHomeModel.h"
#import "USERHomeDataHandel.h"
#import "USERTouSuModel.h"
#import "DENGFANGRequest.h"
#import "SSH_ZFCGViewController.h"
#import "DENGFANGEncryptToolClass.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface USERSecondDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *bgImg;
@property (strong, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *yaoqiuLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) IBOutlet UILabel *adressLabel;
@property (strong, nonatomic) IBOutlet UIButton *bangmang;
@property (strong, nonatomic) IBOutlet UIButton *JieDanBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSString *telPhone;


@property (nonatomic, strong) NSString *orderNoString;//订单号
@property (nonatomic, strong) NSString *rechargeId;
@property (nonatomic, strong) NSString *zhifuJine;//支付金额

@end

@implementation USERSecondDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bgImg.sd_layout.topSpaceToView(self.view, -getStatusHeight);
    if (self.qufenTag == 2) {
        self.rootRightBtn.hidden = YES;
    }else{
        self.rootRightBtn.hidden = NO;
    }
    self.rootRightBtn.sd_layout.widthIs(WidthScale(55));
    [self.rootRightBtn setTitle:@"投诉" forState:UIControlStateNormal];
    [self.rootRightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rootRightBtn setTitleColor:TEXTREDCOLOR forState:UIControlStateNormal];
    
    if (self.qufenTag == 0) {
        self.JieDanBtn.hidden = YES;
    }else if(self.qufenTag == 1){
        self.JieDanBtn.hidden = NO;
    }else if(self.qufenTag == 2){
        self.JieDanBtn.hidden = NO;
        [self.bangmang setTitle:@"完成订单" forState:UIControlStateNormal];
        [self.JieDanBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        self.titleLabel.text = @"等待接单";
    }else{
        self.JieDanBtn.hidden = YES;
        self.bangmang.hidden = YES;
    }
    
    
    NSArray *array = @[
                       @{
                           @"ID":@"100",
                           @"sataus":@"1",
                           @"name":@"王先生",
                           @"elseName":@"李女士",
                           @"elsePhone":@"17673117963",
                           @"title":@"顺路",
                           @"subTle":@"广告推广",
                           @"phoneNum":@"13263437981",
                           @"price":@"¥0",
                           @"time":@"2019-10-13",
                           @"address":@"北京市海淀区上地信息路38号上地数码大厦B座"
                           },
                       @{
                           @"ID":@"101",
                           @"sataus":@"1",
                           @"name":@"高先生",
                           @"elseName":@"李女士",
                           @"elsePhone":@"18612310682",
                           @"title":@"家务",
                           @"subTle":@"打扫卫生清理死角除虫",
                           @"phoneNum":@"13501094932",
                           @"price":@"¥150",
                           @"time":@"2019-10-14",
                           @"address":@"北京市丰台区王佐镇鑫湖家园B区33东北方向171米"
                           },
                       @{
                           @"ID":@"102",
                           @"sataus":@"1",
                           @"name":@"宋先生",
                           @"elseName":@"李女士",
                           @"elsePhone":@"18612245623",
                           @"title":@"顺路",
                           @"subTle":@"带东西去朋友家",
                           @"phoneNum":@"13501094932",
                           @"price":@"¥20",
                           @"time":@"2019-06-08",
                           @"address":@"河北省廊坊市霸州市蓝天艺术幼儿园西150米"
                           },
                       @{
                           @"ID":@"103",
                           @"sataus":@"1",
                           @"name":@"杨先生",
                           @"elseName":@"李女士",
                           @"elsePhone":@"15663237401",
                           @"title":@"搬家",
                           @"subTle":@"搬运家具",
                           @"phoneNum":@"18830984328",
                           @"price":@"¥120",
                           @"time":@"2019-06-12",
                           @"address":@"北京市海淀区双清路30号清华大学内招揽园北京银行东南侧"
                           },
                       @{
                           @"ID":@"104",
                           @"sataus":@"1",
                           @"name":@"孟先生",
                           @"elseName":@"杨先生",
                           @"elsePhone":@"15933283425",
                           @"title":@"搬家",
                           @"subTle":@"搬运家具",
                           @"phoneNum":@"13263425254",
                           @"price":@"¥60",
                           @"time":@"2019-06-15",
                           @"address":@"北京市海淀区青龙桥街道办事处斜对面"
                           }
                       ];
    
    if (self.qufenTag == 0) {
        self.dataArray = [[USERHomeDataHandel sharedHomeDataHandel] getAllDatas];
    }else if(self.qufenTag == 1){
        self.dataArray = [USERModel creatModelWithArray:array];
    }else{
        self.dataArray = [[USERDataHandle sharedDataHandle] getAllDatas];
    }
    
    for (int i=0; i<self.dataArray.count; i++) {
        if (self.qufenTag == 0) {
            USERHomeModel *model = self.dataArray[i];
            if (model.goodsId == self.goodsId) {
                self.timeLabel.text = model.shijian;
                self.typeLabel.text = model.wupingming;
                self.priceLabel.text = @"¥0";
                self.yaoqiuLabel.text = model.tedian;
                self.nameLabel.text = @"";
                self.phoneLabel.text = model.lianxifangshi;
                self.adressLabel.text = model.didian;
                self.telPhone = model.lianxifangshi;
            }
        }else{
            USERModel *model = self.dataArray[i];
            if (model.ID == self.goodsId) {
                self.timeLabel.text = model.time;
                self.typeLabel.text = model.title;
                self.priceLabel.text = model.price;
                self.yaoqiuLabel.text = model.subTle;
                self.nameLabel.text = model.name;
                self.phoneLabel.text = model.phoneNum;
                self.adressLabel.text = model.address;
                self.telPhone = model.phoneNum;
            }
        }
    }
    
}

- (IBAction)HelpBtnClick:(UIButton *)sender {
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:TOKEN];
    if (token.length == 0) {
        [self myLoginAction];
        return;
    }
    
    if (self.qufenTag == 2) {
        
        NSString *stringOne = [self.priceLabel.text substringFromIndex:1];
        if ([stringOne integerValue] == 0) {
            
            [self jumpToSuccessPage];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择支付赏金的方式！" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertAction *kefuAction = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self chongBtnClicked:1];
                
            }];
            UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self chongBtnClicked:2];
            }];
            [alertC addAction:cancelAction];
            [alertC addAction:kefuAction];
            [alertC addAction:enterAction];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }else{
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请确认您掌握能够帮助对方的信息或证据！" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *kefuAction = [UIAlertAction actionWithTitle:@"联系他（她）" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",self.telPhone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        
//        UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"确定投诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            [self.view showMBProgressHUDDelay];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.view hideMBProgressHUDDelay];
//                [SVProgressHUD showSuccessWithStatus:@"我们已将您投诉的内容提交"];
//
//                for (int i=0; i<self.dataArray.count; i++) {
//                    if (self.qufenTag == 0) {
//                        USERHomeModel *model = self.dataArray[i];
//                        if (model.goodsId == self.goodsId) {
//                            [[USERTouSuModel sharedHomeDataHandel] addOneData:model];
//                        }
//                    }
//                }
//
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//
//        }];
        [alertC addAction:cancelAction];
        [alertC addAction:kefuAction];
//        [alertC addAction:enterAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

#pragma mark 最下面的充值按钮：数据请求获取充值订单号
-(void)chongBtnClicked:(NSInteger)type{
    
    NSString *userString = @"2198";
    self.rechargeId = @"6";
    self.zhifuJine = [NSString stringWithFormat:@"%@",[self.priceLabel.text substringFromIndex:1]];
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGInsertPayRecordURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:userString],@"rechargeId":self.rechargeId} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        self.orderNoString = diction[@"orderNo"];
        if (self.orderNoString == nil) {
            [self.view showMBHudWithMessage:diction[@"msg"] hide:2.0];
        } else {
            if (type == 1) {
                [self getAliPayQianMing];
            }else if (type == 2){
                [self getWeChatPayAction];
            }
        }
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark - 支付宝支付
- (void)getAliPayQianMing{
    
    NSString *bodyString = [NSString stringWithFormat:@"%@,%@",@(2198),@"15210992338"];
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
        
        if ([DENGFANGSingletonTime shareInstance].aliResultStatus == 9000) {
            
            [self updatePayResultSuccess:1];
            [self jumpToSuccessPage];
        }else{
            [self updatePayResultSuccess:0];
        }
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    
}

//微信支付
#pragma mark - 微信支付时从后台请求所需签名
- (void)getWeChatPayAction{
    if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [MBProgressHUD showError:@"您未安装微信"];
        return;
    }
    NSString *sings = [NSString stringWithFormat:@"%@%@",[DENGFANGSingletonTime shareInstance].mobileString,self.rechargeId];
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGWeiXinPayURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:sings],@"mobile":[DENGFANGSingletonTime shareInstance].mobileString,@"rechargeId":self.rechargeId,@"flag":@"1"} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"10003"]) {
            [self.view showMBHudWithMessage:diction[@"msg"] hide:2.0];
        } else {
            NSString *timeSting= [NSString stringWithFormat:@"%@",diction[@"data"][@"timestamp"]];
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = diction[@"data"][@"partnerid"];
            request.prepayId= diction[@"data"][@"prepayid"];
            request.package = diction[@"data"][@"package"];
            request.nonceStr= diction[@"data"][@"noncestr"];
            request.timeStamp = timeSting.intValue;
            request.sign= diction[@"data"][@"sign"];
            [WXApi sendReq:request];
            if ([DENGFANGSingletonTime shareInstance].wxRetCode == 0) {
                [self jumpToSuccessPage];
            }
            [self updateWeChatPayResult];
        }
    } fail:^(NSError *error) {
        
    }];
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
    [self.view showMBHudWithMessage:@"订单结算成功！" hide:2.0];
    
    [[USERDataHandle sharedDataHandle] deleteDataByID:[[NSString stringWithFormat:@"%ld",self.goodsId] intValue]];
}

#pragma mark - 微信支付后返回后台的数据请求
- (void)updateWeChatPayResult{
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGWeiXinPayStatusUpdateURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:self.orderNoString],@"orderNo":self.orderNoString,@"payStatus":@([DENGFANGSingletonTime shareInstance].wxRetCode)} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
    } fail:^(NSError *error) {
        
    }];
    
}


- (IBAction)jiedan:(UIButton *)sender {
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:TOKEN];
    if (token.length == 0) {
        [self myLoginAction];
        return;
    }
    
    if (self.qufenTag == 1) {
        [SVProgressHUD showSuccessWithStatus:@"还望能待上线后操作，助人亦是美德哦！"];
    }else if(self.qufenTag == 2){
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确认取消订单" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        
        UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[USERDataHandle sharedDataHandle] deleteDataByID:[[NSString stringWithFormat:@"%ld",(long)self.goodsId]intValue] ];
                [SVProgressHUD showSuccessWithStatus:@"订单取消成功"];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        [alertC addAction:cancelAction];
        [alertC addAction:enterAction];
        [self presentViewController:alertC animated:YES completion:nil];
        
    }
}

//举报按钮
- (void)rightBtnClick:(UIButton *)sender{
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:TOKEN];
    if (token.length == 0) {
        [self myLoginAction];
        return;
    }
    
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"投诉后此订单将被标记，且不可取消标记，可在黑名单中查看投诉的订单，您确认投诉此订单？" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *kefuAction = [UIAlertAction actionWithTitle:@"联系客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",@"15537687767"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    
    UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"确定投诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.view showMBProgressHUDDelay];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view hideMBProgressHUDDelay];
            [SVProgressHUD showSuccessWithStatus:@"我们已将您投诉的内容提交"];
            
            for (int i=0; i<self.dataArray.count; i++) {
                if (self.qufenTag == 0) {
                    USERHomeModel *model = self.dataArray[i];
                    if (model.goodsId == self.goodsId) {
                        [[USERTouSuModel sharedHomeDataHandel] addOneData:model];
                    }
                }
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }];
    [alertC addAction:cancelAction];
    [alertC addAction:kefuAction];
    [alertC addAction:enterAction];
    [self presentViewController:alertC animated:YES completion:nil];
    
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
