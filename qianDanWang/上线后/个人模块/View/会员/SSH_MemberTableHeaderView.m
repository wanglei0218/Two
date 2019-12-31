//
//  SSH_MemberTableHeaderView.m
//  qianDanWang
//
//  Created by AN94 on 9/19/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_MemberTableHeaderView.h"

@implementation SSH_MemberTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageV];
    }
    return self;
}

- (UIImageView *)imageV{
    if(!_imageV){
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - WidthScale(282)) / 2, WidthScale(30), WidthScale(282), WidthScale(17))];
    }
    return _imageV;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
