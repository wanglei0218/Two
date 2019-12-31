//
//  SSH_WoDeZhangHuViewCell.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_WoDeZhangHuViewCell.h"

@implementation SSH_WoDeZhangHuViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    self.backgroundColor = ColorBackground_Line;
    self.contentView.backgroundColor = COLORWHITE;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(7.5);
    }];
    
    self.leftImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.leftImgView];
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(25);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    self.cellTitle = [[UILabel alloc] init];
    self.cellTitle.font = UIFONTTOOL15;
    self.cellTitle.textColor = ColorBlack222;
    [self.contentView addSubview:self.cellTitle];
    [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImgView.mas_right).offset(14);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(self.leftImgView);
    }];
    
    UIImageView *rightJiantouImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wodejiantou"]];
    [self.contentView addSubview:rightJiantouImgView];
    [rightJiantouImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(7.5);
        make.height.mas_equalTo(13);
        make.centerY.mas_equalTo(self.leftImgView);
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
