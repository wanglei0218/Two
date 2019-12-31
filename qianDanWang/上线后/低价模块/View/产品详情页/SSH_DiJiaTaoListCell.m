//
//  SSH_DiJiaTaoListCell.m
//  DENGFANGSC
//
//  Created by LY on 2018/11/27.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_DiJiaTaoListCell.h"
#import "SSH_ShouYeListDetailView.h"


#define JieKuanJinEWidth (ScreenWidth-30)/3

@interface SSH_DiJiaTaoListCell ()

@property (strong, nonatomic) NSString *nameStr;
@property (assign, nonatomic) BOOL jiHidden;
@property (assign, nonatomic) BOOL tuijianHidden;

@property (strong, nonatomic) NSString *identityType;//身份类型（0：上班族公务员 1：企业主  2：自有职业者 3：学生）
@property (strong, nonatomic) NSString *income;//月收入  金额
@property (strong, nonatomic) NSString *carProduction;//车产 0
@property (strong, nonatomic) NSString *property;//房产 0
@property (strong, nonatomic) NSString *isInterest;//接受高息 0
@property (strong, nonatomic) NSString *isCreditCard;//信用卡（0：无、1：10000元以下、2：10001~30000元、3：30001~100000元、4：100000元以上）

@property (strong, nonatomic) NSString *loanStartLimit;//金额
@property (strong, nonatomic) NSString *loanTerm;//期限 （月）
@property (strong, nonatomic) NSString *loanPurpose;// 目的(0：日常消费 1：购买车 2：购买房 3：教育培训 4：短期周转 5：其它 6：旅游  7：房产装修)
@property (nonatomic, strong) NSString *mobileString;//手机号
@property (nonatomic, strong) NSMutableArray *biaoqianArray;
@property (nonatomic, strong) UIView *labelBackView;

@property(nonatomic,strong)SSH_ShouYeListDetailView *detailView;

@end

@implementation SSH_DiJiaTaoListCell

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
    if (_homeCellModel != homeCellModel) {
        _homeCellModel = homeCellModel;
    
        self.mobileString = homeCellModel.mobile;
        
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
                self.income = [NSString stringWithFormat:@"%@万以下",homeCellModel.endAmount];
            }else if ([homeCellModel.amountF intValue] != 0 && [homeCellModel.endAmount intValue] == 0){
                self.income = [NSString stringWithFormat:@"%@万以上",homeCellModel.amountF];
            }else if ([homeCellModel.amountF intValue] != 0 && [homeCellModel.endAmount intValue] != 0){
                self.income = [NSString stringWithFormat:@"%@-%@万",homeCellModel.amountF,homeCellModel.endAmount];
                //NSLog(@"==========%@============%@",homeCellModel.amountF,homeCellModel.endAmount);
            }
        }else{
            NSString *yueshouru;
            NSString *beginYue = [NSString stringWithFormat:@"%@",self.homeCellModel.incomeF];
            NSString *endYue = [NSString stringWithFormat:@"%@",self.homeCellModel.endIncome];
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
            }
            self.income = yueshouru;
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
//        if([star intValue] >= 10000){
//            if ([homeCellModel.loanStartLimit intValue]%10000 == 0) {
//                self.loanStartLimit = [NSString stringWithFormat:@"%d~%d万",[homeCellModel.loanStartLimit intValue]/10000,[endStr intValue]/10000];
//            }else{
//
//                int qian = [homeCellModel.loanStartLimit intValue]/1000;
//                float wan = qian/10.0;
//                self.loanStartLimit = [NSString stringWithFormat:@"%.1f万",wan];
//            }
//        }else{
//            self.loanStartLimit = [homeCellModel.loanStartLimit intValue]?homeCellModel.loanStartLimit:@"0";
//        }
        
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
        NSString * date = [NSDate dateWithTimeInterval:[time integerValue]/1000 format:@"yyyy-MM-dd HH:mm:ss"];
        //self.timeLabel.text = [NSString stringWithFormat:@"申请时间：%@",[NSDate zj_timeInfoWithDateString:date]];
        self.timeLabel.text = [NSString stringWithFormat:@"申请时间：%@",date];
        
        self.timeWidth = [self.timeLabel.text sizeWithFont:UIFONTTOOL12].width;
        
        self.liulanLab.text = [NSString stringWithFormat:@"%@人正在浏览",homeCellModel.onlineView];
        self.liulanWidth = [self.liulanLab.text sizeWithFont:UIFONTTOOL12].width;
        
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
        
//        self.dijiadan_label.hidden = !homeCellModel.isLowPrice;
        if ([homeCellModel.status isEqualToString:@"3"]) {
            self.beiQiangImgView.hidden = NO;
            self.backContentView.backgroundColor = Colore5e5e5;
            self.liulanLab.hidden = YES;
        }else{
            self.beiQiangImgView.hidden = YES;
            self.backContentView.backgroundColor = COLORWHITE;
            self.liulanLab.hidden = NO;
        }
    }
}

- (void)settingLayouts{
    
    self.customNameLabel.text = self.nameStr;
    CGFloat nameWide = [self getWidthWithTitle:self.customNameLabel.text font:UIFONTTOOL15];
    self.customNameLabel.frame = CGRectMake(14, 14.5, nameWide, 15);
    self.labelBackView.frame = CGRectMake(14+nameWide, 14.5, 100, 17);
    [self.labelBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.biaoqianArray.count; i++) {
        
        UIImageView *labelImgView = [[UIImageView alloc] init];
        [self.labelBackView addSubview:labelImgView];
        labelImgView.frame = CGRectMake(10+(15+8)*i, 0, 20, 15);
        
        if ([self.biaoqianArray containsObject:@"tyd_tuijian"]) {
            if (i == [self.biaoqianArray indexOfObject:@"tyd_tuijian"]) {
                labelImgView.frame = CGRectMake(10+(15+8)*i, 0, 30, 15);
            }
        }
        labelImgView.image = [UIImage imageNamed:self.biaoqianArray[i]];
    }
    
    if ([self.biaoqianArray containsObject:@"tyd_tuijian"]) {
        self.yiShenHeImageView.frame = CGRectMake(14+nameWide+10+(15+8)*self.biaoqianArray.count+15, self.labelBackView.y+(self.labelBackView.height-16)*0.5, 50, 16);
    }else{
        self.yiShenHeImageView.frame = CGRectMake(14+nameWide+10+(15+8)*self.biaoqianArray.count, self.labelBackView.y+(self.labelBackView.height-16)*0.5, 50, 16);
    }
    if ([self.homeCellModel.blacklistReview isEqualToString:@"1"]) {
        self.yiShenHeImageView.hidden = NO;
    }else{
        self.yiShenHeImageView.hidden = YES;
    }
    
    //FIXME: 时间
    self.timeLabel.frame = CGRectMake(15, CGRectGetMaxY(self.customNameLabel.frame)+17, self.timeWidth, 12);
    
    self.jieKuanJinEView.keyLabel.text = [NSString stringWithFormat:@"%@%@",[self.jieKuanJinEView.keyLabel.text substringToIndex:5],self.loanStartLimit];
    [self configAttributeTwoString:self.jieKuanJinEView.keyLabel.text rangeString:self.loanStartLimit withLabel:self.jieKuanJinEView.keyLabel];
    CGFloat wide1 = [self getWidthWithTitle:self.jieKuanJinEView.keyLabel.text font:UIFONTTOOL16];
    self.jieKuanJinEView.frame = CGRectMake(5, CGRectGetMaxY(self.timeLabel.frame)+5, wide1, 40);
    
    self.jieKuanQiXianView.keyLabel.text = [NSString stringWithFormat:@"%@ %@",self.jieKuanQiXianView.keyLabel.text,self.loanTerm];
    [self configAttributeTwoString:self.jieKuanQiXianView.keyLabel.text rangeString:self.loanTerm withLabel:self.jieKuanQiXianView.keyLabel];
    CGFloat wide2 = [self getWidthWithTitle:self.jieKuanQiXianView.keyLabel.text font:UIFONTTOOL13];
    self.jieKuanQiXianView.keyLabel.frame = CGRectMake(CGRectGetMaxX(self.huiseyuandian1.frame)+9, 46, wide2, 13);
    self.jieKuanQiXianView.frame = CGRectMake(25+wide1, 44.5, wide2, 40);
    
    self.yongTuView.keyLabel.text = [NSString stringWithFormat:@"%@ %@",self.yongTuView.keyLabel.text,self.loanPurpose];
    [self configAttributeTwoString:self.yongTuView.keyLabel.text rangeString:self.loanPurpose withLabel:self.yongTuView.keyLabel];
    self.yongTuView.frame = CGRectMake(35+wide1+wide2, 44.5, 90, 40);
    self.lineLabel.frame = CGRectMake(15, CGRectGetMaxY(self.jieKuanJinEView.frame), SCREEN_WIDTH-30, 0.5);

    NSString *fangChanStr = [NSString stringWithFormat:@"%@",_homeCellModel.property];
    NSString *chechanStr = [NSString stringWithFormat:@"%@",_homeCellModel.carProduction];
    if (self.isQuanGuo&&[SSH_TOOL_GongJuLei isKongWithString:fangChanStr]&&[SSH_TOOL_GongJuLei isKongWithString:chechanStr]) {
        
        self.detailView.frame = CGRectMake(15, CGRectGetMaxY(self.lineLabel.frame)+14, SCREEN_WIDTH-30, 70-13-15);
        self.less = 13+15;
    }else{
        self.detailView.frame = CGRectMake(15, CGRectGetMaxY(self.lineLabel.frame)+14, SCREEN_WIDTH-30, 70);
        self.less = 0;
    }
    self.detailView.frame = CGRectMake(0, CGRectGetMaxY(self.lineLabel.frame)+14, 0, 0);
    self.detailView.hidden = YES;
    self.detailView.isQuanGuo = self.isQuanGuo;
    self.detailView.isDetail = YES;
//    self.detailView.gaoEZhuanQu = self.gaoEZhuanQu;
    self.detailView.homeCellModel = self.homeCellModel;
//    self.detailView.frame = CGRectMake(15, CGRectGetMaxY(self.lineLabel.frame)+14, SCREEN_WIDTH-30, 70);
    
    //需要重新赋值
    self.threeLineLabel.frame = CGRectMake(15, CGRectGetMaxY(self.detailView.frame)+13, ScreenWidth-30, 0.5);
    self.phoneNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.jieKuanJinEView.frame), SCREEN_WIDTH, 44);
    
     NSString * phone = [NSString stringWithFormat:@"%@（抢单后可联系）",self.mobileString];
     [self configAttributeString:phone rangeString:@"（抢单后可联系）" withLabel:self.phoneLabel];
    
    //FIXME: 浏览人数
    self.liulanLab.frame = CGRectMake(SCREEN_WIDTH-self.liulanWidth-15, 16.5, self.liulanWidth, 12);
    //CGRectMake(self.phoneBtn.x-self.liulanWidth-10, self.phoneLabel.y, self.liulanWidth, self.phoneLabel.height);
    
    if (self.fromWhere == 0 || self.fromWhere == 1) {
//        self.sixLabelBackView.hidden = YES;
//        self.phoneNumberView.frame = CGRectMake(0, 107, SCREEN_WIDTH, 44);
        self.phoneNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.jieKuanJinEView.frame), SCREEN_WIDTH, 44);
//        self.threeLineLabel.hidden = YES;
        if (self.fromWhere == 0) {
            self.phoneBtn.hidden = YES;
        }
    }else if (self.fromWhere == 4){
        self.sixLabelBackView.hidden = YES;
        self.lineLabel.hidden = YES;
        self.threeLineLabel.hidden = YES;
        self.phoneNumberView.hidden = YES;
    }
}



- (void)configQiangDanCell{
    
    self.backContentView = [[UIView alloc] init];
    self.backContentView.backgroundColor = COLORWHITE;
    [self addSubview:self.backContentView];
    [self.backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-7);
    }];
    self.customNameLabel = [[UILabel alloc] init];
    [self.backContentView addSubview:self.customNameLabel];
    self.customNameLabel.font = UIFONTTOOL15;
    self.customNameLabel.text = self.nameStr;
    self.customNameLabel.textColor = ColorBlack222;
    self.customNameLabel.frame = CGRectMake(14, 16, 100, 15);
    
    self.labelBackView = [[UIView alloc] init];
    [self.backContentView addSubview:self.labelBackView];
    self.labelBackView.frame = CGRectMake(114, 14.5, 100, 15);
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = COLOR_With_Hex(0x999999);
    self.timeLabel.font = UIFONTTOOL12;
    [self.backContentView addSubview:self.timeLabel];
//    self.timeLabel.frame = CGRectMake(100, 21.5, 50, 12);
    
    self.yiShenHeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yishenhe"]];
    [self.backContentView addSubview:self.yiShenHeImageView];
//    self.yiShenHeImageView.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame)+9, 14.5, 50, 15);
    self.yiShenHeImageView.hidden = YES;
    
//    self.rightArrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chanpinjiantou"]];
//    [self.backContentView addSubview:self.rightArrowImgView];
//    self.rightArrowImgView.frame = CGRectMake(SCREEN_WIDTH-15, 15, 8, 13);
    
    UIView *firstLineLabel = [[UIView alloc] init];
//    [self.backContentView addSubview:firstLineLabel];
    firstLineLabel.backgroundColor = ColorLineeee;
    firstLineLabel.frame = CGRectMake(15, 44, ScreenWidth-30, 0.5);
    
    self.jieKuanJinEView = [[SSH_LabelANDLabelView alloc] init];
//    self.jieKuanJinEView.keyLabel.text = [NSString stringWithFormat:@"%@金额",[DENGFANGSingletonTime shareInstance].name[0]];
    [self.backContentView addSubview:self.jieKuanJinEView];
    
    //FIXME: ----------------------------------------------------额度
    self.jieKuanJinEView.frame = CGRectMake(0, 44.5, JieKuanJinEWidth, 62);
    NSString *namej = [NSString stringWithFormat:@"%@款金额：",[DENGFANGSingletonTime shareInstance].name[2]];
    if ([self isKongWithString:self.loanStartLimit] || [self.loanStartLimit intValue] == 0) {
        self.jieKuanJinEView.keyLabel.text = namej;
    }else{
        self.jieKuanJinEView.keyLabel.text = [NSString stringWithFormat:@"%@%@",namej,self.loanStartLimit];
        [self configAttributeTwoString:self.jieKuanJinEView.keyLabel.text rangeString:self.loanStartLimit withLabel:self.jieKuanJinEView.keyLabel];
    }
    CGFloat wide1 = [self getWidthWithTitle:self.jieKuanJinEView.keyLabel.text font:UIFONTTOOL16];
    self.jieKuanJinEView.keyLabel.frame = CGRectMake(5, 46, wide1, 13);
    self.huiseyuandian1.frame = CGRectMake(CGRectGetMaxX(self.jieKuanJinEView.keyLabel.frame)+9, 46+5.5, 2, 2);
    
    //FIXME: ----------------------------------------------------期限
    self.jieKuanQiXianView = [[SSH_LabelANDLabelView alloc] init];
    self.jieKuanQiXianView.keyLabel.text = [NSString stringWithFormat:@"%@期限",[DENGFANGSingletonTime shareInstance].name[0]];
    
    //期限隐藏
//    [self.backContentView addSubview:self.jieKuanQiXianView];
    self.jieKuanQiXianView.frame = CGRectMake(15+JieKuanJinEWidth, 44.5, JieKuanJinEWidth, 62);
    
    NSString *named = [NSString stringWithFormat:@"%@ ",[DENGFANGSingletonTime shareInstance].name[1]];
    if ([self isKongWithString:self.loanTerm] || [self.loanTerm intValue] == 0) {
        self.jieKuanQiXianView.keyLabel.text = named;
    }else{
        self.jieKuanQiXianView.keyLabel.text = [NSString stringWithFormat:@"%@%@",named,self.loanTerm];
        [self configAttributeTwoString:self.jieKuanQiXianView.keyLabel.text rangeString:self.loanTerm withLabel:self.jieKuanQiXianView.keyLabel];
    }
    CGFloat wide2 = [self getWidthWithTitle:self.jieKuanQiXianView.keyLabel.text font:UIFONTTOOL13];
    self.jieKuanQiXianView.keyLabel.frame = CGRectMake(CGRectGetMaxX(self.huiseyuandian1.frame)+9, 46, wide2, 13);
    self.huiseyuandian2.frame = CGRectMake(CGRectGetMaxX(self.jieKuanQiXianView.keyLabel.frame)+9, 46+5.5, 2, 2);

    
    //----------------------------------------------------用途
    self.yongTuView = [[SSH_LabelANDLabelView alloc] init];
    //用途隐藏
//    [self.backContentView addSubview:self.yongTuView];
    self.yongTuView.frame = CGRectMake(15+JieKuanJinEWidth*2, 44.5, JieKuanJinEWidth, 62);

    self.yongTuView.keyLabel.text = [NSString stringWithFormat:@"用途 %@",self.loanPurpose];
    if (self.loanPurpose.length == 0 || [self.loanPurpose isEqualToString:@"(null)"]) {
        self.yongTuView.keyLabel.text = @"用途 ";
    }else{
        self.yongTuView.keyLabel.text = [NSString stringWithFormat:@"%@%@",named,self.loanTerm];
        [self configAttributeTwoString:self.yongTuView.keyLabel.text rangeString:self.loanPurpose withLabel:self.yongTuView.keyLabel];
    }
    
    self.lineLabel = [[UIView alloc] init];
    [self.backContentView addSubview:self.lineLabel];
    self.lineLabel.backgroundColor = ColorLineeee;
    self.lineLabel.frame = CGRectMake(15, CGRectGetMaxY(self.jieKuanJinEView.frame)+15, SCREEN_WIDTH-30, 0.5);

    //1.7版本修改
    //
    self.detailView = [[SSH_ShouYeListDetailView alloc] init];
//    [self.backContentView addSubview:self.detailView];
    self.detailView.frame = CGRectMake(15, CGRectGetMaxY(self.lineLabel.frame)+14, SCREEN_WIDTH-30, 70);

    self.threeLineLabel = [[UIView alloc] init];
//    [self.backContentView addSubview:self.threeLineLabel];
    self.threeLineLabel.backgroundColor = ColorLineeee;
    self.threeLineLabel.frame = CGRectMake(15, CGRectGetMaxY(self.detailView.frame)+13, ScreenWidth-30, 0.5);
    
    self.phoneNumberView = [[UIView alloc]init];
    self.phoneNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.jieKuanJinEView.frame), SCREEN_WIDTH, 44);
    self.phoneNumberView.backgroundColor = COLORWHITE;
    [self.backContentView addSubview:self.phoneNumberView];
    self.phoneNumberView.backgroundColor = [UIColor clearColor];
    //电话Label
    self.phoneLabel = [[UILabel alloc] init];
    self.phoneLabel.textColor = ColorBlack222;
    self.phoneLabel.font = UIFONTTOOL14;
    [self.phoneNumberView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(220);
        make.bottom.mas_equalTo(0);
    }];
    
    //电话按钮
    self.phoneBtn = [[UIButton alloc]init];
    [self.phoneNumberView addSubview:self.phoneBtn];
    [self.phoneBtn setImage:[UIImage imageNamed:@"dianhuahui"] forState:UIControlStateNormal];
    [self.phoneBtn setImage:[UIImage imageNamed:@"dianhua"] forState:UIControlStateSelected];
    [self.phoneBtn addTarget:self action:@selector(cellPhoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(25);
        make.centerY.mas_equalTo(self.phoneLabel);
        make.right.mas_equalTo(-15);
    }];
    
    //浏览人数
    UILabel *liulanLab = [[UILabel alloc ]init];
    liulanLab.textColor = COLOR_WITH_HEX(0x999999);
    liulanLab.font = UIFONTTOOL12;
    [self.backContentView addSubview:liulanLab];
//    [self.phoneNumberView addSubview:liulanLab];
    self.liulanLab = liulanLab;

//    self.bottomGrayView = [[UIView alloc] init];
//    [self.backContentView addSubview:self.bottomGrayView];
//    self.bottomGrayView.backgroundColor = ColorLineeee;
//    self.bottomGrayView.frame = CGRectMake(0, CGRectGetMaxY(self.phoneNumberView.frame), ScreenWidth, 7);
    
    self.beiQiangImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shuiyin"]];
    [self.backContentView addSubview:self.beiQiangImgView];
    self.beiQiangImgView.frame = CGRectMake(ScreenWidth-15-92, 110, 92, 72);


    
}

//- (void)shoucangAlertAction{
//    self.shouCangAlertButton.hidden = YES;
//    [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"shouCangAlert"];
//}

- (void)configAttributeString:(NSString *)configString rangeString:(NSString *)rangeString withLabel:(UILabel *)label{
    
    NSString *jineString = configString;
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] initWithString:jineString];
    NSRange range = [jineString rangeOfString:rangeString];
    [mutableAttString addAttributes:@{NSFontAttributeName:UIFONTTOOL13,NSForegroundColorAttributeName:ColorBlack999} range:range];
    [mutableAttString beginEditing];
    label.attributedText = mutableAttString;
}
- (void)configAttributeTwoString:(NSString *)configString rangeString:(NSString *)rangeString withLabel:(UILabel *)label{
    
    NSString *jineString = configString;
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] initWithString:jineString];
    //[NSString stringWithFormat:@"%@",rangeString] 不转换偶尔会报错
    NSRange range = [jineString rangeOfString:[NSString stringWithFormat:@"%@",rangeString]];
    [mutableAttString addAttributes:@{NSFontAttributeName:UIFONTTOOL16,NSForegroundColorAttributeName:COLOR_WITH_HEX(0xe63c3f)} range:range];
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
- (void)cellPhoneButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(phoneButtonClicked:)]) {
        [self.delegate phoneButtonClicked:sender];
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
