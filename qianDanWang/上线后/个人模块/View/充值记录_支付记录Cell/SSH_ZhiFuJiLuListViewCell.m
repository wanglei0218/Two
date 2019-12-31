//
//  SSH_ZhiFuJiLuListViewCell.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ZhiFuJiLuListViewCell.h"

@implementation SSH_ZhiFuJiLuListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.leftImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.leftImgView];
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(25);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    self.cellTitle = [[UILabel alloc] init];
    self.cellTitle.font = UIFONTTOOL14;
    self.cellTitle.textColor = COLOR_With_Hex(0x282828);
    [self.contentView addSubview:self.cellTitle];
    [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImgView.mas_right).offset(14);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self.leftImgView);
    }];
    
    self.moneyLabel = [[UILabel alloc] init];
    self.moneyLabel.textColor = ColorBlack222;
    self.moneyLabel.font = UIFONTTOOL(18);
    self.moneyLabel.textAlignment = 2;
    [self.contentView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(14);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(100);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textAlignment = 2;
    self.timeLabel.font = UIFONTTOOL12;
    self.timeLabel.textColor = ColorBlack999;
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.moneyLabel.mas_bottom).offset(6);
        make.height.mas_equalTo(11);
        make.width.mas_equalTo(150);
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
