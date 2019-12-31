//
//  DENGFENGEncryptToolClass.h
//  jiaogeqian
//
//  Created by 神马的 on 2018/8/11.
//  Copyright © 2018年 zdtc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+SJEncrypt.h"


@interface DENGFANGEncryptToolClass : NSObject

/**
 * md5公式加密
 * string 传入的字符串
 * 返回值：string不为空时，返回公式加密值；string为""或nil时，返回(字符串"")。
 **/
+ (NSString *)md5EncryptWithFormulaFromString:(NSString *)string;

/**
 *  16进制装换为颜色值
 *
 *  @param str 16进制的颜色值（例:#5491ec）
 *
 *  @return 颜色
 */
+ (UIColor *) stringTOColor:(NSString *)str;






+ (NSString *)md5EncryptWithFormulaFromString:(NSString *)string timesTamp:(NSString *)timestamp;


//监测网络
+ (BOOL)checkNetCanUse;
//过滤后台返回字符串中的标签
+ (NSString *)filterHTML:(NSString *)html;

/**
 设置view指定位置的边框
 @param originalView   原view
 @param color          边框颜色
 @param borderWidth    边框宽度
 @param borderType     边框类型 例子: UIBorderSideTypeTop|UIBorderSideTypeBottom
 @return  view
 */

@end
