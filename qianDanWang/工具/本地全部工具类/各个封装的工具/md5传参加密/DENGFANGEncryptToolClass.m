//
//  DENGFENGEncryptToolClass.m
//  jiaogeqian
//
//  Created by 神马的 on 2018/8/11.
//  Copyright © 2018年 zdtc. All rights reserved.
//

#import "DENGFANGEncryptToolClass.h"
#import "DENGFANGSingletonTime.h"

#define kAppleUrlToCheckNetStatus @"http://192.168.1.107:8082/"


@implementation DENGFANGEncryptToolClass


+ (NSString *)md5EncryptWithFormulaFromString:(NSString *)string {
    NSString *totalString = [NSString stringWithFormat:@"%@%@",[self md5Encrypt:string],[DENGFANGSingletonTime shareInstance].timestamp];
    //JGQLog(@"最终的加密：%@",[totalString yf_MD5String]);
    //JGQLog(@"最终的时间戳：%@",[DENGFENGSingletonTime shareInstance].timestamp);
    return [totalString yf_MD5String];
}

+ (NSString *)md5Encrypt:(NSString *)string {
    if ([string isEqualToString:@""] || string == nil) {
        return [@"$" yf_MD5String];
    }

    return [[NSString stringWithFormat:@"%@$",string] yf_MD5String];
}

/**
 *  16进制装换为颜色值
 *
 *  @param str 16进制的颜色值（例:#5491ec）
 *
 *  @return 颜色
 */
+ (UIColor *) stringTOColor:(NSString *)str{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]]
     scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}

+ (NSString *)md5EncryptWithFormulaFromString:(NSString *)string timesTamp:(NSString *)timestamp {
    NSString *totalString = [NSString stringWithFormat:@"%@%@",[self md5Encrypt:string],timestamp];
    return [totalString yf_MD5String];
}
//监测网络
+ (BOOL)checkNetCanUse {
    
    
    
    __block BOOL canUse = NO;
    
    NSString *urlString = kAppleUrlToCheckNetStatus;
    
    // 使用信号量实现NSURLSession同步请求**
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString* result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //解析html页面
        NSString *htmlString = [self filterHTML:result];
        //除掉换行符
        NSString *resultString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        if ([resultString isEqualToString:@"SuccessSuccess"]) {
            canUse = YES;
            
            
        }else {
            canUse = NO;
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return canUse;
}
//过滤后台返回字符串中的标签
+ (NSString *)filterHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return html;
}





@end
