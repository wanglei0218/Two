//
//  TYDHomeLocationHotCityCell.m
//  TYDSC
//
//  Created by huang on 2018/10/25.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "ShangChengHotCityListCell.h"
#import "ShangChengLocationCityModel.h"


#define kMargin 15
#define kButtonWidth ScreenWidth*95/375
#define kGap ( ScreenWidth - kButtonWidth * 3 - kMargin*2-25) / 2
#define kButtonHeight 27.5
#define kGapH 15
#define kTopMargin 43


@interface ShangChengHotCityListCell ()

/** 热门城市 */
@property (strong, nonatomic) UILabel *cityTLabel;

@end

@implementation ShangChengHotCityListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}
- (void)setCityModel:(ShangChengLocationCityModel *)cityModel {
    if (_cityModel != cityModel) {
        _cityModel = cityModel;
        [self setupView];
    }
}
-(UILabel *)cityTLabel{
    if (!_cityTLabel) {
        _cityTLabel = [[UILabel alloc]init];
        _cityTLabel.frame = CGRectMake(15, 0, ScreenWidth-30, 43);
        _cityTLabel.text = @"热门城市：";
        _cityTLabel.font = [UIFont systemFontOfSize:13];
        _cityTLabel.textColor = COLOR_With_Hex(0x999999);
    }
    return _cityTLabel;
}
-(void)setupView{
    [self.contentView addSubview:self.cityTLabel];
    
    
    NSInteger count = 0;
    CGFloat y = 0.0;
    NSInteger x = 1;
    
    for (int i = 1; i <= self.cityModel.hotCity.count; i++) {
        
        TYDLocationCity *city = self.cityModel.hotCity[i - 1];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = (GrayLineColor).CGColor;
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitle:city.name forState:UIControlStateNormal];
        [button setTitleColor:COLOR_With_Hex(0x666666) forState:UIControlStateNormal];
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        button.tag = i;
        if ([city.name isEqualToString:self.cityModel.selectedCity]) {
            [button setTitleColor:COLOR_With_Hex(0xee4c4f) forState:UIControlStateNormal];
            button.layer.borderColor = COLOR_With_Hex(0xee4c4f).CGColor;
        }
        
        
        if (self.cityModel.hotCity.count > count ) {
            
            if (((ScreenWidth) - (kMargin + kButtonWidth * (x - 1) + kGap * (x - 1))) <= kButtonWidth) {
                y += kGapH + kButtonHeight;
                x = 1;
            }
            
            button.frame = CGRectMake(kMargin + ((kButtonWidth + kGap) * (x - 1)), kTopMargin + y, kButtonWidth, kButtonHeight);
            count ++;
            x ++;
        }
        [button addTarget:self action:@selector(citySelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        
        self.cityModel.hotCellH = y + kButtonHeight + kTopMargin + 15;
        
    }
}
- (void)citySelected:(UIButton *)button {
    TYDLocationCity *city = self.cityModel.hotCity[button.tag - 1];
    
    if (self.selectedCityBlock) {
        self.selectedCityBlock(city.name, city.Id);
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
