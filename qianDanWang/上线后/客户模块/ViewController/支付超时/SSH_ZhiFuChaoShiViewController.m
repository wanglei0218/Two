//
//  SSH_ZhiFuChaoShiViewController.m
//  DENGFANGSC
//
//  Created by 锦鳞附体^_^ on 2018/11/22.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ZhiFuChaoShiViewController.h"
#import "SSH_KeHuXiangQingViewController.h"
#import "SSH_ShouyeChanpingXiangQingModel.h"

@interface SSH_ZhiFuChaoShiViewController ()
//@property (nonatomic, strong) UILabel *biaoqian1;//标签1
//@property (nonatomic, strong) UILabel *biaoqian2;//标签2

@property (nonatomic,strong) SSH_ShouyeChanpingXiangQingModel *detailModel;


@property (nonatomic, strong) UIView *huiseyuandian1;
@property (nonatomic, strong) UIView *huiseyuandian2;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UILabel *jieDuoShaoLabel;
@property (nonatomic,strong) UILabel *daiDuoJiuLabel;

@property (nonatomic,strong) UILabel *haveCardLabel;

@property (nonatomic,copy) NSString *loanStartLimit;
@property (nonatomic,copy) NSString *loanTerm;
@property (nonatomic,copy) NSString *isCreditCard;
@property (nonatomic,copy) NSString *loanPurpose;
@property (nonatomic, strong) NSMutableArray *biaoqianArray;
@property (nonatomic, strong) UIView *centerBGView;

@end

@implementation SSH_ZhiFuChaoShiViewController
- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = GrayColor666;
        _moneyLabel.font = UIFONTTOOL15;
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = ColorBlack222;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = UIFONTTOOL15;
    }
    return _nameLabel;
}
- (UILabel *)haveCardLabel {
    if (!_haveCardLabel) {
        _haveCardLabel = [[UILabel alloc] init];
        _haveCardLabel.font = UIFONTTOOL12;
        _haveCardLabel.textColor = ColorBlack222;
        _haveCardLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _haveCardLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text= @"支付详情";

    [self setupUI];
    
    [self reuestModelDetail];
}

- (void)reuestModelDetail {
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"orderNo":self.orderNo,@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]};
    
    
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGOrderInfoByIdURL parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
        self.detailModel = [[SSH_ShouyeChanpingXiangQingModel alloc]init];
        [self.detailModel setValuesForKeysWithDictionary:diction[@"data"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupModelInfo];
        });
    }fail:^(NSError *error) {
        
    }];
}
- (void)setupUI {
    
    self.normalBackView.backgroundColor = ColorBackground_Line;
    
    
    //顶部超时view
    UIView *topBgView  = [[UIView alloc] init];
    [self.view addSubview:topBgView];
    [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(getRectNavAndStatusHight);
        make.left.right.offset(0);
        make.height.mas_equalTo(120);
    }];
    
    
    UIImageView *payoutBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"支付超时"]];
    [topBgView addSubview:payoutBGView];
    [payoutBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    
    UILabel *payoutLabel = [[UILabel alloc] init];
    payoutLabel.textAlignment = NSTextAlignmentCenter;
    payoutLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    payoutLabel.textColor = Colorffffff;
    payoutLabel.text = @"支付超时，订单已关闭！";
    [topBgView addSubview:payoutLabel];
    [payoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(topBgView);
    }];
    
    //中间订单信息
    self.centerBGView = [[UIView alloc] init];
    self.centerBGView.backgroundColor = Colorffffff;
    [self.view addSubview:self.centerBGView];
    [self.centerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topBgView.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.height.mas_equalTo(79.5);
    }];
    
    [self.centerBGView addSubview:self.nameLabel];
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(14);
//        make.top.offset(17);
//    }];
    
    self.jieDuoShaoLabel = [[UILabel alloc] init];
    self.jieDuoShaoLabel.textColor = ColorBlack222;
    self.jieDuoShaoLabel.font = UIFONTTOOL12;
    [self.centerBGView addSubview:self.jieDuoShaoLabel];
    [self.jieDuoShaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(self.nameLabel);
    }];
    
    //    self.jieDuoShaoLabel.frame = CGRectMake(15, 54, 30, 13);
    
    self.huiseyuandian1 = [[UIView alloc] init];
    [self.centerBGView addSubview:self.huiseyuandian1];
    self.huiseyuandian1.backgroundColor = COLOR_With_Hex(0x999999);
    self.huiseyuandian1.layer.masksToBounds = YES;
    self.huiseyuandian1.layer.cornerRadius = 1;
    [self.huiseyuandian1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.jieDuoShaoLabel);
        make.left.mas_equalTo(self.jieDuoShaoLabel.mas_right).offset(9);
        make.size.mas_equalTo(CGSizeMake(2, 2));
    }];
//    self.huiseyuandian1.frame = CGRectMake(CGRectGetMaxX(self.jieDuoShaoLabel.frame)+9, 54+5.5, 2, 2);
    
    self.daiDuoJiuLabel = [[UILabel alloc] init];
    self.daiDuoJiuLabel.textColor = ColorBlack222;
    self.daiDuoJiuLabel.font = UIFONTTOOL12;
    [self.centerBGView addSubview:self.daiDuoJiuLabel];
    [self.daiDuoJiuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.huiseyuandian1.mas_right).offset(9);
        make.top.mas_equalTo(self.jieDuoShaoLabel);
    }];
    
//    self.daiDuoJiuLabel.frame = CGRectMake(CGRectGetMaxX(self.huiseyuandian1.frame)+9, 54, 30, 13);
    
    self.huiseyuandian2 = [[UIView alloc] init];
    [self.centerBGView addSubview:self.huiseyuandian2];
    self.huiseyuandian2.backgroundColor = COLOR_With_Hex(0x999999);
    self.huiseyuandian2.layer.masksToBounds = YES;
    self.huiseyuandian2.layer.cornerRadius = 1;
    [self.huiseyuandian2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.jieDuoShaoLabel);
        make.left.mas_equalTo(self.daiDuoJiuLabel.mas_right).offset(9);
        make.size.mas_equalTo(CGSizeMake(2, 2));
    }];
    
//    self.huiseyuandian2.frame = CGRectMake(CGRectGetMaxX(self.daiDuoJiuLabel.frame)+9, 54+5.5, 2, 2);
    
    [self.centerBGView addSubview:self.haveCardLabel];
    [self.haveCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.huiseyuandian2.mas_right).offset(9);
        make.centerY.mas_equalTo(self.jieDuoShaoLabel);
    }];
    
    
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = ColorBackground_Line;
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.centerBGView.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.height.mas_equalTo(1);
    }];
    
    //金额视图
    UIView *moneyBGView = [[UIView alloc] init];
    moneyBGView.backgroundColor = Colorffffff;

    [self.view addSubview:moneyBGView];
    [moneyBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(0);
        make.left.right.offset(0);
        make.height.mas_equalTo(50);
    }];
    [moneyBGView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(moneyBGView);
        make.right.offset(-20);
    }];
    
    
    //再去看看按钮
    UIButton *seeAgainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    seeAgainButton.backgroundColor = COLOR_With_Hex(0xe63c3f);
    seeAgainButton.titleLabel.font = UIFONTTOOL16;
    seeAgainButton.layer.cornerRadius = 17.5;
    [seeAgainButton setTitle:@"再去看看" forState:UIControlStateNormal];
    [seeAgainButton addTarget:self action:@selector(seeAgainButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:seeAgainButton];
    [seeAgainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(moneyBGView.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(35);
    }];
}

- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}



- (void)setupModelInfo {
    NSLog(@"%@",self.detailModel);
    self.nameLabel.text = self.detailModel.name;
    NSString *cion = [NSString stringWithFormat:@"%@",self.detailModel.cion];
    
    self.moneyLabel.text = [NSString stringWithFormat:@"抢单价 : %@金币",[self isKongWithString:cion]?@"0":cion];
    NSInteger loanStart = [self.detailModel.loanStartLimit integerValue];
    NSInteger loanTerm = [self.detailModel.loanTerm integerValue];
    
    CGFloat nameWide = [self getWidthWithTitle:self.nameLabel.text font:UIFONTTOOL15];
    self.nameLabel.frame = CGRectMake(14, 17, nameWide, 15);
//    BOOL jiHidden = ![self.detailModel.isWorryMoney boolValue];
//    BOOL tuijianHidden = ![self.detailModel.isRecommend boolValue];
    
    // 标签的顺序：实 社 公 微 推荐
    // @"tyd_gong",@"tyd_she",@"tyd_shi",@"tyd_wei",@"tyd_tuijian"
//    self.biaoqianArray = @[@"tyd_gong",@"tyd_she",@"tyd_shi",@"tyd_wei"].mutableCopy;
//
//    for (int i = 0; i < self.biaoqianArray.count; i++) {
//        UIImageView *labelImgView = [[UIImageView alloc] init];
//        [self.centerBGView addSubview:labelImgView];
//        labelImgView.frame = CGRectMake(14+nameWide+10+(15+8)*i, 17, 15, 15);
//        if (i==4) {
//            //后面要改成 if 推荐 is 1
//            labelImgView.frame = CGRectMake(14+nameWide+10+(15+8)*i, 17, 30, 15);
//        }
//        labelImgView.image = [UIImage imageNamed:self.biaoqianArray[i]];
//    }
    
    if(loanStart >= 10000){
        if (loanStart%10000 == 0) {
            self.loanStartLimit = [NSString stringWithFormat:@"%ld万",loanStart/10000];
        }else{
//            NSInteger balance = loanStart % 10000;
//            self.loanStartLimit = [NSString stringWithFormat:@"%ld.%ld万",loanStart/10000,loanStart%10000];
            self.loanStartLimit = [NSString stringWithFormat:@"%.1f万",loanStart/10000.0];
        }
    }else{
        self.loanStartLimit = loanStart?[@(loanStart) stringValue]:@"0";
    }
    
    if (loanTerm >=12 ) {
        if (loanTerm%12 == 0) {
            self.loanTerm = [NSString stringWithFormat:@"%ld年",loanTerm/12];
        }else{
            self.loanTerm = [NSString stringWithFormat:@"%ld年%ld个月",loanTerm/12,loanTerm%12];
        }
    }else{
        self.loanTerm = [NSString stringWithFormat:@"%ld个月",loanTerm];
    }
    
    
    
    
    NSString *namej = [NSString stringWithFormat:@"%@ ",[DENGFANGSingletonTime shareInstance].name[2]];
    if ([self isKongWithString:self.loanStartLimit] || [self.loanStartLimit integerValue] == 0) {
        self.jieDuoShaoLabel.text = namej;
    }else{
        self.jieDuoShaoLabel.text = [NSString stringWithFormat:@"%@%@",namej,self.loanStartLimit];
        [self configAttributeString:self.jieDuoShaoLabel.text rangeString:self.loanStartLimit withLabel:self.jieDuoShaoLabel];
    }
    
    NSString *named = [NSString stringWithFormat:@"%@ ",[DENGFANGSingletonTime shareInstance].name[1]];
    if ([self isKongWithString:self.loanTerm] || [self.loanTerm integerValue] == 0) {
        self.daiDuoJiuLabel.text = named;
    }else{
        self.daiDuoJiuLabel.text = [NSString stringWithFormat:@"%@%@",named,self.loanTerm];
        [self configAttributeString:self.daiDuoJiuLabel.text rangeString:self.loanTerm withLabel:self.daiDuoJiuLabel];
    }
    
    if ([self.detailModel.loanPurpose isEqualToString:@"5"]) {
        self.loanPurpose = @"其它";
    }else if ([self.detailModel.loanPurpose isEqualToString:@"0"]){
        self.loanPurpose = @"日常消费";
    }else if ([self.detailModel.loanPurpose isEqualToString:@"1"]){
        self.loanPurpose = @"购买车";
    }else if ([self.detailModel.loanPurpose isEqualToString:@"2"]){
        self.loanPurpose = @"购买房";
    }else if ([self.detailModel.loanPurpose isEqualToString:@"3"]){
        self.loanPurpose = @"教育培训";
    }else if ([self.detailModel.loanPurpose isEqualToString:@"4"]){
        self.loanPurpose = @"短期周转";
    }else if ([self.detailModel.loanPurpose isEqualToString:@"6"]){
        self.loanPurpose = @"旅游";
    }else if ([self.detailModel.loanPurpose isEqualToString:@"7"]){
        self.loanPurpose = @"房产装修";
    }else{
        self.loanPurpose = @"";
    }
    if ([self isKongWithString:self.loanPurpose]) {
        self.haveCardLabel.text = @"用途 ";
    }else{
        self.haveCardLabel.text = [NSString stringWithFormat:@"用途 %@",self.loanPurpose];
        [self configAttributeString:self.haveCardLabel.text rangeString:self.loanPurpose withLabel:self.haveCardLabel];
    }
    
//    self.haveCardLabel.text = self.isCreditCard;
}

- (BOOL)isKongWithString:(NSString *)string{
    NSString *str = [NSString stringWithFormat:@"%@",string]; //不转换偶尔会报错
    if ([str isEqualToString:@"<null>"] || [str isEqualToString:@""] || str == nil || [str isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}
- (void)configAttributeString:(NSString *)configString rangeString:(NSString *)rangeString withLabel:(UILabel *)label{
    NSString *jineString = configString;
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] initWithString:jineString];
    NSRange range = [jineString rangeOfString:rangeString];
    [mutableAttString addAttributes:@{NSFontAttributeName:UIFONTTOOL13,NSForegroundColorAttributeName:ColorZhuTiHongSe} range:range];
    [mutableAttString beginEditing];
    label.attributedText = mutableAttString;
}

#pragma mark -再去看看按钮点击
- (void)seeAgainButtonClick {
    SSH_KeHuXiangQingViewController *produceVC = [SSH_KeHuXiangQingViewController new];
    produceVC.orderNo = self.orderNo;
    produceVC.pageType = self.pageType;
    produceVC.creditinfoId = self.creditinfoId;
    produceVC.fromWhere = 3;
    produceVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:produceVC animated:YES];
}

@end
