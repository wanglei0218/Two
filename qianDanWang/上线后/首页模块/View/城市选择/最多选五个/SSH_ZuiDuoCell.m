//
//  SSH_ZuiDuoCell.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/14.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_ZuiDuoCell.h"
#import "SSH_LocationCityModel.h"
#import "SSH_ZuiDuoCityView.h"

#define kMargin 15
#define kButtonWidth SCREEN_WIDTH*95/375
#define kGap ( SCREEN_WIDTH - kButtonWidth * 3 - kMargin*2-25) / 2
#define kButtonHeight 27.5
#define kGapH 15
#define kTopMargin 43

@interface SSH_ZuiDuoCell()


@property (strong, nonatomic) UILabel *cityTLabel;

@end

@implementation SSH_ZuiDuoCell

-(UILabel *)cityTLabel{
    if (!_cityTLabel) {
        _cityTLabel = [[UILabel alloc]init];
        _cityTLabel.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, 43);
        _cityTLabel.text = @"最多选5个（长按删除）";
        _cityTLabel.font = UIFONTTOOL13;
        _cityTLabel.textColor = ColorBlack999;
    }
    return _cityTLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return  self;
}

- (void)setCityModel:(SSH_LocationCityModel *)cityModel {
    _cityModel = cityModel;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self.contentView addSubview:self.cityTLabel];
    
    self.cityModel.zuiDuoCellH = 43;
    
    NSInteger count = 0;
    CGFloat y = 0.0;
    NSInteger x = 1;
    
    for (int i = 0; i < self.cityModel.zuiDuoCity.count; i++) {
        
        DENGFANGLocationCity *city = self.cityModel.zuiDuoCity[i];
        SSH_ZuiDuoCityView *cityView = [[SSH_ZuiDuoCityView alloc] init];
        cityView.backgroundColor = [UIColor redColor];
//        cityView.layer.borderWidth = 0.5;
//        cityView.layer.borderColor = (GrayLineColor).CGColor;
        cityView.layer.cornerRadius = 6;
        cityView.titleLabel.font = UIFONTTOOL12;
        cityView.titleLabel.text = city.name;
//        cityView.titleLabel.textColor = GrayColor666;
        cityView.titleLabel.textColor = [UIColor whiteColor];

        cityView.num = i;
        cityView.shanChuButton.tag = i;
        cityView.shanChuButton.hidden = YES;
        if (self.cityModel.zuiDuoCity.count > count ) {
            
            if (((SCREEN_WIDTH) - (kMargin + kButtonWidth * (x - 1) + kGap * (x - 1))) <= kButtonWidth) {
                y += kGapH + kButtonHeight;
                x = 1;
            }
            
            cityView.frame = CGRectMake(kMargin + ((kButtonWidth + kGap) * (x - 1)), kTopMargin + y, kButtonWidth, kButtonHeight);
            count ++;
            x ++;
        }
        
        [self.contentView addSubview:cityView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnTap:)];
        
        [cityView addGestureRecognizer:tap];
        self.cityModel.zuiDuoCellH = y + kButtonHeight + kTopMargin + 15;
        
    }
}

-(void)btnTap:(UITapGestureRecognizer *)gestureRecognizer{
    
    SSH_ZuiDuoCityView *cityView = (SSH_ZuiDuoCityView *)gestureRecognizer.view;
    //获取本地数据删除
    if (self.delectedCityBlock) {
        DENGFANGLocationCity *city = self.cityModel.zuiDuoCity[cityView.num];
        self.delectedCityBlock(city.name, city.Id);
    }
}


@end
