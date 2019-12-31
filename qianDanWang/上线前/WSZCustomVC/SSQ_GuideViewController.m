//
//  SSQ_GuideViewController.m
//  Bookkeeping
//
//  Created by YTer on 2018/8/20.
//  Copyright © 2018年 hwYTer. All rights reserved.
//

#import "SSQ_GuideViewController.h"
#import "DENGFANG_StartLoadingViewController.h"
#import "SSH_TabbarViewController.h"
#import "SSH_YanZhengMaDengLuController.h"


@interface SSQ_GuideViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIPageControl *YT_PageContr;
@property (nonatomic, strong) UIScrollView *YT_crollView;
@property (nonatomic, assign)NSInteger YT_rrentPageInd;
@end
#define PAGE_CONTROL_HEIGHT 20

@implementation SSQ_GuideViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //存储一个标记->只要进入了启动页,在进入app后就需要判断是否提示切换城市
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"CITY"];
    //消息推送
    [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"isopen"];
    
    
    self.YT_crollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.YT_crollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.YT_crollView];
    self.YT_crollView.delegate = self;
    self.YT_crollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREENH_HEIGHT);
    self.YT_crollView.pagingEnabled = YES;
    
    CGFloat imageW = self.YT_crollView.frame.size.width;
    CGFloat imageH = self.YT_crollView.frame.size.height;
    NSArray *arr1 = @[@"iPhone6-1",@"iPhone6-2",@"iPhone6-3"];
    NSArray *arr2 = @[@"iPhonePlus-1",@"iPhonePlus-2",@"iPhonePlus-3"];
    NSArray *arr3 = @[@"iPhoneSE-1",@"iPhoneSE-2",@"iPhoneSE-3"];
    NSArray *arr4 = @[@"iPhoneX-1",@"iPhoneX-2",@"iPhoneX-3"];
        for (int i = 0; i<HWNewfeatureImageCount; i++) {
            // 创建UIImageView
            UIImageView *imageView = [[UIImageView alloc] init];
            // 显示图片
            if (IS_IPHONE5) {
                imageView.image = [UIImage imageNamed:arr3[i]];
            }else if (IS_IPHONE6){
                imageView.image = [UIImage imageNamed:arr1[i]];
            }else if (IS_IPHONE6PLUS){
                imageView.image = [UIImage imageNamed:arr2[i]];
            }else{
                imageView.image = [UIImage imageNamed:arr4[i]];
            }
            
            [self.YT_crollView addSubview:imageView];
            // 设置frame
            imageView.frame = CGRectMake(i * imageW, 0, imageW, imageH);
            // 给最后一个imageView添加按钮
            if (i == HWNewfeatureImageCount - 1) {
                [self setupLastImageView:imageView];
            }
        }
    
    self.YT_PageContr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 121 - PAGE_CONTROL_HEIGHT, self.view.frame.size.width, PAGE_CONTROL_HEIGHT)];
    self.YT_PageContr.numberOfPages = 3;
    [self.view addSubview:self.YT_PageContr];
    self.YT_PageContr.pageIndicatorTintColor = GrayColor666;
    self.YT_PageContr.currentPageIndicatorTintColor = COLOR_With_Hex(0xf15053);
    
}

/**
 *   设置最后一个UIImageView中的内容
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    
    imageView.userInteractionEnabled = YES;
    // 1.添加开始按钮
    [self setupStartButton:imageView];
}


/**
 *  添加开始按钮
 */
- (void)setupStartButton:(UIImageView *)imageView
{
    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
    startButton.frame = CGRectMake(AdaptedWidth(75) , SCREENH_HEIGHT - AdaptedHeight(41.5)-45.5,  AdaptedWidth(134), 45.5);  //120
    startButton.centerX = SCREEN_WIDTH/2;
    startButton.layer.masksToBounds = YES;
    startButton.layer.cornerRadius = 22.5;
    [imageView addSubview:startButton];
    [startButton setTitle:@"立即体验" forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17.4];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 按钮的frame
    
    // 添加点击事件
    [startButton setBackgroundColor:COLOR_With_Hex(0xf15053)];
    
    [startButton addTarget:self action:@selector(YT_YTbuttonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.YT_rrentPageInd = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    self.YT_PageContr.currentPage = self.YT_rrentPageInd;
}



- (void)YT_YTbuttonAction{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[SSH_TabbarViewController alloc] init];
//    SSH_YanZhengMaDengLuController *verVC = [[SSH_YanZhengMaDengLuController alloc] init];
//    verVC.isShowTiaoGuo = 1;
//    SSQ_HiddenNavigationViewController *naviVC = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:verVC];
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:naviVC animated:YES completion:nil];
}




 
@end
