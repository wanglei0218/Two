//
//  AppDelegate.m
//  TaoYouDan
//
//  Created by LY on 2018/9/17.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "AppDelegate.h"

#import "SSH_TabbarViewController.h"//tabbar
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "SSQ_GuideViewController.h"
#import "DENGFANG_StartLoadingViewController.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <ShareSDK/ShareSDK.h>
#import "SSH_KeHuXiangQingViewController.h"
#import "SSH_WangYeViewController.h"


#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate ()<WXApiDelegate,CLLocationManagerDelegate,JPUSHRegisterDelegate>

{
    CLLocationManager * locationManager;
}
@property (assign, nonatomic) UIBackgroundTaskIdentifier bgTask;
@property (strong, nonatomic) dispatch_block_t expirationHandler;
@property (assign, nonatomic) BOOL jobExpired;
@property (assign, nonatomic) BOOL background;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [MXLivenessLicManger initWithProductionMode:YES];
//    [MXOCRLicManger initWithProductionMode:YES];
    
    [AMapServices sharedServices].apiKey = AMapKey;
    
    //[UMConfigure initWithAppkey:UMKey channel:@"App Store"];
    
    [self setupJPushapplication:application didFinishLaunchingWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self setupGuideView:application dictionary:launchOptions];
    
    [self.window makeKeyAndVisible];
    //[self getWeChatID];

    
    [DENGFANGSingletonTime shareInstance].tokenString = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGTokenKey];
    [DENGFANGSingletonTime shareInstance].mobileString = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGPhoneKey];
    NSString *useidStr = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGUserIDKey];
    [DENGFANGSingletonTime shareInstance].useridString = [useidStr intValue];
    
    //Assume that we're in background at first since we get no notification from device that we're in background when
    //app launches immediately into background (i.e. when powering on the device or when the app is killed and restarted)
    
    return YES;
}


#pragma mark - 获取微信AppID APPSecret 摩羯AppID
- (void)getWeChatID {
    [[DENGFANGRequest shareInstance] getWithUrlString:@"base/getSysConfig" parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil]} success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            NSDictionary *dic = diction[@"data"];
            [DENGFANGSingletonTime shareInstance].weChatIDStr = dic[@"vxPayAppId"];
            [DENGFANGSingletonTime shareInstance].moJieIDStr = dic[@"moxieId"];
            [DENGFANGSingletonTime shareInstance].weChatSecret = dic[@"vxAppsecret"];
            [self setUpWXShareManager];
            [self setUpShareManager];
            
        } else {
            [self reloadWeChatID];
        }
    } fail:^(NSError *error) {
        [self reloadWeChatID];
    }];
}

- (void)reloadWeChatID {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getWeChatID];
    });
}

#pragma mark - 配置微信
- (void)setUpWXShareManager {
    /*这个是上线后的key*/
    [WXApi registerApp:[DENGFANGSingletonTime shareInstance].weChatIDStr]; //微信分享、微信支付
}

#pragma mark - 配置友盟
- (void)setUpUMManager {
    [UMConfigure initWithAppkey:UMKey channel:@"App Store"];
}

#pragma mark - 配置分享
- (void)setUpShareManager {
//    微信
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        [platformsRegister setupWeChatWithAppId:[DENGFANGSingletonTime shareInstance].weChatIDStr appSecret:[DENGFANGSingletonTime shareInstance].weChatSecret];
    }];
}

//引导页
- (void)setupGuideView:(UIApplication *)application dictionary:(NSDictionary *)launchOptions{
    if([UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    
    DENGFANG_StartLoadingViewController *vc = [[DENGFANG_StartLoadingViewController alloc]init];
    vc.application = application;
    vc.launchOptions = launchOptions;
    self.window.rootViewController = vc;

}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            
            [DENGFANGSingletonTime shareInstance].aliResultStatus = [resultDic[@"resultStatus"] intValue];
            NSLog(@"%d",[resultDic[@"resultStatus"] intValue]);
            NSLog(@"%d",[DENGFANGSingletonTime shareInstance].aliResultStatus);
            [[NSNotificationCenter defaultCenter] postNotificationName:DENGFANGPayFinishName object:nil];
        }];
    }else if ([url.host isEqualToString:@"pay"]) {
        // 处理微信的支付结果
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
            [DENGFANGSingletonTime shareInstance].aliResultStatus = [resultDic[@"resultStatus"] intValue];
            NSLog(@"%d",[resultDic[@"resultStatus"] intValue]);
            NSLog(@"%d",[DENGFANGSingletonTime shareInstance].aliResultStatus);
            [[NSNotificationCenter defaultCenter] postNotificationName:DENGFANGPayFinishName object:nil];
        }];
    }else if ([url.host isEqualToString:@"pay"]) {
        // 处理微信的支付结果
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        
        [DENGFANGSingletonTime shareInstance].wxRetCode = response.errCode;
        [[NSNotificationCenter defaultCenter] postNotificationName:DENGFANGPayFinishName object:nil];
        switch (response.errCode) {
            case WXSuccess:
                NSLog(@"支付成功");
                
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}


- (void)setupJPushapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    NSString *jiguang = [[NSUserDefaults standardUserDefaults] objectForKey:@"jiguangkey"];
    if (jiguang == nil || jiguang.length == 0) {
        return;
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:jiguang
                          channel:@"App Store"
                 apsForProduction:1 advertisingIdentifier:nil];
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    //获取registrationID
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        
        [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
}
#pragma 极光推送
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification {

    NSLog(@"111");
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    [self jumpWithNotificationInfo:userInfo];
    
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}



- (void)jumpWithNotificationInfo:(NSDictionary *)info {
    // 如果为空就返回
    if (!info) {
        return;
    }
    
    NSLog(@"info---%@",info);
    UIViewController *showVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    BOOL isOnline = [self findChildViewControllerFromSuper:showVC withDict:info];
    
    if (!isOnline) {
        __weak typeof(self) weakSelf = self;
        [DENGFANGSingletonTime shareInstance].did = ^(BOOL isYes) {
            [weakSelf findChildViewControllerFromSuper:showVC withDict:info];
        };
    }
    
}

- (BOOL)findChildViewControllerFromSuper:(UIViewController *)showVC withDict:(NSDictionary *)info {
    BOOL isOnline = NO;
    for (UIViewController *childVC in showVC.childViewControllers) {
        if ([childVC isKindOfClass:[SSH_TabbarViewController class]]) {
            SSH_TabbarViewController * tabBarControllerConfig = (SSH_TabbarViewController *)childVC;
            SSQ_BaseNavigationViewController *nav = (SSQ_BaseNavigationViewController *)tabBarControllerConfig.selectedViewController;
            isOnline = YES;
            [self jumpController:info navigationVc:nav];
        }
    }
    return isOnline;
}

-(void)jumpController:(NSDictionary *)info navigationVc:(SSQ_BaseNavigationViewController *)nav{
    
    NSString *productID = info[@"creditId"];
    NSString *openType = info[@"openType"];
    
    if ([openType isEqualToString:@"1"]) { //推送资源
        SSH_KeHuXiangQingViewController *productDetail = [SSH_KeHuXiangQingViewController new];
        productDetail.creditinfoId = productID;
        productDetail.pageType = 1;
        productDetail.fromWhere = 2;
        productDetail.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:productDetail animated:YES];
    }else if ([openType isEqualToString:@"2"]) { //H5链接
        NSString *htmlUrl = info[@"htmlUrl"];
        SSH_WangYeViewController *webVC = [[SSH_WangYeViewController alloc] init];
        webVC.webUrl = htmlUrl;
        webVC.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:webVC animated:YES];
    }else{ //启动app
        
    }
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 实现如下代码，才能使程序处于后台时被杀死，调用applicationWillTerminate:方法
//    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(){}];
    
//    [self monitorBatteryStateInBackground];
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    [locationManager startUpdatingLocation];
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
     NSLog(@"程序被杀死，applicationWillTerminate");
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];

    [self resetTaoDanDaQuanShuaiXuanState];//重置淘单大全里面的筛选状态
    [self resetCustomerManagerShuaiXuanState];//重置客户管理里面的筛选状态
    

    //清空手机存储状态
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Manager_PhoneStatus];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
#pragma mark 重置淘单大全里面的筛选状态
-(void)resetTaoDanDaQuanShuaiXuanState{
    //#define Big_CustomerStatus     @"BigCustomerStatus" //客户状态 - code
    //#define Big_MortgageType       @"BigMortgageType" //资产抵押类型 - code
    //#define Big_IDEntityType       @"BigIDEntityType" //身份类型 - code
    //#define Big_LoanLimit          @"BigLoanLimit" //dk金额 -id值
    //#define Big_LoanStartLimit     @"BigLoanStartLimit" //dk金额 -开始金额
    //#define Big_LoanEndLimit       @"BigLoanEndLimit" //dk金额 -结束金额
    //#define Big_Qualification      @"BigQualification" //资质信息
    
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Big_CustomerStatus];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Big_MortgageType];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Big_IDEntityType];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Big_LoanLimit];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Big_LoanStartLimit];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Big_LoanEndLimit];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Big_Qualification];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
#pragma mark 重置客户管理里面的筛选状态
-(void)resetCustomerManagerShuaiXuanState{
    //客户管理 - 筛选 状态保存
    //#define Manager_CustomerStatus     @"ManagerCustomerStatus" //客户状态 - code
    //#define Manager_MortgageType       @"ManagerMortgageType" //资产抵押类型 - code
    //#define Manager_IDEntityType       @"ManagerIDEntityType" //身份类型 - code
    //#define Manager_LoanLimit          @"ManagerLoanLimit" //dk金额 -id值
    //#define Manager_LoanStartLimit     @"ManagerLoanStartLimit" //dk金额 -开始金额
    //#define Manager_LoanEndLimit       @"ManagerLoanEndLimit" //dk金额 -结束金额
    //#define Manager_Qualification      @"ManagerQualification" //资质信息
    
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Manager_CustomerStatus];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Manager_MortgageType];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Manager_IDEntityType];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Manager_LoanLimit];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Manager_LoanStartLimit];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Manager_LoanEndLimit];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Manager_Qualification];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
