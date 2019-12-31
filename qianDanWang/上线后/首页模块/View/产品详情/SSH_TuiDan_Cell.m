//
//  SSH_TuiDan_Cell.m
//  qianDanWang
//
//  Created by 畅轻 on 2019/12/18.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_TuiDan_Cell.h"

@interface SSH_TuiDan_Cell ()


@end

@implementation SSH_TuiDan_Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)tuidanDidSelectedButton:(UIButton *)sender {
    self.didSelectedBut(sender);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
