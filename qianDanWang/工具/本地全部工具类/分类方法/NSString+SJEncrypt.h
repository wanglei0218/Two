//
//  NSString+SJEncrypt.h
//  jiaogeqian
//
//  Created by 神马的 on 2018/8/12.
//  Copyright © 2018年 zdtc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SJEncrypt)

- (NSString *)yf_MD5String;

+ (NSString *)yf_getNowTimestamp;

+ (NSString *)md5:(NSString *)string;

-(CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

-(CGSize )sizeWithFont:(UIFont *)font;

@end
