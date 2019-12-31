//
//  SSH_LabelANDLabelView.m
//  DENGFANGSC
//
//  Created by LY on 2018/11/27.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_LabelANDLabelView.h"

@implementation SSH_LabelANDLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLabelView];
    }
    return self;
}

- (void)setupLabelView{
    
    self.keyLabel = [[UILabel alloc] init];
    self.keyLabel.font = [UIFont systemFontOfSize:12];
    self.keyLabel.textAlignment = 1;
    self.keyLabel.textColor = ColorBlack222;
    [self addSubview:self.keyLabel];
    [self.keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(12);
    }];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.font = [UIFont systemFontOfSize:14];
    self.valueLabel.textAlignment = 1;
    self.valueLabel.textColor = ColorZhuTiHongSe;
    [self addSubview:self.valueLabel];
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.keyLabel.mas_bottom).offset(9);
        make.height.mas_equalTo(14);
    }];
    
}

@end
