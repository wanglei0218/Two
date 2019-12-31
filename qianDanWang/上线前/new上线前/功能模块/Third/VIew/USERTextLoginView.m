//
//  USERTextLoginView.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/18.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERTextLoginView.h"

@implementation USERTextLoginView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self creatLoginInputView];
    }
    return self;
}
- (void)creatLoginInputView
{
    //icon
    self.iconImg = [[UIImageView alloc] init];
    [self addSubview:self.iconImg];
    self.iconImg.sd_layout.centerYEqualToView(self).widthIs(18).heightIs(20).leftSpaceToView(self, WidthScale(28));
    
    //输入框
    self.inputContent = [[UITextField alloc] init];
    [self addSubview:self.inputContent];
    self.inputContent.sd_layout.leftSpaceToView(self.iconImg, WidthScale(10)).centerYEqualToView(self).widthIs(ScreenWidth*0.5).heightIs(40);
    self.inputContent.textColor = TEXTMAINCOLOR;
    self.inputContent.tintColor = TEXTFUCOLOR;
    self.inputContent.font = [UIFont systemFontOfSize:WidthScale(16)];
    self.inputContent.textAlignment = NSTextAlignmentLeft;
    
    //验证码
    self.inputVeyCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.inputVeyCode];
    self.inputVeyCode.sd_layout.rightSpaceToView(self, 30).centerYEqualToView(self).heightIs(30).widthIs(WidthScale(85));
    [self.inputVeyCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.inputVeyCode setTitleColor:TEXTFUCOLOR forState:UIControlStateNormal];
    self.inputVeyCode.titleLabel.font = [UIFont systemFontOfSize:14];
    self.inputVeyCode.hidden = YES;
    
    //眼睛
    self.eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.eyeBtn];
    self.eyeBtn.sd_layout.centerYEqualToView(self).rightSpaceToView(self, 30).widthIs(20).heightIs(20);
    [self.eyeBtn setImage:[UIImage imageNamed:@"eyeone"] forState:UIControlStateNormal];
    self.eyeBtn.hidden = YES;
    
    UIView *viewLine = [[UIView alloc] init];
    [self addSubview:viewLine];
    viewLine.sd_layout.centerXEqualToView(self).widthIs(ScreenWidth-30).heightIs(1.5f).bottomSpaceToView(self, 0);
    viewLine.backgroundColor = RGB(220, 220, 220);
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
