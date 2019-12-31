//
//  SSH_ZhiFuStyleButton.m
//  DENGFANGSC
//
//  Created by LY on 2019/1/21.
//  Copyright © 2019年 DENGFANG. All rights reserved.
//

#import "SSH_ZhiFuStyleButton.h"

@implementation SSH_ZhiFuStyleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self zhifuStylelayout];
    }
    return self;
}

- (void)zhifuStylelayout{
    
    self.icon = [[UIImageView alloc] init];
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17.5);
        make.width.height.mas_equalTo(25);
        make.centerY.mas_equalTo(self);
    }];
    
    self.sytleLabel = [[UILabel alloc] init];
    self.sytleLabel.font = [UIFont systemFontOfSize:15];
    self.sytleLabel.textColor = COLOR_WITH_HEX(0x222222);
    [self addSubview:self.sytleLabel];
    [self.sytleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(10);
        make.centerY.mas_equalTo(self.icon);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];
    
    self.selectImgView = [[UIImageView alloc] init];
    [self addSubview:self.selectImgView];
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5.5-17.5);
        make.centerY.mas_equalTo(self.icon);
        make.width.height.mas_equalTo(15);
    }];
    
    self.fengexian = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhifufangshi_xuxian"]];
    [self addSubview:self.fengexian];
    [self.fengexian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17.5);
        make.right.mas_equalTo(-17.5);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

@end
