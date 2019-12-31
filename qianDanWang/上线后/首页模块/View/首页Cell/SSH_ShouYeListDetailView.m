//
//  SSH_ShouYeListDetailView.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/4/22.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_ShouYeListDetailView.h"


@interface SSH_ShouYeListDetailView()

@property(nonatomic,strong)UIImageView *oneImage;
@property(nonatomic,strong)UILabel *chengshiLab;
@property(nonatomic,strong)UIView *line1;
@property(nonatomic,strong)UILabel *gongzuoLab;
@property(nonatomic,strong)UIView *line2;
@property(nonatomic,strong)UILabel *zhimafenLab;

@property(nonatomic,strong)UIImageView *twoImage;
@property(nonatomic,strong)NSString *income;
@property(nonatomic,strong)UILabel *yueshouruLab;
@property(nonatomic,strong)UIView *line3;
@property(nonatomic,strong)UILabel *shouruxingshiLab;
@property(nonatomic,strong)UIView *line4;
@property(nonatomic,strong)UILabel *xinyongkaLab;

@property(nonatomic,strong)UIImageView *threeImage;
@property(nonatomic,strong)UILabel *fangchanLab;
@property(nonatomic,strong)UIView *line5;
@property(nonatomic,strong)UILabel *chechanLab;

@end

@implementation SSH_ShouYeListDetailView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *oneImage = [[UIImageView alloc] init];
        oneImage.image = [UIImage imageNamed:@"dizhi"];
        [self addSubview:oneImage];
        self.oneImage = oneImage;
        
        UILabel *chengshiLab = [[UILabel alloc] init];
        chengshiLab.font = UIFONTTOOL12;
        chengshiLab.textColor = GrayColor666;
        [self addSubview:chengshiLab];
        self.chengshiLab = chengshiLab;
        
        UIView *line1 = [[UIView alloc] init];
        line1.backgroundColor = COLOR_WITH_HEX(0xf3f3f3);
        [self addSubview:line1];
        self.line1 = line1;
        
        UILabel *gongzuoLab = [[UILabel alloc] init];
        gongzuoLab.font = UIFONTTOOL12;
        gongzuoLab.textColor = GrayColor666;
        [self addSubview:gongzuoLab];
        self.gongzuoLab = gongzuoLab;
        
        UIView *line2 = [[UIView alloc] init];
        line2.backgroundColor = COLOR_WITH_HEX(0xf3f3f3);
        [self addSubview:line2];
        self.line2 = line2;
        
        UILabel *zhimafenLab = [[UILabel alloc] init];
        zhimafenLab.font = UIFONTTOOL12;
        zhimafenLab.textColor = COLOR_WITH_HEX(0xe63c3f);
        [self addSubview:zhimafenLab];
        self.zhimafenLab = zhimafenLab;
        
        UIImageView *twoImage = [[UIImageView alloc] init];
        twoImage.image = [UIImage imageNamed:@"yueshouru"];
        [self addSubview:twoImage];
        self.twoImage = twoImage;
        
        UILabel *yueshouruLab = [[UILabel alloc] init];
        yueshouruLab.font = UIFONTTOOL12;
        yueshouruLab.textColor = GrayColor666;
        [self addSubview:yueshouruLab];
        self.yueshouruLab = yueshouruLab;
        
        UIView *line3 = [[UIView alloc] init];
        line3.backgroundColor = COLOR_WITH_HEX(0xf3f3f3);
        [self addSubview:line3];
        self.line3 = line3;
        
        UILabel *shouruxingshiLab = [[UILabel alloc] init];
        shouruxingshiLab.font = UIFONTTOOL12;
        shouruxingshiLab.textColor = GrayColor666;
        [self addSubview:shouruxingshiLab];
        self.shouruxingshiLab = shouruxingshiLab;
        
        UIView *line4 = [[UIView alloc] init];
        line4.backgroundColor = COLOR_WITH_HEX(0xf3f3f3);
        [self addSubview:line4];
        self.line4 = line4;
        
        UILabel *xinyongkaLab = [[UILabel alloc] init];
        xinyongkaLab.font = UIFONTTOOL12;
        xinyongkaLab.textColor = COLOR_WITH_HEX(0xe63c3f);
        [self addSubview:xinyongkaLab];
        self.xinyongkaLab = xinyongkaLab;
        
        UIImageView *threeImage = [[UIImageView alloc] init];
        threeImage.image = [UIImage imageNamed:@"fangchan"];
        [self addSubview:threeImage];
        self.threeImage = threeImage;
        
        UILabel *fangchanLab = [[UILabel alloc] init];
        fangchanLab.font = UIFONTTOOL12;
        fangchanLab.textColor = GrayColor666;
        [self addSubview:fangchanLab];
        self.fangchanLab = fangchanLab;
        
        UIView *line5 = [[UIView alloc] init];
        line5.backgroundColor = COLOR_WITH_HEX(0xf3f3f3);
        [self addSubview:line5];
        self.line5 = line5;
        
        UILabel *chechanLab = [[UILabel alloc] init];
        chechanLab.font = UIFONTTOOL12;
        chechanLab.textColor = GrayColor666;
        [self addSubview:chechanLab];
        self.chechanLab = chechanLab;
        
    }
    return self;
}

-(void)setHomeCellModel:(SSH_HomeCreditxinxiListModel *)homeCellModel
{
    _homeCellModel = homeCellModel;
    
    //第一列
    NSString * nowCityStr = [NSString stringWithFormat:@"%@",_homeCellModel.city];
    if ([SSH_TOOL_GongJuLei isKongWithString:_homeCellModel.city]) {
        //        nowCityStr = @"";
        nowCityStr = @"地区未知";
    }else{
        nowCityStr = [NSString stringWithFormat:@"%@",_homeCellModel.city];
    }
    CGSize chengshiText = [nowCityStr sizeWithFont:UIFONTTOOL12];
    self.oneImage.frame = CGRectMake(0, 0, 14, 14);
    self.chengshiLab.text = nowCityStr;
    self.chengshiLab.frame = CGRectMake(CGRectGetMaxX(self.oneImage.frame)+10, 0, chengshiText.width, 14);
    
    self.line1.frame = CGRectMake(CGRectGetMaxX(self.chengshiLab.frame)+10, 0, 1, 14);
    
    //（0：上班族 1：公务员 2：企业主  3：自有职业者  4：学生）
    NSString *shenFenStr;
    if ([_homeCellModel.identityType isEqualToString:@"0"]) {
        shenFenStr = @"上班族";
    }else if ([_homeCellModel.identityType isEqualToString:@"1"]){
        shenFenStr = @"公务员";
    }else if ([_homeCellModel.identityType isEqualToString:@"2"]){
        shenFenStr = @"企业主";
    }else if ([_homeCellModel.identityType isEqualToString:@"3"]){
        shenFenStr = @"自有职业者";
    }else if ([_homeCellModel.identityType isEqualToString:@"4"]){
        shenFenStr = @"学生";
    }else{
        shenFenStr = @"身份未知";
    }
    
    if ([shenFenStr isEqualToString:@"企业主"]) {
        
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
        NSString *shouru = [NSString stringWithFormat:@"%@",homeCellModel.income];
        if ([self isKongWithString:shouru] || [shouru isEqualToString:@"0"]) {
            self.income = @"月收入未知";
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
    }
    self.gongzuoLab.text = shenFenStr;
    CGSize gongzuoText = [shenFenStr sizeWithFont:UIFONTTOOL12];
    self.gongzuoLab.frame = CGRectMake(CGRectGetMaxX(self.line1.frame)+10, 0, gongzuoText.width, 14);
    
    self.line2.frame = CGRectMake(CGRectGetMaxX(self.gongzuoLab.frame)+10, 0, 1, 14);
    
    NSString *zhiMaFenStr;
    if([SSH_TOOL_GongJuLei isKongWithString:_homeCellModel.sesameCreditF]){
        zhiMaFenStr = @"芝麻分未知";
    }else{
        if ([SSH_TOOL_GongJuLei isKongWithString:_homeCellModel.endSesameCredit]) {
            NSString *str1 = _homeCellModel.sesameCreditF;
            //2.截取从0位到第n为（第n位不算在内）
            NSString *str3 = [str1 substringToIndex:3];
            zhiMaFenStr = [NSString stringWithFormat:@"芝麻%@",str3];
        } else if ([_homeCellModel.endSesameCredit isEqualToString:@"0分"]) {
            NSString *str1 = _homeCellModel.sesameCreditF;
            //2.截取从0位到第n为（第n位不算在内）
            NSString *str3 = [str1 substringToIndex:3];
            zhiMaFenStr = [NSString stringWithFormat:@"芝麻%@以上",str3];
        } else if ([_homeCellModel.sesameCreditF isEqualToString:@"0分"]) {
            NSString *str1 = _homeCellModel.endSesameCredit;
            //2.截取从0位到第n为（第n位不算在内）
            NSString *str3 = [str1 substringToIndex:3];
            zhiMaFenStr = [NSString stringWithFormat:@"芝麻%@以下",str3];
        } else {
            
            NSString *str1 = _homeCellModel.sesameCreditF;
            NSString *str2 = _homeCellModel.endSesameCredit;
            //2.截取从0位到第n为（第n位不算在内）
            NSString *str3 = [str1 substringToIndex:3];
            NSString *str4 = [str2 substringToIndex:3];
            zhiMaFenStr = [NSString stringWithFormat:@"芝麻%@~%@",str3,str4];
        }
        
    }
    self.zhimafenLab.text = zhiMaFenStr;
    CGSize zhimafenText = [zhiMaFenStr sizeWithFont:UIFONTTOOL12];
    self.zhimafenLab.frame = CGRectMake(CGRectGetMaxX(self.line2.frame)+10, 0, zhimafenText.width, 14);
    
    //第二列
    CGSize yueshouruText = [self.income sizeWithFont:UIFONTTOOL12];
    self.twoImage.frame = CGRectMake(0, CGRectGetMaxY(self.oneImage.frame)+14, 14, 14);
    self.yueshouruLab.text = self.income;
    self.yueshouruLab.frame = CGRectMake(CGRectGetMaxX(self.twoImage.frame)+10, self.twoImage.y, yueshouruText.width, 14);
    self.line3.frame = CGRectMake(CGRectGetMaxX(self.yueshouruLab.frame)+10, self.twoImage.y, 1, 14);
    
    if (self.isQuanGuo) { //全国专区 不显示收入形式
        
        self.line4.frame = self.line3.frame;
        self.shouruxingshiLab.hidden = YES;
        
    }else{
        
        NSString *modelLife;
        if (self.isDetail && [_homeCellModel.identityType isEqualToString:@"3"]) {
            modelLife = _homeCellModel.businessLifeF;
        }else{
            modelLife = _homeCellModel.businessLife;
        }
        
        //收入形式
        NSString *shouruxingshiStr;
        if ([modelLife isEqualToString:@"0"]) {
            shouruxingshiStr = @"银行代发";
        }else if ([modelLife isEqualToString:@"1"]){
            shouruxingshiStr = @"现金发放";
        }else if ([modelLife isEqualToString:@"2"]){
            shouruxingshiStr = @"转账打卡";
        }else if ([modelLife isEqualToString:@"3"]){
            shouruxingshiStr = @"部分现金部分打卡";
        }else{
            shouruxingshiStr = @"收入形式未知";
        }
        
        self.shouruxingshiLab.text = shouruxingshiStr;
        CGSize shouruxingshiText = [shouruxingshiStr sizeWithFont:UIFONTTOOL12];
        self.shouruxingshiLab.frame = CGRectMake(CGRectGetMaxX(self.line3.frame)+10, self.twoImage.y, shouruxingshiText.width, 14);
        self.line4.frame = CGRectMake(CGRectGetMaxX(self.shouruxingshiLab.frame)+10, self.twoImage.y, 1, 14);
        self.shouruxingshiLab.hidden = NO;
        
    }
    
    
    
    //信用卡
    NSString * carLiStr;
    if ([_homeCellModel.isCreditCard isEqualToString:@"0"]) {
        carLiStr = @"信用卡无";
    }else if ([_homeCellModel.isCreditCard isEqualToString:@"1"]){
        carLiStr = @"信用卡1万元以下";//@"信用卡10000元以下";
    }else if ([_homeCellModel.isCreditCard isEqualToString:@"2"]){
        carLiStr = @"信用卡1万~3万元";//@"信用卡10001~30000元";
    }else if ([_homeCellModel.isCreditCard isEqualToString:@"3"]){
        carLiStr = @"信用卡3万~10万元";//@"信用卡30001~100000元";
    }else if ([_homeCellModel.isCreditCard isEqualToString:@"4"]){
        carLiStr = @"信用卡10万元以上";//@"信用卡100000元以上";
    }else{
        carLiStr = @"信用卡未知";
    }
    self.xinyongkaLab.text = carLiStr;
    CGSize xinyongkaText = [carLiStr sizeWithFont:UIFONTTOOL12];
    self.xinyongkaLab.frame = CGRectMake(CGRectGetMaxX(self.line4.frame)+10, self.twoImage.y, xinyongkaText.width, 14);
    
    
    //第三列
    NSString *fangChanStr = [NSString stringWithFormat:@"%@",_homeCellModel.property];
    if ([fangChanStr isEqualToString:@"0"]){
        fangChanStr = @"无房产";
    }else if ([SSH_TOOL_GongJuLei isKongWithString:fangChanStr]){
        fangChanStr = @"房产未知";
    }else{
        fangChanStr = @"有房产";
    }
    CGSize fangchanText = [fangChanStr sizeWithFont:UIFONTTOOL12];
    self.threeImage.frame = CGRectMake(0, CGRectGetMaxY(self.twoImage.frame)+14, 14, 14);
    self.fangchanLab.text = fangChanStr;
    self.fangchanLab.frame = CGRectMake(CGRectGetMaxX(self.threeImage.frame)+10, self.threeImage.y, fangchanText.width, 14);
    self.line5.frame = CGRectMake(CGRectGetMaxX(self.fangchanLab.frame)+10, self.threeImage.y, 1, 14);
    
    //
    NSString *chechanStr = [NSString stringWithFormat:@"%@",_homeCellModel.carProduction];
    if ([chechanStr isEqualToString:@"0"]) {
        chechanStr = @"无车产";
    }else if ([SSH_TOOL_GongJuLei isKongWithString:chechanStr]) {
        chechanStr = @"车产未知";
    }else{
        chechanStr = @"有车产";
    }
    self.chechanLab.text = chechanStr;
    CGSize chechanText = [chechanStr sizeWithFont:UIFONTTOOL12];
    self.chechanLab.frame = CGRectMake(CGRectGetMaxX(self.line5.frame)+7, self.threeImage.y, chechanText.width, 14);
    
    
    //全国专区的房产和车产都没有就不显示
    if ([fangChanStr isEqualToString:@"房产未知"] && [chechanStr isEqualToString:@"车产未知"] && self.isQuanGuo) {
        self.threeImage.hidden = YES;
        self.fangchanLab.hidden = YES;
        self.line5.hidden = YES;
        self.chechanLab.hidden = YES;
    }else{
        self.threeImage.hidden = NO;
        self.fangchanLab.hidden = NO;
        self.line5.hidden = NO;
        self.chechanLab.hidden = NO;
    }
    
}


- (BOOL)isKongWithString:(NSString *)string{
    NSString *str = [NSString stringWithFormat:@"%@",string]; //不转换偶尔会报错
    if ([str isEqualToString:@"<null>"] || [str isEqualToString:@""] || str == nil || [str isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}


@end
