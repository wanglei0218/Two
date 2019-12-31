//
//  SSH_ShareButton.m
//  jiaogeqian
//
//  Created by LY on 2018/8/24.
//  Copyright © 2018年 zdtc. All rights reserved.
//

#import "SSH_ShareButton.h"

@implementation SSH_ShareButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupButtonView];
    }
    return self;
}

- (void)setupButtonView{
    
    self.topImgView = [[UIImageView alloc] init];
    [self addSubview:self.topImgView];
    [self.topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(55);
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
    }];
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.textAlignment = 1;
    self.bottomLabel.font = [UIFont systemFontOfSize:12];
    self.bottomLabel.textColor = COLOR_WITH_HEX(0x222222);
    [self addSubview:self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topImgView.mas_bottom).offset(10);
        make.height.mas_equalTo(12);
    }];
    
}

@end
