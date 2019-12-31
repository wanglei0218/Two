//
//  HYFirstNormalHeader.m
//  jiaogeqian
//
//  Created by 河神 on 2019/4/30.
//  Copyright © 2019 zdtc. All rights reserved.
//

#import "USERFirstNormalHeader.h"

@implementation USERFirstNormalHeader

- (void)prepare{
    [super prepare];
    
    self.stateLabel.font = [UIFont systemFontOfSize:WidthScale(11)];
    
    self.lastUpdatedTimeLabel.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
