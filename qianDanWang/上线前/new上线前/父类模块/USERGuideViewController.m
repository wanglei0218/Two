//
//  USERGuideViewController.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/28.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERGuideViewController.h"
#import "USERTabBarViewController.h"
#import "ImageScrollView.h"

@interface USERGuideViewController ()<ImageScrollViewDelegate>

@end

@implementation USERGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 图片数组
    NSArray *imgNameArr = @[@"Guide1",@"Guide2"];
    // 创建滚动视图
    ImageScrollView *guideScrView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:ImageScrollType_Guide images:imgNameArr confirmBtnTitle:@"立即体验" confirmBtnTitleColor:[UIColor whiteColor] confirmBtnFrame:CGRectMake(WidthScale(100),  ScreenHeight - WidthScale(124) - SafeAreaBottomHEIGHT, ScreenWidth - WidthScale(200), WidthScale(44)) autoScrollTimeInterval:0 delegate:self];
    
    if (isPad) {
        guideScrView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:ImageScrollType_Guide images:imgNameArr confirmBtnTitle:@"立即体验" confirmBtnTitleColor:[UIColor whiteColor] confirmBtnFrame:CGRectMake(WidthScale(100),  ScreenHeight - WidthScale(100) - SafeAreaBottomHEIGHT, ScreenWidth - WidthScale(200), WidthScale(44)) autoScrollTimeInterval:0 delegate:self];
    }
    
    // 添加到父视图上
    [self.view addSubview:guideScrView];
    // 添加分页控件
    [guideScrView addPageControlToSuperView:self.view];
}


// 立即体验
-(void)experienceDidHandle {
    // （1） 切换窗口的根视图控制器
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = [[USERTabBarViewController alloc] init];
    
    // （2)将当前app的版本号持久化
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:CURRENT_VERSION forKey:SAVE_VERSION];
    [ud synchronize];
    
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
