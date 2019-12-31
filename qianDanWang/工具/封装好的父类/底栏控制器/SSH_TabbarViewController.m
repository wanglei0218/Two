//
//  SSH_TabbarViewController.m
//  TaoYouDan
//
//  Created by LY on 2018/9/17.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_TabbarViewController.h"
#import "SSH_HomeViewController.h"//首页
#import "SSH_DiErYeViewController.h"//淘单大全
//#import "SSH_KeHeGuanLiViewController.h"//客户管理
#import "SSH_GeRenZhongXinController.h"//个人中心
#import "SSH_YanZhengMaDengLuController.h"//验证码登录
#import "SSH_DiJiaTaoViewController.h"//低价淘单
#import "SSH_XinKeHuGuanLiController.h"
#import "SSH_FengXianBaKongViewController.h"
@interface SSH_TabbarViewController ()<UITabBarControllerDelegate>

@end

@implementation SSH_TabbarViewController

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    NSString *token = [DENGFANGSingletonTime shareInstance].tokenString;
    if ([token isEqualToString:@""] || token == nil) {
//        if ([viewController isKindOfClass:[DENGFANGClientManageViewController class]] || [viewController isKindOfClass:[DENGFANGMineViewController class]]) {
        
       
    //ttyydd-这个地方，不能根据isKindOfClass来判断是否相等，打印出来的class都是SSQ_BaseNavigationViewController。应根据viewController在self.viewControllers中的位置来判断是否相等
        if (viewController == self.viewControllers[1] || viewController == self.viewControllers[2] || viewController == self.viewControllers[3]) {
//
            SSH_YanZhengMaDengLuController *verVC = [[SSH_YanZhengMaDengLuController alloc] init];
            verVC.isShowTiaoGuo = 0;
            SSQ_HiddenNavigationViewController *naviVC = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:verVC];
            [self presentViewController:naviVC animated:YES completion:nil];
            return NO;
        }
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    SSQ_BaseNavigationViewController *homeNVC = [[SSQ_BaseNavigationViewController alloc] initWithRootViewController:[[SSH_HomeViewController alloc] init]];
    [self setController:homeNVC withTitle:@"首页" imageName:@"shouye1_no" selImageName:@"shouye1_sel"];
    
    SSQ_BaseNavigationViewController *taoDanNVC = [[SSQ_BaseNavigationViewController alloc] initWithRootViewController:[[SSH_DiErYeViewController alloc] init]];
    [self setController:taoDanNVC withTitle:@"淘单大全" imageName:@"qiangdan_no" selImageName:@"qiangdan_sel"];
    
//    SSQ_BaseNavigationViewController *diJiaTaoDanNVC = [[SSQ_BaseNavigationViewController alloc] initWithRootViewController:[[SSH_DiJiaTaoViewController alloc] init]];
//    [self setController:diJiaTaoDanNVC withTitle:@"低价淘单" imageName:@"dijiataodan_no" selImageName:@"dijiataodan_select"];
    
    SSQ_BaseNavigationViewController *clientNVC = [[SSQ_BaseNavigationViewController alloc] initWithRootViewController:[[SSH_XinKeHuGuanLiController alloc] init]];
    [self setController:clientNVC withTitle:@"客户管理" imageName:@"kehu_guanli_no" selImageName:@"kehu_guanli_sel"];
    
    SSQ_BaseNavigationViewController *mineNVC = [[SSQ_BaseNavigationViewController alloc] initWithRootViewController:[[SSH_GeRenZhongXinController alloc] init]];
    [self setController:mineNVC withTitle:@"我的" imageName:@"wode1_no" selImageName:@"wode1_sel"];
    
    self.viewControllers = @[homeNVC,taoDanNVC,clientNVC,mineNVC];
    self.tabBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)setController:(UIViewController *)controller withTitle:(NSString *)title imageName:(NSString *)imageName selImageName:(NSString *)selImageName{
    
    [controller.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    controller.tabBarItem.title = title;
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (void)initialize{
    UITabBarItem *appearance = [UITabBarItem appearance];
    [appearance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateNormal];
    [appearance setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:COLOR_WITH_HEX(0x0560F6)} forState:UIControlStateSelected];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
