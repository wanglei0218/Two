//
//  SSH_HotCityListCell.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/25.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_HotCityListCell.h"
#import "SSH_LocationCityModel.h"


#define kMargin 15
#define kButtonWidth SCREEN_WIDTH*95/375
#define kGap ( SCREEN_WIDTH - kButtonWidth * 3 - kMargin*2-25) / 2
#define kButtonHeight 27.5
#define kGapH 15
#define kTopMargin 43


@interface SSH_HotCityListCell ()

/** 热门城市 */
@property (strong, nonatomic) UILabel *cityTLabel;

@end

@implementation SSH_HotCityListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}
- (void)setCityModel:(SSH_LocationCityModel *)cityModel {
    if (_cityModel != cityModel) {
        _cityModel = cityModel;
        [self setupView];
    }
}
-(UILabel *)cityTLabel{
    if (!_cityTLabel) {
        _cityTLabel = [[UILabel alloc]init];
        _cityTLabel.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, 43);
        _cityTLabel.text = @"热门城市：";
        _cityTLabel.font = UIFONTTOOL13;
        _cityTLabel.textColor = ColorBlack999;
    }
    return _cityTLabel;
}
-(void)setupView{
    [self.contentView addSubview:self.cityTLabel];
    
    
    NSInteger count = 0;
    CGFloat y = 0.0;
    NSInteger x = 1;
    
    for (int i = self.num; i < self.cityModel.hotCity.count; i++) {
        
        DENGFANGLocationCity *city = self.cityModel.hotCity[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = (GrayLineColor).CGColor;
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = UIFONTTOOL12;
        [button setTitle:city.name forState:UIControlStateNormal];
        [button setTitleColor:GrayColor666 forState:UIControlStateNormal];
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        button.tag = i;
        
        if (self.cityModel.hotCity.count > count ) {
            
            if (((SCREEN_WIDTH) - (kMargin + kButtonWidth * (x - 1) + kGap * (x - 1))) <= kButtonWidth) {
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
    DENGFANGLocationCity *city = self.cityModel.hotCity[button.tag];
//    NSLog(@"%@---%ld",city.name,city.Id);
    if (self.selectedCityBlock) {
        self.selectedCityBlock(city.name, city.Id);
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
