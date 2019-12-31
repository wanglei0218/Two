//
//  SSH_ShouyeFenleiCell.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/6.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ShouyeFenleiCell.h"

@implementation SSH_ShouyeFenleiCell



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configDENGFANGCell];
    }
    return self;
}

- (void)configDENGFANGCell{
    
    self.typeImgView = [[UIImageView alloc] init];
    [self addSubview:self.typeImgView];
    [self.typeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
    }];
    
    self.typeTitleLabel = [[UILabel alloc] init];
    [self addSubview:self.typeTitleLabel];
    self.typeTitleLabel.textAlignment = 1;
    self.typeTitleLabel.textColor = ColorBlack343434;
    self.typeTitleLabel.font = UIFONTTOOL12;
    [self.typeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(11);
    }];
    
}

@end
