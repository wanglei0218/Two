//
//  SSH_New_QYZPTableViewCell.m
//  qianDanWang
//
//  Created by 小锦鲤 on 2019/8/21.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_New_QYZPTableViewCell.h"

@implementation SSH_New_QYZPTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)buttonDidSelection:(UIButton *)sender {
    self.blackDidButton(sender);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
