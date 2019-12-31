//
//  SSH_CreditCollectionReusableView.m
//  qianDanWang
//
//  Created by AN94 on 9/24/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_CreditCollectionReusableView.h"

@implementation SSH_CreditCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.label];
    }
    return self;
}

- (UILabel *)label{
    if(!_label){
        _label = [[UILabel alloc]initWithFrame:CGRectMake(WidthScale(15), 0, SCREEN_WIDTH - WidthScale(15), WidthScale(31))];
        _label.font = [UIFont systemFontOfSize:13];
        _label.textColor = COLOR_WITH_HEX(0x333333);
    }
    return _label;
}

@end
