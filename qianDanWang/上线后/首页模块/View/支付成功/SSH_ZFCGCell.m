//
//  SSH_ZFCGCell.m
//  DENGFANGSC
//
//  Created by LY on 2018/11/2.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ZFCGCell.h"

@implementation SSH_ZFCGCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    self.titleNameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleNameLabel];
    self.titleNameLabel.font = UIFONTTOOL14;
    self.titleNameLabel.textColor = GrayColor666;
    [self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self);
    }];
    
    self.valueLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.valueLabel];
    self.valueLabel.textColor = ColorBlack222;
    self.valueLabel.font = UIFONTTOOL14;
    self.valueLabel.textAlignment = 2;
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self);
    }];
    
    UIImageView *lineImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_success_xuxian"]];
    [self.contentView addSubview:lineImgView];
    [lineImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(0.5);
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
