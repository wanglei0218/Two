//
//  SSH_ZuiDuoCityView.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/14.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_ZuiDuoCityView.h"

@implementation SSH_ZuiDuoCityView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.shanChuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shanChuButton setBackgroundImage:[UIImage imageNamed:@"城市选择叉"] forState:UIControlStateNormal];
        [self.shanChuButton setEnlargeEdge:30];
        [self addSubview:self.shanChuButton];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    self.titleLabel.frame = self.bounds;

    
    self.shanChuButton.size = CGSizeMake(10, 10);
    self.shanChuButton.center = CGPointMake(self.width-2, 2);
    
    
}

@end
