//
//  SSH_MemberOtherTableViewCell.m
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_MemberOtherTableViewCell.h"

@implementation SSH_MemberOtherTableViewCell

- (void)setCellContentWithData:(NSDictionary *)data{
    
    /*
     @property (weak, nonatomic) IBOutlet UIImageView *leftImage;                ///<图片
     @property (weak, nonatomic) IBOutlet UILabel *topLabel;                     ///<标题
     @property (weak, nonatomic) IBOutlet UILabel *bottomLabel;                  ///<内容
     @property (weak, nonatomic) IBOutlet UILabel *rightLabel;                   ///<按钮
     */
    
    self.leftImage.image = [UIImage imageNamed:[data objectForKey:@"name"]];
    self.topLabel.text = [data objectForKey:@"name"];
    self.bottomLabel.text = [data objectForKey:@"content"];
    if ([[data objectForKey:@"right"] isEqualToString:@"敬请期待"]) {
        self.rightLabel.backgroundColor = COLOR_WITH_HEX(0xece8e2);
        self.rightLabel.textColor = COLOR_WITH_HEX(0xbf9d84);
    }
    self.rightLabel.text = [data objectForKey:@"right"];
    
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
