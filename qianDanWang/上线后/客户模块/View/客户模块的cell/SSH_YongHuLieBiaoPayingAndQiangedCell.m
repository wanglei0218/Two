//
//  SSH_YongHuLieBiaoPayingAndQiangedCell.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_YongHuLieBiaoPayingAndQiangedCell.h"
@interface SSH_YongHuLieBiaoPayingAndQiangedCell ()

@property (strong, nonatomic) NSString *nameStr;
@property (assign, nonatomic) BOOL jiHidden;
@property (assign, nonatomic) BOOL tuijianHidden;

@property (strong, nonatomic) NSString *loanStartLimit;//金额
@property (strong, nonatomic) NSString *loanTerm;//期限 （月）
@property (strong, nonatomic) NSString *loanPurpose;// 目的(0：日常消费 1：购买车 2：购买房 3：教育培训 4：短期周转 5：其它)
@property (nonatomic, strong) NSMutableArray *biaoqianArray;
@property (nonatomic, strong) UIView *labelBackView;

@end
@implementation SSH_YongHuLieBiaoPayingAndQiangedCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = ColorBackground_Line;
        [self createClientListCell];
    }
    return self;
}
-(void)setPayListCellModel:(SSH_KeHuGuanLiListModel *)payListCellModel{
    if (_payListCellModel != payListCellModel) {
        _payListCellModel = payListCellModel;
        
        
        if([payListCellModel.loanStartLimit intValue] >= 10000){
            if ([payListCellModel.loanStartLimit intValue]%10000 == 0) {
                self.loanStartLimit = [NSString stringWithFormat:@"%d万",[payListCellModel.loanStartLimit intValue]/10000];
            }else{
                
                int qian = [payListCellModel.loanStartLimit intValue]/1000;
                float wan = qian/10.0;
                self.loanStartLimit = [NSString stringWithFormat:@"%.1f万",wan];
            }
        }else{
            self.loanStartLimit = [payListCellModel.loanStartLimit intValue]?payListCellModel.loanStartLimit:@"0";
        }
        
        if ([payListCellModel.loanTerm intValue] >=12 ) {
            if ([payListCellModel.loanTerm intValue]%12 == 0) {
                self.loanTerm = [NSString stringWithFormat:@"%d年",[payListCellModel.loanTerm intValue]/12];
            }else{
                self.loanTerm = [NSString stringWithFormat:@"%d年%d个月",[payListCellModel.loanTerm intValue]/12,[payListCellModel.loanTerm intValue]%12];
            }
        }else{
            self.loanTerm = [NSString stringWithFormat:@"%d个月",[payListCellModel.loanTerm intValue]];
        }
        
        
        if ([payListCellModel.loanPurpose isEqual:[NSNull null]] || [payListCellModel.loanPurpose intValue] == 5) {
            self.loanPurpose = @"其他";
        }else if ([payListCellModel.loanPurpose intValue] == 0){
            self.loanPurpose = @"日常消费";
        }else if ([payListCellModel.loanPurpose intValue] == 1){
            self.loanPurpose = @"购买车";
        }else if ([payListCellModel.loanPurpose intValue] == 2){
            self.loanPurpose = @"购买房";
        }else if ([payListCellModel.loanPurpose intValue] == 3){
            self.loanPurpose = @"教育培训";
        }else if ([payListCellModel.loanPurpose intValue] == 4){
            self.loanPurpose = @"短期周转";
        }else if ([payListCellModel.loanPurpose isEqualToString:@"6"]){
            self.loanPurpose = @"旅游";
        }else if ([payListCellModel.loanPurpose isEqualToString:@"7"]){
            self.loanPurpose = @"房产装修";
        }
        
        self.nameStr = payListCellModel.creditName;
        self.tuijianHidden = YES;
    
        self.biaoqianArray = [NSMutableArray array];
        
        if ([SSH_TOOL_GongJuLei isKongWithString:payListCellModel.isFund] || [payListCellModel.isFund isEqualToString:@"0"]) {
            
        }else{
            [self.biaoqianArray addObject:@"tyd_gong"];
        }
        
        if ([SSH_TOOL_GongJuLei isKongWithString:payListCellModel.isSecurity] || [payListCellModel.isSecurity isEqualToString:@"0"]) {
            
        }else{
            [self.biaoqianArray addObject:@"tyd_she"];
        }
        
        if ([SSH_TOOL_GongJuLei isKongWithString:payListCellModel.isRealName] || [payListCellModel.isRealName isEqualToString:@"0"]) {
            
        }else{
            [self.biaoqianArray addObject:@"tyd_shi"];
        }
        
        if ([SSH_TOOL_GongJuLei isKongWithString:payListCellModel.isWeiliD] || [payListCellModel.isWeiliD isEqualToString:@"0"]) {
            
        }else{
            [self.biaoqianArray addObject:@"tyd_wei"];
        }
        
//        if ([SSH_TOOL_GongJuLei isKongWithString:homeCellModel.isRecommend] || [homeCellModel.isRecommend isEqualToString:@"0"]) {
//            
//        }else{
//            [self.biaoqianArray addObject:@"tyd_tuijian"];
//        }
        
        [self settingLayouts];
        
        if ([payListCellModel.orderStatus intValue] == 2) { //已抢 成功
            NSString * date = [NSDate dateWithTimeInterval:[payListCellModel.createTime integerValue]/1000 format:@"yyyy-MM-dd HH:mm:ss"];
            self.payTime.text = [NSString stringWithFormat:@"抢单时间 %@",date];
            self.payTime.textColor = ColorBlack333;
            self.payTime.font = UIFONTTOOL12;
            self.payAndPhoneBtn.enabled = YES;
            [self.payAndPhoneBtn setImage:[UIImage imageNamed:@"yutagoutong"] forState:UIControlStateNormal];
            [self configAttributeString1:self.payTime.text rangeString:@"抢单时间" withLabel:self.payTime];
        }else if ([payListCellModel.orderStatus intValue] == 1){ //支付中
            NSString * jishi = [NSDate dateWithTimeInterval:[payListCellModel.expireDate integerValue]/1000 format:@"mm:ss"];
            [self.payAndPhoneBtn setImage:[UIImage imageNamed:@"pay-1"] forState:UIControlStateNormal];
            self.payAndPhoneBtn.enabled = YES;
            self.payTime.textColor = ColorZhuTiHongSe;
            self.payTime.text =  [NSString stringWithFormat:@"支付倒计时 %@",jishi];
        }else{
            self.payTime.text = @"支付超时！";
            self.payTime.textColor = ColorBlack999;
            [self.payAndPhoneBtn setImage:[UIImage imageNamed:@"pay-2"] forState:UIControlStateNormal];
            self.payAndPhoneBtn.enabled = NO;
        }
    }
}

- (void)settingLayouts{
    
    self.customNameLabel.text = self.nameStr;
    CGFloat nameWide = [self getWidthWithTitle:self.customNameLabel.text font:UIFONTTOOL15];
    self.customNameLabel.frame = CGRectMake(14, 14.5, nameWide, 15);
    
    self.labelBackView.frame = CGRectMake(14+nameWide, 14.5, 100, 15);
    [self.labelBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.biaoqianArray.count; i++) {
        
        UIImageView *labelImgView = [[UIImageView alloc] init];
        [self.labelBackView addSubview:labelImgView];
        labelImgView.frame = CGRectMake(10+(15+8)*i, 0, 15, 15);
        
        if ([self.biaoqianArray containsObject:@"tyd_tuijian"]) {
            if (i == [self.biaoqianArray indexOfObject:@"tyd_tuijian"]) {
                labelImgView.frame = CGRectMake(10+(15+8)*i, 0, 30, 15);
            }
        }
        labelImgView.image = [UIImage imageNamed:self.biaoqianArray[i]];
    }
    
    if ([self.biaoqianArray containsObject:@"tyd_tuijian"]) {
        self.timeLabel.frame = CGRectMake(14+nameWide+10+(15+8)*self.biaoqianArray.count+15, 16.5, 100, 12);
    }else{
        self.timeLabel.frame = CGRectMake(14+nameWide+10+(15+8)*self.biaoqianArray.count, 16.5, 100, 12);
    }
    
    NSString *namej = [NSString stringWithFormat:@"%@ ",[DENGFANGSingletonTime shareInstance].name[2]];
    if ([self isKongWithString:self.loanStartLimit] || [self.loanStartLimit intValue] == 0) {
        self.jieDuoShaoLabel.text = namej;
    }else{
        self.jieDuoShaoLabel.text = [NSString stringWithFormat:@"%@%@",namej,self.loanStartLimit];
        [self configAttributeString:self.jieDuoShaoLabel.text rangeString:self.loanStartLimit withLabel:self.jieDuoShaoLabel];
    }
    CGFloat wide1 = [self getWidthWithTitle:self.jieDuoShaoLabel.text font:UIFONTTOOL13];
    self.jieDuoShaoLabel.frame = CGRectMake(15, 46, wide1, 13);
    
    
    self.huiseyuandian1.frame = CGRectMake(CGRectGetMaxX(self.jieDuoShaoLabel.frame)+9, 46+5.5, 2, 2);
    
    NSString *named = [NSString stringWithFormat:@"%@ ",[DENGFANGSingletonTime shareInstance].name[1]];
    if ([self isKongWithString:self.loanTerm] || [self.loanTerm intValue] == 0) {
        self.daiDuoJiuLabel.text = named;
    }else{
        self.daiDuoJiuLabel.text = [NSString stringWithFormat:@"%@%@",named,self.loanTerm];
        [self configAttributeString:self.daiDuoJiuLabel.text rangeString:self.loanTerm withLabel:self.daiDuoJiuLabel];
    }
    CGFloat wide2 = [self getWidthWithTitle:self.daiDuoJiuLabel.text font:UIFONTTOOL13];
    self.daiDuoJiuLabel.frame = CGRectMake(CGRectGetMaxX(self.huiseyuandian1.frame)+9, 46, wide2, 13);
    
    self.huiseyuandian2.frame = CGRectMake(CGRectGetMaxX(self.daiDuoJiuLabel.frame)+9, 46+5.5, 2, 2);
    
    self.yongTuLabel.text = [NSString stringWithFormat:@"用途 %@",self.loanPurpose];
    self.yongTuLabel.frame = CGRectMake(CGRectGetMaxX(self.huiseyuandian2.frame)+9, 46, 90, 13);
    [self configAttributeString:self.yongTuLabel.text rangeString:self.loanPurpose withLabel:self.yongTuLabel];
}


- (void)createClientListCell{
    self.backContentView = [[UIView alloc] init];
    self.backContentView.backgroundColor = COLORWHITE;
    [self addSubview:self.backContentView];
    [self.backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(0);
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
    self.timeLabel.frame = CGRectMake(100, 16.5, 100, 12);

    
    //右箭头
    self.rightArrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chanpinjiantou"]];
    [self.backContentView addSubview:self.rightArrowImgView];
    [self.rightArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);//待修改
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(13);
    }];
    
    self.jieDuoShaoLabel = [[UILabel alloc] init];
    self.jieDuoShaoLabel.textColor = ColorZhuTiHongSe;
    self.jieDuoShaoLabel.font = UIFONTTOOL13;
    [self.backContentView addSubview:self.jieDuoShaoLabel];
    self.jieDuoShaoLabel.frame = CGRectMake(15, 46, 30, 13);
    
    
    self.huiseyuandian1 = [[UIView alloc] init];
    [self.backContentView addSubview:self.huiseyuandian1];
    self.huiseyuandian1.backgroundColor = COLOR_With_Hex(0x999999);
    self.huiseyuandian1.layer.masksToBounds = YES;
    self.huiseyuandian1.layer.cornerRadius = 1;
    self.huiseyuandian1.frame = CGRectMake(CGRectGetMaxX(self.jieDuoShaoLabel.frame)+9, 46+5.5, 2, 2);
    
    self.daiDuoJiuLabel = [[UILabel alloc] init];
    self.daiDuoJiuLabel.textColor = ColorZhuTiHongSe;
    self.daiDuoJiuLabel.font = UIFONTTOOL13;
    [self.backContentView addSubview:self.daiDuoJiuLabel];
    self.daiDuoJiuLabel.frame = CGRectMake(CGRectGetMaxX(self.huiseyuandian1.frame)+9, 46, 30, 13);
    
    self.huiseyuandian2 = [[UIView alloc] init];
    [self.backContentView addSubview:self.huiseyuandian2];
    self.huiseyuandian2.backgroundColor = COLOR_With_Hex(0x999999);
    self.huiseyuandian2.layer.masksToBounds = YES;
    self.huiseyuandian2.layer.cornerRadius = 1;
    self.huiseyuandian2.frame = CGRectMake(CGRectGetMaxX(self.daiDuoJiuLabel.frame)+9, 46+5.5, 2, 2);
    
    self.yongTuLabel = [[UILabel alloc] init];
    self.yongTuLabel.textColor = ColorZhuTiHongSe;
    self.yongTuLabel.font = UIFONTTOOL13;
    [self.backContentView addSubview:self.yongTuLabel];
    self.yongTuLabel.frame = CGRectMake(CGRectGetMaxX(self.huiseyuandian2.frame)+9, 46, 90, 13);
    
    UIView *lineLabel = [[UIView alloc] init];
    [self.backContentView addSubview:lineLabel];
    lineLabel.backgroundColor = ColorBackground_Line;
    lineLabel.frame = CGRectMake(15, CGRectGetMaxY(self.daiDuoJiuLabel.frame)+16, SCREEN_WIDTH-30, 0.5);
    
   
    
    //抢单时间 支付倒计时
    self.payTime = [[UILabel alloc]init];
    [self.backContentView addSubview:self.payTime];
    self.payTime.font = UIFONTTOOL12;
    self.payTime.textColor = ColorZhuTiHongSe;
    [self.payTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(lineLabel.mas_bottom).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.bottom.mas_equalTo(0);
    }];
    
    //按钮
    self.payAndPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backContentView addSubview:self.payAndPhoneBtn];
    [self.payAndPhoneBtn setImage:[UIImage imageNamed:@"pay-1"] forState:UIControlStateNormal];
    [self.payAndPhoneBtn setImage:[UIImage imageNamed:@"pay-2"] forState:UIControlStateSelected];
    [self.payAndPhoneBtn addTarget:self action:@selector(payAndPhoneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.payAndPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(25);
//        make.top.mas_equalTo(lineLabel.mas_bottom).offset(10);
        make.centerY.mas_equalTo(self.payTime);
        make.width.mas_equalTo(95);
        //        make.bottom.mas_equalTo(-10);
    }];
}

- (void)configAttributeString:(NSString *)configString rangeString:(NSString *)rangeString withLabel:(UILabel *)label{
    
    NSString *jineString = configString;
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] initWithString:jineString];
    NSRange range = [jineString rangeOfString:rangeString];
    [mutableAttString addAttributes:@{NSFontAttributeName:UIFONTTOOL12,NSForegroundColorAttributeName:ColorBlack222} range:range];
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
-(void)payAndPhoneBtnClicked:(UIButton *)btn{
//    [btn setImage:[UIImage imageNamed:@"yutabunenggoutong"] forState:UIControlStateNormal];
    if (self.phoneBtnBlock) {
        self.phoneBtnBlock(btn);
    }
}


-(void)setChildBtnTag:(NSInteger)tag{
    self.payAndPhoneBtn.tag = tag;
}

- (void)configAttributeString1:(NSString *)configString rangeString:(NSString *)rangeString withLabel:(UILabel *)label{
    
    NSString *jineString = configString;
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] initWithString:jineString];
    NSRange range = [jineString rangeOfString:rangeString];
    [mutableAttString addAttributes:@{NSFontAttributeName:UIFONTTOOL12,NSForegroundColorAttributeName:ColorBlack999} range:range];
    [mutableAttString beginEditing];
    label.attributedText = mutableAttString;
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
