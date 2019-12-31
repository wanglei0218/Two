//
//  DENGFANG_StartLoadingViewController.m
//  SecondCarTao
//
//  Created by 哈士奇（＾Ｏ＾） on 2019/5/10.
//  Copyright © 2019 幸运儿╮(￣▽￣)╭. All rights reserved.
//

#import "DENGFANG_StartLoadingViewController.h"
#import "SSH_TabbarViewController.h"
#import "SSQ_NEW_YtjudgeNeter.h"
#import "SSQ_NEW_NetWorkEnginer.h"
#import "USERTabBarViewController.h"
#import "SSQ_BeforeStarJiaZai.h"
#import "SSQ_GuideViewController.h"

#import "DENGFANGWangPageViewController.h"
#import "DENGFANGNetWorkLoadHintView.h"

#import "WXApi.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <ShareSDK/ShareSDK.h>
#import "SSH_KeHuXiangQingViewController.h"
#import "SSH_WangYeViewController.h"
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>

#define AppShare [UIApplication sharedApplication].keyWindow

@interface DENGFANG_StartLoadingViewController ()<UIApplicationDelegate>
/**  */
@property (nonatomic,strong) DENGFANGWangPageViewController *webVC;
/** 遮盖图 */
@property (nonatomic,strong) DENGFANGNetWorkLoadHintView *loadNetView;

@property(nonatomic,strong)USERTabBarViewController *tabBarVC;  // tabBar控制器（上线前）

@property(nonatomic,strong) UIImageView * wIg;
@end

@implementation DENGFANG_StartLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupWebView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    @weakify(self);
    
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            {
                NSLog(@"没有网络(断网)");
                [self_weak_.loadNetView removeFromSuperview];
                self_weak_.wIg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"netNoGood"]];
                self_weak_.wIg.userInteractionEnabled = YES;
                
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self_weak_ action:@selector(FDENGFANGQueryData)];
                [self_weak_.wIg addGestureRecognizer:tap];
                
                _wIg.bounds = CGRectMake(0, 0, 179, 162);
                _wIg.center  = self_weak_.view.center;
                [self_weak_.view addSubview:_wIg];
                [self_weak_.view sendSubviewToBack:_wIg];
            }
                break;
                
                
            default:
            {
                if ([SSQ_NEW_NetWorkEnginer YT_ytProxySettinger]) {
                    return;
                }
                [self FDENGFANGQueryData];
            }
                break;
        }
    }];
    [mgr startMonitoring];
    
    
}


- (void)setupWebView {
    self.webVC = [[DENGFANGWangPageViewController alloc] init];
    self.webVC.view.backgroundColor = [UIColor whiteColor];

    self.loadNetView = [DENGFANGNetWorkLoadHintView netWorkLoadHintViewInitWithFrame:self.view.bounds];
    [self.view addSubview:self.loadNetView];
}


- (void)FDENGFANGQueryData{
    
    @weakify(self);
    [SSQ_NEW_NetWorkEnginer YT_ytGetWithUrlStringer:ContentUrl parameters:@{@"time":[self currentDateStr],@"device":@"ios"} success:^(NSDictionary *data) {
        
        [self_weak_.wIg removeFromSuperview];
        
        NSDictionary * dic = data;
        NSString *lianJie = data[@"lianJie"];
        [DENGFANGSingletonTime shareInstance].lianJieArr = [lianJie componentsSeparatedByString:@","];
        
        
        SSH_TabbarViewController *baseTabVC = [[SSH_TabbarViewController alloc] init];
        [self_weak_ addChildViewController:baseTabVC];
        [self_weak_.view insertSubview:baseTabVC.view belowSubview:self.loadNetView];
        
        
        if ([[data allKeys] containsObject:ContentWebUrl]) {
            NSString *lianJie = data[@"lianJie"];
            [DENGFANGSingletonTime shareInstance].lianJieArr = [lianJie componentsSeparatedByString:@","];
            [self getWeChatID];
            
            USERTabBarViewController *nnn = [[USERTabBarViewController alloc] init];
            self_weak_.webVC.urlStr = dic[@"tydurl"];
            
            if ([[dic allKeys] containsObject:ContentColor]) {
                self_weak_.webVC.colorstr = dic[ContentColor];
            }else {
                self_weak_.webVC.colorstr = @"0xFFFFFF";
            }
            
            self_weak_.webVC.finishBlock = ^(BOOL isShow) {
                __strong typeof(self_weak_) strongSelf = self_weak_;
                if (isShow) {
                    strongSelf.loadNetView.netWorkStatue = NetWorkStatuesBad;
                }else {
                    [strongSelf.loadNetView netWorkViewRemoveFromSuperView];
                }
            };
            [self_weak_ addChildViewController:nnn];
            [self_weak_.view insertSubview:nnn.view belowSubview:self.loadNetView];
            [self.loadNetView netWorkViewRemoveFromSuperView];
            [baseTabVC.view removeFromSuperview];
            
        } else if ([data[@"data"] isEqualToString:ContentYS]) {
            
            [self_weak_.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
            [self_weak_.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            [DENGFANGSingletonTime shareInstance].isOnline = YES;
            NSString *name = data[@"name"];
            [DENGFANGSingletonTime shareInstance].name = [name componentsSeparatedByString:@","];
            SSH_TabbarViewController * dilanVC = [SSH_TabbarViewController new];
            
            /**
            lianJie[0] = img1.taoyoudan.cn
            lianJie[1] = s1.taoyoudan.cn
            lianJie[2] = m.taoyoudan.cn
            */
            NSString *lianJie = data[@"lianJie"];
            [DENGFANGSingletonTime shareInstance].lianJieArr = [lianJie componentsSeparatedByString:@","];
            NSString *fenXiaoLianJie = data[@"fx"];
            [DENGFANGSingletonTime shareInstance].fenXiaoLianJie = fenXiaoLianJie;
            NSDictionary *infoDictionary = [NSBundle mainBundle].infoDictionary;
            NSString *currentAppVersion = infoDictionary[@"CFBundleShortVersionString"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *appVersion = [userDefaults stringForKey:@"appVersion"];
            [self getWeChatID];
            if (appVersion == nil || appVersion != currentAppVersion) {
//                AppDelegate *app = ;
                [userDefaults setValue:currentAppVersion forKey:@"appVersion"];
                SSQ_GuideViewController *userGuideViewController = [[SSQ_GuideViewController alloc] init];
                AppShare.rootViewController = userGuideViewController;
            }else{
                [self_weak_ addChildViewController:dilanVC];
                [self_weak_.view insertSubview:dilanVC.view belowSubview:self.loadNetView];
                [self.loadNetView netWorkViewRemoveFromSuperView];
                
                [baseTabVC.view removeFromSuperview];
            }
            
            
            if ([DENGFANGSingletonTime shareInstance].did) {
                [DENGFANGSingletonTime shareInstance].did(YES);
            }
            
        }else{
            //如果是上线前,直接移除伪启动图
            [self_weak_.loadNetView netWorkViewRemoveFromSuperView];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (NSString *)currentDateStr{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS "];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    return dateString;
}

- (void)getWeChatID {
    [[DENGFANGRequest shareInstance] getWithUrlString:@"base/getSysConfig" parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil]} success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            NSDictionary *dic = diction[@"data"];
            [DENGFANGSingletonTime shareInstance].weChatIDStr = dic[@"vxPayAppId"];
            [DENGFANGSingletonTime shareInstance].moJieIDStr = dic[@"moxieId"];
            [DENGFANGSingletonTime shareInstance].weChatSecret = dic[@"vxAppsecret"];
            [DENGFANGSingletonTime shareInstance].UMengKeyStr = dic[@"umengIOSApiKey"];
            [DENGFANGSingletonTime shareInstance].JPushKeyStr = dic[@"jiguangApikey"];
            
            [self setUpWXShareManager];
            [self setUpShareManager];
            [self setUpUMManager];
            [self setupJPushapplication:self.application didFinishLaunchingWithOptions:self.launchOptions];
            
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
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:[DENGFANGSingletonTime shareInstance].UMengKeyStr channel:@"App Store"];
    
}

#pragma mark - 配置分享
- (void)setUpShareManager {
    //    微信
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        [platformsRegister setupWeChatWithAppId:[DENGFANGSingletonTime shareInstance].weChatIDStr appSecret:[DENGFANGSingletonTime shareInstance].weChatSecret];
    }];
}

- (void)setupJPushapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
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
    [[NSUserDefaults standardUserDefaults] setObject:[DENGFANGSingletonTime shareInstance].JPushKeyStr forKey:@"jiguangkey"];
    [JPUSHService setupWithOption:launchOptions appKey:[DENGFANGSingletonTime shareInstance].JPushKeyStr
                          channel:@"App Store"
                 apsForProduction:1 advertisingIdentifier:nil];
    
}


#warning 测试用
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
    
//    [MBProgressHUD showSuccess:@"12"];
    NSLog(@"111");
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//    [MBProgressHUD showSuccess:@"10"];
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//    [MBProgressHUD showSuccess:@"10下"];
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
