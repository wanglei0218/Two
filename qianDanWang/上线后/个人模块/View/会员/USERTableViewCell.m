//
//  USERTableViewCell.m
//  qianDanWang
//
//  Created by AN94 on 9/20/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "USERTableViewCell.h"

@implementation USERTableViewCell

- (void)setCellData:(NSArray *)cellData{
    _cellData = cellData;
    
    for (int i = 0 ; i < cellData.count ; i++) {
        
    }
    
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
