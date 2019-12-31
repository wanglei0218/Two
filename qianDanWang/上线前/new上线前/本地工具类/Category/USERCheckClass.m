

#import "USERCheckClass.h"

@implementation USERCheckClass


+ (BOOL)checkProxySetting {
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = proxies[0];
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
    {
        return NO;
    }else
    {
        return YES;
    }
}

+ (BOOL)checkTelNumber:(NSString*) telNumber
{
    NSString *pattern =@"^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(17[0,3,5-8])|(18[0-9])|166|198|199(147))\\d{8}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

+ (NSString *)UUID {
    NSString *UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return UUID;
}

+ (BOOL)checkUserIdCard: (NSString*) idCard{
    NSString*pattern =@"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}




+(void)showLoding:(UIView *)view
{
    USERMyJiaZai *jiazaiView = [[USERMyJiaZai alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-getRectNavAndStatusHightOnew)];
    jiazaiView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
    [view addSubview:jiazaiView];
}
+(void)HidenLoding:(UIView *)view
{
    for (UIView *vw in view.subviews) {
        if ([vw isKindOfClass:[USERMyJiaZai class]]) {
            [vw removeFromSuperview];
        }
    }
}

+(void)showInView:(UIView *)view wydkTile:(NSString *)title
{
    MBProgressHUD *mbProgress = [MBProgressHUD showHUDAddedTo:view animated:YES];
    mbProgress.mode = MBProgressHUDModeText;
    mbProgress.label.text = title;
    [mbProgress hideAnimated:YES afterDelay:1.5];
}



@end
