//
//  DENGFANGHomeLocationView.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_CurrentLocationView.h"


@interface SSH_CurrentLocationView ()

/** 当前定位 */
@property (strong, nonatomic) UILabel *cityLabel;

/**
 小图标
 */
@property (strong, nonatomic) UIImageView *sImgView;

@end

@implementation SSH_CurrentLocationView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createHomeLocationView];
    }
    return self;
}
-(void)createHomeLocationView{
    [self addSubview:self.cityLabel];
    [self addSubview:self.sImgView];
    [self addSubview:self.nowLoctionLabel];
    [self addSubview:self.reLoctionBtn];

    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = GrayLineColor;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [self setupConstraints];
    
}
#pragma mark 懒加载
-(UILabel *)cityLabel{
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc]init];
        _cityLabel.text = @"当前定位";
        _cityLabel.font = UIFONTTOOL13;
        _cityLabel.textColor = ColorBlack999;
        _cityLabel.textAlignment = NSTextAlignmentRight;
    }
    return _cityLabel;
}
-(UIImageView *)sImgView{
    if (!_sImgView) {
        _sImgView = [[UIImageView alloc]init];
        _sImgView.image = [UIImage imageNamed:@"h_dingwei"];
    }
    return _sImgView;
}
-(UILabel *)nowLoctionLabel{
    if (!_nowLoctionLabel) {
        _nowLoctionLabel = [[UILabel alloc]init];
        _nowLoctionLabel.text = @"";
        _nowLoctionLabel.textColor = ColorZhuTiHongSe;
        _nowLoctionLabel.font = UIFONTTOOL17;
    }
    return _nowLoctionLabel;
}
-(UIButton *)reLoctionBtn{
    if (!_reLoctionBtn) {
        _reLoctionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reLoctionBtn.backgroundColor = [UIColor clearColor];
    }
    return _reLoctionBtn;
}
#pragma mark -- 约束
- (void)setupConstraints {
    
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(60);
    }];
    

    [self.sImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(14);
    }];
    
    [self.nowLoctionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sImgView.mas_right).offset(8.5);
        make.top.bottom.mas_offset(0);
        make.right.mas_equalTo(self.cityLabel.mas_left).offset(-10);
    }];
    
    [self.reLoctionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH/2-15);
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
