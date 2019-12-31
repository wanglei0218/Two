//
//  SSH_ZhifuXiangQingViewController.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/11.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ZhifuXiangQingViewController.h"
#import "SSH_ZhiFuXiangQingTableViewCell.h"//左文字右文字cell
#import "SSH_ChargeActionViewController.h" //充值界面
#import "SSH_ZhiFuXiangQingModel.h"//支付详情model
#import "SSH_GRBsafeKeyBoard.h"//输入密码的键盘
#import "SSH_IDYanZhengViewController.h"//身份验证
#import "SSH_ZhiFuStyleButton.h"//支付方式View
#import "SSH_GeRenXinXiModel.h"

@interface SSH_ZhifuXiangQingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *jinBiNumberLabel;//金币数
@property (nonatomic, strong) UILabel *accountAllJinBiNumLabel;//账户所剩的金币数
@property (nonatomic, strong) NSArray *leftTitleArray;//列表左侧标题的数组
@property (nonatomic, strong) NSMutableArray *rightTitleArray;
@property (nonatomic, strong) UITableView *zfxqTableView;
@property (nonatomic,assign) NSInteger timeStamp;

@property (nonatomic,strong) UIView *topTimeView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) SSH_GRBkeyTextField * safeInputTextField;
@property(nonatomic,strong) SSH_GRBsafeKeyBoard * board;

@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) UILabel *rightNameLabel;
@property (nonatomic, strong) UILabel *suoXuNameLabel;//所需支付金币数-标题
@property (nonatomic, strong) UIButton *goChongZhiButton;

@property (nonatomic, strong) NSMutableAttributedString *suosheng_jinbi_String;
@property (nonatomic, strong) NSMutableAttributedString *suosheng_youbi_String;
@property (nonatomic, assign) int payStyle;//支付方式：0:金币支付，1:优币支付
@property (nonatomic, assign) int viewAppearNum;//页面出现的次数
@property (nonatomic, strong) NSString *needPayNumStr;

@end

@implementation SSH_ZhifuXiangQingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.viewAppearNum++;
    if (self.viewAppearNum >1) {
        [self getDENGFANGUserInfoData];
    }
}

#pragma mark 获取用户信息
-(void)getDENGFANGUserInfoData{
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]};
    
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGUserInfoURL parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"userInfo %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            SSH_GeRenXinXiModel *infoModel = [[SSH_GeRenXinXiModel alloc]init];
            [infoModel setValuesForKeysWithDictionary:diction[@"data"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *shengyuCoinString;
                if ([self.needPayNumStr intValue]>[infoModel.coinNum intValue]) {
                    shengyuCoinString = [NSString stringWithFormat:@"%@金币(金币不足)",infoModel.coinNum];
                    
                }else{
                    shengyuCoinString = [NSString stringWithFormat:@"%@金币",infoModel.coinNum];
                }
                NSMutableAttributedString *shengyuCoinAttString = [self configAttributeString:shengyuCoinString rangeString:@"(金币不足)"];
                
//                NSString *shengyu_UCoin_String;
//                if ([self.needPayNumStr intValue]>[infoModel.uCoinNum intValue]) {
//                    shengyu_UCoin_String = [NSString stringWithFormat:@"%@优币(优币不足)",infoModel.uCoinNum];
//
//                }else{
//                    shengyu_UCoin_String = [NSString stringWithFormat:@"%@优币",infoModel.uCoinNum];
//                }
//                NSMutableAttributedString *shengyu_UCoin_AttString = [self configAttributeString:shengyu_UCoin_String rangeString:@"(优币不足)"];
                
                
                self.suosheng_jinbi_String = shengyuCoinAttString;
//                self.suosheng_youbi_String = shengyu_UCoin_AttString;
                
                UILabel *suoshengLabel = [self.view viewWithTag:4980];
                
                if (self.payStyle == 0) {
//                    self.suoXuNameLabel.text = @"所需支付金币数";
//                    self.goChongZhiButton.hidden = NO;
                    suoshengLabel.attributedText = self.suosheng_jinbi_String;
                }else{
//                    self.suoXuNameLabel.text = @"所需支付优币数";
//                    self.goChongZhiButton.hidden = YES;
                    suoshengLabel.attributedText = self.suosheng_youbi_String;
                }
            });
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadPayDetailData];
    self.titleLabelNavi.text= @"支付详情";
    self.normalBackView.backgroundColor = ColorBackground_Line;
    NSString *jineString = [NSString stringWithFormat:@"%@金额:",[DENGFANGSingletonTime shareInstance].name[0]];
    NSString *qiXianString = [NSString stringWithFormat:@"%@期限:",[DENGFANGSingletonTime shareInstance].name[0]];
    self.leftTitleArray = @[@[@"账户所剩:"],@[@"客      户:",jineString,qiXianString,@"申请时间:"],@[@"支付方式:"]];
    self.rightTitleArray = @[@[@""],@[@"",@"",@"1",@""],@[@""]].mutableCopy;
//    [self setupCountDownView];
    [self setupZhiFuDetailView];
    
}

#pragma mark -倒计时页面
-  (void)setupCountDownView {
    self.topTimeView = [[UIView alloc] init];
    self.topTimeView.backgroundColor = ColorFdd9da;
    [self.view addSubview:self.topTimeView];
    [self.topTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(getRectNavAndStatusHight);
        make.left.right.offset(0);
        make.height.mas_equalTo(25);
    }];
    
    //时间标签
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = ColorE63c3f;
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self.topTimeView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.topTimeView);
    }];
    
}
-(void)timeDown {
    if (self.timeStamp > 0) {
        self.timeStamp--;
        // 重新计算 时/分/秒
        NSString *str_minute = [NSString stringWithFormat:@"%02ld", (self.timeStamp % 3600) / 60];
        NSString *str_second = [NSString stringWithFormat:@"%02ld", self.timeStamp % 60];
        
        NSString *timeString = [NSString stringWithFormat:@"支付倒计时 %@:%@",str_minute,str_second];
        
        self.timeLabel.text = timeString;
    }else {
        [self.timer invalidate];
        self.timeLabel.text = @"支付超时!";
        self.topTimeView.backgroundColor = ColorF9f3dd;
        self.timeLabel.textColor = GrayColor666;
        return;
        
    }
}

- (NSMutableAttributedString *)configAttributeString:(NSString *)configString rangeString:(NSString *)rangeString {
    
    NSString *jineString = configString;
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] initWithString:jineString];
    NSRange range = [jineString rangeOfString:rangeString];
    [mutableAttString addAttributes:@{NSFontAttributeName:UIFONTTOOL12,NSForegroundColorAttributeName:ColorZhuTiHongSe} range:range];
    [mutableAttString beginEditing];
    return mutableAttString;
//    label.attributedText = mutableAttString;
}

#pragma mark **数据请求**
- (void)loadPayDetailData{
    NSString *signsString = [NSString stringWithFormat:@"%d%@",[DENGFANGSingletonTime shareInstance].useridString,self.orderNo];
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGPayDetailURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:signsString],@"orderNo":self.orderNo,@"userId":@([DENGFANGSingletonTime shareInstance].useridString)} success:^(id responsObject) {
    
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"zhifu_detail%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            SSH_ZhiFuXiangQingModel *model = [[SSH_ZhiFuXiangQingModel alloc] init];
            [model setValuesForKeysWithDictionary:diction[@"data"]];
            self.timeStamp = [model.expireDate integerValue]/1000;
            self.jinBiNumberLabel.text = [NSString stringWithFormat:@"%@",model.coin];
            self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeDown) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            self.needPayNumStr = model.coin;
            NSString *shengyuCoinString;
            if ([model.coin intValue]>[model.coinNum intValue]) {
                shengyuCoinString = [NSString stringWithFormat:@"%@金币(金币不足)",model.coinNum];

            }else{
                shengyuCoinString = [NSString stringWithFormat:@"%@金币",model.coinNum];
            }
            NSMutableAttributedString *shengyuCoinAttString = [self configAttributeString:shengyuCoinString rangeString:@"(金币不足)"];
            
//            NSString *shengyu_UCoin_String;
//            if ([model.coin intValue]>[model.uCoinNum intValue]) {
//                shengyu_UCoin_String = [NSString stringWithFormat:@"%@优币(优币不足)",model.uCoinNum];
//
//            }else{
//                shengyu_UCoin_String = [NSString stringWithFormat:@"%@优币",model.uCoinNum];
//            }
//            NSMutableAttributedString *shengyu_UCoin_AttString = [self configAttributeString:shengyu_UCoin_String rangeString:@"(优币不足)"];
            
            NSString * applyTimeString = [NSDate dateWithTimeInterval:[model.createTime integerValue]/1000 format:@"yyyy年MM月dd日 HH:mm"];
            
            NSString *loanMoneyStr;

            if([model.loanStartLimit intValue] >= 10000){
                if ([model.loanStartLimit intValue]%10000 == 0) {
                    loanMoneyStr = [NSString stringWithFormat:@"%d万",[model.loanStartLimit intValue]/10000];
                }else{
                    
                    int qian = [model.loanStartLimit intValue]/1000;
                    float wan = qian/10.0;
                    loanMoneyStr = [NSString stringWithFormat:@"%.1f万",wan];
                }
            }else{
                loanMoneyStr = [model.loanStartLimit intValue]?model.loanStartLimit:@"0";
            }
            
            NSString *loanTerm ;
            if ([model.loanTerm intValue] >=12 ) {
                if ([model.loanTerm intValue]%12 == 0) {
                    loanTerm = [NSString stringWithFormat:@"%d年",[model.loanTerm intValue]/12];
                }else{
                    loanTerm = [NSString stringWithFormat:@"%d年%d个月",[model.loanTerm intValue]/12,[model.loanTerm intValue]%12];
                }
            }else{
                loanTerm = [NSString stringWithFormat:@"%d个月",[model.loanTerm intValue]];
            }
            
            self.suosheng_jinbi_String = shengyuCoinAttString;
//            self.suosheng_youbi_String = shengyu_UCoin_AttString;
            
            self.rightTitleArray = @[@[shengyuCoinAttString],@[[NSString stringWithFormat:@"%@",model.name],loanMoneyStr,loanTerm,applyTimeString],@[@""]].mutableCopy;
            self.rightNameLabel.text = [NSString stringWithFormat:@"支付完成即可拨打电话：%@",model.mobile];
            [self.zfxqTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

//时间戳转字符串
- (NSString *)timeStampChangeToString:(NSInteger)timeStamp{
    NSDate *configDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *timeString = [formatter stringFromDate:configDate];
    return timeString;
}

#pragma mark 设置页面布局
- (void)setupZhiFuDetailView{
    
    self.zfxqTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.normalBackView addSubview:self.zfxqTableView];
    self.zfxqTableView.backgroundColor = [UIColor clearColor];
    self.zfxqTableView.delegate = self;
    self.zfxqTableView.dataSource = self;
    self.zfxqTableView.separatorStyle = 0;
    self.zfxqTableView.showsVerticalScrollIndicator = NO;
    
    
    if (IS_IPHONE5) {
        self.zfxqTableView.scrollEnabled = YES;
        [self.zfxqTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(40);
            make.bottom.mas_equalTo(-47);
        }];
    }else{
        self.zfxqTableView.scrollEnabled = NO;
        [self.zfxqTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(40);
            make.height.mas_equalTo(514.5);
        }];
    }
    
    self.zfxqTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zhifuxiangqingbeijing"]];
    
    self.rightNameLabel = [[UILabel alloc] init];
    self.rightNameLabel.textColor = COLOR_With_Hex(0x222222);
    self.rightNameLabel.font = UIFONTTOOL12;
    self.rightNameLabel.textAlignment = 1;
    [self.normalBackView addSubview:self.rightNameLabel];
    [self.rightNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(12);
        make.top.mas_equalTo(self.zfxqTableView.mas_bottom).offset(17.5);
    }];
    
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 53+22.5)];
    self.zfxqTableView.tableHeaderView = headView;
    
    //所需支付金币数-标题
    self.suoXuNameLabel = [[UILabel alloc] init];
    [headView addSubview:self.suoXuNameLabel];
    self.suoXuNameLabel.text = @"所需支付金币数";
    self.suoXuNameLabel.textColor = GrayColor666;
    self.suoXuNameLabel.font = UIFONTTOOL13;
    [self.suoXuNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17.5);
        make.top.mas_equalTo(22.5);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(13);
    }];
    
    //去充值按钮
    self.goChongZhiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView addSubview:self.goChongZhiButton];
    self.goChongZhiButton.backgroundColor = ColorZhuTiHongSe;
    [self.goChongZhiButton setTitle:@"去充值" forState:UIControlStateNormal];
    self.goChongZhiButton.titleLabel.font = UIFONTTOOL12;
    self.goChongZhiButton.layer.masksToBounds = YES;
    self.goChongZhiButton.layer.cornerRadius = 12;
    [self.goChongZhiButton addTarget:self action:@selector(goToChongZhiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.goChongZhiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-17.5);
        make.centerY.mas_equalTo(headView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(24);
    }];
    
    //所需金币数
    self.jinBiNumberLabel = [[UILabel alloc] init];
    [headView addSubview:self.jinBiNumberLabel];
    self.jinBiNumberLabel.font = UIFONTTOOL(36);
    self.jinBiNumberLabel.textColor = ColorZhuTiHongSe;
    [self.jinBiNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17.5);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(28);
    }];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-64, 183)];
    self.zfxqTableView.tableFooterView = footerView;
    
    SSH_ZhiFuStyleButton *jinbizhifu = [[SSH_ZhiFuStyleButton alloc] init];
    [footerView addSubview:jinbizhifu];
    [jinbizhifu addTarget:self action:@selector(selectPayStyle:) forControlEvents:UIControlEventTouchUpInside];
    jinbizhifu.tag = 3000;
    jinbizhifu.icon.image = [UIImage imageNamed:@"zhifufangshi_jinbi"];
    jinbizhifu.sytleLabel.text = @"金币支付";
    jinbizhifu.selectImgView.image = [UIImage imageNamed:@"zhifufangshi_xuanze"];
    [jinbizhifu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(55);
    }];
    
    SSH_ZhiFuStyleButton *youbizhifu = [[SSH_ZhiFuStyleButton alloc] init];
    [footerView addSubview:youbizhifu];
//    [youbizhifu addTarget:self action:@selector(selectPayStyle:) forControlEvents:UIControlEventTouchUpInside];
//    youbizhifu.tag = 3001;
//    youbizhifu.icon.image = [UIImage imageNamed:@"zhifufangshi_youbi"];
//    youbizhifu.sytleLabel.text = @"优币支付";
//    youbizhifu.selectImgView.image = [UIImage imageNamed:@"zhifufangshi_weixuanze"];
    youbizhifu.fengexian.hidden = YES;
    [youbizhifu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(jinbizhifu.mas_bottom);
        make.height.mas_equalTo(55);
    }];
    
    UIButton *surePayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:surePayButton];
    surePayButton.backgroundColor = ColorZhuTiHongSe;
    [surePayButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [surePayButton addTarget:self action:@selector(sureToPayAction) forControlEvents:UIControlEventTouchUpInside];
    surePayButton.titleLabel.font = UIFONTTOOL15;
    surePayButton.layer.masksToBounds = YES;
    surePayButton.layer.cornerRadius = 17.5;
    [surePayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(240);
        make.centerX.mas_equalTo(footerView);
        make.top.mas_equalTo(youbizhifu.mas_bottom).offset(12);
        make.height.mas_equalTo(35);
    }];
    
}

#pragma mark 支付方式选择事件
- (void)selectPayStyle:(SSH_ZhiFuStyleButton *)sender{
    for (int i =0; i < 2; i++) {
        SSH_ZhiFuStyleButton *button = [self.view viewWithTag:3000+i];
        button.selectImgView.image = [UIImage imageNamed:@"zhifufangshi_weixuanze"];
    }
    sender.selectImgView.image = [UIImage imageNamed:@"zhifufangshi_xuanze"];
    
    UILabel *suoshengLabel = [self.view viewWithTag:4980];
    if (sender.tag == 3000) {
        [MobClick event:@"detail-buy-jinbi"];
        self.payStyle = 0;
        self.suoXuNameLabel.text = @"所需支付金币数";
        self.goChongZhiButton.hidden = NO;
        suoshengLabel.attributedText = self.suosheng_jinbi_String;
    }else{
        [MobClick event:@"detail-buy-youbi"];
        self.payStyle = 0;
        self.payStyle = 1;
        self.suoXuNameLabel.text = @"所需支付金币数";
        self.goChongZhiButton.hidden = YES;
        suoshengLabel.attributedText = self.suosheng_youbi_String;
    }
    
    
//    [self.zfxqTableView reloadData];
    
}

#pragma mark 确认支付按钮事件
- (void)sureToPayAction{
    [MobClick event:@"detail-buy-nowpay"];
    NSString *isPayPwdString = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGIsPayPwd];
//    if ([isPayPwdString isEqualToString:@"0"]) {
//
//        [self shezhi_mima_action];
//    }else if ([isPayPwdString isEqualToString:@"1"]) {
    
//        [self payTo];
//    }
    [self sureToPayJinBiAction:@""];
}
#pragma mark - 设置密码提示弹窗
- (void)shezhi_mima_action{
    
    self.grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self.grayView];
    self.grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shezhi_mima_dismiss_action)];
    [self.grayView addGestureRecognizer:tapGesture];
    
    UIView *whiteView = [[UIView alloc] init];
    [self.grayView addSubview:whiteView];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 10;
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(270);
        make.height.mas_equalTo(130);
        make.centerX.centerY.mas_equalTo(self.grayView);
    }];
    
    UILabel *mima_alert_label = [[UILabel alloc] init];
    [whiteView addSubview:mima_alert_label];
    mima_alert_label.text = @"您还未设置支付密码\n请设置支付密码！";
    mima_alert_label.font = UIFONTTOOL15;
    mima_alert_label.textColor = ColorBlack333;
    mima_alert_label.textAlignment = 1;
    mima_alert_label.numberOfLines = 0;
    [mima_alert_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(25);
    }];
    
    UIButton *shezhi_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [whiteView addSubview:shezhi_button];
    [shezhi_button setTitle:@"设置密码" forState:UIControlStateNormal];
    shezhi_button.backgroundColor = ColorZhuTiHongSe;
    shezhi_button.layer.masksToBounds = YES;
    shezhi_button.layer.cornerRadius = 15;
    shezhi_button.titleLabel.font = UIFONTTOOL15;
    [shezhi_button addTarget:self action:@selector(shezhi_mima_button_action) forControlEvents:UIControlEventTouchUpInside];
    [shezhi_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(-17);
        make.centerX.mas_equalTo(whiteView);
    }];
    
    
}

- (void)shezhi_mima_button_action{
    [self shezhi_mima_dismiss_action];
    
    SSH_IDYanZhengViewController *yanzhengVC = [[SSH_IDYanZhengViewController alloc] init];
    [self.navigationController pushViewController:yanzhengVC animated:YES];
}

- (void)shezhi_mima_dismiss_action{
    [self.grayView removeFromSuperview];
}

-(void)payTo{
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.board = [SSH_GRBsafeKeyBoard GRB_showSafeInputKeyBoard];
    __weak typeof(self)WS = self;
    self.board.SSH_GRBsafeKeyFinish=^(NSString * passWord){
        if (passWord.length==6) {
            
//            [WS.board GRB_endKeyBoard];
//            [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
            [WS sureToPayJinBiAction:passWord];
        }
        
    };
    self.board.SSH_GRBsafeKeyClose=^{
        
        [WS.board GRB_endKeyBoard];
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    };
    
    self.board.SSH_GRBsafeKeyForgetPassWord=^{
        NSLog(@"点击忘记密码了");
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
        
        SSH_IDYanZhengViewController *yanzhengVC = [[SSH_IDYanZhengViewController alloc] init];
        [WS.navigationController pushViewController:yanzhengVC animated:YES];
    };
}

#pragma mark 支付数据接口
- (void)sureToPayJinBiAction:(NSString *)pwd{
    
//    versionType  支付新增参数  抢单支付终端（1：淘优单）
    NSString *signString = [NSString stringWithFormat:@"%d%@",[DENGFANGSingletonTime shareInstance].useridString,self.orderNo];
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGSurePayJinBiURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:signString],@"orderNo":self.orderNo,@"mobile":[DENGFANGSingletonTime shareInstance].mobileString,@"payPwd":[pwd yf_MD5String],@"payType":@(self.payStyle),@"versionType":@"1"} success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"支付成功"]];
            [self.board GRB_endKeyBoard];
            [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
            //支付成功
            NSString *orderNo = self.orderNo;
            NSDictionary *dict = @{
                                   @"orderNo":orderNo
                                   };
            NSNotification *notification =[NSNotification notificationWithName:RefreshDetailKey object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [SSH_TOOL_GongJuLei showAlter:[UIApplication sharedApplication].keyWindow WithMessage:@"支付成功！"];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
            
            [SSH_TOOL_GongJuLei showAlter:[UIApplication sharedApplication].keyWindow WithMessage:[NSString stringWithFormat:@"%@",diction[@"msg"]]];
            
            
        }
        
    } fail:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 22;
    }else{
        return 46;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat tHeight;
    if (section == 0) {
        tHeight = 1;
    }else if (section == 1) {
        tHeight = 22;
    }else{
        tHeight = 46;
    }
    UIView *sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-64, tHeight)];
    return sectionHeadView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 4;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }else if (indexPath.section == 1) {
        return 30;
    }else{
//        return 56;
        return 12;
    }
}

#pragma mark cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = @"zfxqTableViewCell";
    SSH_ZhiFuXiangQingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[SSH_ZhiFuXiangQingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.leftTitleLabel.text = self.leftTitleArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.rightNameLabel.tag = 4980;
        if ([self.rightTitleArray[0][0] isKindOfClass:[NSString class]]) {
            
        }else{
            cell.rightNameLabel.attributedText = self.rightTitleArray[0][0];
        }
        
    }else{
        cell.rightNameLabel.text = [NSString stringWithFormat:@"%@",self.rightTitleArray[indexPath.section][indexPath.row]];
    }
    
    
    cell.selectionStyle = 0;
    return cell;
}

//去充值按钮点击事件
- (void)goToChongZhiAction{
    SSH_ChargeActionViewController * chongzhiVC = [[SSH_ChargeActionViewController alloc]init];
    chongzhiVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chongzhiVC animated:YES];
}

- (void)dealloc {
    [self.timer invalidate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
