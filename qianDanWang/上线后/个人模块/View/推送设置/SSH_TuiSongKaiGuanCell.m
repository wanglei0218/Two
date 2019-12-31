//
//  SSH_TuiSongKaiGuanCell.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/13.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_TuiSongKaiGuanCell.h"

@implementation SSH_TuiSongKaiGuanCell

+ (id)cellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    NSString *className = NSStringFromClass([self class]);
    [tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:className];
    
    return [tableView dequeueReusableCellWithIdentifier:className forIndexPath:indexPath];
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
