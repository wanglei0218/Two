//
//  SSH_JiangLiGuiZeTableViewCell.m
//  DENGFANGSC
//
//  Created by LY on 2018/12/11.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_JiangLiGuiZeTableViewCell.h"

@implementation SSH_JiangLiGuiZeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupCellLayout];
    }
    return self;
}

- (void)setupCellLayout{
    
    //左边序号label
    self.leftLabel = [[UILabel alloc] init];
    [self addSubview:self.leftLabel];
    self.leftLabel.font = UIFONTTOOL(13);
    self.leftLabel.textColor = COLORWHITE;
    self.leftLabel.textAlignment = 2;
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(33);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(13);
    }];
    
    //右边规则内容
    //这个行间距要求是：8
    self.rightLabel = [[UILabel alloc] init];
    [self addSubview:self.rightLabel];
    self.rightLabel.textColor = COLORWHITE;
    self.rightLabel.font = UIFONTTOOL13;
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftLabel.mas_right).offset(9);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(0);
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
