//
//  SSH_GeRenZhongXinListCell.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/17.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_GeRenZhongXinListCell.h"

@implementation SSH_GeRenZhongXinListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell{
    
    self.leftImgView = [[UIImageView alloc] init];
    [self addSubview:self.leftImgView];
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(18);
        make.centerY.mas_equalTo(self);
    }];
    
    self.cellTitle = [[UILabel alloc] init];
    self.cellTitle.font = UIFONTTOOL15;
    self.cellTitle.textColor = ColorBlack222;
    [self addSubview:self.cellTitle];
    [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImgView.mas_right).offset(15);
//        make.width.mas_equalTo(260);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
    }];
    
    self.hotImage = [[UIImageView alloc] init];
    [self addSubview:self.hotImage];
    [self.hotImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.left.mas_equalTo(self.cellTitle.mas_right).offset(11);
    }];
    self.hotImage.hidden = YES;
    
    UIImageView *rightJiantouImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wodejiantou"]];
    [self addSubview:rightJiantouImgView];
    [rightJiantouImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(7.5);
        make.height.mas_equalTo(13);
        make.centerY.mas_equalTo(self);
    }];
    
    self.rightJinBiLabel = [[UILabel alloc] init];
    self.rightJinBiLabel.hidden = YES;
    [self addSubview:self.rightJinBiLabel];
    self.rightJinBiLabel.textAlignment = 2;
    self.rightJinBiLabel.font = UIFONTTOOL13;
    self.rightJinBiLabel.textColor = ColorZhuTiHongSe;
    [self.rightJinBiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rightJiantouImgView.mas_left).offset(-10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(13);
        make.centerY.mas_equalTo(self);
    }];
    
    self.rightYiShiMing = [[UIImageView alloc] init];
    self.rightYiShiMing.hidden = YES;
    [self addSubview:self.rightYiShiMing];
    [self.rightYiShiMing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rightJiantouImgView.mas_left).offset(-10);
        make.width.mas_equalTo(71);
        make.height.mas_equalTo(19);
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
