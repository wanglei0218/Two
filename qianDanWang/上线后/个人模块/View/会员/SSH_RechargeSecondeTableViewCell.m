//
//  SSH_RechargeSecondeTableViewCell.m
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_RechargeSecondeTableViewCell.h"

@implementation SSH_RechargeSecondeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)selectBut:(UIButton *)sender {
    self.selectionButton(sender);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
