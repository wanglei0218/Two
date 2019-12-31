//
//  SSH_CityListCell.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/25.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_CityListCell.h"
#import "SSH_LocationCityModel.h"


@interface SSH_CityListCell ()

/** 热门城市 */
@property (strong, nonatomic) UILabel *cityNameLabel;

/** 图片 */
@property (strong, nonatomic) UIImageView *citySelectedImageView;

/** 线 */
@property (strong, nonatomic) UIView *lineView;
@end

@implementation SSH_CityListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = COLORWHITE;
        [self createLocationListCell];
    }
    return self;
}
- (void)setCity:(DENGFANGLocationCity *)city {
    if (_city != city) {
        _city = city;
        self.cityNameLabel.text = city.name;
        self.citySelectedImageView.hidden = !city.isSelected;
    }
}
-(void)createLocationListCell{
    [self.contentView addSubview:self.cityNameLabel];
    [self.contentView addSubview:self.citySelectedImageView];
    [self.contentView addSubview:self.lineView];
    [self setupConstraints];

}
#pragma mark 懒加载
-(UILabel *)cityNameLabel{
    if (!_cityNameLabel) {
        _cityNameLabel = [[UILabel alloc]init];
        _cityNameLabel.textColor = ColorBlack222;
        _cityNameLabel.font = UIFONTTOOL14;
    }
    return _cityNameLabel;
}
-(UIImageView *)citySelectedImageView{
    if (!_citySelectedImageView) {
        _citySelectedImageView = [[UIImageView alloc]init];
        _citySelectedImageView.image = [UIImage imageNamed:@"h_dingwei_duigou"];
    }
    return _citySelectedImageView;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = GrayLineColor;
    }
    return _lineView;
}
#pragma mark 约束
-(void)setupConstraints{
    [self.cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0.5);
        make.bottom.mas_equalTo(-0.5);
        make.width.mas_equalTo(SCREEN_WIDTH/3*2);
    }];
    
    [self.citySelectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(12);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_offset(0);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
