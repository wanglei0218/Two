//
//  SSH_CreditDetailsBottomVIew.m
//  qianDanWang
//
//  Created by AN94 on 9/24/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_CreditDetailsBottomView.h"

@implementation SSH_CreditDetailsBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /*
         @property (nonatomic,strong)UILabel *topLabel;              ///<顶部
         @property (nonatomic,strong)UIButton *leftBtn;              ///<立即计算
         @property (nonatomic,strong)UIButton *rightBtn;             ///<重新计算
         */
        [self addSubview:self.topLabel];
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
    }
    return self;
}

- (UILabel *)topLabel{
    if(!_topLabel){
        _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, WidthScale(10), SCREEN_WIDTH, WidthScale(20))];
        _topLabel.textColor = COLOR_WITH_HEX(0xc8c8c8);
        _topLabel.font = [UIFont systemFontOfSize:14];
        _topLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topLabel;
}

- (UIButton *)leftBtn{
    if(!_leftBtn){
        _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(WidthScale(20), CGRectGetMaxY(self.topLabel.frame) + WidthScale(20), WidthScale(155), WidthScale(45))];
        NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"立即计算" attributes:@{
                                                                            NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                                            NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                                                  }];
        _leftBtn.layer.cornerRadius = WidthScale(45) / 2;
        _leftBtn.layer.masksToBounds = YES;
        [_leftBtn setAttributedTitle:attr forState:UIControlStateNormal];
        _leftBtn.backgroundColor = COLOR_WITH_HEX(0x0064ff);
        [_leftBtn addTarget:self action:@selector(didSelectTheLeftBtn) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _leftBtn;
}

- (UIButton *)rightBtn{
    if(!_rightBtn){
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - WidthScale(175), CGRectGetMaxY(self.topLabel.frame) + WidthScale(20), WidthScale(155), WidthScale(45))];
        NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"重新计算" attributes:@{
                                                                            NSFontAttributeName:[UIFont systemFontOfSize:18],
                                                                            NSForegroundColorAttributeName:COLOR_WITH_HEX(0x0064ff)
                                                                                                  }];
        _rightBtn.layer.cornerRadius = WidthScale(45) / 2;
        _rightBtn.layer.masksToBounds = YES;
        [_rightBtn setAttributedTitle:attr forState:UIControlStateNormal];
        _rightBtn.layer.borderColor = COLOR_WITH_HEX(0x0064ff).CGColor;
        _rightBtn.layer.borderWidth = 0.5;
        [_rightBtn addTarget:self action:@selector(didSelectTheRightBtn) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _rightBtn;
}

- (void)didSelectTheLeftBtn{
    if([self.delegate respondsToSelector:@selector(didSelecteTheBtnWithTarget:)]){
        [self.delegate didSelecteTheBtnWithTarget:0];
    }
}

- (void)didSelectTheRightBtn{
    if([self.delegate respondsToSelector:@selector(didSelecteTheBtnWithTarget:)]){
        [self.delegate didSelecteTheBtnWithTarget:1];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
