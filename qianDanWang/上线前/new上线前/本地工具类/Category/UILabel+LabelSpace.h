//
//  UILabel+LabelSpace.h
//  FourthProject
//
//  Created by XXX on 2019/1/16.
//  Copyright © 2019 OOO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (LabelSpace)


/** * 改变行间距 */
+ (void)changeLineSpaceForLabel:(UILabel *)label LineSpace:(float)space;
/** * 改变字间距 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WordSpace:(float)space;
/** * 改变行间距和字间距 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;


// 获得多行UILabel的每一行Text
+ (NSArray *)getSeparatedLinesFromLabelText:(NSString *)text labelFont:(UIFont *)font labelRect:(CGRect)rect;

// 改变label中部分文字的大小和颜色
+(void)changeTextLab:(UILabel *)myLabel stringArray:(NSArray *)strArray colorArray:(NSArray *)colorArray fontArray:(NSArray *)fontArray;

@end

NS_ASSUME_NONNULL_END
