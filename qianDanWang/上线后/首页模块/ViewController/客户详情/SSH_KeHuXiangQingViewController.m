//
//  DENGFANGProductDetailViewController.m
//  DENGFANGSC
//
//  Created by 锦鳞附体^_^ on 2018/11/27.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_KeHuXiangQingViewController.h"
#import "SSH_ProductDetailTableViewCell.h"
#import "SSH_JingChaHFiveViewController.h"//警察点击跳转页面

#import "SSH_HomeCreditxinxiListModel.h"
#import "SSH_ShouyeChanpingXiangQingModel.h"

#import "SSH_YanZhengMaDengLuController.h"
#import "SSH_ShenFenRenZhengZhuController.h"//用户认证
#import "SSH_ShenFenZhengRenZhengViewController.h" //新用户认证
#import "SSH_ZhifuXiangQingViewController.h"
#import "SSH_DiJiaTaoListCell.h"
#import "SSH_ProductDetailBuChongCell.h" //补充信息
#import "SSH_ChargeActionViewController.h" //充值
#import "SSH_TuiDanViewController.h"
#import "SSH_New_RZViewController.h"

#import "SSH_TuiDan_Cell.h"//退单的cell"

static NSString *tuiDanCell = @"SSH_TuiDan_Cell";
@interface SSH_KeHuXiangQingViewController ()<UITableViewDelegate,UITableViewDataSource,SSH_HomeQiangDanTableViewCellDelegate>

@property (nonatomic,strong) UITableView *detailTableView;

@property (nonatomic,strong) NSMutableArray *resultArray;

@property (nonatomic, strong) SSH_HomeCreditxinxiListModel * topCellModel;

@property (nonatomic, strong) SSH_ShouyeChanpingXiangQingModel * detailModel;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *phoneView;//打电话背景
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *phoneBtn;
@property (nonatomic, strong) UIView *bottomView;//底部背景
@property (nonatomic, strong) UILabel *moneyLabel;//底部上的钱数

@property (nonatomic, strong) UILabel *markLabel;//顶部最上面的提示信息

@property (nonatomic,strong)UIButton *qiangButton;//抢单按钮
@property (nonatomic,strong)UIImageView * moneyImg;//底部金币图片

@property (nonatomic,strong)UIButton * collectionBtn;//收藏btn
@property (nonatomic, strong) NSString *isCollection;//0:未收藏，1:已收藏

@property (nonatomic,strong) NSMutableArray *allCellArray;  //所有的cell标题数组
@property (nonatomic,strong) UIButton *alertButton; //收藏提示按钮
//@property (nonatomic, strong) UIView *redAlertView;//红色提示框
@property(nonatomic,assign)CGFloat buChongCellH; //补充cell的高
@property(nonatomic,strong)NSArray *buChongArr; //补充cell里的label


@property (nonatomic,strong)UILabel *tuidanTextLable;//footer显示状态的label
@property (nonatomic,strong)UIButton *tousuBtn;//footer退单的投诉
@property (nonatomic,strong)UILabel *readLab;   //

@property (nonatomic, strong) UIView *tableFooterView;

//蒙版弹出式图
@property (nonatomic, strong)UIView *grayView;
@property (nonatomic, strong)UIView *whiteView;
@property (nonatomic, strong)UIImageView *adImgView;

@end

static NSString *const HomeLabelCell = @"DENGFANGDiJiaTaoDanTableViewCell";

static NSString *const cellID = @"infoCellID";

@implementation SSH_KeHuXiangQingViewController
- (NSMutableArray *)resultArray {
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}
- (NSMutableArray *)allCellArray {
    if (!_allCellArray) {
        _allCellArray = [NSMutableArray array];
    }
    return _allCellArray;
}
- (UITableView *)detailTableView {
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _detailTableView.backgroundColor = ColorLineeee;
        _detailTableView.dataSource = self;
        _detailTableView.delegate = self;
        [_detailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SSH_ProductDetailTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID];
        [_detailTableView registerClass:[SSH_ProductDetailBuChongCell class] forCellReuseIdentifier:NSStringFromClass([SSH_ProductDetailBuChongCell class])];
    }
    return _detailTableView;
}

- (UIView *)tableFooterView{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, WidthScale(72))];
        _tableFooterView.backgroundColor = ColorLineeee;
        _tableFooterView.userInteractionEnabled = YES;
//        if (self.pageType==2) {
//            self.detailTableView.tableFooterView = [UIView new];
//        }
    }
    return _tableFooterView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.pageType == 1){
        [self getDENGFANGCreditinfoByIdForData];
    }else if (self.pageType == 2){
        [self getDENGFANGOrderInfoByIdURLForData];
    }
    
    self.lineView.hidden = NO;
    [DENGFANGSingletonTime shareInstance].isShow = [[NSUserDefaults standardUserDefaults] boolForKey:@"shouCangAlert"];
    self.titleLabelNavi.text = @"详情";
    
    //    if(self.pageType == 1){
    //        [self getDENGFANGCreditinfoByIdForData];
    //    }else if (self.pageType == 2){
    //        [self getDENGFANGOrderInfoByIdURLForData];
    //    }
    
    [self setupTableView];
    [self createBottomView];
    [self setupAlertConent];
    [self setupTableViewFooterView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDetailModel:) name:RefreshDetailKey object:nil];
}
//
- (void)setupAlertConent{
    
    UIButton *alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:alertButton];
    [alertButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(getRectNavAndStatusHight+255);
        make.size.mas_equalTo(CGSizeMake(45, 44));
    }];
    alertButton.tag = 3000;
    [alertButton setImage:[UIImage imageNamed:@"警察"] forState:UIControlStateNormal];
    [alertButton addTarget:self action:@selector(alertAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:alertButton];
//    self.redAlertView.hidden = YES;
}

- (void)alertAction{
    //警察
    [MobClick event:@"Detailspage-gongan"];
    SSH_JingChaHFiveViewController *jingcha = [[SSH_JingChaHFiveViewController alloc] init];
    [self.navigationController pushViewController:jingcha animated:YES];
}

#pragma mark 创建底部
-(void)createBottomView{
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bottomView];
    CGFloat height = IS_IPHONEX||IS_IPHONEMAX?-20:0;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(61);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(height);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [self.bottomView addSubview:lineView];
    lineView.backgroundColor = Colordddddd;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView * sBgView = [[UIView alloc]init];
    sBgView.backgroundColor = COLORWHITE;
    [self.bottomView addSubview:sBgView];
    [sBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    self.moneyImg = [[UIImageView alloc]init];
//    [self.bottomView addSubview:self.moneyImg];
//    self.moneyImg.image = [UIImage imageNamed:@"money-1"];
//    [self.moneyImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(3);
//        make.left.mas_equalTo(25);//44
//        make.width.mas_equalTo(52);
//        make.height.mas_equalTo(43);
//    }];
    
    self.qiangButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sBgView addSubview:self.qiangButton];
    self.qiangButton.backgroundColor = COLOR_WITH_HEX(0x0062ff);
    [self.qiangButton addTarget:self action:@selector(qiangBtnCilcked:) forControlEvents:UIControlEventTouchUpInside];
    [self.qiangButton setTitle:@"立即抢单" forState:UIControlStateNormal];
    self.qiangButton.titleLabel.font = UIFONTTOOL17;
    self.qiangButton.layer.masksToBounds = YES;
    self.qiangButton.layer.cornerRadius = 20;
    CGFloat btnWidth = IS_IPHONE5?100:160;
    [self.qiangButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(40);
//        make.width.mas_equalTo(btnWidth);
        make.centerY.mas_equalTo(sBgView);
    }];
    
    self.moneyLabel = [[UILabel alloc]init];
//    [sBgView addSubview:self.moneyLabel];
//    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.mas_equalTo(0);
//        make.left.mas_equalTo(self.moneyImg.mas_right).offset(9);
//        make.right.mas_equalTo(self.qiangButton.mas_left).offset(-10);
//    }];
//    self.moneyLabel.textColor = COLOR_WITH_HEX(0xe63c3f);
//    self.moneyLabel.font = UIFONTTOOL22;
//    self.moneyLabel.text = @"￥ 金币";
//    [self configAttributeString:self.moneyLabel.text rangeString:@"金币" textFont:UIFONTTOOL13 rangColor:ColorBlack222 withLabel:self.moneyLabel];
    
}

#pragma mark --创建tableViewFooterView
- (void)setupTableViewFooterView{
    
    self.tuidanTextLable = [[UILabel alloc] initWithFrame:CGRectMake(WidthScale(15), 0, ScreenWidth-WidthScale(30), WidthScale(90))];
    self.tuidanTextLable.font = [UIFont systemFontOfSize:WidthScale(12)];
    self.tuidanTextLable.textColor = ColorBlack999;
    self.tuidanTextLable.numberOfLines = 0;
    self.tuidanTextLable.textAlignment = NSTextAlignmentCenter;
    [self.tableFooterView addSubview:self.tuidanTextLable];
    self.tuidanTextLable.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tuidanTapClick:)];
    [self.tuidanTextLable addGestureRecognizer:tap];
    
    self.tousuBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.tuidanTextLable.width-WidthScale(70), WidthScale(3), WidthScale(80), WidthScale(32))];
    [self.tousuBtn setTitle:@"《退单规则》" forState:UIControlStateNormal];
    [self.tousuBtn setTitleColor:COLOR_With_Hex(0xd44b46) forState:UIControlStateNormal];
    self.tousuBtn.titleLabel.font = [UIFont systemFontOfSize:WidthScale(12)];
    [self.tousuBtn addTarget:self action:@selector(tuidanShensuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.readLab = [[UILabel alloc] initWithFrame:CGRectMake(self.tousuBtn.frame.origin.x - 35, self.tousuBtn.frame.origin.y, 40, WidthScale(32))];
    self.readLab.text = @"请阅读";
    self.readLab.textColor = COLOR_WITH_HEX(0xadadad);
    self.readLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [self.tuidanTextLable addSubview:self.readLab];
    [self.tuidanTextLable addSubview:self.tousuBtn];
    
}

#pragma mark --退单入口
- (void)tuidanShensuBtnClick:(UIButton *)sender{
    [MobClick event:@"Detailspage-Return rule"];
    
    UIView *xibView = [[NSBundle mainBundle] loadNibNamed:@"SSH_DetailTuiDanGuiZeView" owner:self options:nil].lastObject;
    [self popAlertViewWithImageName:@"" contentView:xibView];

    if (self.shenQingTime != nil) {
//        tuidanVC.shenQingTimeStr = [NSDate dateWithTimeInterval:[self.shenQingTime integerValue]/1000 format:@"yyyy-MM-dd HH:mm:ss"];
    }
//    [self.navigationController pushViewController:tuidanVC animated:YES];
}
#pragma mark --弹出视图
- (void)popAlertViewWithImageName:(NSString *)name contentView:(UIView *)cView {
    self.grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //     [[UIApplication sharedApplication].keyWindow addSubview:self.grayView];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.grayView];
    //    [self.navigationController.view addSubview:self.grayView];
    self.grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    self.whiteView = [[UIView alloc] init];
    [self.grayView addSubview:self.whiteView];
    self.whiteView.layer.masksToBounds = YES;
    self.whiteView.layer.cornerRadius = 6;
    self.whiteView.backgroundColor = [UIColor clearColor];
    CGFloat wHeight = (SCREEN_WIDTH-60)*692/507;
    self.whiteView.frame = CGRectMake(30, (ScreenHeight-wHeight)/2, ScreenWidth-60, wHeight);
    
    UIImageView *adImgView = [[UIImageView alloc] initWithFrame:self.whiteView.bounds];
    [self.whiteView addSubview:adImgView];
    adImgView.image = [UIImage imageNamed:name];
//    self.adImgView = adImgView;
    
    cView.frame = self.whiteView.bounds;
    cView.backgroundColor = [UIColor clearColor];
    [self.whiteView addSubview:cView];
    
    UIButton *button = [UIButton new];
    [self.whiteView addSubview:button];
    button.frame = self.whiteView.bounds;
    [button addTarget:self action:@selector(clickAdImgView:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 500;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.grayView addSubview:closeButton];
    [closeButton setImage:[UIImage imageNamed:@"yaoqing_X"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeCurrentView) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake((ScreenWidth-35)/2, CGRectGetMaxY(self.whiteView.frame)+30, 35, 35);
    
}

- (void)clickAdImgView:(UIButton *) sender{
    [self.whiteView removeFromSuperview];
    [self.grayView removeFromSuperview];
}

- (void)closeCurrentView{
    [MobClick event:@"Detailspage-Chargeback-close"];
    [self.whiteView removeFromSuperview];
    [self.grayView removeFromSuperview];
}

- (void)tuidanTapClick:(UITapGestureRecognizer *)tap{
    
    NSLog(@"-----%@------",self.detailModel.isRefund);
    if ([SSH_TOOL_GongJuLei isKongWithString:self.detailModel.isRefund]) {
        return;
    }
    
    if ([self.detailModel.isRefund integerValue]==0) {
        
        if ([self.detailModel.singleState integerValue] == 0) {
            [MobClick event:@"Detailspage-Chargeback"];
            SSH_TuiDanViewController *tuidanVC = [[SSH_TuiDanViewController alloc] init];
            tuidanVC.nameStr = self.detailModel.name;
            tuidanVC.orderNo = self.detailModel.orderNo;
            tuidanVC.singleState = @"1";
            tuidanVC.remindTuiDan = ^{
                [self getDENGFANGOrderInfoByIdURLForData];
            };
            if (self.shenQingTime.length > 0) {
                tuidanVC.shenQingTimeStr = [NSDate dateWithTimeInterval:[self.shenQingTime integerValue]/1000 format:@"yyyy-MM-dd HH:mm:ss"];
            }
            [self.navigationController pushViewController:tuidanVC animated:YES];
        }
    }
}

#pragma mark -信息tableView
- (void)setupTableView {
    CGFloat height = IS_IPHONEX||IS_IPHONEMAX?-81:-61;
    [self.view addSubview:self.detailTableView];
    self.detailTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.detailTableView.separatorColor = ColorLineeee;
    self.detailTableView.showsVerticalScrollIndicator = NO;
    [self.detailTableView registerNib:[UINib nibWithNibName:@"SSH_TuiDan_Cell" bundle:nil] forCellReuseIdentifier:tuiDanCell];
    [self.detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getRectNavAndStatusHight);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(height);
    }];
    [self.allCellArray addObject:@""];
    
}

#pragma mark 资源详情接口
-(void)getDENGFANGCreditinfoByIdForData{
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%@",self.creditinfoId]],@"creditinfoId":self.creditinfoId,@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString],@"isDiscount":(self.isDiscount==nil||[self.isDiscount isEqualToString:@""])?@"0":self.isDiscount};
    
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGCreditinfoByIdURL parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        //        NSLog(@"资源详情界面 %@",diction);
        NSLog(@"ZiYuanDetail%@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            self.topCellModel = [[SSH_HomeCreditxinxiListModel alloc] init];
            [self.topCellModel setValuesForKeysWithDictionary:diction[@"data"]];
            if (self.fromWhere == 3) {
                self.fromWhere = self.topCellModel.isLowPrice == 1?1:2;
            }
            
            self.detailModel = [[SSH_ShouyeChanpingXiangQingModel alloc]init];
            [self.detailModel setValuesForKeysWithDictionary:diction[@"data"]];
            
            [self dealAllData];
            
            self.moneyLabel.text = [NSString stringWithFormat:@"%@ 金币",[self.detailModel.cion intValue]==0?@"0":self.detailModel.cion];
            [self.qiangButton setTitle:[NSString stringWithFormat:@"%@金币(立即抢单)",[self.detailModel.cion intValue]==0?@"0":self.detailModel.cion] forState:UIControlStateNormal];
            
            [self configAttributeString:self.moneyLabel.text rangeString:@"金币" textFont:UIFONTTOOL13 rangColor:ColorBlack222 withLabel:self.moneyLabel];
            
            [self.detailTableView reloadData];
            
            
            if ([self.detailModel.status intValue] == 3) {
                self.moneyImg.image = [UIImage imageNamed:@"money-2"];
                self.moneyLabel.textColor = Colorf3a3a5;
                [self configAttributeString:self.moneyLabel.text rangeString:@"金币" textFont:UIFONTTOOL13 rangColor:Color878787 withLabel:self.moneyLabel];
                self.qiangButton.backgroundColor = Colordddddd;
                [self.qiangButton setTitle:@"已被抢" forState:UIControlStateNormal];
                [self.qiangButton setTitleColor:ColorBlack999 forState:UIControlStateNormal];
                self.qiangButton.enabled = NO;
            }
            
            self.tuidanTextLable.attributedText = [self setWangLeiAttributedStringWithString:@"退单功能仅对vip用户开放"];
            self.tuidanTextLable.userInteractionEnabled = NO;
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark 客户管理 - 订单详情页  DENGFANGOrderInfoByIdURL
-(void)getDENGFANGOrderInfoByIdURLForData{
    
    NSDictionary *dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"orderNo":self.orderNo,@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]};
    
//    NSLog(@"%@",dic);
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGOrderGetOrderByIdURL parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"DingDanXiangQingYe %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            self.topCellModel = [[SSH_HomeCreditxinxiListModel alloc] init];
            [self.topCellModel setValuesForKeysWithDictionary:diction[@"data"]];
            if (self.fromWhere == 3) {
                self.fromWhere = self.topCellModel.isLowPrice == 1?1:2;
            }
            
            self.detailModel = [[SSH_ShouyeChanpingXiangQingModel alloc]init];
            [self.detailModel setValuesForKeysWithDictionary:diction[@"data"]];
            
            [self dealAllData];
            
            self.moneyLabel.text = [NSString stringWithFormat:@"%@ 金币",[self.detailModel.cion intValue]==0?@"0":self.detailModel.cion];
            
            if ([self.detailModel.isRefund integerValue] == 1) { //不符合退单
                ///富文本
                self.tuidanTextLable.text = @"该订单超过48小时";//@"我要退单（该订单要在购买时间后48小时以内）";
                self.tousuBtn.hidden = YES;
                self.readLab.hidden = YES;
                if ([self.detailModel.singleState integerValue] == 1) {
                    self.tuidanTextLable.text = @"退单申请审核中，请耐心等待";
                    self.tousuBtn.hidden = YES;
                    self.readLab.hidden = YES;
                }else if ([self.detailModel.singleState integerValue] == 4) {
                    self.tuidanTextLable.text = [NSString stringWithFormat:@"退单申请未通过\n原因：%@",self.detailModel.singleNote];
                    self.tousuBtn.hidden = NO;
                    self.readLab.hidden = NO;
                }
                
            } else if ([self.detailModel.isRefund integerValue] == 0){  //符合退单
                if ([self.detailModel.singleState integerValue] == 0) {
                    self.tuidanTextLable.attributedText = [self setAttributedStringWithString:@"此订单仅有一次申请机会申请退单"];
                    self.tuidanTextLable.userInteractionEnabled = YES;
                } else if ([self.detailModel.singleState integerValue] == 1) {
                    self.tuidanTextLable.text = @"退单申请审核中，请耐心等待";
                    self.tousuBtn.hidden = YES;
                   self.readLab.hidden = YES;
                }else if ([self.detailModel.singleState integerValue] == 4) {
                    self.tuidanTextLable.text = [NSString stringWithFormat:@"退单申请未通过\n原因：%@",self.detailModel.singleNote];
                    self.tousuBtn.hidden = NO;
                    self.readLab.hidden = NO;
                }else{
                    self.tuidanTextLable.text = @"该订单超过48小时";//@"我要退单（该订单要在购买时间后48小时以内）";
                    self.tousuBtn.hidden = YES;
                    self.readLab.hidden = YES;
                }
                
            } else if ([self.detailModel.isRefund integerValue] == 2){  //不是vip不可退单
                self.tuidanTextLable.attributedText = [self setAttributedStringWithString:@"退单功能仅对vip用户开放"];
                self.tuidanTextLable.userInteractionEnabled = NO;
            } else if ([self.detailModel.isRefund integerValue] == 3){  //vip退单次数用完不可退单
                self.tuidanTextLable.attributedText = [self setAttributedStringWithString:@"退单次数已用尽\n续费会员可增加退单次数"];
            }
            
//            NSLog(@"%@",self.detailModel.cion);
            
            [self configAttributeString:self.moneyLabel.text rangeString:@"金币" textFont:UIFONTTOOL13 rangColor:ColorBlack222 withLabel:self.moneyLabel];
            
            [self.detailTableView reloadData];
            
            
            
            if ([self.detailModel.orderStatus intValue] == 2) { //成功
                self.moneyImg.image = [UIImage imageNamed:@"money-2"];
                self.moneyLabel.textColor = Colorf3a3a5;
                [self configAttributeString:self.moneyLabel.text rangeString:@"金币" textFont:UIFONTTOOL13 rangColor:Color878787 withLabel:self.moneyLabel];
                [self.qiangButton setTitle:@"拨打电话" forState:UIControlStateNormal];
                self.phoneBtn.selected = YES;
                self.phoneBtn.enabled = YES;
            }else if ([self.detailModel.orderStatus intValue] == 1){ //支付中
                self.moneyImg.image = [UIImage imageNamed:@"money-2"];
                self.moneyLabel.textColor = Colorf3a3a5;
                [self configAttributeString:self.moneyLabel.text rangeString:@"金币" textFont:UIFONTTOOL13 rangColor:Color878787 withLabel:self.moneyLabel];
                [self.qiangButton setTitle:@"继续支付" forState:UIControlStateNormal];
            }else if ([self.detailModel.orderStatus intValue] == 0){ //失败
                if ([self.detailModel.status intValue] == 3) {
                    self.moneyImg.image = [UIImage imageNamed:@"money-2"];
                    self.moneyLabel.textColor = Colorf3a3a5;
                    [self configAttributeString:self.moneyLabel.text rangeString:@"金币" textFont:UIFONTTOOL13 rangColor:Color878787 withLabel:self.moneyLabel];
                    self.qiangButton.backgroundColor = Colordddddd;
                    [self.qiangButton setTitle:@"已被抢" forState:UIControlStateNormal];
                    [self.qiangButton setTitleColor:ColorBlack999 forState:UIControlStateNormal];
                    self.qiangButton.enabled = NO;
                }
            }
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark -处理数据
-(void)dealAllData{
    if (self.allCellArray.count>1) {
        [self.allCellArray removeObjectsInRange:NSMakeRange(1, self.allCellArray.count-1)];
    }
    
    //FIXME: 1.基本信息
    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
    [baseDic setValue:@"jiben_xinxi" forKey:@"image"];
    
    NSMutableArray *baseArray = [NSMutableArray array];
//    //申请时间
//    NSString * timeStr = [NSDate dateWithTimeInterval:[self.detailModel.createTime integerValue]/1000 format:@"yyyy年MM月dd日 HH:mm"];
//    [baseArray addObject:@{@"申请时间":timeStr}];
    
    //年龄
    NSString * ageStr;
    if ([SSH_TOOL_GongJuLei isKongWithString:self.detailModel.age]) {
        ageStr = @"未知";
    }else{
        ageStr = [NSString stringWithFormat:@"%@岁",self.detailModel.age];
    }
    [baseArray addObject:@{@"年龄":ageStr}];
    
    //原户籍所在地
    NSString * hujiCityStr;
    if ([SSH_TOOL_GongJuLei isKongWithString:self.detailModel.householdCity]) {
        hujiCityStr = @"未知";
    }else{
        hujiCityStr = [NSString stringWithFormat:@"%@",self.detailModel.householdCity];
    }
    if (![hujiCityStr isEqualToString:@""]) {
        [baseArray addObject:@{@"原户籍所在地":hujiCityStr}];
    }
    //当前所在城市
    NSString * nowCityStr = [NSString stringWithFormat:@"%@",self.detailModel.city];
    if ([SSH_TOOL_GongJuLei isKongWithString:self.detailModel.city]) {
        nowCityStr = @"未知";
    }else{
        nowCityStr = [NSString stringWithFormat:@"%@",self.detailModel.city];
    }
    if (![nowCityStr isEqualToString:@""]) {
        [baseArray addObject:@{@"当前所在城市":nowCityStr}];
    }
    //手机号归属地
    NSString * phoneCityStr = [NSString stringWithFormat:@"%@",self.detailModel.mobileCity];
    if (phoneCityStr.length == 0) {
        phoneCityStr = @"未知";
    }
    [baseArray addObject:@{@"手机号归属地":phoneCityStr}];
    
    //信用记录
    NSString * xinyongjilu;
    if ([self.detailModel.creditHistory isEqualToString:@"0"]){

        NSString *wuxinyongka = [NSString stringWithFormat:@"无信用卡和%@款",[DENGFANGSingletonTime shareInstance].name[1]];

        xinyongjilu = wuxinyongka;
    }else if ([self.detailModel.creditHistory isEqualToString:@"1"]){
        xinyongjilu = @"信用良好无逾期";
    }else if ([self.detailModel.creditHistory isEqualToString:@"2"]){
        xinyongjilu = @"1年内逾期少于3次且少于90天";
    }else if ([self.detailModel.creditHistory isEqualToString:@"3"]){
        xinyongjilu = @"1年内逾期超过3次或者大于90天";
    }else{
        xinyongjilu = @"未知";
    }
    if (![xinyongjilu isEqualToString:@""]) {
        [baseArray addObject:@{@"信用记录":xinyongjilu}];
    }
    [baseDic setValue:baseArray forKey:@"info"];
    //FIXME: 2.1工作信息
    NSMutableDictionary *jobDic = [NSMutableDictionary dictionary];
    NSMutableArray *jobArray = [NSMutableArray array];
    [jobDic setValue:@"gongzuo_xinxi" forKey:@"image"];
    
    //月收入
    NSString *yueshouru;
    NSString *beginYue = [NSString stringWithFormat:@"%@",self.topCellModel.incomeF];
    NSString *endYue = [NSString stringWithFormat:@"%@",self.topCellModel.endIncome];
    if (([beginYue isEqualToString:@"(null)"] || [beginYue isEqualToString:@"0"]) && [endYue isEqualToString:@"(null)"]) {
        yueshouru = @"未知";
    }else{
        if ([beginYue isEqualToString:@"0"]) {
            yueshouru = [NSString stringWithFormat:@"%@以下",endYue];
        } else if ([endYue isEqualToString:@"0"]) {
            yueshouru = [NSString stringWithFormat:@"%@以上",beginYue];
        } else {
            yueshouru = [NSString stringWithFormat:@"%@~%@",beginYue,endYue];
        }
//        if([self.topCellModel.income intValue] >= 10000){
//            if ([self.topCellModel.income intValue]%10000 == 0) {
//                yueshouru = [NSString stringWithFormat:@"%d万",[self.topCellModel.income intValue]/10000];
//            }else{
//                int qian = [self.topCellModel.income intValue]/1000;
//                float wan = qian/10.0;
//                yueshouru = [NSString stringWithFormat:@"%.1f万",wan];
//            }
//        }else{
//            yueshouru = [NSString stringWithFormat:@"%@元",self.topCellModel.income];
//        }
    }
    if (![yueshouru isEqualToString:@""]) {
        [jobArray addObject:@{@"月收入":yueshouru}];
    }
    //工资发放形式
    NSString * gongzi;
    if ([self.detailModel.businessLife isEqualToString:@"0"]) {
        gongzi = @"银行代发";
    }else if ([self.detailModel.businessLife isEqualToString:@"1"]){
        gongzi = @"现金发放";
    }else if ([self.detailModel.businessLife isEqualToString:@"2"]){
        gongzi = @"转账打卡";
    }else if ([self.detailModel.businessLife isEqualToString:@"3"]){
        gongzi = @"部分打卡部分现金";
    }else{
        gongzi = @"未知";
    }
    if (![gongzi isEqualToString:@""]) {
        [jobArray addObject:@{@"收入形式":gongzi}];
    }
    //单位名称
    NSString * comStr;
    if ([SSH_TOOL_GongJuLei isKongWithString:self.detailModel.companyName]) {
        comStr = @"未知";
    }else{
        if ([self.detailModel.orderStatus integerValue] == 2) {
            comStr = [NSString stringWithFormat:@"%@",self.detailModel.companyName];
        }else {
            comStr = [NSString stringWithFormat:@"%@(抢单后可见)",self.detailModel.companyName];
        }
    }
    if (![comStr isEqualToString:@""]) {
        //[jobArray addObject:@{@"单位名称":comStr}];
    }
    
    //工龄时长
    NSString * workyStr;
    if ([SSH_TOOL_GongJuLei isKongWithString:self.detailModel.operationYears]) {
        workyStr = @"未知";
    }else{
        workyStr = [NSString stringWithFormat:@"%@年",self.detailModel.operationYears];
    }
    if (![workyStr isEqualToString:@""]) {
        //[jobArray addObject:@{@"当前单位工龄(年)":workyStr}];
    }
    //职业身份
    NSString * jobShenfen = [NSString stringWithFormat:@"%@",self.topCellModel.identityType];
    if ([self.detailModel.identityType isEqualToString:@"0"]) { //0：上班族
        jobShenfen = @"上班族";
        [jobArray addObject:@{@"职业身份":jobShenfen}];
    }
    if ([self.detailModel.identityType isEqualToString:@"1"]){//1：公务员
        jobShenfen = @"公务员/事业单位";
        [jobArray addObject:@{@"职业身份":jobShenfen}];
    }
    
    //社保
    NSString * shebao;
    if ([self.detailModel.isSecurity isEqualToString:@"0"]) {
        shebao = @"无社保";
    }else if ([self.detailModel.isSecurity isEqualToString:@"1"]){
        shebao = @"未满6个月";
    }else if ([self.detailModel.isSecurity isEqualToString:@"2"]){
        shebao = @"6个月以上";
    }else if ([self.detailModel.isSecurity isEqualToString:@"3"]){
        shebao = @"连续1年及以上";
    }else if ([self.detailModel.isSecurity isEqualToString:@"4"]){
        shebao = @"3个月以下";
    }else{
        shebao = @"未知";
    }
    if (![shebao isEqualToString:@""]) {
        [jobArray addObject:@{@"本地社保已缴纳":shebao}];
    }
    
    //公积金
    NSString * gongjijin;
    if ([self.detailModel.isFund isEqualToString:@"0"]) {
        gongjijin = @"无公积金";
    }else if ([self.detailModel.isFund isEqualToString:@"1"]){
        gongjijin = @"未满6个月";
    }else if ([self.detailModel.isFund isEqualToString:@"2"]){
        gongjijin = @"6个月以上";
    }else if ([self.detailModel.isFund isEqualToString:@"3"]){
        gongjijin = @"连续1年及以上";
    }else if ([self.detailModel.isFund isEqualToString:@"4"]){
        gongjijin = @"3个月以下";
    }else{
        gongjijin = @"未知";
    }
    if (![gongjijin isEqualToString:@""]) {
        [jobArray addObject:@{@"本地公积金已缴纳":gongjijin}];
    }
    
    
    
    [jobDic setValue:jobArray forKey:@"info"];
    
    //FIXME: 2.2企业主的工作信息
    NSMutableDictionary *entrepreneurDic = [NSMutableDictionary dictionary];
    [entrepreneurDic setValue:@"gongzuo_xinxi" forKey:@"image"];
    NSMutableArray *entrepreneurArray = [NSMutableArray array];
    if ([self.detailModel.identityType isEqualToString:@"2"]){//企业主
        jobShenfen = @"个体户/企业主";
        [entrepreneurArray addObject:@{@"职业身份":jobShenfen}];
    }
    
    //营业执照
    
    NSString * liceStr = [NSString stringWithFormat:@"%@",self.detailModel.isLicense];
    if ([liceStr isEqualToString:@"1"]) {
        liceStr = @"有";
    }else if([liceStr isEqualToString:@"0"]){
        liceStr = @"无";
    }else{
        liceStr = @"";
    }
    if (![liceStr isEqualToString:@""]) {
        [entrepreneurArray addObject:@{@"营业执照":liceStr}];
    }
    
    //年流水
    NSString *nianLiushuiStr = [NSString stringWithFormat:@"%@",self.topCellModel.amountF];
    if ([SSH_TOOL_GongJuLei isKongWithString:nianLiushuiStr] || [nianLiushuiStr intValue] == 0) {
        nianLiushuiStr = @"未知";
    }else{
        
        if ([self.topCellModel.amountF intValue] == 0) {
            nianLiushuiStr = [NSString stringWithFormat:@"%@万以下",self.topCellModel.endAmount];
        }else if ([self.topCellModel.amountF intValue] != 0 && [self.topCellModel.endAmount intValue] == 0){
            nianLiushuiStr = [NSString stringWithFormat:@"%@万以上",self.topCellModel.amountF];
        }else if ([self.topCellModel.amountF intValue] != 0 && [self.topCellModel.endAmount intValue] != 0){
            nianLiushuiStr = [NSString stringWithFormat:@"%@-%@万",self.topCellModel.amountF,self.topCellModel.endAmount];
        }
    }
    
    if (![nianLiushuiStr isEqualToString:@""]) {
        [entrepreneurArray addObject:@{@"年流水(万)":nianLiushuiStr}];
    }
    
    //经营年限
    NSString * operationYearsStr = @"";
    if (![SSH_TOOL_GongJuLei isKongWithString:self.detailModel.operationYears]) {
        if ([self.detailModel.operationYears isEqualToString:@"0"]) {
            operationYearsStr = @"1年以下";
        } else if ([self.detailModel.operationYears isEqualToString:@"3"]) {
            operationYearsStr = @"3年以上";
        } else {
            operationYearsStr = [NSString stringWithFormat:@"%@年",self.detailModel.operationYears];
        }
        
    } else {
        operationYearsStr = @"未知";
    }
    [entrepreneurArray addObject:@{@"经营年限(年)":operationYearsStr}];
    
    if (![shebao isEqualToString:@""]) {
        [entrepreneurArray addObject:@{@"本地社保已缴纳":shebao}];
    }
    if (![gongjijin isEqualToString:@""]) {
        [entrepreneurArray addObject:@{@"本地公积金已缴纳":gongjijin}];
    }
    
    [entrepreneurDic setValue:entrepreneurArray forKey:@"info"];
    
    //FIXME: 3.资产信息
    NSMutableDictionary *propertyDic = [NSMutableDictionary dictionary];
    NSMutableArray *propertyArray = [NSMutableArray array];
    [propertyDic setValue:@"zichan_xinxi" forKey:@"image"];
    
    //芝麻信用
    NSString * zhimaxinyong;
    if([SSH_TOOL_GongJuLei isKongWithString:self.detailModel.sesameCreditF]){
        zhimaxinyong = @"未知";
    } else if ([self.detailModel.sesameCreditF isEqualToString:@"0分"]) {
        zhimaxinyong = [NSString stringWithFormat:@"%@以下",self.detailModel.endSesameCredit];
    } else if ([SSH_TOOL_GongJuLei isKongWithString:self.detailModel.endSesameCredit]) {
        zhimaxinyong = [NSString stringWithFormat:@"%@",self.detailModel.sesameCreditF];
    } else if ([self.detailModel.endSesameCredit isEqualToString:@"0分"]) {
        zhimaxinyong = [NSString stringWithFormat:@"%@以上",self.detailModel.sesameCreditF];
    } else {
        zhimaxinyong = [NSString stringWithFormat:@"%@~%@",self.detailModel.sesameCreditF,self.detailModel.endSesameCredit];
    }
    if (![zhimaxinyong isEqualToString:@""]) {
        [propertyArray addObject:@{@"芝麻信用":zhimaxinyong}];
    }
    
    //信用卡
    NSString * carLiStr;
    if ([self.detailModel.isCreditCard isEqualToString:@"0"]) {
        carLiStr = @"无";
    }else if ([self.detailModel.isCreditCard isEqualToString:@"1"]){
        carLiStr = @"10000元以下";
    }else if ([self.detailModel.isCreditCard isEqualToString:@"2"]){
        carLiStr = @"10001~30000元";
    }else if ([self.detailModel.isCreditCard isEqualToString:@"3"]){
        carLiStr = @"30001~100000元";
    }else if ([self.detailModel.isCreditCard isEqualToString:@"4"]){
        carLiStr = @"100000元以上";
    }else{
        carLiStr = @"";
    }
    if (![carLiStr isEqualToString:@""]) {
        [propertyArray addObject:@{@"信用卡":carLiStr}];
    }
    
    //微粒额度
    NSString *weiliEduStr = @"";
    NSString *str1 = self.detailModel.isWeiliD;
    NSString *str2 = self.detailModel.endWeiliDLimit;
    
    if ([self.detailModel.isWeiliD isEqualToString:@"1"]) {
        if ([self.detailModel.weiliDLimitF isEqualToString:@"0"]) {
            weiliEduStr = [NSString stringWithFormat:@"%@以下",self.detailModel.endWeiliDLimit];
        } else if ([self.detailModel.endWeiliDLimit isEqualToString:@"0"]) {
            weiliEduStr = [NSString stringWithFormat:@"%@以上",self.detailModel.weiliDLimitF];;
        } else if (self.detailModel.weiliDLimitF.length != 0 && self.detailModel.endWeiliDLimit.length != 0) {
            weiliEduStr = [NSString stringWithFormat:@"%@~%@",self.detailModel.weiliDLimitF,self.detailModel.endWeiliDLimit];
        } else if (self.detailModel.weiliDLimitF.length == 0) {
            weiliEduStr = @"未知";
        } else if (self.detailModel.endWeiliDLimit.length == 0) {
            weiliEduStr = [NSString stringWithFormat:@"%@以下",self.detailModel.weiliDLimitF];
        } else  {
            weiliEduStr = @"未知";
        }
    } else if ([self.detailModel.isWeiliD isEqualToString:@"0"]) {
        weiliEduStr = @"无";
    } else {
        weiliEduStr = @"未知";
    }
    
    if ([SSH_TOOL_GongJuLei isKongWithString:weiliEduStr] || [weiliEduStr isEqualToString:@"0"]) {
        
    }else{
        NSString *weiLiDai = [NSString stringWithFormat:@"微粒%@",[DENGFANGSingletonTime shareInstance].name[1]];
        [propertyArray addObject:@{weiLiDai:weiliEduStr}];
    }
    
    
    //房产类型
    NSString *fangchanTypeStr = [NSString stringWithFormat:@"%@",self.detailModel.propertyType];
    if ([SSH_TOOL_GongJuLei isKongWithString:self.detailModel.property]) {
        fangchanTypeStr = @"未知";
    }else if ([self.detailModel.property integerValue] == 0){
        fangchanTypeStr = @"无房产";
    }else{
        if ([fangchanTypeStr isEqualToString:@"0"]) {
            fangchanTypeStr = @"商品住房";
        }else if ([fangchanTypeStr isEqualToString:@"1"]){
            fangchanTypeStr = @"商住两用房";
        }else if ([fangchanTypeStr isEqualToString:@"2"]){
            fangchanTypeStr = @"办公楼";
        }else if ([fangchanTypeStr isEqualToString:@"3"]){
            fangchanTypeStr = @"厂房";
        }else if ([fangchanTypeStr isEqualToString:@"4"]){
            fangchanTypeStr = @"经济适用房";
        }else if ([fangchanTypeStr isEqualToString:@"5"]){
            fangchanTypeStr = @"其他";
        }
    }
    if (![fangchanTypeStr isEqualToString:@""]) {
        [propertyArray addObject:@{@"房产类型":fangchanTypeStr}];
    }
    
    //名下车产
    NSString *chechanStr = [NSString stringWithFormat:@"%@",self.detailModel.carProduction];
    if ([chechanStr isEqualToString:@"0"]) {
        chechanStr = @"无车产";
    }else if ([chechanStr isEqualToString:@"1"]) {
        chechanStr = @"有车不接受抵押";
    }else if ([chechanStr isEqualToString:@"2"]) {
        chechanStr = @"其他";
    }else if ([chechanStr isEqualToString:@"3"]) {
        chechanStr = @"有车可接受抵押";
    }else{
        chechanStr = @"未知";
    }
    if (![chechanStr isEqualToString:@""]) {
        [propertyArray addObject:@{@"名下车产":chechanStr}];
    }
    
    //个人保险
    NSString * insuStr = [NSString stringWithFormat:@"%@",self.detailModel.isInsurance];
    if ([insuStr isEqualToString:@"0"]){
        insuStr = @"无保险单";
    }else if ([self.detailModel.isInsurance isEqualToString:@"1"]){
        insuStr = @"未满6个月";
    }else if ([self.detailModel.isInsurance isEqualToString:@"2"]){
        insuStr = @"6个月以上";
    }else{
        insuStr = @"未知";
    }
    if (![insuStr isEqualToString:@""]) {
        [propertyArray addObject:@{@"个人保险":insuStr}];
    }
    
    [propertyDic setValue:propertyArray forKey:@"info"];
    
    
    
    [self.allCellArray addObject:baseDic];
    
    //2.自由职业者的工作信息
    NSMutableDictionary *freeWorkDic = [NSMutableDictionary dictionary];
    [freeWorkDic setValue:@"gongzuo_xinxi" forKey:@"image"];
    NSMutableArray *freeWorkArray = [NSMutableArray array];
    
    if ([self.detailModel.identityType isEqualToString:@"3"]){//自由职业
        jobShenfen = @"自由职业者";
        [freeWorkArray addObject:@{@"职业身份":jobShenfen}];
    }
    
    //月收入
    if (![yueshouru isEqualToString:@""]) {
        [freeWorkArray addObject:@{@"月收入":yueshouru}];
    }
    
    //收入形式
    NSString *freeIncomeStyleString = [NSString stringWithFormat:@"%@",self.detailModel.businessLifeF];
    if ([freeIncomeStyleString isEqualToString:@"0"]) {
        freeIncomeStyleString = @"银行代发";
    }else if ([freeIncomeStyleString isEqualToString:@"1"]){
        freeIncomeStyleString = @"现金发放";
    }else if ([freeIncomeStyleString isEqualToString:@"2"]){
        freeIncomeStyleString = @"转账工资";
    }else if ([freeIncomeStyleString isEqualToString:@"3"]){
        freeIncomeStyleString = @"部分打卡部分现金";
    }else{
        freeIncomeStyleString = @"未知";
    }
    if (![freeIncomeStyleString isEqualToString:@""]) {
        [freeWorkArray addObject:@{@"收入形式":freeIncomeStyleString}];
    }
    
    if (![gongjijin isEqualToString:@""]) {
        [freeWorkArray addObject:@{@"本地公积金已缴纳":gongjijin}];
    }
    if (![shebao isEqualToString:@""]) {
        [freeWorkArray addObject:@{@"本地社保已缴纳":shebao}];
    }
    
    
    [freeWorkDic setValue:freeWorkArray forKey:@"info"];
    
    //新增补充信息
    NSMutableDictionary *buChongDic = [NSMutableDictionary dictionary];
    [buChongDic setValue:@"buchong_xinxi" forKey:@"image"];
    NSMutableArray *buChongArray = [NSMutableArray array];
    [buChongArray addObject:@{@" ":@" "}];
    [buChongDic setValue:buChongArray forKey:@"info"];
    
    if ([self.detailModel.additionCondition hasSuffix:@","]) {
        self.detailModel.additionCondition = [self.detailModel.additionCondition substringToIndex:([self.detailModel.additionCondition length]-1)];//去掉最后一个字符串如
    }
    
    self.buChongArr = [self.detailModel.additionCondition componentsSeparatedByString:@","];
    
    if ([self.detailModel.identityType intValue] == 0 || [self.detailModel.identityType intValue] == 1) { //0：上班族 1：公务员
        [self.allCellArray addObject:jobDic];
    }else if ([self.detailModel.identityType intValue] == 2){//企业主
        [self.allCellArray addObject:entrepreneurDic];
    }else if ([self.detailModel.identityType intValue] == 3){//自由职业
        [self.allCellArray addObject:freeWorkDic];
    }
    [self.allCellArray addObject:propertyDic];
    
//    if (self.buChongArr.count) {
//        [self.allCellArray addObject:buChongDic]; //补充信息
//    }
    
    NSMutableDictionary *tuiDanDic = [NSMutableDictionary dictionary];
    [tuiDanDic setValue:@"tuiDan_shupming" forKey:@"image"];
    NSMutableArray *tuiDanArray = [NSMutableArray array];
    [tuiDanArray addObject:@{@"1111":@"2222"}];
    [tuiDanDic setValue:tuiDanArray forKey:@"info"];
    [self.allCellArray addObject:tuiDanDic];

//    if (self.pageType==2) {
//        [self.allCellArray addObject:tuiDanDic];
//    }
}

#pragma mark 收藏按钮点击事件
-(void)shouCangBtnClicked:(UIButton *)btn{
    
    if ([[DENGFANGSingletonTime shareInstance].tokenString isEqualToString:@""] || [DENGFANGSingletonTime shareInstance].tokenString == nil) {
        
        SSH_YanZhengMaDengLuController *verVC = [[SSH_YanZhengMaDengLuController alloc] init];
        verVC.isShowTiaoGuo = 0;
        SSQ_HiddenNavigationViewController *naviVC = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:verVC];
        [self presentViewController:naviVC animated:NO completion:nil];
    }else{
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"shouCangAlert"]) {
            [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"shouCangAlert"];
            self.alertButton.hidden = YES;
        }
        if ([self.isCollection isEqualToString:@"1"]) {
            
            [btn setImage:[UIImage imageNamed:@"shoucang_no"] forState:UIControlStateNormal];
            self.isCollection = @"0";
        }else{
            [btn setImage:[UIImage imageNamed:@"shoucang_sel"] forState:UIControlStateNormal];
            self.isCollection = @"1";
        }
        
        self.collectionBtn = btn;
        [self getAddMyCollection];
    }
    
}

#pragma mark  添加收藏接口 DENGFANGAddMyCollection
-(void)getAddMyCollection{
    
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"creditId":self.creditinfoId,@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]};
    
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGAddMyCollectionURL parameters:dic success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@" 添加收藏接口 %@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            //            self.collectionBtn.selected = !self.collectionBtn.selected;
            if ([self.isCollection isEqualToString:@"1"]) {
                
                [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"收藏成功"];
            }else{
                [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"取消收藏"];
            }
            
        }else if ([diction[@"code"] isEqualToString:@"10014"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:DENGFANGLogOutObserverName object:nil];
            [self presentDengluPage];
            
            if ([self.isCollection isEqualToString:@"1"]) {
                
                [self.collectionBtn setImage:[UIImage imageNamed:@"shoucang_no"] forState:UIControlStateNormal];
                self.isCollection = @"0";
            }else{
                [self.collectionBtn setImage:[UIImage imageNamed:@"shoucang_sel"] forState:UIControlStateNormal];
                self.isCollection = @"1";
            }
            
            
        }else if ([diction[@"code"] isEqualToString:@"10004"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DENGFANGLogOutObserverName object:nil];
            [self presentDengluPage];
            [SSH_ZhangHaoDongJieView showInSuperView:diction[@"msg"]];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:diction[@"msg"]];
        }
        
    } fail:^(NSError *error) {
        
    }];
}

- (void)presentDengluPage{
    
    SSH_YanZhengMaDengLuController *verVC = [[SSH_YanZhengMaDengLuController alloc] init];
    verVC.isShowTiaoGuo = 0;
    SSQ_HiddenNavigationViewController *naviVC = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:verVC];
    [self presentViewController:naviVC animated:NO completion:nil];
}



#pragma mark 抢单点击事件
-(void)qiangBtnCilcked:(UIButton *)sender {
    [MobClick event:@"detail-buy"];
    sender.userInteractionEnabled = NO;
    if ([[DENGFANGSingletonTime shareInstance].tokenString isEqualToString:@""] || [DENGFANGSingletonTime shareInstance].tokenString == nil) {
        sender.userInteractionEnabled = YES;
        SSH_YanZhengMaDengLuController *verVC = [[SSH_YanZhengMaDengLuController alloc] init];
        verVC.isShowTiaoGuo = 0;
        SSQ_HiddenNavigationViewController *naviVC = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:verVC];
        [self presentViewController:naviVC animated:NO completion:nil];
    }else{
        if ([self.detailModel.orderStatus intValue] == 1) {
            sender.userInteractionEnabled = YES;
            //继续支付
            SSH_ZhifuXiangQingViewController *zhifuVC = [[SSH_ZhifuXiangQingViewController alloc] init];
            zhifuVC.orderNo = self.orderNo;
            [self.navigationController pushViewController:zhifuVC animated:YES];
        }else if ([self.detailModel.orderStatus intValue] == 2){
            sender.userInteractionEnabled = YES;
            [self  phoneBtnClicked];
        }else{
            
            [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGQiangDanURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"creditinfoId":self.creditinfoId,@"isDiscount":(self.isDiscount==nil||[self.isDiscount isEqualToString:@""])?@"0":self.isDiscount} success:^(id responsObject) {
                sender.userInteractionEnabled = YES;
                NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"%@",diction);
                if ([diction[@"code"] isEqualToString:@"200"]){
                    //抢单成功
                    [self sureToPayJinBiAction:@"" orderNo:diction[@"orderNo"]];
                }else if ([diction[@"code"] isEqualToString:@"10014"]){
                    //token失效
                    [[NSNotificationCenter defaultCenter] postNotificationName:DENGFANGLogOutObserverName object:nil];
                    [self presentDengluPage];
                    
                }else if ([diction[@"code"] isEqualToString:@"10004"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:DENGFANGLogOutObserverName object:nil];
                    [self presentDengluPage];
                    [SSH_ZhangHaoDongJieView showInSuperView:diction[@"msg"]];
                }else if ([diction[@"code"] isEqualToString:@"30000"]) {
                    //跳转到认证界面
                    if ([diction[@"msg"] isEqualToString:@""] || diction[@"msg"] == nil) {
                        //认证中、认证失败
                        SSH_New_RZViewController *rz = [[SSH_New_RZViewController alloc] init];
                        [self.navigationController pushViewController:rz animated:YES];
                    }else{
                        //未认证
                        [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:diction[@"msg"]];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            SSH_New_RZViewController *rz = [[SSH_New_RZViewController alloc] init];
                            [self.navigationController pushViewController:rz animated:YES];
                        });
                    }
                    
                }else if ([diction[@"code"] isEqualToString:@"50001"]){
                    //金币不足
                    [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:diction[@"msg"]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        SSH_ChargeActionViewController *chargeVC = [[SSH_ChargeActionViewController alloc] init];
                        [self.navigationController pushViewController:chargeVC animated:YES];
                    });
                }else{
                    [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:diction[@"msg"]];
                }
            } fail:^(NSError *error) {
                sender.userInteractionEnabled = YES;
                [SSH_TOOL_GongJuLei showAlter:self.navigationController.view WithMessage:[NSString stringWithFormat:@"%@",error]];
            }];
            
        }
    }
    
    
}
//FIXME: ---------------------------------------支付
- (void)sureToPayJinBiAction:(NSString *)pwd orderNo:(NSString *)orderNo{
    
//    versionType  支付新增参数  抢单支付终端（1：淘优单）
    NSString *signString = [NSString stringWithFormat:@"%d%@",[DENGFANGSingletonTime shareInstance].useridString,orderNo];
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGSurePayJinBiURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:signString],@"orderNo":orderNo,@"mobile":[DENGFANGSingletonTime shareInstance].mobileString,@"payPwd":[pwd yf_MD5String],@"payType":@"0",@"versionType":@"1"} success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"支付成功"]];
            [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
            //支付成功
            NSDictionary *dict = @{
                                   @"orderNo":orderNo
                                   };
            NSNotification *notification =[NSNotification notificationWithName:RefreshDetailKey object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [SSH_TOOL_GongJuLei showAlter:[UIApplication sharedApplication].keyWindow WithMessage:@"支付成功！"];
//            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
            if ([diction[@"code"] isEqualToString:@"50001"]) {
                UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
                window.windowLevel = UIWindowLevelNormal;
                UIView *xibView = [[NSBundle mainBundle] loadNibNamed:@"SSH_KH_JBBZView" owner:self options:nil].lastObject;
                xibView.frame = window.frame;
                [self.view addSubview:xibView];
            } else {
                [SSH_TOOL_GongJuLei showAlter:[UIApplication sharedApplication].keyWindow WithMessage:[NSString stringWithFormat:@"%@",diction[@"msg"]]];
            }
        }
        
    } fail:^(NSError *error) {
        
    }];
}

- (IBAction)chongZhiButton:(UIButton *)sender {
    [sender.superview.superview removeFromSuperview];
    SSH_ChargeActionViewController * chongzhiVC = [[SSH_ChargeActionViewController alloc]init];
    chongzhiVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chongzhiVC animated:YES];
}
- (IBAction)hiddenChongZhiView:(UIButton *)sender {
    [sender.superview.superview removeFromSuperview];
}

//FIXME: ---------------------------------------支付

#pragma  mark 电话点击事件
- (void)phoneButtonClicked:(UIButton *)sender {
    [self phoneBtnClicked];
}
-(void)phoneBtnClicked{
    
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.detailModel.mobile];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}



#pragma mark -空判断
//- (BOOL)isKongWithString:(NSString *)string{
//    if ([string isEqualToString:@"<null>"] || [string isEqualToString:@""] || string == nil || [string isEqualToString:@"(null)"]) {
//        return YES;
//    }
//    return NO;
//}

#pragma mark -富文本方法
- (void)configAttributeString:(NSString *)configString rangeString:(NSString *)rangeString textFont:(UIFont *)font rangColor:(UIColor *)color withLabel:(UILabel *)label {
    
    NSString *jineString = configString;
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] initWithString:jineString];
    NSRange range = [jineString rangeOfString:rangeString];
    [mutableAttString addAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} range:range];
    [mutableAttString beginEditing];
    label.attributedText = mutableAttString;
}
- (void)configAttributeString:(NSString *)configString rangeString1:(NSString *)rangeString1 rangeString2:(NSString *)rangeString2 withLabel:(UILabel *)label{
    if ([rangeString1 isKindOfClass:NSNull.class]) {
        rangeString1 = @"";
    }
    if ([rangeString2 isKindOfClass:NSNull.class]) {
        rangeString2 = @"";
    }
    NSString *jineString = configString;
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] initWithString:jineString];
    NSRange range1 = [jineString rangeOfString:rangeString1];
    NSRange range2 = [jineString rangeOfString:rangeString2];
    
    [mutableAttString addAttributes:@{NSFontAttributeName:UIFONTTOOL13,NSForegroundColorAttributeName:ColorBlack222} range:range1];
    [mutableAttString addAttributes:@{NSFontAttributeName:UIFONTTOOL13,NSForegroundColorAttributeName:COLOR_WITH_HEX(0xe63c3f)} range:range2];
    
    [mutableAttString beginEditing];
    label.attributedText = mutableAttString;
}


#pragma mark -tableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allCellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    NSArray *infoArray = self.allCellArray[section][@"info"];
    return infoArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        SSH_DiJiaTaoListCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeLabelCell];
        if (!cell) {
            cell = [[SSH_DiJiaTaoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HomeLabelCell];
        }
        self.alertButton = cell.shouCangAlertButton;
        cell.fromWhere = self.fromWhere;
//        cell.gaoEZhuanQu = self.gaoEZhuanQu;
        
        NSLog(@"%d",self.isQuanGuo);
        
        cell.isQuanGuo = self.isQuanGuo;
        cell.homeCellModel = self.topCellModel;
        self.less = cell.less;
        cell.selectionStyle = 0;
        cell.shouCangBtn.hidden = NO;
        //电话Label
        self.phoneLabel = cell.phoneLabel;
        
        //电话按钮
        self.phoneBtn = cell.phoneBtn;
        if (self.pageType == 1 ) {
            self.phoneBtn.enabled = NO;
        }else{
            if ([self.detailModel.orderStatus intValue] != 2) {
                self.phoneBtn.enabled = NO;
            }else{
                self.phoneBtn.selected = YES;
            }
        }
        cell.rightArrowImgView.hidden = YES;
        cell.beiQiangImgView.hidden = YES;
        cell.delegate = self;
        if ([self.detailModel.isCollection isEqualToString:@"1"]) {
            [cell.shouCangBtn setImage:[UIImage imageNamed:@"shoucang_sel"] forState:UIControlStateNormal];
            self.isCollection = @"1";
            cell.shouCangAlertButton.hidden = YES;
        }else{
            [cell.shouCangBtn setImage:[UIImage imageNamed:@"shoucang_no"] forState:UIControlStateNormal];
            self.isCollection = @"0";
            cell.shouCangAlertButton.hidden = [DENGFANGSingletonTime shareInstance].isShow;
        }
        cell.backgroundColor = COLORWHITE;
        cell.backContentView.backgroundColor = COLORWHITE;
        return cell;
    }else if (indexPath.section == 4){
        SSH_TuiDan_Cell *cell = [tableView dequeueReusableCellWithIdentifier:tuiDanCell];
        //退单信息
        cell.didSelectedBut = ^(UIButton * guize) {
            [self tuidanShensuBtnClick:guize];
        };
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tuidanTapClick:)];
        [cell.detailLab addGestureRecognizer:tap];
        cell.detailLab.attributedText = self.tuidanTextLable.attributedText;
        cell.selectionStyle = 0;
        return cell;
    }
    SSH_ProductDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSArray *infoArray = self.allCellArray[indexPath.section][@"info"];
    NSDictionary *info = infoArray[indexPath.row];
    
    NSString *leftText = info.allKeys.count?info.allKeys[0]:@"";
    NSString *rightText = info.allValues.count?info.allValues[0]:@"";
    cell.titleLabel.text = leftText;
    cell.detailLabel.text = rightText;
    
    cell.titleLabel.textColor = COLOR_WITH_HEX(0x999999);
    cell.detailLabel.textColor = COLOR_WITH_HEX(0x0062ff);
    
    if ([leftText isEqualToString:@"身份证"]) {
        NSArray * arr1 = [cell.detailLabel.text componentsSeparatedByString:@"("];
        if (arr1.count > 1) {
            NSString *ranStr2 = [NSString stringWithFormat:@"(%@",arr1[1]];
            [self configAttributeString:cell.detailLabel.text rangeString1:self.detailModel.idCard rangeString2:ranStr2 withLabel:cell.detailLabel];
        }
    }
    
    return cell;
}

#pragma mark -tableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0){
        self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 7)];
        self.headView.backgroundColor = ColorBackground_Line;
        self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 25);
        self.headView.backgroundColor = Colorf9f3dd;
        self.markLabel = [[UILabel alloc] init];
        self.markLabel.backgroundColor = [UIColor clearColor];
        self.markLabel.textColor = GrayColor666;
        self.markLabel.font = UIFONTTOOL12;
        
        if (self.detailModel.mark.length == 0  || [self.detailModel.mark isEqualToString:@"<null>"] || self.detailModel.mark == nil) {
            self.markLabel.text = @"";
        }else{
            self.markLabel.text = self.detailModel.mark;
        }
        
        self.markLabel.textAlignment = NSTextAlignmentCenter;
        [self.headView addSubview:self.markLabel];
        [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(5);
            make.top.bottom.mas_equalTo(0);
        }];
        if (self.detailModel.mark.length == 0  || [self.detailModel.mark isEqualToString:@"<null>"] || self.detailModel.mark == nil) {
            self.markLabel.hidden = YES;
            self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH,0);
            self.headView.backgroundColor = ColorBackground_Line;
        }
        return self.headView;
    }else{
        NSArray *infoArray = self.allCellArray[section][@"info"];
        NSArray *titleArr = @[@"",@"基本信息",@"工作信息",@"资产信息",@"退单说明"];
        if (infoArray.count == 0) {
            return nil;
        }else{
            UIView *sectionView = [[UIView alloc] init];
            sectionView.backgroundColor = [UIColor whiteColor];
            NSString *imageName = self.allCellArray[section][@"image"];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            [sectionView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.center.mas_equalTo(sectionView);
                make.left.mas_equalTo(15);
                make.centerY.mas_equalTo(sectionView);
                make.size.mas_equalTo(imageView.image.size);
            }];
            
            UILabel *lab = [[UILabel alloc] init];
            lab.text = titleArr[section];
            lab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
            lab.textColor = COLOR_WITH_HEX(0x0062ff);
            [sectionView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(imageView.mas_right).offset(7);
                make.top.bottom.mas_equalTo(0);
            }];
            return sectionView;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = ColorLineeee;
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 145-self.less;
    }else if (indexPath.section == 4){
        return UITableViewAutomaticDimension;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.detailModel.mark.length == 0 || [self.detailModel.mark isEqualToString:@"<null>"] || self.detailModel.mark == nil) {
            self.markLabel.hidden = YES;
            self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH,0);
            return 0.1;
        }
        return 25;
    }else{
        NSArray *infoArray = self.allCellArray[section][@"info"];
        if (infoArray.count == 0) {
            return 0;
        }else{
            return 42.5;
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.allCellArray.count-1) {
        //        return 87.5;
        return 0;
    }else{
        return 7;
    }
    
}

#pragma mark -接受通知
- (void)refreshDetailModel:(NSNotification *)notification {
    NSLog(@"%@",notification.userInfo[@"orderNo"]);
    NSString *orderNo = notification.userInfo[@"orderNo"];
    self.orderNo = orderNo;
    self.pageType = 2;
    self.phoneBtn.enabled = YES;
    self.phoneBtn.selected = YES;
    self.qiangButton.enabled = YES;
    self.qiangButton.backgroundColor = COLOR_WITH_HEX(0x0062ff);
    [self.qiangButton setTitleColor:COLORWHITE forState:UIControlStateNormal];
    [self getDENGFANGOrderInfoByIdURLForData];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshDetailKey object:nil];
}

#pragma mark -富文本
- (NSMutableAttributedString *)setAttributedStringWithString:(NSString *)string {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    UIFont *font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    NSInteger range = string.length;
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(range - 4,4)];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,range - 4)];
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0xadadad) range:NSMakeRange(0,range - 4)];
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0xe63c3f) range:NSMakeRange(range - 4,4)];
    return attrString;
}


#pragma mark -富文本
- (NSMutableAttributedString *)setWangLeiAttributedStringWithString:(NSString *)string {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    UIFont *font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    NSInteger range = string.length;
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(range - 4,4)];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,range - 4)];
    [attrString addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0xadadad) range:NSMakeRange(0,range)];
    //[attrString addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0xe63c3f) range:NSMakeRange(range - 4,4)];
    return attrString;
}


@end
