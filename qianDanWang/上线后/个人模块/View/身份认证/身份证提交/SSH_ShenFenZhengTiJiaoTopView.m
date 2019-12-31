//
//  SSH_ShenFenZhengTiJiaoTopView.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/12.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_ShenFenZhengTiJiaoTopView.h"

@implementation SSH_ShenFenZhengTiJiaoTopView

+(instancetype)creatView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
