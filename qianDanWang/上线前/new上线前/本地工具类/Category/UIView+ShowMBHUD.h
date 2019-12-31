//
//  UIView+ShowMBHUD.h
//  USERYINHAGN
//
//  Created by 河神 on 2019/6/3.
//  Copyright © 2019 ***. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ShowMBHUD)


// 使用MBProgressHUD做文本提示框
-(void)showMBHudWithMessage:(NSString *)msg hide:(NSTimeInterval)seconds;

// 显示MBProgressHUD样式的菊花等待指示器
-(void)showMBProgressHUD;

// 隐藏MBProgressHUD样式的菊花等待指示器
-(void)hideMBProgressHUD;

// 显示MBProgressHUD样式的菊花等待指示器带有延时
-(void)showMBProgressHUDDelay;

// 隐藏MBProgressHUD样式的菊花等待指示器带有延时
-(void)hideMBProgressHUDDelay;

// 显示审核中的菊花控件
-(void)showMBShenHeProgressHUD;

@end

NS_ASSUME_NONNULL_END
