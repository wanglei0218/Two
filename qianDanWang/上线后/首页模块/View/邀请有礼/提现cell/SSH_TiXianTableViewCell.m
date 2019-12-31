//
//  SSH_TiXianTableViewCell.m
//  DENGFANGSC
//
//  Created by LY on 2019/1/22.
//  Copyright © 2019年 DENGFANG. All rights reserved.
//

#import "SSH_TiXianTableViewCell.h"

@implementation SSH_TiXianTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self tixianCellLayout];
    }
    return self;
}

- (void)tixianCellLayout{
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:13];
    self.nameLabel.textAlignment = 2;
    self.nameLabel.textColor = GrayColor666;
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(13);
        make.centerY.mas_equalTo(self);
    }];
    
    self.shuruTextField = [[UITextField alloc] init];
    self.shuruTextField.textColor = ColorBlack222;
    self.shuruTextField.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.shuruTextField];
    [self.shuruTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(10);
        make.right.mas_equalTo(-15);
    }];
    
    self.yanzhengmaButton = [UIButton new];
    [self.yanzhengmaButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.yanzhengmaButton setTitleColor:ColorZhuTiHongSe forState:UIControlStateNormal];
    self.yanzhengmaButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.yanzhengmaButton];
    self.yanzhengmaButton.hidden = YES;
    [self.yanzhengmaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(93);
    }];
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
