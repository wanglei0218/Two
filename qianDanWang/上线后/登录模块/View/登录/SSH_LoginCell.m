//
//  LYDengluCell.m
//  reViewApp
//
//  Created by  梁媛 on 2017/7/3.
//  Copyright © 2017年 chaoqianyan. All rights reserved.
//
//

#import "SSH_LoginCell.h"

@implementation SSH_LoginCell


//本页面的总高度为54
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.textField = [[UITextField alloc] init];
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.textColor = ColorBlack222;
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(27.5);
        make.right.mas_equalTo(-27.5);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(10);
    }];
    
    self.mimashowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mimashowButton setImage:[[UIImage imageNamed:@"weidakaiyanjing"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.mimashowButton.adjustsImageWhenHighlighted = NO;
    [self addSubview:self.mimashowButton];
    self.mimashowButton.hidden = YES;
    [self.mimashowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-29);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self);
    }];
    
    self.getVertiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.getVertiButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.getVertiButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.getVertiButton setTitleColor:ColorZhuTiHongSe forState:UIControlStateNormal];
    self.getVertiButton.titleLabel.font = UIFONTTOOL(15);
    [self addSubview:self.getVertiButton];
    self.getVertiButton.hidden = YES;
    [self.getVertiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self.textField);
        make.width.mas_equalTo(78);
    }];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    [self addSubview:lineLabel];
    lineLabel.backgroundColor = GrayLineColor;
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.textField);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
}

@end
