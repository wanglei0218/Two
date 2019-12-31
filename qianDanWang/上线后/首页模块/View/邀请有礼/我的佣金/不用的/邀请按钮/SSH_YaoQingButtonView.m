//
//  SSH_YaoQingButtonView.m
//  DENGFANGSC
//
//  Created by LY on 2018/12/11.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_YaoQingButtonView.h"

@implementation SSH_YaoQingButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLORWHITE;
        [self setupYaoQingView];
    }
    return self;
}

- (void)setupYaoQingView{
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = 1;
    self.titleLabel.font = UIFONTTOOL14;
    self.titleLabel.textColor = ColorBlack222;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(14);
        make.height.mas_equalTo(14);
    }];
    
    self.renshuLabel = [[UILabel alloc] init];
    self.renshuLabel.textAlignment = 1;
    self.renshuLabel.font = UIFONTTOOL12;
    self.renshuLabel.textColor = ColorBlack222;
    [self addSubview:self.renshuLabel];
    [self.renshuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(14);
    }];
    
    self.redLineView = [[UIView alloc] init];
    [self addSubview:self.redLineView];
    self.redLineView.hidden = YES;
    self.redLineView.backgroundColor = COLOR_WITH_HEX(0xf3591e);
    [self.redLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(110);
        make.centerX.mas_equalTo(self);
    }];
    
    self.clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.clickButton];
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

@end
