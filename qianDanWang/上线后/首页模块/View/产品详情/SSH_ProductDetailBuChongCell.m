//
//  SSH_ProductDetailBuChongCell.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/4/16.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_ProductDetailBuChongCell.h"

@implementation SSH_ProductDetailBuChongCell


-(void)setArr:(NSArray *)arr{
    
    _arr = arr;
//    NSLog(@"_arr == %@",_arr);
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *lab = nil;
    CGFloat labelW = (SCREEN_WIDTH-90)/3;
    for (int i=0; i<_arr.count; i++) {
    
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        label.text = _arr[i];
        label.textColor = COLOR_WITH_HEX(0x666666);
        label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.borderWidth = 1;
        label.layer.borderColor = COLOR_WITH_HEX(0xf3f3f3).CGColor;
        label.layer.cornerRadius = 5;
        
        int row = i/3;
        int col = i%3;
        label.frame = CGRectMake(30+(labelW+15)*col, 15+(28+15)*row, labelW, 28);
        lab = label;
    }
    
    self.buChongCellH = CGRectGetMaxY(lab.frame)+15;
    
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
