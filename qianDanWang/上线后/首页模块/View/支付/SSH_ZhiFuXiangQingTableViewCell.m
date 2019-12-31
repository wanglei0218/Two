//
//  SSH_ZhiFuXiangQingTableViewCell.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/11.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ZhiFuXiangQingTableViewCell.h"

@implementation SSH_ZhiFuXiangQingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configZhiFuCellView];
    }
    return self;
}

- (void)configZhiFuCellView{
    
    self.leftTitleLabel = [[UILabel alloc] init];
    self.leftTitleLabel.font = UIFONTTOOL12;
    self.leftTitleLabel.textColor = COLOR_With_Hex(0x666666);
    [self addSubview:self.leftTitleLabel];
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17.5);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(12);
        make.centerY.mas_equalTo(self);
    }];
    
    self.rightNameLabel = [[UILabel alloc] init];
    self.rightNameLabel.textColor = COLOR_With_Hex(0x222222);
    self.rightNameLabel.font = UIFONTTOOL12;
    self.rightNameLabel.textAlignment = 2;
    [self addSubview:self.rightNameLabel];
    [self.rightNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftTitleLabel.mas_right);
        make.right.mas_equalTo(-17.5);
        make.height.mas_equalTo(12);
        make.centerY.mas_equalTo(self);
    }];
    
}

/*
 @property (nonatomic, strong) UILabel *leftTitleLabel;//左侧label
 @property (nonatomic, strong) UILabel *rightNameLabel;//右侧label
 */

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
