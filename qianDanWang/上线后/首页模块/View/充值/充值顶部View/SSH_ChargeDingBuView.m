//
//  SSH_ChargeDingBuView.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ChargeDingBuView.h"

@implementation SSH_ChargeDingBuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createChongZhiView];
    }
    return self;
}
-(void)createChongZhiView{
    self.bgImgView = [[UIImageView alloc]init];
    [self addSubview:self.bgImgView];
    self.bgImgView.image = [UIImage imageNamed:@"chongzhi_no"];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    self.songImgView = [[UIImageView alloc]init];
    [self.bgImgView addSubview:self.songImgView];
    self.songImgView.image = [UIImage imageNamed:@"chongzhi_song"];
    [self.songImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(70);
    }];
    
    //金币
    self.jinbiLabel = [[UILabel alloc]init];
    [self.bgImgView addSubview:self.jinbiLabel];
    self.jinbiLabel.textAlignment = NSTextAlignmentCenter;
    self.jinbiLabel.textColor = ColorBlack222;
    self.jinbiLabel.font = UIFONTTOOL24;
    [self.jinbiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(31);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(20);
    }];
    
   
    
    //价格
    self.moneyLabel = [[UILabel alloc]init];
    [self.bgImgView addSubview:self.moneyLabel];
    self.moneyLabel.textColor = GrayColor666;
    self.moneyLabel.font = UIFONTTOOL12;
    self.moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jinbiLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(13);
    }];
    
    if (IS_IPHONE5) {
        self.jinbiLabel.font = UIFONTTOOL17;
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.jinbiLabel.mas_bottom).offset(3);
        }];
    }
    
    
    //送
    self.songLabel = [[UILabel alloc]init];
    [self.songImgView addSubview:self.songLabel];
    self.songLabel.textColor = COLORWHITE;
    self.songLabel.font = UIFONTTOOL12;
    self.songLabel.textAlignment = NSTextAlignmentCenter;
    [self.songLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(22);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
