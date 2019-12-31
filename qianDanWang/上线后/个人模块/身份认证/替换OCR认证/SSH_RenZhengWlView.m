//
//  SSH_RenZhengWlView.m
//  qianDanWang
//
//  Created by 畅轻 on 2019/12/30.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_RenZhengWlView.h"

@implementation SSH_RenZhengWlView

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
        make.height.mas_equalTo(112);
        make.width.mas_equalTo(219);
        make.center.mas_equalTo(self.bigView);
    }];
    //self.bgImgView.contentMode = UIViewContentModeScaleAspectFit;
    //self.bgImgView.layer.masksToBounds = YES;
    
    //相机
    self.phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bigView addSubview:self.phoneBtn];
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(36);
        make.height.width.mas_equalTo(55);
        make.centerX.mas_equalTo(self.bigView);
    }];
    [self.phoneBtn addTarget:self action:@selector(shangChuanZhengBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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

@end
