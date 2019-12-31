//
//  DENGFANGIDShangChuanView.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ShenFenUploadView.h"

@implementation SSH_ShenFenUploadView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView{
    self.bigView = [[UIView alloc]init];
    [self addSubview:self.bigView];
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(155);
    }];
    [self.bigView borderForColor:GrayLineColor borderWidth:1.0f borderType:UIBorderSideTypeAll];
    self.bigView.layer.cornerRadius = 7.5;
    self.bigView.clipsToBounds = YES;
    
    //背景
    self.bgImgView = [[UIImageView alloc]init];
    [self.bigView addSubview:self.bgImgView];
    self.bgImgView.image = [UIImage imageNamed:@"ID-zheng"];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(137);
        make.width.mas_equalTo(219);
        make.center.mas_equalTo(self.bigView);
    }];
    
    //相机
    self.phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bigView addSubview:self.phoneBtn];
    [self.phoneBtn setImage:[UIImage imageNamed:@"zhaoxiang"] forState:UIControlStateNormal];
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(36);
        make.height.width.mas_equalTo(55);
        make.centerX.mas_equalTo(self.bigView);
    }];
    [self.phoneBtn addTarget:self action:@selector(shangChuanZhengBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //label
    self.myLabel = [[UILabel alloc]init];
    [self.bigView addSubview:self.myLabel];
    self.myLabel.textAlignment = NSTextAlignmentCenter;
    self.myLabel.text = @"请上传身份证反面";
    self.myLabel.textColor = ColorBlack222;
    self.myLabel.font = UIFONTTOOL14;
    [self.myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneBtn.mas_bottom).offset(15);
        make.bottom.mas_equalTo(-35);
        make.left.right.mas_equalTo(0);
    }];
    
    //重新上传按钮
    self.reSubmitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bigView addSubview:self.reSubmitBtn];
    self.reSubmitBtn.backgroundColor = Color000;
    self.reSubmitBtn.layer.cornerRadius = 15;
    self.reSubmitBtn.clipsToBounds = YES;
    self.reSubmitBtn.alpha = 0.7;
    [self.reSubmitBtn setTitle:@"重新上传" forState:UIControlStateNormal];
    [self.reSubmitBtn setTitleColor:Colorf8f8f8 forState:UIControlStateNormal];
    self.reSubmitBtn.titleLabel.font = UIFONTTOOL12;
    [self.reSubmitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(75);
        make.center.mas_equalTo(self.bigView);
    }];
    [self.reSubmitBtn addTarget:self action:@selector(shangChuanZhengBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.reSubmitBtn.hidden = YES;
}
// 设置索引
-(void)setChildBtnTag:(NSInteger)tag{
    self.phoneBtn.tag = tag;
    self.reSubmitBtn.tag = tag;
}
-(void)shangChuanZhengBtnClicked:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(shangChuanZhengBtnClicked:)]) {
        [self.delegate shangChuanZhengBtnClicked:btn];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
