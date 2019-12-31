//
//  UIView+ShowMBHUD.m
//  USERYINHAGN
//
//  Created by 河神 on 2019/6/3.
//  Copyright © 2019 ***. All rights reserved.
//

#import "UIView+ShowMBHUD.h"

@implementation UIView (ShowMBHUD)


// 使用MBProgressHUD做提示框
-(void)showMBHudWithMessage:(NSString *)msg hide:(NSTimeInterval)seconds {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = msg;
        [self addSubview:hud];
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:seconds];
    });
}

// 显示MBProgressHUD样式的菊花等待指示器
-(void)showMBProgressHUD {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 做一个等待指示器
        MBProgressHUD *hud = [[MBProgressHUD  alloc] initWithView:self];
        [self addSubview:hud];
        hud.tag = 888;
        hud.removeFromSuperViewOnHide = YES;
        [hud showAnimated:YES];
    });
}

// 隐藏MBProgressHUD样式的菊花等待指示器
-(void)hideMBProgressHUD{
    
    // 回到UI主线程，
    dispatch_async(dispatch_get_main_queue(), ^{
        // 得到hud的内存
        MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:888];
        [hud hideAnimated:YES];
        hud = nil;
    });
}


// 显示MBProgressHUD样式的菊花等待指示器
-(void)showMBProgressHUDDelay {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 做一个等待指示器
        MBProgressHUD *hud = [[MBProgressHUD  alloc] initWithView:self];
        [self addSubview:hud];
        hud.tag = 999;
        hud.label.text = @"正在加载...";
        hud.removeFromSuperViewOnHide = YES;
        [hud showAnimated:YES];
    });
}

// 隐藏MBProgressHUD样式的菊花等待指示器
-(void)hideMBProgressHUDDelay{
    
    // 回到UI主线程，
    dispatch_async(dispatch_get_main_queue(), ^{
        // 得到hud的内存
        MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:999];
        [hud hideAnimated:YES afterDelay:1.20f];
        hud = nil;
    });
}


// 显示MBProgressHUD样式的菊花等待指示器
-(void)showMBShenHeProgressHUD {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 做一个等待指示器
        MBProgressHUD *hud = [[MBProgressHUD  alloc] initWithView:self];
        [self addSubview:hud];
        hud.label.text = @"正在审核中...";
        hud.tag = 333;
        hud.removeFromSuperViewOnHide = YES;
        [hud showAnimated:YES];
    });
}



@end
