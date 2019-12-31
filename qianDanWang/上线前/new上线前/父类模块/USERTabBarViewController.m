//
//  USERTabBarViewController.m
//  USERPRODUCT
//
//  Created by 河神 on 2019/5/29.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERTabBarViewController.h"
#import "USERFirstViewController.h"
#import "USERSecondViewController.h"
#import "USERThirdViewController.h"

@interface USERTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation USERTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createNavWithControllerName:@"USERFirstViewController" title:@"首页" imgName:@"shouye_no1" selectImgName:@"shouye_sel"];

    [self createNavWithControllerName:@"USERSecondViewController" title:@"我要帮忙" imgName:@"bangmang_no" selectImgName:@"bangmang_sel"];

    [self createNavWithControllerName:@"USERThirdViewController" title:@"我的" imgName:@"wode_no1" selectImgName:@"wode_sel"];

    
    if (@available(iOS 10.0, *)) {
        [[UITabBar appearance] setUnselectedItemTintColor:RGB(200, 200, 200)];
    } else {
        // Fallback on earlier versions
    }
}


// 根据不同的参数创建不同的导航控制器
-(UINavigationController *)createNavWithControllerName:(NSString *)cName
                                                 title:(NSString *)title
                                               imgName:(NSString *)name
                                         selectImgName:(NSString *)selName {
    // 根据类的名称的字符串得到一个类的对象
    UIViewController *Vc = [[NSClassFromString(cName) alloc] init];
    // 实例化一个导航
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Vc];
    
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    Vc.tabBarItem.selectedImage = [[UIImage imageNamed:selName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.title = title;
    
    //tabBar图片和文字上移动
    Vc.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    Vc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 0);

    [self addChildViewController:nav];
    
    return nav;
}


+(void)initialize
{
    NSMutableDictionary *normalAttr = [NSMutableDictionary dictionary];
    normalAttr[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    normalAttr[NSForegroundColorAttributeName] = TEXTSEN_Color;
    NSMutableDictionary *selecAttr = [NSMutableDictionary dictionary];
    selecAttr[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    selecAttr[NSForegroundColorAttributeName] = MAINCOLOR1;
    UITabBarItem *appearance = [UITabBarItem appearance];
    [appearance setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [appearance setTitleTextAttributes:selecAttr forState:UIControlStateSelected];
}




@end
