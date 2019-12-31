//
//  SSH_ChongZhiHuoDongTableViewCell.m
//  DENGFANGSC
//
//  Created by LY on 2018/12/15.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ChongZhiHuoDongTableViewCell.h"

@implementation SSH_ChongZhiHuoDongTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self tydSetupCell];
    }
    return self;
}

- (void)tydSetupCell{
    
    self.beijing_imgView = [[UIImageView alloc] init];
    [self addSubview:self.beijing_imgView];
    [self.beijing_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(330);
        make.height.mas_equalTo(103);
        make.top.mas_equalTo(4);
        make.centerX.mas_equalTo(self);
    }];
    
    self.chongzhi_num_Label = [[UILabel alloc] init];
    self.chongzhi_num_Label.font = UIFONTTOOL(30);
    self.chongzhi_num_Label.textAlignment = 1;
    [self.beijing_imgView addSubview:self.chongzhi_num_Label];
    [self.chongzhi_num_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(265);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(27);
    }];
    
    self.song_num_Label = [[UILabel alloc] init];
    self.song_num_Label.font = UIFONTTOOL16;
    self.song_num_Label.textAlignment = 1;
    self.song_num_Label.textColor = COLOR_With_Hex(0x7a7a7a);
    [self.beijing_imgView addSubview:self.song_num_Label];
    [self.song_num_Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(self.chongzhi_num_Label);
        make.height.mas_equalTo(16);
        make.top.mas_equalTo(self.chongzhi_num_Label.mas_bottom).offset(9);
    }];
    
}

/*
 @property (nonatomic, strong) UIImageView *beijing_imgView;
 @property (nonatomic, strong) UILabel *chongzhi_num_Label;
 @property (nonatomic, strong) UILabel *song_num_Label;
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
