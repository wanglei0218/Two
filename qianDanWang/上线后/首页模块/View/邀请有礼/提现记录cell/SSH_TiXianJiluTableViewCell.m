//
//  SSH_TiXianJiluTableViewCell.m
//  DENGFANGSC
//
//  Created by LY on 2019/1/24.
//  Copyright © 2019年 DENGFANG. All rights reserved.
//

#import "SSH_TiXianJiluTableViewCell.h"

@implementation SSH_TiXianJiluTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup_tixian_jilu_cell];
    }
    return self;
}

- (void)setup_tixian_jilu_cell{
    
    self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tixian_jilu_youbi"]];
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(41);
        make.centerY.mas_equalTo(self);
    }];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(11);
        make.top.mas_equalTo(12.5);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(14);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = COLOR_With_Hex(0xcccccc);
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(150);
        make.top.mas_equalTo(self.statusLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.statusLabel);
    }];
    
    self.moneyLabel = [[UILabel alloc] init];
    self.moneyLabel.textAlignment = 2;
    self.moneyLabel.font = [UIFont systemFontOfSize:21];
    self.moneyLabel.textColor = ColorBlack222;
    [self.contentView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(130);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(21);
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
