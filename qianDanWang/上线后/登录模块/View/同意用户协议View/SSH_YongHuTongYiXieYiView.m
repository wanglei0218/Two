//
//  DENGFANGAgreeUserProtocolView.m
//  DENGFANGSC
//
//  Created by LY on 2018/9/21.
//  Copyright © 2018年 LY. All rights reserved.
//这个页面在外面的布局直接写成距左距右为0

#import "SSH_YongHuTongYiXieYiView.h"

@implementation SSH_YongHuTongYiXieYiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAgreeProtocolView];
    }
    return self;
}

- (void)setupAgreeProtocolView{
    
    UIView *protocolBackView = [[UIView alloc] init];
    [self addSubview:protocolBackView];
    [protocolBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(210);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(17);
    }];
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [protocolBackView addSubview:self.selectButton];
    [self.selectButton setImage:[UIImage imageNamed:@"dianji"] forState:UIControlStateNormal];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.height.mas_equalTo(15);
        make.centerY.mas_equalTo(protocolBackView);
    }];
    
    UILabel *serviceProLabel = [[UILabel alloc] init];
    serviceProLabel.font = [UIFont systemFontOfSize:12];
    serviceProLabel.textColor = ColorZhuTiHongSe;
    [protocolBackView addSubview:serviceProLabel];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意《用户服务协议》"];
    NSRange range = NSMakeRange(0, 7);
    [attString addAttributes:@{NSForegroundColorAttributeName:GrayColor666} range:range];
    serviceProLabel.attributedText = attString;
    [serviceProLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectButton.mas_right).offset(5);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.selectButton);
        make.height.mas_equalTo(12);
    }];
    serviceProLabel.userInteractionEnabled = YES;
    
    self.protocolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [protocolBackView addSubview:self.protocolButton];
    [self.protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectButton.mas_right).offset(5);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.selectButton);
        make.height.mas_equalTo(12);
    }];
}

@end
