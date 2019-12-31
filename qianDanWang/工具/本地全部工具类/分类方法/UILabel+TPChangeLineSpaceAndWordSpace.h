//
//  UILabel+TPChangeLineSpaceAndWordSpace.h
//  TourismProject
//
//  Created by huang on 2018/10/10.
//  Copyright © 2018年 PraiseGroupXuHaoArt All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TPChangeLineSpaceAndWordSpace)
//1.设置：行间距
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

//2.设置：字间距
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

//3.设置：行间距 与 字间距
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;
@end
