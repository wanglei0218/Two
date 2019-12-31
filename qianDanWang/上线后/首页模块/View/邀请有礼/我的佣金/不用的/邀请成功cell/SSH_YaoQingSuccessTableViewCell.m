//
//  SSH_YaoQingSuccessTableViewCell.m
//  DENGFANGSC
//
//  Created by LY on 2018/12/11.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_YaoQingSuccessTableViewCell.h"

@implementation SSH_YaoQingSuccessTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupYaoQingCell];
    }
    return self;
}

- (void)setupYaoQingCell{
    /*
     @property (nonatomic, strong) UILabel *userLabel;//用户
     @property (nonatomic, strong) UILabel *timeLabel;//时间
     @property (nonatomic, strong) UILabel *jinbiLabel;//金币
     */
    self.userLabel = [[UILabel alloc] init];
    self.userLabel.font = UIFONTTOOL13;
    self.userLabel.textColor = ColorBlack222;
    [self addSubview:self.userLabel];
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(13);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = UIFONTTOOL12;
    self.timeLabel.textColor = GrayColor666;
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.userLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(12);
    }];
    
    self.jinbiLabel = [[UILabel alloc] init];
    self.jinbiLabel.font = UIFONTTOOL13;
    self.jinbiLabel.textColor = COLOR_With_Hex(0xf3591e);
    self.jinbiLabel.textAlignment = 2;
    self.jinbiLabel.hidden = YES;
    [self addSubview:self.jinbiLabel];
    [self.jinbiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(13);
        make.centerY.mas_equalTo(self);
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
