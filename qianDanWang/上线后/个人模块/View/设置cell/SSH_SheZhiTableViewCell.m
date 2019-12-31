//
//  SSH_SheZhiTableViewCell.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_SheZhiTableViewCell.h"

@implementation SSH_SheZhiTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configCell];
    }
    return self;
}

- (void)configCell{
    
    UIImageView *jiantouImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wodejiantou"]];
    [self.contentView addSubview:jiantouImgView];
    [jiantouImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(7.5);
        make.height.mas_equalTo(13);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    self.leftTitleLabel = [[UILabel alloc] init];
    self.leftTitleLabel.textColor = ColorBlack222;
    self.leftTitleLabel.font = UIFONTTOOL(15);
    [self.contentView addSubview:self.leftTitleLabel];
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(jiantouImgView.mas_left).offset(-10);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView);
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
