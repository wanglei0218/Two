//
//  LYShareAlertView.m
//  jiaogeqian
//
//  Created by LY on 2018/8/24.
//  Copyright © 2018年 zdtc. All rights reserved.
//

#import "SSH_ShareView.h"
#import "SSH_ShareButton.h"//分享里的按钮view

@interface SSH_ShareView ()

@property (nonatomic, strong) UIView *grayView;
@property (nonatomic, strong) UIView *whiteView;

@end

@implementation SSH_ShareView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)showShareAlertView{
    self.grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self addSubview:self.grayView];
    self.grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = COLOR_WITH_HEX(0xf3f3f3);
    [self.grayView addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(177);
        make.bottom.mas_equalTo(0);
    }];
    
    UILabel *diSanFangShareLabel = [[UILabel alloc] init];
    [self.whiteView addSubview:diSanFangShareLabel];
    diSanFangShareLabel.text = @"第三方分享";
    diSanFangShareLabel.textColor = COLOR_WITH_HEX(0x666666);
    diSanFangShareLabel.font = [UIFont systemFontOfSize:11];
    [diSanFangShareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.height.mas_equalTo(11);
        make.right.mas_equalTo(-15);
    }];
    
    NSArray *shareTitleArray = @[@"微信好友",@"微信朋友圈"];
    CGFloat shareWidth = 65;
    CGFloat shareMargin = (SCREEN_WIDTH-shareWidth*2)/3;
    for (int i = 0; i < shareTitleArray.count; i++) {
        SSH_ShareButton *shareButton = [[SSH_ShareButton alloc] init];
        [self.whiteView addSubview:shareButton];
        shareButton.bottomLabel.text = shareTitleArray[i];
        //shareButton.topImgView.backgroundColor = [UIColor redColor];
        shareButton.topImgView.image = [UIImage imageNamed:shareTitleArray[i]];
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(shareWidth);
            make.height.mas_equalTo(77);
            make.top.mas_equalTo(diSanFangShareLabel.mas_bottom).offset(15);
            make.left.mas_equalTo(shareMargin+(shareMargin+shareWidth)*i);
        }];
        shareButton.tag = 40030+i;
        [shareButton addTarget:self action:@selector(shareToOtherPlatformAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton *cancleShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.whiteView addSubview:cancleShareButton];
    [cancleShareButton addTarget:self action:@selector(clickCancelShareAction) forControlEvents:UIControlEventTouchUpInside];
    cancleShareButton.backgroundColor = [UIColor whiteColor];
    [cancleShareButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleShareButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancleShareButton setTitleColor:COLOR_WITH_HEX(0x222222) forState:UIControlStateNormal];
    [cancleShareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([touches anyObject].view != self.whiteView) {
        [self clickCancelShareAction];
    }
}

//分享的方法
- (void)shareToOtherPlatformAction:(SSH_ShareButton *)sender{
    if (sender.tag == 40030) {
        [MobClick event:@"Invitattion activitties-2"];
    } else {
        [MobClick event:@"Invitattion activitties-3"];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickShareButtonAction:)]) {
        [self.delegate clickShareButtonAction:(int)sender.tag-40030];
    }
}

//取消分享的方法
- (void)clickCancelShareAction{
    [self.whiteView removeFromSuperview];
    [self.grayView removeFromSuperview];
    [self removeFromSuperview];
}

@end
