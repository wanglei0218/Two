//
//  SSH_TOOL_GongJuLei.h
//  reViewApp
//
//  Created by liangyuan on 16/8/30.
//  Copyright © 2016年 chaoqianyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSH_TOOL_GongJuLei : NSObject

@property (nonatomic, strong) NSString *tokenString;

//计算文本高度
+ (CGFloat)labelHeightLabelWithWidth:(CGFloat)width text:(NSString *)string font:(CGFloat)font;

+ (BOOL)checkTelNumber:(NSString*) telNumber;

+(CGFloat)textSizeWithText:(NSString *)labelText Font:(CGFloat)aFont;

+ (BOOL)checkUserIdCard: (NSString*) idCard;

+ (BOOL)validateEmail:(NSString *)email;

+ (NSString *)UUID;

+ (void)showAlter:(UIView *)view WithMessage:(NSString *)message;

+ (void)showAlter:(UIView *)view WithImageView:(UIImageView *)imageView;

+ (UIView *)LoadGifWithView:(UIView *)view;

+(BOOL)getDicStr:(id)mess;
+ (void)showErrorAlter:(UIView *)view;

//获取当前时间戳  （以毫秒为单位）
+ (NSInteger)getNowTimeTimestamp;

/**
 * md5公式加密
 * string 传入的字符串
 * 返回值：string不为空时，返回公式加密值；string为""或nil时，返回(字符串"")。
 **/
+ (NSString *)md5EncryptWithFormulaFromString:(NSString *)string;

//计算富文本高度
+ (CGSize)sizeLabelWidth:(CGFloat)width attributedText:(NSString *)str lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace font:(CGFloat)font;

/**
 * 存储选择城市方法
 * cityName 选择的城市名称
 **/
+ (void)saveSelectCityName:(NSString *)cityName;

/**
 * 获取选择城市的方法
 *
 **/
+ (NSString *)getSelectedCityName;

+ (BOOL)isContainsEmoji:(NSString *)string;

/* 电话的星号加密 */
+ (NSString*)changeTelephone:(NSString*)teleStr;
/* 判断字符串是否为空 */
+ (BOOL)isKongWithString:(NSString *)string;
@end
