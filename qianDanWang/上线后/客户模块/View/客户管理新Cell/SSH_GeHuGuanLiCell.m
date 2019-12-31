//
//  SSH_GeHuGuanLiCell.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/5/11.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_GeHuGuanLiCell.h"
#import "SSH_XinKeHuGuanLiModel.h"

@interface SSH_GeHuGuanLiCell()

@property (nonatomic, strong) UIView *huiseyuandian1;
@property (nonatomic, strong) UIView *huiseyuandian2;

@property (nonatomic, strong) UIView *backContentView;//背景View
@property (nonatomic, strong) UILabel *customNameLabel;//客户姓名
@property (nonatomic, strong) UILabel *timeLabel;//发布时间
@property (nonatomic, strong) UILabel *jieDuoShaoLabel;//多少
@property (nonatomic, strong) UILabel *daiDuoJiuLabel;//多久
@property (nonatomic, strong) UILabel *yongTuLabel;//用途
@property (nonatomic, strong) UILabel *genJingLabel;//跟进记录
@property(nonatomic,strong)UIImageView *phoneImage;
@property(nonatomic,strong)UILabel *phoneLabel;

@end

@implementation SSH_GeHuGuanLiCell

-(void)setFrame:(CGRect)frame
{
    frame.origin.y += 7.5;
    frame.size.height -= 7.5;
    
    [super setFrame:frame];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {

        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    
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
    self.customNameLabel.textColor = ColorBlack222;
    
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = COLOR_With_Hex(0x999999);
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.backContentView addSubview:self.timeLabel];
    
    self.jieDuoShaoLabel = [[UILabel alloc] init];
    self.jieDuoShaoLabel.textColor = COLOR_WITH_HEX(0xe63c3f);
    self.jieDuoShaoLabel.font = UIFONTTOOL16;
    [self.backContentView addSubview:self.jieDuoShaoLabel];
    
    self.huiseyuandian1 = [[UIView alloc] init];
//    [self.backContentView addSubview:self.huiseyuandian1];
    self.huiseyuandian1.backgroundColor = COLOR_With_Hex(0x999999);
    self.huiseyuandian1.layer.masksToBounds = YES;
    self.huiseyuandian1.layer.cornerRadius = 1;
    
    self.daiDuoJiuLabel = [[UILabel alloc] init];
    self.daiDuoJiuLabel.textColor = COLOR_WITH_HEX(0xe63c3f);
    self.daiDuoJiuLabel.font = UIFONTTOOL13;
    //期限隐藏
//    [self.backContentView addSubview:self.daiDuoJiuLabel];

    self.huiseyuandian2 = [[UIView alloc] init];
    [self.backContentView addSubview:self.huiseyuandian2];
    self.huiseyuandian2.backgroundColor = COLOR_With_Hex(0x999999);
    self.huiseyuandian2.layer.masksToBounds = YES;
    self.huiseyuandian2.layer.cornerRadius = 1;
    
    self.yongTuLabel = [[UILabel alloc] init];
    self.yongTuLabel.textColor = COLOR_WITH_HEX(0xe63c3f);
    self.yongTuLabel.font = UIFONTTOOL13;
    //用途隐藏
//    [self.backContentView addSubview:self.yongTuLabel];
    
    self.genJingLabel = [[UILabel alloc] init];
    self.genJingLabel.textColor = ColorZhuTiHongSe;
    self.genJingLabel.font = UIFONTTOOL13;
    [self.backContentView addSubview:self.genJingLabel];
    
    self.phoneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"客户管理_电话"]];
    [self.backContentView addSubview:self.phoneImage];
    
    self.phoneLabel = [[UILabel alloc] init];
    self.phoneLabel.textColor = ColorZhuTiHongSe;
    self.phoneLabel.font = UIFONTTOOL13;
    [self.backContentView addSubview:self.phoneLabel];
    
    self.phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.phoneButton addTarget:self action:@selector(clickPhoneButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.backContentView addSubview:self.phoneButton];
    self.phoneButton.backgroundColor = [UIColor clearColor];
    
    self.gengXinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.gengXinButton.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:12]];
    [self.gengXinButton setTitle:@"更新状态" forState:UIControlStateNormal];
    [self.gengXinButton setBackgroundImage:[UIImage imageNamed:@"按钮选中"] forState:UIControlStateNormal];
    [self.gengXinButton setBackgroundImage:[UIImage imageNamed:@"按钮未选中"] forState:UIControlStateSelected];
    [self.gengXinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backContentView addSubview:self.gengXinButton];
    [self.gengXinButton addTarget:self action:@selector(clickGengXinButton:) forControlEvents:UIControlEventTouchUpInside];
    self.gengXinButton.backgroundColor = [UIColor clearColor];

    
}

-(void)setModel:(SSH_XinKeHuGuanLiModel *)model{
    _model = model;
    
    
    
    
    //名字
   self.customNameLabel.text = _model.creditName;
    [self.customNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];
    
    //时间
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.customNameLabel.mas_centerY);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(11);
    }];
    
    self.timeLabel.text = [NSDate dateWithTimeInterval:[_model.createTime integerValue]/1000 format:@"yyyy-MM-dd HH:mm:ss"];
    

    /************************借多少****************************/
    NSString *star = [NSString stringWithFormat:@"%@",_model.loanStartLimitF];
    NSString *endStr = [NSString stringWithFormat:@"%@",_model.loanEndLimit];
    NSString *jieDuoShaoStr;
    if ([star isEqualToString:@"0"]) {
        jieDuoShaoStr = [NSString stringWithFormat:@"%d万以下",[endStr intValue]/10000];
    } else if ([star intValue] == 0) {
        jieDuoShaoStr = [NSString stringWithFormat:@"%d万以下",[endStr intValue]/10000];
    } else if ([endStr intValue] == 0) {
        jieDuoShaoStr = [NSString stringWithFormat:@"%d万以上",[star intValue]/10000];
    } else if ([endStr isEqualToString:@"0"]) {
        jieDuoShaoStr = [NSString stringWithFormat:@"%d万以上",[star intValue]/10000];
    } else {
        jieDuoShaoStr = [NSString stringWithFormat:@"%d万~%d万",[star intValue]/10000,[endStr intValue]/10000];
    }
    
    
//    if([_model.loanStartLimit intValue] >= 10000){
//        if ([_model.loanStartLimit intValue]%10000 == 0) {
//            jieDuoShaoStr = [NSString stringWithFormat:@"%d万",[_model.loanStartLimit intValue]/10000];
//        }else{
//
//            int qian = [_model.loanStartLimit intValue]/1000;
//            float wan = qian/10.0;
//            jieDuoShaoStr = [NSString stringWithFormat:@"%.1f万",wan];
//        }
//    }else{
//        jieDuoShaoStr = [_model.loanStartLimit intValue]?_model.loanStartLimit:@"0";
//    }
    
    NSString *namej = [NSString stringWithFormat:@"%@ ",[DENGFANGSingletonTime shareInstance].name[2]];
    if ([self isKongWithString:jieDuoShaoStr] || [jieDuoShaoStr intValue] == 0) {
        self.jieDuoShaoLabel.text = namej;
    }else{
        self.jieDuoShaoLabel.text = [NSString stringWithFormat:@"%@%@",namej,jieDuoShaoStr];
        [self configAttributeString:self.jieDuoShaoLabel.text rangeString:namej withLabel:self.jieDuoShaoLabel];
    }
    CGFloat wide1 = [self getWidthWithTitle:self.jieDuoShaoLabel.text font:UIFONTTOOL16];
    [self.jieDuoShaoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.customNameLabel.mas_bottom).offset(17);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(wide1);
        make.height.mas_equalTo(13);
    }];
    /****************************************************/
    
    //圆点1
  
//    [self.huiseyuandian1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.jieDuoShaoLabel.mas_right).offset(9);
//        make.centerY.mas_equalTo(self.jieDuoShaoLabel.mas_centerY);
//        make.width.mas_equalTo(2);
//        make.height.mas_equalTo(2);
//    }];
//
//FIXME: 期限隐藏----------------------
   
//    NSString *jieDuoJiuStr;
//    if ([_model.loanTerm intValue] >=12 ) {
//        if ([_model.loanTerm intValue]%12 == 0) {
//            jieDuoJiuStr = [NSString stringWithFormat:@"%d年",[_model.loanTerm intValue]/12];
//        }else{
//            jieDuoJiuStr = [NSString stringWithFormat:@"%d年%d个月",[_model.loanTerm intValue]/12,[_model.loanTerm intValue]%12];
//        }
//    }else{
//        jieDuoJiuStr = [NSString stringWithFormat:@"%d个月",[_model.loanTerm intValue]];
//    }
//
//    NSString *named = [NSString stringWithFormat:@"%@ ",[DENGFANGSingletonTime shareInstance].name[1]];
//    if ([self isKongWithString:jieDuoJiuStr] || [jieDuoJiuStr intValue] == 0) {
//        self.daiDuoJiuLabel.text = named;
//    }else{
//        self.daiDuoJiuLabel.text = [NSString stringWithFormat:@"%@%@",named,jieDuoJiuStr];
//        [self configAttributeString:self.daiDuoJiuLabel.text rangeString:named withLabel:self.daiDuoJiuLabel];
//    }
//    CGFloat wide2 = [self getWidthWithTitle:self.daiDuoJiuLabel.text font:UIFONTTOOL13];
//    [self.daiDuoJiuLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.huiseyuandian1.mas_right).offset(9);
//        make.width.mas_equalTo(wide2);
//        make.centerY.mas_equalTo(self.huiseyuandian1.mas_centerY);
//        make.height.mas_equalTo(13);
//    }];
//    /*******************************************************/
//
//    //圆点2
//
//    [self.huiseyuandian2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.daiDuoJiuLabel.mas_right).offset(9);
//        make.centerY.mas_equalTo(self.daiDuoJiuLabel.mas_centerY);
//        make.width.mas_equalTo(2);
//        make.height.mas_equalTo(2);
//    }];
    
//FIXME: 用途隐藏----------------------
//
//    [self.yongTuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.huiseyuandian2.mas_right).offset(9);
//        make.centerY.mas_equalTo(self.huiseyuandian2.mas_centerY);
//        make.width.mas_equalTo(90);
//        make.height.mas_equalTo(13);
//    }];
//    NSString *yongTuStr;
//    if ([_model.loanPurpose isEqualToString:@"5"]) {
//        yongTuStr = @"其他";
//    }else if ([_model.loanPurpose isEqualToString:@"0"]){
//        yongTuStr = @"日常消费";
//    }else if ([_model.loanPurpose isEqualToString:@"1"]){
//        yongTuStr = @"购买车";
//    }else if ([_model.loanPurpose isEqualToString:@"2"]){
//        yongTuStr = @"购买房";
//    }else if ([_model.loanPurpose isEqualToString:@"3"]){
//        yongTuStr = @"教育培训";
//    }else if ([_model.loanPurpose isEqualToString:@"4"]){
//        yongTuStr = @"短期周转";
//    }else if ([_model.loanPurpose isEqualToString:@"6"]){
//        yongTuStr = @"旅游";
//    }else if ([_model.loanPurpose isEqualToString:@"7"]){
//        yongTuStr = @"房产装修";
//    }else{
//        yongTuStr = @"";
//    }
//    self.yongTuLabel.text = [NSString stringWithFormat:@"用途 %@",yongTuStr];
//    [self configAttributeString:self.yongTuLabel.text rangeString:@"用途" withLabel:self.yongTuLabel];
    
    /*******************************************************/
    
    /*******************跟进记录******************************/
    
    self.genJingLabel.text = [NSString stringWithFormat:@"最后跟进记录：%@",_model.updateStatus];
    CGFloat wide3 = [self getWidthWithTitle:self.genJingLabel.text font:UIFONTTOOL13];
    [self configAttributeString:self.genJingLabel.text rangeString:@"最后跟进记录："  withLabel:self.genJingLabel];
    
    [self.genJingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.jieDuoShaoLabel.mas_bottom).offset(17);
        make.width.mas_equalTo(wide3);
        make.height.mas_equalTo(13);
    }];
    /*******************************************************/
    
    //电话小图标
   
    [self.phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.genJingLabel.mas_bottom).offset(17);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(13);
    }];
    
    /*******************电话******************************/
   
    self.phoneLabel.text = [NSString stringWithFormat:@"%@（点击可拨打）",_model.mobile];
    CGFloat wide4 = [self getWidthWithTitle:self.phoneLabel.text font:UIFONTTOOL13];
    [self configAttributeString:self.phoneLabel.text rangeString:_model.mobile withLabel:self.phoneLabel];
    
    [self.phoneLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneImage.mas_right).offset(2);
        make.centerY.mas_equalTo(self.phoneImage.mas_centerY);
        make.width.mas_equalTo(wide4);
        make.height.mas_equalTo(13);
    }];
    
    /*******************************************************/
    
    /*******拨打电话*******************************************/
   
    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.phoneImage.mas_left);
        make.top.mas_equalTo(self.phoneImage.mas_top);
        make.bottom.mas_equalTo(self.phoneImage.mas_bottom);
        make.right.mas_equalTo(self.phoneLabel.mas_right);
    }];
    /*******************************************************/
//    PingFang-SC-Medium
    /*******拨打电话*******************************************/
   
    [self.gengXinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(27.5);
        make.bottom.mas_equalTo(self.phoneImage.mas_bottom);
        make.right.mas_equalTo(-15);
    }];
    if (_model.lastRecordId == 2) {
        self.gengXinButton.hidden = YES;
    }else{
        self.gengXinButton.hidden = NO;
    }
    
    /*******************************************************/
    
}

-(void)clickPhoneButton:(UIButton *)btn{
    if (self.phoneBtnBlock) {
        self.phoneBtnBlock(btn, YES);
    }
}

-(void)clickGengXinButton:(UIButton *)btn{
    if (self.phoneBtnBlock) {
        self.phoneBtnBlock(btn, NO);
    }
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

- (BOOL)isKongWithString:(NSString *)string{
    NSString *str = [NSString stringWithFormat:@"%@",string]; //不转换偶尔会报错
    if ([str isEqualToString:@"<null>"] || [str isEqualToString:@""] || str == nil || [str isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}

- (void)configAttributeString1:(NSString *)configString rangeString:(NSString *)rangeString withLabel:(UILabel *)label{
    
    NSString *jineString = configString;
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] initWithString:jineString];
    NSRange range = [jineString rangeOfString:rangeString];
    [mutableAttString addAttributes:@{NSFontAttributeName:UIFONTTOOL12,NSForegroundColorAttributeName:ColorBlack999} range:range];
    [mutableAttString beginEditing];
    label.attributedText = mutableAttString;
}


@end
