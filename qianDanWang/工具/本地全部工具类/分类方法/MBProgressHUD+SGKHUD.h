//
//  MBProgressHUD+SGKHUD.h
//  CarSD
//
//  Created by Air on 2018/8/17.
//  Copyright © 2018年 SGK. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (SGKHUD)
+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;
@end
