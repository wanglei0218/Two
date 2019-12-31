//
//  SSH_ShoucangZhuangTaiTableViewCell.m
//  DENGFANGSC
//
//  Created by LY on 2018/12/12.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ShoucangZhuangTaiTableViewCell.h"

@implementation SSH_ShoucangZhuangTaiTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setShoucangStatusView];
    }
    return self;
}

- (void)setShoucangStatusView{
    self.statusTitleLabel = [[UILabel alloc] init];
    [self addSubview:self.statusTitleLabel];
    self.statusTitleLabel.textColor = GrayColor666;
    self.statusTitleLabel.font = UIFONTTOOL12;
    [self.statusTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
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
