//
//  SSH_ZYJumpView.m
//  qianDanWang
//
//  Created by AN94 on 9/20/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_ZYJumpView.h"

@implementation SSH_ZYJumpView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
    }
    return self;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, WidthScale(5), ScreenWidth / 2, WidthScale(20))];
        _titleLabel.text = @"温馨提示";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), SCREEN_WIDTH/2, WidthScale(50))];
        _contentLabel.text = @"该海报为会员专属，您还未开通会员\n请您先开通会员";
        _contentLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
//        _contentLabel.textColor = Colorbdbdbd;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (UIButton *)leftBtn{
    if(!_leftBtn){
        _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(WidthScale(5), CGRectGetMaxY(self.contentLabel.frame) + WidthScale(5), WidthScale(60), WidthScale(30))];
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:COLOR_WITH_HEX(0xf9f9f9) forState:UIControlStateNormal];
        _leftBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _leftBtn.layer.borderWidth = 1;
        _leftBtn.layer.cornerRadius = 5;
        _leftBtn.layer.masksToBounds = YES;
        [_leftBtn addTarget:self action:@selector(didSelecteTheLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn{
    if(!_rightBtn){
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth / 2 - WidthScale(65), CGRectGetMaxY(self.contentLabel.frame) + WidthScale(5), WidthScale(60), WidthScale(30))];
        [_rightBtn setBackgroundColor:RGB(235, 0, 0)];
        NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"成为会员" attributes:@{
                                                                                                  NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                                                                  NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                                                  }];
        [_rightBtn setAttributedTitle:attr forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(didSelecteTheRightBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (void)didSelecteTheLeftBtn{
    if([self.delegate respondsToSelector:@selector(didSelecteTheBtnWithTarget:)]){
        [self.delegate didSelecteTheBtnWithTarget:1];
    }
}

- (void)didSelecteTheRightBtn{
    if([self.delegate respondsToSelector:@selector(didSelecteTheBtnWithTarget:)]){
        [self.delegate didSelecteTheBtnWithTarget:2];
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
