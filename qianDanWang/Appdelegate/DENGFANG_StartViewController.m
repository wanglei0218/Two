//
//  JGStartViewController.m
//  jiaogeqian
//
//  Created by huang on 2018/9/5.
//  Copyright © 2018年 zdtc. All rights reserved.
//

#import "DENGFANG_StartViewController.h"
#import "SSQ_NEW_YtjudgeNeter.h"
#import "SSQ_NEW_NetWorkEnginer.h"
//#import "SSQ_TabBarViewController.h"
#import "SSQ_BeforeStarJiaZai.h"
#import "SSH_TabbarViewController.h"//二手车底栏

@interface DENGFANG_StartViewController ()
{
    NSString * _trackViewUrl;
    
    UIImageView * _imgView;
    
}
@property(strong,nonatomic)UIView * noNetView;
@property(strong,nonatomic)UIImageView *netImg;
@end

@implementation DENGFANG_StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImage * logoIcon;
    
    if (IS_IPHONE5) {
        logoIcon = [UIImage imageNamed:@"StatImg4"];

    }else if (IS_IPHONE6){
        logoIcon = [UIImage imageNamed:@"StatImg3"];

    }else if (IS_IPHONE6PLUS){
        logoIcon = [UIImage imageNamed:@"StatImg2"];

    }else{
        logoIcon = [UIImage imageNamed:@"StatImg1"];

    }
    _imgView = [[UIImageView alloc] init];
    _imgView.image = logoIcon;
    [self.view addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    
    if ([[SSQ_NEW_YtjudgeNeter YT_YTShareJudgeNeter] YTIsConnectioner] == NO ) {
        [_imgView removeFromSuperview];
        [self creatNoNet];

    }else{
        
        if ([SSQ_NEW_NetWorkEnginer YT_ytProxySettinger]) {
            return;
        }
        [self queryData];
    }
}
-(void)creatNoNet{
    
    self.noNetView = [[UIView alloc]init];
    self.noNetView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT);
    [self.view addSubview:self.noNetView];
    
    UIImageView *wIg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nono"]];
    wIg.frame = CGRectMake((SCREEN_WIDTH-150)/2+10, SCREENH_HEIGHT*192/667, 150, 150*317/299);
    [self.noNetView addSubview:wIg];
    
    UIButton * btn = [[UIButton alloc]init];
    btn.frame = CGRectMake((SCREEN_WIDTH-90)/2, wIg.frame.size.height+wIg.frame.origin.y+30, 90, 25);
    [btn setTitle:@"点击重新加载" forState:UIControlStateNormal];
    //bdbdbd
    [btn setTitleColor:COLOR_With_Hex(0xbdbdbd) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    UIColor *borderColor = COLOR_With_Hex(0xbdbdbd);
    btn.layer.borderColor = borderColor.CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(queryData) forControlEvents:UIControlEventTouchUpInside];
    [self.noNetView addSubview:btn];
}
- (void)queryData{
    if ([[SSQ_NEW_YtjudgeNeter YT_YTShareJudgeNeter] YTIsConnectioner] != NO ) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
            [_imgView removeFromSuperview];
            [self.noNetView removeFromSuperview];
            self.netImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"netNoGood"]];
            self.netImg.frame = CGRectMake((SCREEN_WIDTH-150)/2, SCREENH_HEIGHT*192/667, 150, 150);
            [self.view addSubview:self.netImg];
        });
    }
    
    [SSQ_NEW_NetWorkEnginer YT_ytGetWithUrlStringer:ContentUrl parameters:@{@"time":[self currentDateStr],@"device":@"ios"} success:^(NSDictionary *data) {
        [self updateApp];
        
        [self.noNetView removeFromSuperview];
        [self.netImg removeFromSuperview];
        SSH_TabbarViewController *baseTabVC = [[SSH_TabbarViewController alloc] init];
        SHAREDAPP.window.rootViewController = baseTabVC;

        [self addChildViewController:baseTabVC];
        [self.view addSubview:baseTabVC.view];
        
        
        [_imgView removeFromSuperview];
        
        
        if ([[data allKeys] containsObject:ContentWebUrl]) {
            SSQ_BeforeStarJiaZai *DianDian_webView = [[SSQ_BeforeStarJiaZai alloc] init];
            DianDian_webView.urlStr = data[@"tydurl"];
            if ([[data allKeys] containsObject:ContentColor]) {
                DianDian_webView.tangdouColor = data[ContentColor];
            }else{
                DianDian_webView.tangdouColor = @"0xFFFFFF";
            }
            SHAREDAPP.window.rootViewController = DianDian_webView;

        }else if ([data[@"data"] isEqualToString:ContentYS])
        {
            [DENGFANGSingletonTime shareInstance].isOnline = YES;
            NSString *name = data[@"name"];
            [DENGFANGSingletonTime shareInstance].name = [name componentsSeparatedByString:@","];
            UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
            keyWindow.rootViewController = [SSH_TabbarViewController new];
            
            SSH_TabbarViewController * tabVC = [SSH_TabbarViewController new];
            
            [self addChildViewController:tabVC];
            [self.view addSubview:tabVC.view];
            
            [baseTabVC.view removeFromSuperview];
            if ([DENGFANGSingletonTime shareInstance].did) {
                [DENGFANGSingletonTime shareInstance].did(YES);
            }
            
        }
    } failure:^(NSError *error) {
        //        hhhuuu.hidden = YES;
        [_imgView removeFromSuperview];

    }];
    
    
}
- (NSString *)currentDateStr{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS "];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    return dateString;
}

- (void)updateApp
{
    NSError *error;
    NSString *appUrl = @"https://itunes.apple.com/lookup?id=";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", appUrl, KAPPID];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *appInfoDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if (error) {
        return;
    }
    
    NSArray *resultArray = [appInfoDict objectForKey:@"results"];
    
    if (![resultArray count]) {
        return;
    }
    
    NSDictionary *infoDict = [resultArray objectAtIndex:0];
    //获取服务器上应用的最新版本号
    NSString *updateVersion = infoDict[@"version"];
    
    NSString *note = [infoDict objectForKey:@"releaseNotes"];
    
    _trackViewUrl = infoDict[@"trackViewUrl"];
    
    //获取当前设备中应用的版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"] ;
    
    //判断两个版本是否相同
    if ([updateVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
        NSString *titleStr = [NSString stringWithFormat:@"发现新版本"];
        [self setupAlertView];
    }
    
}

- (void)setupAlertView {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"升级" message:@"发现新版本" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_trackViewUrl]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:enterAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
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
