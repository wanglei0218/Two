//
//  SSH_New_SYBDTableViewCell.m
//  qianDanWang
//
//  Created by 小锦鲤 on 2019/8/21.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_New_SYBDTableViewCell.h"

@interface SSH_New_SYBDTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *tongYiBut;

@end

@implementation SSH_New_SYBDTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTongYi:(BOOL)TongYi {
    if (TongYi) {
        self.tongYiBut.userInteractionEnabled = NO;
        [self.tongYiBut setTitle:@"我同意" forState:UIControlStateNormal];
        self.tongYiBut.backgroundColor = COLOR_WITH_HEX(0xbbbbbb);
    } else {
        
    }
}

- (IBAction)zunShouButton:(UIButton *)sender {
    self.didSelectionButton(sender);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
