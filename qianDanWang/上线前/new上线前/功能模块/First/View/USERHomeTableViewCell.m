//
//  USERHomeTableViewCell.m
//  USERPRODUCT
//
//  Created by 河神 on 2019/5/31.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERHomeTableViewCell.h"

@implementation USERHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpAllView];
        [self setUpAllViewFrame];
    }
    return self;
}

- (void)setUpAllView{
    
    self.bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"liebiao_beijing"]];
    [self addSubview:self.bgImg];
    
    self.wupinLabel = [[UILabel alloc] init];
    [self.bgImg addSubview:self.wupinLabel];
    self.wupinLabel.textColor = COLOR_With_Hex(0x222222);
    self.wupinLabel.font = [UIFont fontWithName:@"Fang-SC-Medium" size:WidthScale(13)];
    
    self.timeLable = [[UILabel alloc] init];
    [self.bgImg addSubview:self.timeLable];
    self.timeLable.textColor = COLOR_With_Hex(0x999999);
    self.timeLable.textAlignment = NSTextAlignmentRight;
    self.timeLable.font = [UIFont systemFontOfSize:WidthScale(11)];
    
    self.addressLable = [[UILabel alloc] init];
    [self.bgImg addSubview:self.addressLable];
    self.addressLable.textColor = COLOR_With_Hex(0x222222);
    self.addressLable.font = [UIFont systemFontOfSize:WidthScale(12)];
    
    self.tedianLable = [[UILabel alloc] init];
    [self.bgImg addSubview:self.tedianLable];
    self.tedianLable.textColor = COLOR_With_Hex(0x222222);
    self.tedianLable.font = [UIFont systemFontOfSize:WidthScale(12)];
    
    self.phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bgImg addSubview:self.phoneButton];
    [self.phoneButton setTitleColor:COLOR_With_Hex(0x222222) forState:UIControlStateNormal];
    self.phoneButton.titleLabel.font = [UIFont systemFontOfSize:WidthScale(12)];
    [self.phoneButton setImage:[UIImage imageNamed:@"首页_电话"] forState:UIControlStateNormal];
    
}

- (void)setUpAllViewFrame{
    
    self.bgImg.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, WidthScale(0)).widthIs(ScreenWidth).heightIs(WidthScale(145));
    
    self.wupinLabel.sd_layout.leftSpaceToView(self.bgImg, WidthScale(30)).topSpaceToView(self.bgImg, WidthScale(15)).heightIs(WidthScale(13));
    [self.wupinLabel setSingleLineAutoResizeWithMaxWidth:WidthScale(150)];
    
    self.timeLable.sd_layout.rightSpaceToView(self.bgImg, WidthScale(30)).topEqualToView(self.wupinLabel).heightIs(WidthScale(11));
    [self.timeLable setSingleLineAutoResizeWithMaxWidth:WidthScale(150)];
    
    self.addressLable.sd_layout.leftEqualToView(self.wupinLabel).topSpaceToView(self.wupinLabel, WidthScale(17)).heightIs(WidthScale(12)).widthIs(ScreenWidth-WidthScale(60));
    
    self.tedianLable.sd_layout.leftEqualToView(self.wupinLabel).topSpaceToView(self.addressLable, WidthScale(17)).heightIs(WidthScale(12)).widthIs(ScreenWidth-WidthScale(60));
    
    self.phoneButton.sd_layout.leftEqualToView(self.wupinLabel).topSpaceToView(self.tedianLable, WidthScale(17)).heightIs(WidthScale(18)).widthIs(115);
}


@end
