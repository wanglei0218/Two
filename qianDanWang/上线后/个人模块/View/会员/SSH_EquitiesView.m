//
//  SSH_EquitiesView.m
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_EquitiesView.h"

@implementation SSH_EquitiesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.lineLabel];
        [self addSubview:self.textView];
        [self addSubview:self.bottomBtn];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WidthScale(285), WidthScale(48))];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = COLOR_WITH_HEX(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"权益说明";
    }
    return _titleLabel;
}

- (UILabel *)lineLabel{
    if(!_lineLabel){
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame),  WidthScale(285), 1)];
        _lineLabel.backgroundColor = RGB(211, 211, 211);
    }
    return _lineLabel;
}

- (UITextView *)textView{
    if(!_textView){
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(WidthScale(5), CGRectGetMaxY(self.lineLabel.frame), WidthScale(275), WidthScale(336))];
        NSString *str = @"1.购买会员：叠加购买会员卡，权益使用次数累计叠加。\n2.退单无忧：购买会员等级不同享受退单次数权益不同，成为普通会员在会员有效期内可退6次，vip会员可退单9次，高级会员可以退单12次，至尊会员可退单15次。\n3.推广海报：海报任意使用，不限次数。当前若无使用权限，购买会员卡立即生效。\n4.自动抢单：系统依据累计开通会员次数和充值金币金额权重随机分配订单。\n5.推广贷款：普通用户最高返4%，会员最高可返5%（此功能正在开发，敬请期待）\n6.办卡佣金：普通用户最高208元/张，尊享会员最高260元/张（此功能正在开发，敬请期待）\n7.信用查询：免费使用信用查询。（此功能正在开发，敬请期待）";
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc]initWithString:str attributes:@{
                                        NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:14],
                                        NSForegroundColorAttributeName:COLOR_WITH_HEX(0x666666)}];
        NSRange frist = [str rangeOfString:@"购买会员"];
        NSRange seconde = [str rangeOfString:@"退单无忧"];
        NSRange thride = [str rangeOfString:@"推广海报"];
        NSRange fourth = [str rangeOfString:@"自动抢单"];
        NSRange fifth = [str rangeOfString:@"推广贷款"];
        NSRange sixth = [str rangeOfString:@"办卡佣金"];
        NSRange seventh = [str rangeOfString:@"信用查询"];
        
        [mAttr addAttributes:@{
                               NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:14],
                               NSForegroundColorAttributeName:COLOR_WITH_HEX(0x222222)} range:frist];
        [mAttr addAttributes:@{
                               NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:14],
                               NSForegroundColorAttributeName:COLOR_WITH_HEX(0x222222)} range:seconde];
        [mAttr addAttributes:@{
                               NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:14],
                               NSForegroundColorAttributeName:COLOR_WITH_HEX(0x222222)} range:thride];
        [mAttr addAttributes:@{
                               NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:14],
                               NSForegroundColorAttributeName:COLOR_WITH_HEX(0x222222)} range:fourth];
        [mAttr addAttributes:@{
                               NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:14],
                               NSForegroundColorAttributeName:COLOR_WITH_HEX(0x222222)} range:fifth];
        [mAttr addAttributes:@{
                               NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:14],
                               NSForegroundColorAttributeName:COLOR_WITH_HEX(0x222222)} range:sixth];
        [mAttr addAttributes:@{
                               NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Semibold" size:14],
                               NSForegroundColorAttributeName:COLOR_WITH_HEX(0x222222)} range:seventh];
        
        _textView.attributedText = mAttr;
    }
    return _textView;
}

- (UIButton *)bottomBtn{
    if(!_bottomBtn){
        _bottomBtn = [[UIButton alloc]initWithFrame:CGRectMake((WidthScale(285) - WidthScale(215)) / 2, CGRectGetMaxY(self.textView.frame) + WidthScale(20), WidthScale(215), WidthScale(40))];
        _bottomBtn.layer.cornerRadius = 20;
        _bottomBtn.layer.masksToBounds = YES;
        _bottomBtn.backgroundColor = RGB(26, 71, 255);
        NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"知道了" attributes:@{
                                                        NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                        NSForegroundColorAttributeName:COLOR_WITH_HEX(0xfefefe)
                                                                                                 }];
        [_bottomBtn setAttributedTitle:attr forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(didSelectTheBottomBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (void)didSelectTheBottomBtn{
    if([self.delegate respondsToSelector:@selector(didSelecteTheKnow)]){
        [self.delegate didSelecteTheKnow];
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
