//
//  UILabel+LabelSpace.m
//  FourthProject
//
//  Created by XXX on 2019/1/16.
//  Copyright © 2019 OOO. All rights reserved.
//

#import "UILabel+LabelSpace.h"
#import <CoreText/CoreText.h>


@implementation UILabel (LabelSpace)


/** * 改变行间距 */
+ (void)changeLineSpaceForLabel:(UILabel *)label LineSpace:(float)linespace{
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    [paragraphStyle setLineSpacing:linespace];
    label.attributedText = attributedString; [label sizeToFit];
}
/** * 改变字间距 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WordSpace:(float)wordspace{
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordspace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString; [label sizeToFit];
}
/** * 改变行间距和字间距 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace{
    
    if (label.text == nil) {
        return;
    }
    
    
    NSString *labelText = label.text;
    if (labelText == nil) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString; [label sizeToFit];
}


+ (NSArray *)getSeparatedLinesFromLabelText:(NSString *)text labelFont:(UIFont *)font labelRect:(CGRect)rect;
{
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0),path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}


// 改变指定label文本大小与颜色
+(void)changeTextLab:(UILabel *)myLabel stringArray:(NSArray *)strArray colorArray:(NSArray *)colorArray fontArray:(NSArray *)fontArray {
    
    NSMutableAttributedString *mutAttStr = [[NSMutableAttributedString alloc] initWithString:myLabel.text];
    NSString *_str =nil;
    UIFont *_font =nil;
    NSRange _range =NSMakeRange(0,0);
    
    for (int i=0; i<strArray.count; i++) {
        //NSLog(@"---> strArray.count = %ld",strArray.count);
        _str = strArray[i];
        NSUInteger location = [[mutAttStr string] rangeOfString:_str].location;
        NSUInteger length = [[mutAttStr string] rangeOfString:_str].length;
        _range = NSMakeRange(location, length);
        // 改变颜色
        if (colorArray.count >= (i+1)) {
            [mutAttStr addAttribute:NSForegroundColorAttributeName value:colorArray[i] range:_range];
        }
        // 改变字体大小
        if (fontArray.count >= (i+1)) {
            _font = [UIFont fontWithName:@"PingFang-SC-Regular" size:WidthScale([fontArray[i] floatValue])];
            [mutAttStr addAttribute:NSFontAttributeName value:_font range:_range];
        }
    }
    [myLabel setAttributedText:mutAttStr];
    
}


@end
