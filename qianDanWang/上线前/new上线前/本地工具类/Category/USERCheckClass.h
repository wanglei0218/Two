

#import <Foundation/Foundation.h>
#import "USERMyJiaZai.h"

NS_ASSUME_NONNULL_BEGIN

@interface USERCheckClass : NSObject

+ (BOOL)checkProxySetting;

+ (BOOL)checkTelNumber:(NSString*) telNumber;

+ (NSString *)UUID;

/**
 校验身份证号
 */
+ (BOOL)checkUserIdCard: (NSString*) idCard;

+(void)showLoding:(UIView *)view;
+(void)HidenLoding:(UIView *)view;

+(void)showInView:(UIView *)view wydkTile:(NSString *)title;


@end

NS_ASSUME_NONNULL_END
