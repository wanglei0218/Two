//
//  SJWeXinQQAlert.m
//  jiaogeqian
//
//  Created by LY on 2018/8/6.
//  Copyright © 2018年 zdtc. All rights reserved.
//

#import "SSH_WeChatAlertView.h"
#define LanSe COLOR_WITH_HEX(0x2c70fa)
@interface SSH_WeChatAlertView ()

@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) UIView *whiteView;

@end

@implementation SSH_WeChatAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)showWeXinQQAlertView{}

-(void)setDingYueHaoModel:(SSH_DingYueHaoModel *)dingYueHaoModel
{
    _dingYueHaoModel = dingYueHaoModel;
    
    self.grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self addSubview:self.grayView];
    self.grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    [self.grayView addSubview:self.whiteView];
    self.whiteView.layer.masksToBounds = YES;
    self.whiteView.layer.cornerRadius = 6;
    self.whiteView.size = CGSizeMake(305, 338+_dingYueHaoModel.contentText1Size.height+_dingYueHaoModel.contentText2Size.height);
    self.whiteView.center = CGPointMake(ScreenWidth*0.5, ScreenHeight*0.5);
    
    self.titleOfficalLabel = [[UILabel alloc] init];
    self.titleOfficalLabel.text = self.dingYueHaoModel.titleText;
    [self.whiteView addSubview:self.titleOfficalLabel];
    self.titleOfficalLabel.textColor = ColorBlack222;
    self.titleOfficalLabel.textAlignment = 1;
    self.titleOfficalLabel.frame = CGRectMake(0, 18, self.whiteView.width, 17);
    
    
    UILabel *method1 = [[UILabel alloc] init];
    [self.whiteView addSubview:method1];
    method1.text = @"方案一：";
    method1.textColor = ColorBlack222;
    method1.font = [UIFont systemFontOfSize:13];
    method1.frame = CGRectMake(15, CGRectGetMaxY(self.titleOfficalLabel.frame)+20, self.whiteView.width-30, 15);
    
    //设置的是灰色的字体和颜色,后面富文本设置的时候，设置《方案一》和《淘优单》这些文字
    self.method1ContentLabel = [[UILabel alloc] init];
    [self.whiteView addSubview:self.method1ContentLabel];
    self.method1ContentLabel.font = [UIFont systemFontOfSize:13];
    self.method1ContentLabel.textColor = GrayColor666;
    self.method1ContentLabel.text = _dingYueHaoModel.contentText1;
    self.method1ContentLabel.numberOfLines = 0;
    self.method1ContentLabel.frame = CGRectMake(15, CGRectGetMaxY(method1.frame)+10, _dingYueHaoModel.contentText1Size.width, _dingYueHaoModel.contentText1Size.height);
    
    UILabel *method2 = [[UILabel alloc] init];
    [self.whiteView addSubview:method2];
    method2.text = @"方案二：";
    method2.textColor = ColorBlack222;
    method2.font = [UIFont systemFontOfSize:13];
    method2.frame = CGRectMake(15, CGRectGetMaxY(self.method1ContentLabel.frame)+15, self.whiteView.width-30, 15);
    
    
    self.method2ContentLabel = [[UILabel alloc] init];
    [self.whiteView addSubview:self.method2ContentLabel];
    self.method2ContentLabel.font = [UIFont systemFontOfSize:13];
    self.method2ContentLabel.textColor = GrayColor666;
    self.method2ContentLabel.text = _dingYueHaoModel.contentText2;
    self.method2ContentLabel.numberOfLines = 0;
    self.method2ContentLabel.frame = CGRectMake(15, CGRectGetMaxY(method2.frame)+10, _dingYueHaoModel.contentText2Size.width, _dingYueHaoModel.contentText2Size.height);
    
    self.QRCodeImgview = [[UIImageView alloc] init];
    [self.whiteView addSubview:self.QRCodeImgview];
    self.QRCodeImgview.frame = CGRectMake((self.whiteView.width-138)*0.5, CGRectGetMaxY(self.method2ContentLabel.frame)+20, 138, 138);
    
    self.jumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.whiteView addSubview:self.jumpButton];
    self.jumpButton.layer.masksToBounds = YES;
    self.jumpButton.layer.cornerRadius = 15;
    self.jumpButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.jumpButton.backgroundColor = COLOR_WITH_HEX(0x0964F6);
    [self.jumpButton setTitle:@"去微信" forState:UIControlStateNormal];
    [self.jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(115);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(self.QRCodeImgview.mas_bottom).offset(15);
    }];

    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.grayView addSubview:self.closeButton];
    [self.closeButton setImage:[UIImage imageNamed:@"guanbi_gongzhonghao"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeCurrentView) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(35);
        make.centerX.mas_equalTo(self.whiteView);
        make.top.mas_equalTo(self.whiteView.mas_bottom).offset(32.5);
    }];
    

}

- (void)closeCurrentView{
    [MobClick event:@"my-WeChat-close"];
    [self.whiteView removeFromSuperview];
    [self.grayView removeFromSuperview];
    [self removeFromSuperview];
}

@end
