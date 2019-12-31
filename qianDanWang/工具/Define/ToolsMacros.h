//
//  ToolsMacros.h
//  TaoYouDan
//
//  Created by LY on 2018/9/18.
//  Copyright © 2018年 LY. All rights reserved.
//

#ifndef ToolsMacros_h
#define ToolsMacros_h

#define chengShiXuanZeFilePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/city.plist"]



//获取设备尺寸
#define SCREEN_WIDTH             ([[UIScreen mainScreen] bounds].size.width)
#define SCREENH_HEIGHT            ([[UIScreen mainScreen] bounds].size.height)

#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)
//横向比例
#define WidthScale(number) ([UIScreen mainScreen].bounds.size.width/375.*(number))
//纵向比例
#define HeightScale(number) ([UIScreen mainScreen].bounds.size.height/667.*(number))

//获取导航栏+状态栏的高度
#define getRectNavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height
//获取状态栏高度
#define getStatusHeight [[UIApplication sharedApplication] statusBarFrame].size.height

//获取导航栏
#define getRectNavHight  self.navigationController.navigationBar.frame.size.height

//x \ xs
#define IS_IPHONEX (([[UIScreen mainScreen] bounds].size.height-812)?NO:YES)
//xr \ xs max
#define IS_IPHONEMAX (([[UIScreen mainScreen] bounds].size.height-896)?NO:YES)

#define IS_PhoneXAll (IS_IPHONEX || IS_IPHONEMAX)

//获取底部安全距离
#define SafeAreaBottomHEIGHT (IS_PhoneXAll ? 34.0 : 0.0)
#define SafeAreaAllBottomHEIGHT (IS_PhoneXAll ? 83.0 : 49.0)

//获取tabbar高度
#define getTabbarHeight self.tabBarController.tabBar.frame.size.height

#define isPad         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

//导航栏高度
#define Height_NavBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 88.0 : 64.0)
//TabBar 高度
#define Height_TabBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 83.0 : 49.0)

//获取设备
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_IPHONE6 (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)
#define IS_IPHONE6PLUS (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)
//x \ xs
#define IS_IPHONEX (([[UIScreen mainScreen] bounds].size.height-812)?NO:YES)
//xr \ xs max
#define IS_IPHONEMAX (([[UIScreen mainScreen] bounds].size.height-896)?NO:YES)

#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

//单利
#define SHAREDAPP ((AppDelegate *)([[UIApplication sharedApplication] delegate]))

#define kScreenWidthRatio  (SCREEN_WIDTH / 320.0)
#define kScreenHeightRatio (SCREENH_HEIGHT / 568.0)
#define AdaptedWidth(x)  ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x) ceilf((x) * kScreenHeightRatio)


#pragma mark -----------------------上线前
#import "AppDelegate.h"
#import "USERRootViewController.h"
#import "SDAutoLayout.h"
#import "AFHTTPSessionManager.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import <Masonry.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "SDCycleScrollView.h"
#import "USERNetWorkClass.h"
#import "SZKImagePickerVC.h"
#import "FMDB.h"

#import "USERDanLi.h"
#import "UIViewExt.h"
#import "USERFirstNormalHeader.h"
#import "USERMYGeneralRefrshFooter.h"

#import "UILabel+LabelSpace.h"
#import "UIView+ShowMBHUD.h"
#import "USERCheckClass.h"

#import "USERModel.h"
#import "USERDataHandle.h"
#import "USERAdd.h"
#import "USERAddress.h"
#import "USERAllQiuZhuData.h"

#define __WEAKSELF __weak typeof(self) weakSelf = self;
//获取设备尺寸
#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)
//颜色工具
#define COLOR_With_Hex(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define MAINCOLOR1 COLOR_With_Hex(0xff9e00)
#define TEXTMAINCOLOR RGB(50,50,50)
#define TEXTREDCOLOR COLOR_With_Hex(0xfc4e4f)
#define TEXTFUCOLOR COLOR_With_Hex(0xff7d00)
#define TEXTSEN_Color RGB(152,152,152)
#define BACKGROUND_Color RGB(248,248,248)
#define GrayLineColor COLOR_With_Hex(0xdbdbdb)
#define ColorBackground_Line  COLOR_With_Hex(0xf3f3f3)

//#define ASAPPNAME @"APP名字"
//#define AppleStoreId @""
//#define KeyWithJPush @"10eb5887b1315fa60d67c108"
//#define AppKeyWithUM @"5d15752a570df3ad12000182"

#define COPYRIGHT @"广州蓝上信息科技有限公司公司 版权所有"

// 用于持久化当前app版本号的key
#define SAVE_VERSION @"savedVersion"
// 表示当前app版本号的宏
#define CURRENT_VERSION [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]


//横向比例
#define WidthScale(number) ([UIScreen mainScreen].bounds.size.width/375.*(number))
//纵向比例
#define HeightScale(number) ([UIScreen mainScreen].bounds.size.height/667.*(number))

//获取导航栏+状态栏的高度
#define getRectNavAndStatusHightOnew  ([[UIApplication sharedApplication] statusBarFrame].size.height>20?88:64)
//获取状态栏高度
#define getStatusHeight [[UIApplication sharedApplication] statusBarFrame].size.height

//x \ xs
#define IS_IPHONEX (([[UIScreen mainScreen] bounds].size.height-812)?NO:YES)
//xr \ xs max
#define IS_IPHONEMAX (([[UIScreen mainScreen] bounds].size.height-896)?NO:YES)

#define IS_PhoneXAll (IS_IPHONEX || IS_IPHONEMAX)

//获取底部安全距离
#define SafeAreaBottomHEIGHT (IS_PhoneXAll ? 34.0 : 0.0)
#define SafeAreaAllBottomHEIGHT (IS_PhoneXAll ? 83.0 : 49.0)

#define isPad         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

//TabBar 高度
#define getTabbarHeightNew ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 83.0 : 49.0)

//获取设备
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_IPHONE6 (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)
#define IS_IPHONE6PLUS (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)

//单利
#define SHAREDAPP ((AppDelegate *)([[UIApplication sharedApplication] delegate]))


#define YYQLog(FORMAT, ...) fprintf(stderr,"[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


#define APP_BUILD ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

#define USERID @"USERID"
#define TOKEN @"TOKEN"
#define PHONE @"phone"
#define NAME @"name"
#define LoginValue @"Login"
#define LogStatus @"LogStatus"

#define SelectedCityKeyNew @"SelectedCityKeyNew"
#define SelectedCityNameNew @"SelectedCityNameNew"
#define CityNameNew @"CityNameNew"

#pragma mark -----------------------上线前

#endif /* ToolsMacros_h */
