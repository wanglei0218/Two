//
//  SSH_ImgANDLabelView.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/7.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ImgANDLabelView.h"

@implementation SSH_ImgANDLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configImgLabelView];
    }
    return self;
}


/*
 @property (nonatomic, strong) UIImageView *leftImgView;//左面小图标图片
 @property (nonatomic, strong) UILabel *rightLabel;//右面文字描述
 */
- (void)configImgLabelView{
    
    self.leftImgView = [[UIImageView alloc] init];
    [self addSubview:self.leftImgView];
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self);
    }];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.font = UIFONTTOOL12;
    self.rightLabel.textColor = GrayColor666;
    if (IS_IPHONE5) {
        self.rightLabel.font = UIFONTTOOL12;
    }
    [self addSubview:self.rightLabel];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImgView.mas_right).offset(7);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(11);
        make.centerY.mas_equalTo(self);
    }];
    
}

@end
