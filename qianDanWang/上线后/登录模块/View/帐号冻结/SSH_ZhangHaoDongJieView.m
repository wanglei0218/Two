//
//  DENGFANGAccountsFreezeView.m
//  DENGFANGSC
//
//  Created by 锦鳞附体^_^ on 2018/11/26.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ZhangHaoDongJieView.h"


@interface SSH_ZhangHaoDongJieView()
@property (nonatomic,strong) UILabel *reasonLabel;

@end

@implementation SSH_ZhangHaoDongJieView

- (UILabel *)reasonLabel {
    if (!_reasonLabel) {
        _reasonLabel = [[UILabel alloc] init];
        _reasonLabel.textColor = GrayColor666;
        _reasonLabel.font = [UIFont systemFontOfSize:14];
        _reasonLabel.numberOfLines = 3;
    }
    return _reasonLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

+ (void)showInSuperView:(NSString *)info {
    SSH_ZhangHaoDongJieView *accountView = [[SSH_ZhangHaoDongJieView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    accountView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    accountView.reasonLabel.text = info;
    [[UIApplication sharedApplication].keyWindow addSubview:accountView];
}

- (void)setupUI {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.centerX = self.centerX;
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.offset(222);
        make.size.mas_equalTo(CGSizeMake(295, 223));
    }];
    backView.layer.cornerRadius = 10;
    
    UILabel *titleLable = [[UILabel alloc] init];
    [backView addSubview:titleLable];
    titleLable.text = @"冻结提醒";
    titleLable.textColor = ColorBlack222;
    titleLable.font = [UIFont boldSystemFontOfSize:17];
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(18.5);
        make.centerX.mas_equalTo(backView);
    }];
    
    //冻结原因
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.textColor = GrayColor666;
    infoLabel.text = @"冻结原因:";
    infoLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLable.mas_bottom).offset(21);
        make.left.offset(20);
    }];
    
    //具体内容
    [backView addSubview:self.reasonLabel];
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(infoLabel.mas_bottom).offset(15);
        make.left.offset(50);
        make.right.offset(-50);
    }];
    
    //确认按钮
    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:enterButton];
    [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.reasonLabel.mas_bottom).offset(25);
        make.centerX.mas_equalTo(backView);
        make.width.mas_equalTo(115);
        make.height.mas_equalTo(30);
    }];
    [enterButton setTitle:@"确定" forState:UIControlStateNormal];
    enterButton.backgroundColor = COLOR_WITH_HEX(0xe63d40);
    enterButton.titleLabel.font = [UIFont systemFontOfSize:15];
    enterButton.layer.cornerRadius = 15;
    [enterButton addTarget:self action:@selector(enterButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)enterButtonClick {
    [self removeFromSuperview];
}
@end
