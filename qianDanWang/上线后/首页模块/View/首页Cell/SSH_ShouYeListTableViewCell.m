//
//  SSH_ShouYeListTableViewCell.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/7.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ShouYeListTableViewCell.h"
#import "SSH_ImgANDLabelView.h"//左图右文字
#import "SSH_ShouYeListDetailView.h"
@interface SSH_ShouYeListTableViewCell ()

@property (strong, nonatomic) NSString *nameStr;
@property (assign, nonatomic) BOOL jiHidden;
@property (assign, nonatomic) BOOL tuijianHidden;

@property (nonatomic, strong) UIButton *rightBottomBut;

@property (strong, nonatomic) NSString *identityType;//身份类型（0：上班族公务员 1：企业主  2：自有职业者 3：学生）
@property (strong, nonatomic) NSString *income;//月收入  金额
@property (strong, nonatomic) NSString *carProduction;//车产 0
@property (strong, nonatomic) NSString *property;//房产 0
@property (strong, nonatomic) NSString *isInterest;//接受高息 0
@property (strong, nonatomic) NSString *isCreditCard;//信用卡（0：无、1：10000元以下、2：10001~30000元、3：30001~100000元、4：100000元以上）

@property (strong, nonatomic) NSString *loanStartLimit;//金额
@property (strong, nonatomic) NSString *loanTerm;//期限 （月）
@property (strong, nonatomic) NSString *loanPurpose;// 目的(0：日常消费 1：购买车 2：购买房 3：教育培训 4：短期周转 5：其它)
@property (nonatomic, strong) NSMutableArray *biaoqianArray;
@property (nonatomic, strong) UIView *labelBackView;

@property(nonatomic,strong)SSH_ShouYeListDetailView *detailView;

@end
@implementation SSH_ShouYeListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = ColorBackground_Line;
        
        [self configQiangDanCell];
    }
    return self;
}

-(void)setHomeCellModel:(SSH_HomeCreditxinxiListModel *)homeCellModel{
    //    if (_homeCellModel != homeCellModel) {
    //        _homeCellModel = homeCellModel;
    _homeCellModel = homeCellModel;
    
    if ([homeCellModel.identityType isEqualToString:@"0"]) {
        self.identityType = @"上班族";
    }else if ([homeCellModel.identityType isEqualToString:@"1"]){
        self.identityType = @"公务员";
    }else if ([homeCellModel.identityType isEqualToString:@"2"]){
        self.identityType = @"企业主";
    }else if ([homeCellModel.identityType isEqualToString:@"3"]){
        self.identityType = @"自由职业者";
    }else if ([homeCellModel.identityType isEqualToString:@"4"]){
        self.identityType = @"学生";
    }else{
        self.identityType = @"";
    }
    if ([self.identityType isEqualToString:@"企业主"]) {
        
        if ([homeCellModel.amountF isKindOfClass:[NSNull class]] || [homeCellModel.amountF isEqual:[NSNull null]] || homeCellModel.amountF == nil) {
            self.income = @"未知";
        }else if ([homeCellModel.amountF intValue] == 0) {
            self.income = [NSString stringWithFormat:@"年流水%@万以下",homeCellModel.endAmount];
        }else if ([homeCellModel.amountF intValue] != 0 && [homeCellModel.endAmount intValue] == 0){
            self.income = [NSString stringWithFormat:@"年流水%@万以上",homeCellModel.amountF];
        }else if ([homeCellModel.amountF intValue] != 0 && [homeCellModel.endAmount intValue] != 0){
            self.income = [NSString stringWithFormat:@"年流水%@-%@万",homeCellModel.amountF,homeCellModel.endAmount];
            //NSLog(@"==========%@============%@",homeCellModel.amountF,homeCellModel.endAmount);
        }
    }else{
        NSString *shouru = [NSString stringWithFormat:@"%@",homeCellModel.income];
        if ([self isKongWithString:shouru]) {
            self.income = @"";
        }else if ([shouru isEqualToString:@"0"]) {
            self.income = @"无月收入";
        }else{
            if([homeCellModel.income intValue] >= 10000){
                if ([homeCellModel.income intValue]%10000 == 0) {
                    self.income = [NSString stringWithFormat:@"月收入%d万",[homeCellModel.income intValue]/10000];
                }else{
                    int qian = [homeCellModel.income intValue]/1000;
                    float wan = qian/10.0;
                    self.income = [NSString stringWithFormat:@"月收入%.1f万",wan];
                }
            }else{
                self.income = [NSString stringWithFormat:@"月收入%@元",homeCellModel.income];
            }
        }
    }
    
    
    if ([homeCellModel.carProduction isEqualToString:@"0"] || [homeCellModel.carProduction isEqualToString:@"2"]) {
        self.carProduction = @"无车产";
    }else if ([homeCellModel.carProduction isEqualToString:@"1"] || [homeCellModel.carProduction isEqualToString:@"3"]) {
        self.carProduction = @"有车产";
    }else{
        self.carProduction = @"";
    }
    
    if ([homeCellModel.property isEqualToString:@"0"] || [homeCellModel.property isEqualToString:@"2"]) {
        self.property = @"无房产";
    }else if ([homeCellModel.property isEqualToString:@"1"] || [homeCellModel.property isEqualToString:@"3"]) {
        self.property = @"有房产";
    }else{
        self.property = @"";
    }
    
    if ([homeCellModel.isInterest isEqualToString:@"0"]) {
        self.isInterest = @"不接受高息";
    }else if ([homeCellModel.isInterest isEqualToString:@"1"]) {
        self.isInterest = @"接受高息";
    }else{
        self.isInterest = @"";
    }
    
    //（0：无、1：10000元以下、2：10001~30000元、3：30001~100000元、4：100000元以上）
    if ([homeCellModel.isCreditCard isEqualToString:@"0"]) {
        self.isCreditCard = @"无信用卡";
    }else if ([homeCellModel.isCreditCard isEqualToString:@"1"] || [homeCellModel.isCreditCard isEqualToString:@"2"] ||[homeCellModel.isCreditCard isEqualToString:@"3"] || [homeCellModel.isCreditCard intValue] == 4){
        self.isCreditCard = @"有信用卡";
    }else{
        self.isCreditCard = @"";
    }
    
    NSString *star = [NSString stringWithFormat:@"%@",homeCellModel.loanStartLimitF];
    NSString *endStr = [NSString stringWithFormat:@"%@",homeCellModel.loanEndLimit];
    if ([star isEqualToString:@"0"]) {
        self.loanStartLimit = [NSString stringWithFormat:@"%d万以下",[endStr intValue]/10000];
    } else if ([endStr isEqualToString:@"0"]) {
        self.loanStartLimit = [NSString stringWithFormat:@"%d万以上",[star intValue]/10000];
    } else {
        self.loanStartLimit = [NSString stringWithFormat:@"%d万~%d万",[star intValue]/10000,[endStr intValue]/10000];
    }
    
//    if([homeCellModel.loanStartLimit intValue] >= 10000){
//        if ([homeCellModel.loanStartLimit intValue]%10000 == 0) {
//            self.loanStartLimit = [NSString stringWithFormat:@"%d万",[homeCellModel.loanStartLimit intValue]/10000];
//        }else{
//            
//            int qian = [homeCellModel.loanStartLimit intValue]/1000;
//            float wan = qian/10.0;
//            self.loanStartLimit = [NSString stringWithFormat:@"%.1f万",wan];
//        }
//    }else{
//        self.loanStartLimit = [homeCellModel.loanStartLimit intValue]?homeCellModel.loanStartLimit:@"0";
//    }
    
    if ([homeCellModel.loanTerm intValue] >=12 ) {
        if ([homeCellModel.loanTerm intValue]%12 == 0) {
            self.loanTerm = [NSString stringWithFormat:@"%d年",[homeCellModel.loanTerm intValue]/12];
        }else{
            self.loanTerm = [NSString stringWithFormat:@"%d年%d个月",[homeCellModel.loanTerm intValue]/12,[homeCellModel.loanTerm intValue]%12];
        }
    }else{
        self.loanTerm = [NSString stringWithFormat:@"%d个月",[homeCellModel.loanTerm intValue]];
    }
    
    if ([homeCellModel.loanPurpose isEqualToString:@"5"]) {
        self.loanPurpose = @"其它";
    }else if ([homeCellModel.loanPurpose isEqualToString:@"0"]){
        self.loanPurpose = @"日常消费";
    }else if ([homeCellModel.loanPurpose isEqualToString:@"1"]){
        self.loanPurpose = @"购买车";
    }else if ([homeCellModel.loanPurpose isEqualToString:@"2"]){
        self.loanPurpose = @"购买房";
    }else if ([homeCellModel.loanPurpose isEqualToString:@"3"]){
        self.loanPurpose = @"教育培训";
    }else if ([homeCellModel.loanPurpose isEqualToString:@"4"]){
        self.loanPurpose = @"短期周转";
    }else if ([homeCellModel.loanPurpose isEqualToString:@"6"]){
        self.loanPurpose = @"旅游";
    }else if ([homeCellModel.loanPurpose isEqualToString:@"7"]){
        self.loanPurpose = @"房产装修";
    }else{
        self.loanPurpose = @"";
    }
    
    self.nameStr = homeCellModel.name;
    
    self.jiHidden = ![homeCellModel.isWorryMoney boolValue];
    self.tuijianHidden = ![homeCellModel.isRecommend boolValue];
    
    NSString *timeString = [NSString stringWithFormat:@"%@",homeCellModel.updateTime];
    NSString *time = [self isKongWithString:timeString]?homeCellModel.createTime:homeCellModel.updateTime;
    NSString *date = [NSDate dateWithTimeInterval:[time integerValue]/1000 format:@"yyyy-MM-dd HH:mm:ss"];
    self.timeLabel.text = [NSDate zj_timeInfoWithDateString:date];
    self.timeWidth = [self.timeLabel.text sizeWithFont:UIFONTTOOL12].width;
    
    self.biaoqianArray = [NSMutableArray array];
    
    if ([SSH_TOOL_GongJuLei isKongWithString:homeCellModel.isFund] || [homeCellModel.isFund isEqualToString:@"0"]) {
        
    }else{
        [self.biaoqianArray addObject:@"xgqd_gong"];
    }
    
    if ([SSH_TOOL_GongJuLei isKongWithString:homeCellModel.isSecurity] || [homeCellModel.isSecurity isEqualToString:@"0"]) {
        
    }else{
        [self.biaoqianArray addObject:@"xgqd_she"];
    }
    
    if ([SSH_TOOL_GongJuLei isKongWithString:homeCellModel.isRealName] || [homeCellModel.isRealName isEqualToString:@"0"]) {
        
    }else{
        [self.biaoqianArray addObject:@"xgqd_shi"];
    }
    
    if ([SSH_TOOL_GongJuLei isKongWithString:homeCellModel.isWeiliD] || [homeCellModel.isWeiliD isEqualToString:@"0"]) {
        
    }else{
        [self.biaoqianArray addObject:@"xgqd_wei"];
    }
    
    if ([SSH_TOOL_GongJuLei isKongWithString:homeCellModel.isRecommend] || [homeCellModel.isRecommend isEqualToString:@"0"]) {
        
    }else{
        [self.biaoqianArray addObject:@"tyd_tuijian"];
    }
    
    if ([SSH_TOOL_GongJuLei isKongWithString:homeCellModel.isDiscount] || [homeCellModel.isDiscount isEqualToString:@"0"]) {
        
    }else{
        [self.biaoqianArray addObject:@"xgqd_zhe"];
    }
    
    
    
    [self settingLayouts];
    [self setRightBottomButton];
    if ([homeCellModel.status isEqualToString:@"3"]) {
        self.beiQiangImgView.hidden = NO;
        self.rightBottomBut.backgroundColor = ColorBlack999;
        [self.rightBottomBut setTitle:@"已被抢" forState:UIControlStateNormal];
    }else{
        self.beiQiangImgView.hidden = YES;
        self.rightBottomBut.backgroundColor = COLOR_WITH_HEX(0x0062ff);
        [self.rightBottomBut setTitle:@"可抢单" forState:UIControlStateNormal];
    }
    //    }
}

//FIXME: 设置右下叫按钮
- (void)setRightBottomButton {
    self.rightBottomBut = [[UIButton alloc] init];
    [self.backContentView addSubview:self.rightBottomBut];
    [self.rightBottomBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-7);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    self.rightBottomBut.layer.cornerRadius = 15;
}

- (void)settingLayouts{
    
    self.customNameLabel.text = self.nameStr;
    CGFloat nameWide = [self getWidthWithTitle:self.customNameLabel.text font:UIFONTTOOL15];
    self.customNameLabel.frame = CGRectMake(14, 14.5, nameWide, 15);
    
    self.labelBackView.frame = CGRectMake(14+nameWide, 14.5, 150, 17);
    [self.labelBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.biaoqianArray.count; i++) {
        
        UIImageView *labelImgView = [[UIImageView alloc] init];
        [self.labelBackView addSubview:labelImgView];
        
        labelImgView.frame = CGRectMake(10+(17+8)*i, 0, 23, 17);
        
        if ([self.biaoqianArray containsObject:@"tyd_tuijian"]) {
            if (i == [self.biaoqianArray indexOfObject:@"tyd_tuijian"]) {
                labelImgView.frame = CGRectMake(10+(17+8)*i, 0, 36, 17);
            }
            
        }
        labelImgView.image = [UIImage imageNamed:self.biaoqianArray[i]];
    }
    
    if ([self.biaoqianArray containsObject:@"tyd_tuijian"]) {
        self.yiShenHeImageView.frame = CGRectMake(14+nameWide+10+(17+8)*self.biaoqianArray.count+15, self.labelBackView.y+(self.labelBackView.height-19)*0.5, 50, 17);
    }else{
        self.yiShenHeImageView.frame = CGRectMake(14+nameWide+10+(17+8)*self.biaoqianArray.count, self.labelBackView.y+(self.labelBackView.height-19)*0.5, 50, 17);
    }
    if ([self.homeCellModel.blacklistReview isEqualToString:@"1"]) {
        self.yiShenHeImageView.hidden = NO;
    }else{
        self.yiShenHeImageView.hidden = YES;
    }
    
    self.timeLabel.frame = CGRectMake(self.rightArrowImgView.x-self.timeWidth-10, 16.5, self.timeWidth, 12);
    
    NSString *namej = [NSString stringWithFormat:@"%@ ",[DENGFANGSingletonTime shareInstance].name[2]];
    if ([self isKongWithString:self.loanStartLimit] || [self.loanStartLimit intValue] == 0) {
        self.jieDuoShaoLabel.text = namej;
    }else{
        self.jieDuoShaoLabel.text = [NSString stringWithFormat:@"%@%@",namej,self.loanStartLimit];
        [self configAttributeString:self.jieDuoShaoLabel.text rangeString:self.loanStartLimit withLabel:self.jieDuoShaoLabel];
    }
    CGFloat wide1 = [self getWidthWithTitle:self.jieDuoShaoLabel.text font:UIFONTTOOL13];
    self.jieDuoShaoLabel.frame = CGRectMake(15, 46, wide1, 13);
    
    
//    self.huiseyuandian1.frame = CGRectMake(CGRectGetMaxX(self.jieDuoShaoLabel.frame)+9, 46+5.5, 2, 2);
//    NSString *named = [NSString stringWithFormat:@"%@ ",[DENGFANGSingletonTime shareInstance].name[1]];
//    if ([self isKongWithString:self.loanTerm] || [self.loanTerm intValue] == 0) {
//        self.daiDuoJiuLabel.text = named;
//    }else{
//        self.daiDuoJiuLabel.text = [NSString stringWithFormat:@"%@%@",named,self.loanTerm];
//        [self configAttributeString:self.daiDuoJiuLabel.text rangeString:self.loanTerm withLabel:self.daiDuoJiuLabel];
//    }
//    CGFloat wide2 = [self getWidthWithTitle:self.daiDuoJiuLabel.text font:UIFONTTOOL13];
//    self.daiDuoJiuLabel.frame = CGRectMake(CGRectGetMaxX(self.huiseyuandian1.frame)+9, 46, wide2, 13);
    
//    self.huiseyuandian2.frame = CGRectMake(CGRectGetMaxX(self.daiDuoJiuLabel.frame)+9, 46+5.5, 2, 2);
    
//    self.yongTuLabel.text = [NSString stringWithFormat:@"用途 %@",self.loanPurpose];
//    self.yongTuLabel.frame = CGRectMake(CGRectGetMaxX(self.huiseyuandian2.frame)+9, 46, 90, 13);
//    [self configAttributeString:self.yongTuLabel.text rangeString:self.loanPurpose withLabel:self.yongTuLabel];
    
    self.lineLabel.frame = CGRectMake(15, CGRectGetMaxY(self.daiDuoJiuLabel.frame)+16, SCREEN_WIDTH-30, 0.5);
    
    self.detailView.isQuanGuo = self.isQuanGuo;
//    self.detailView.gaoEZhuanQu = self.gaoEZhuanQu;
    self.detailView.homeCellModel = self.homeCellModel;
    
    //高额专区
    
    
    NSString *fangChanStr = [NSString stringWithFormat:@"%@",_homeCellModel.property];
    NSString *chechanStr = [NSString stringWithFormat:@"%@",_homeCellModel.carProduction];
    if (self.isQuanGuo&&[SSH_TOOL_GongJuLei isKongWithString:fangChanStr]&&[SSH_TOOL_GongJuLei isKongWithString:chechanStr]) {
        
        self.detailView.frame = CGRectMake(15, CGRectGetMaxY(self.lineLabel.frame)+14, SCREEN_WIDTH-30, 75-13-15);
        self.less = 13+15;
    }else{
        self.detailView.frame = CGRectMake(15, CGRectGetMaxY(self.lineLabel.frame)+14, SCREEN_WIDTH-30, 75);
        self.less = 0;
    }
    
    
    
}

- (void)configQiangDanCell{
    
    self.backContentView = [[UIView alloc] init];
    self.backContentView.backgroundColor = COLORWHITE;
    [self.contentView addSubview:self.backContentView];
    self.backContentView.layer.cornerRadius = 8;
    [self.backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(4);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-4);
    }];
    
    self.customNameLabel = [[UILabel alloc] init];
    [self.backContentView addSubview:self.customNameLabel];
    self.customNameLabel.font = UIFONTTOOL15;
    self.customNameLabel.text = self.nameStr;
    self.customNameLabel.textColor = ColorBlack222;
    self.customNameLabel.frame = CGRectMake(14, 14.5, 100, 15);
    
    self.labelBackView = [[UIView alloc] init];
    [self.backContentView addSubview:self.labelBackView];
    self.labelBackView.frame = CGRectMake(114, 14.5, 100, 15);
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = COLOR_With_Hex(0x999999);
    self.timeLabel.font = UIFONTTOOL12;
    [self.backContentView addSubview:self.timeLabel];
    //    self.timeLabel.frame = CGRectMake(100, 16.5, 50, 12);
    
    self.yiShenHeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yishenhe"]];
    [self.backContentView addSubview:self.yiShenHeImageView];
    //    self.yiShenHeImageView.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame)+9, 14.5, 50, 15);
    self.yiShenHeImageView.hidden = YES;
    
    self.rightArrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chanpinjiantou"]];
    [self.backContentView addSubview:self.rightArrowImgView];
    self.rightArrowImgView.frame = CGRectMake(SCREEN_WIDTH-45-8, 15, 8, 13);
    
    self.jieDuoShaoLabel = [[UILabel alloc] init];
    self.jieDuoShaoLabel.textColor = ColorBlack222;
    self.jieDuoShaoLabel.font = UIFONTTOOL13;
    [self.backContentView addSubview:self.jieDuoShaoLabel];
    self.jieDuoShaoLabel.frame = CGRectMake(15, 46, 30, 13);
    
    self.huiseyuandian1 = [[UIView alloc] init];
//    [self.backContentView addSubview:self.huiseyuandian1];
    self.huiseyuandian1.backgroundColor = COLOR_With_Hex(0x999999);
    self.huiseyuandian1.layer.masksToBounds = YES;
    self.huiseyuandian1.layer.cornerRadius = 1;
    self.huiseyuandian1.frame = CGRectMake(CGRectGetMaxX(self.jieDuoShaoLabel.frame)+9, 46+5.5, 2, 2);
    
    self.daiDuoJiuLabel = [[UILabel alloc] init];
    self.daiDuoJiuLabel.textColor = ColorBlack222;
    self.daiDuoJiuLabel.font = UIFONTTOOL13;
    //期限隐藏
//    [self.backContentView addSubview:self.daiDuoJiuLabel];
    self.daiDuoJiuLabel.frame = CGRectMake(CGRectGetMaxX(self.huiseyuandian1.frame)+9, 46, 30, 13);
    
    self.huiseyuandian2 = [[UIView alloc] init];
//    [self.backContentView addSubview:self.huiseyuandian2];
    self.huiseyuandian2.backgroundColor = COLOR_With_Hex(0x999999);
    self.huiseyuandian2.layer.masksToBounds = YES;
    self.huiseyuandian2.layer.cornerRadius = 1;
    self.huiseyuandian2.frame = CGRectMake(CGRectGetMaxX(self.daiDuoJiuLabel.frame)+9, 46+5.5, 2, 2);
    
    self.yongTuLabel = [[UILabel alloc] init];
    self.yongTuLabel.textColor = ColorBlack222;
    self.yongTuLabel.font = UIFONTTOOL13;
    //用途隐藏
//    [self.backContentView addSubview:self.yongTuLabel];
    self.yongTuLabel.frame = CGRectMake(CGRectGetMaxX(self.huiseyuandian2.frame)+9, 46, 90, 13);
    
    self.lineLabel = [[UIView alloc] init];
    [self.backContentView addSubview:self.lineLabel];
    self.lineLabel.backgroundColor = ColorLineeee;
    self.lineLabel.frame = CGRectMake(15, CGRectGetMaxY(self.daiDuoJiuLabel.frame)+16, SCREEN_WIDTH-30, 0.5);
    
    //1.7版本修改
    //
    self.detailView = [[SSH_ShouYeListDetailView alloc] init];
    [self.backContentView addSubview:self.detailView];
    self.detailView.frame = CGRectMake(15, CGRectGetMaxY(self.lineLabel.frame)+14, SCREEN_WIDTH-30, 75);
    
    //FIXME: 订单被抢
    self.beiQiangImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shuiyin"]];
//    [self.backContentView addSubview:self.beiQiangImgView];
//    [self.beiQiangImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(92);
//        make.height.mas_equalTo(72);
//        make.top.mas_equalTo(35);
//        make.right.mas_equalTo(-15);
//    }];
    
    //收藏按钮
    self.shouCangBtn = [[UIButton alloc]init];
    [self.backContentView addSubview:self.shouCangBtn];
    [self.shouCangBtn setImage:[UIImage imageNamed:@"shoucang_no"] forState:UIControlStateNormal];
    [self.shouCangBtn setImageEdgeInsets:UIEdgeInsetsMake(12, 13, 12, 13)];
    [self.shouCangBtn addTarget:self action:@selector(shouCangBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.shouCangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    self.shouCangBtn.hidden = YES;
    
}

- (void)configAttributeString:(NSString *)configString rangeString:(NSString *)rangeString withLabel:(UILabel *)label{
    
    NSString *jineString = configString;
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] initWithString:jineString];
    //[NSString stringWithFormat:@"%@",rangeString] 不转换偶尔会报错
    NSRange range = [jineString rangeOfString:[NSString stringWithFormat:@"%@",rangeString]];
    [mutableAttString addAttributes:@{NSFontAttributeName:UIFONTTOOL13,NSForegroundColorAttributeName:COLOR_WITH_HEX(0xe63c3f)} range:range];
    [mutableAttString beginEditing];
    label.attributedText = mutableAttString;
}

- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

-(void)shouCangBtnClicked:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(shouCangBtnClicked:)]) {
        [self.delegate shouCangBtnClicked:btn];
    }
    
}
-(void)setChildBtnTag:(NSInteger)tag{
    self.shouCangBtn.tag = tag;
}

- (BOOL)isKongWithString:(NSString *)string{
    NSString *str = [NSString stringWithFormat:@"%@",string]; //不转换偶尔会报错
    if ([str isEqualToString:@"<null>"] || [str isEqualToString:@""] || str == nil || [str isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
