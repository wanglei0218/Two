//
//  SSH_ZiZhiXinXiListView.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/21.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_ZiZhiXinXiListView.h"

@implementation SSH_ZiZhiXinXiListView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = CCRandomColor;
//        [self setUI];
    }
    return self;
}

-(void)setShaiXuanM:(SSH_ShaiXuanModel *)shaiXuanM{
    _shaiXuanM = shaiXuanM;
    
    
    UILabel *titleLab = [[UILabel alloc] init];
    [self addSubview:titleLab];
    self.titleLab = titleLab;
    titleLab.textColor = ColorBlack222;
    titleLab.font = UIFONTTOOL13;
    titleLab.text = _shaiXuanM.conditionName;
    
    UIButton *inputButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [inputButton setBackgroundColor:COLOR_WITH_HEX(0xf3f3f3)];
    [inputButton setTitleColor:ColorBlack222 forState:UIControlStateNormal];
    [inputButton.titleLabel setFont:UIFONTTOOL12];
    inputButton.layer.cornerRadius = 12;
    inputButton.clipsToBounds = YES;
    inputButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    inputButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self addSubview:inputButton];
    [inputButton setTitle:@"请选择" forState:UIControlStateNormal];
    self.inputButton = inputButton;
    
    
    UIImageView *qianTouImage1 = [[UIImageView alloc] init];
    qianTouImage1.image = [UIImage imageNamed:@"筛选箭头下"];
    [inputButton addSubview:qianTouImage1];
    self.qianTouImage1 = qianTouImage1;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(29);
    }];
    
    [self.inputButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_top);
        make.left.mas_equalTo(self.titleLab.mas_right).offset(1);
        make.height.mas_equalTo(29);
        make.width.mas_equalTo(self.width-60-45);
    }];
    
    [self.qianTouImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(self.inputButton.mas_centerY);
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
