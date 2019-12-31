//
//  DENGFANGHelperFunction.m
//  reViewApp
//
//  Created by liangyuan on 16/8/30.
//  Copyright © 2016年 chaoqianyan. All rights reserved.
//

#import "DENGFANGHelperFunction.h"

@implementation DENGFANGHelperFunction


+ (CGFloat)labelHeightLabelWithWidth:(CGFloat)width text:(NSString *)string font:(CGFloat)font{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height;
}


+ (BOOL)checkTelNumber:(NSString*) telNumber{
    NSString *pattern =@"^1+\\d{10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

+(CGFloat)textSizeWithText:(NSString *)labelText Font:(CGFloat)aFont{
    CGSize textSize = [labelText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:aFont]}];
    return textSize.width;
}

+ (BOOL)checkUserIdCard: (NSString*) value{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length = 0;
    if (!value){
        return NO;
    }else {
        length = value.length;
        //不满足15位和18位，即身份证错误
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    // 检测省份身份行政区代码
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO; //标识省份代码是否正确
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    if (!areaFlag) {
        return NO;
    }
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    int year =0;
    //分为15位、18位身份证进行校验
    switch (length) {
        case 15:
            //获取年份对应的数字
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            //使用正则表达式匹配字符串 NSMatchingReportProgress:找到最长的匹配字符串后调用block回调
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                //1：校验码的计算方法 身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。将这17位数字和系数相乘的结果相加。
                
                int S = [value substringWithRange:NSMakeRange(0,1)].intValue*7 + [value substringWithRange:NSMakeRange(10,1)].intValue *7 + [value substringWithRange:NSMakeRange(1,1)].intValue*9 + [value substringWithRange:NSMakeRange(11,1)].intValue *9 + [value substringWithRange:NSMakeRange(2,1)].intValue*10 + [value substringWithRange:NSMakeRange(12,1)].intValue *10 + [value substringWithRange:NSMakeRange(3,1)].intValue*5 + [value substringWithRange:NSMakeRange(13,1)].intValue *5 + [value substringWithRange:NSMakeRange(4,1)].intValue*8 + [value substringWithRange:NSMakeRange(14,1)].intValue *8 + [value substringWithRange:NSMakeRange(5,1)].intValue*4 + [value substringWithRange:NSMakeRange(15,1)].intValue *4 + [value substringWithRange:NSMakeRange(6,1)].intValue*2 + [value substringWithRange:NSMakeRange(16,1)].intValue *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                //2：用加出来和除以11，看余数是多少？余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 3：获取校验位
                NSString *lastStr = [value substringWithRange:NSMakeRange(17,1)];
                //4：检测ID的校验位
                if ([lastStr isEqualToString:@"x"]) {
                    if ([M isEqualToString:@"X"]) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                        return YES;
                    }else {
                        return NO;
                    }
                }
            }else {
                return NO;
            }
        default:
            return NO;
    }
}

+ (BOOL)validateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (NSString *)UUID {
    NSString *UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return UUID;
}

+ (void)showAlter:(UIView *)view WithMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    [hud hideAnimated:YES afterDelay:1.5];
}

+ (UIView *)LoadGifWithView:(UIView *)view {
    UIImage *gifImg = [UIImage sd_imageWithGIFData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"叫个" ofType:@"gif"]]];
    UIImageView *gifview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,65, 65)];
    gifview.image = gifImg;
    UIView *tishikuang = [UIView new];
    tishikuang.frame = CGRectMake((SCREEN_WIDTH-180)/2, 241, 65, 65);
    tishikuang.centerX = SCREEN_WIDTH/2;
    tishikuang.centerY = SCREENH_HEIGHT/2;
    tishikuang.backgroundColor = COLOR_With_Hex(0xf7f7f7);
    tishikuang.layer.masksToBounds = YES;
    tishikuang.layer.cornerRadius = 5;
    [tishikuang addSubview:gifview];
    [view addSubview:tishikuang];
    return tishikuang;
}
+(BOOL)getDicStr:(id)mess {
    if ([mess isKindOfClass:[NSNull class]]) {
        return NO;
    }else{
        return YES;
    }
}

+ (void)showErrorAlter:(UIView *)view {
    
    NSArray * arr = [DENGFANGHelperFunction getCurrentVC];
    
    for (UIView *childView in arr) {
        if ([childView isKindOfClass:[MBProgressHUD class]]) {
            [childView removeFromSuperview];
        }
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"网络信号不佳，请检查网络！";
    [hud hideAnimated:YES afterDelay:1.5];
}
//获取当前控制的所有view
+(NSArray *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        //多层present
        while (appRootVC.presentedViewController) {
            appRootVC = appRootVC.presentedViewController;
            if (appRootVC) {
                nextResponder = appRootVC;
            }else{
                break;
            }
        }
        
    }else{
        
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else if ([nextResponder isKindOfClass:[UIWindow class]]){
        UIWindow *win = (UIWindow *)nextResponder;
        result = win.rootViewController;
    }else{
        result = nextResponder;
    }
    
    return result.view.subviews;
}

//获取当前时间戳  （以毫秒为单位）
+ (NSInteger)getNowTimeTimestamp{
    
    NSDate *datenow = [NSDate date];
    
    NSInteger timeSp = [datenow timeIntervalSince1970]*1000;
    
    
   
    
    return timeSp;
}

/**
 * md5公式加密
 * string 传入的字符串
 * 返回值：string不为空时，返回公式加密值；string为""或nil时，返回(字符串"")。
 **/
+ (NSString *)md5EncryptWithFormulaFromString:(NSString *)string{
    NSString *totalString = [NSString stringWithFormat:@"%@%ld",[self md5Encrypt:string],(long)[self getNowTimeTimestamp]];
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

//富文本高度计算
+ (CGSize)sizeLabelWidth:(CGFloat)width attributedText:(NSString *)str lineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace font:(CGFloat)font{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpace;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, str.length)];
    label.attributedText = attributeString;
    
    CGRect textOfRect = [label textRectForBounds:CGRectMake(0, 0, width, CGFLOAT_MAX) limitedToNumberOfLines:0];
    
    return textOfRect.size;
}


+ (void)saveSelectCityName:(NSString *)cityName {
    [[NSUserDefaults standardUserDefaults] setValue:cityName forKey:SelectedCityKey];
}
+ (NSString *)getSelectedCityName {
    NSString *cityName = [[NSUserDefaults standardUserDefaults] valueForKey:SelectedCityKey];
    if (cityName == nil) {
        cityName = @"";
    }
    return cityName;
}

+ (BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3 || ls == 0xfe0f) {
                 isEomji = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}
@end
