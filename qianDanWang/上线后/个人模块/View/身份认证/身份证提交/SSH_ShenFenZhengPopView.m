//
//  SSH_ShenFenZhengPopView.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/12.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_ShenFenZhengPopView.h"


@interface SSH_ShenFenZhengPopView()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation SSH_ShenFenZhengPopView

+(instancetype)creatView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 7;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = COLOR_With_Hex(0xdbdbdb).CGColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
