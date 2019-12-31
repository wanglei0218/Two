//
//  USERAddressTableViewCell.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/19.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERAddressTableViewCell.h"

@implementation USERAddressTableViewCell



- (IBAction)editBtnClick:(UIButton *)sender {
    self.editBtnBlock();
}


- (IBAction)deleteBtnClick:(UIButton *)sender {
    self.deleteBtnBlock();
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
