//
//  SSQ_BeforeStarJiaZai.m
//  KuaiYiHua
//
//  Created by  梁媛 on 2018/9/6.
//  Copyright © 2018年 chaoqianyan. All rights reserved.
//
//GitHub地址：https://github.com/LYPRO
//简书地址：http://www.jianshu.com/u/5f8c014bd8df
//
//

#import "SSQ_BeforeStarJiaZai.h"

@interface SSQ_BeforeStarJiaZai ()<UIWebViewDelegate>{
    float height;
    NSArray *hostArr;
    
    NSURLRequest *request;
}


@property (nonatomic, strong) MBProgressHUD *zhuanquan;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) BOOL shifoudiyicijinlai;
@property (nonatomic, strong) NSString *shouyeUrl;//首页URL

@end

@implementation SSQ_BeforeStarJiaZai
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    
   
    self.shifoudiyicijinlai = YES;
    unsigned long red = strtoul([_tangdouColor UTF8String], 0, 16);
    self.view.backgroundColor = COLOR_With_Hex(red);
    if (IS_IPHONEX || IS_IPHONEMAX) {
        height = 44;
    }else{
        height = 20;
    }
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, 44)];
    navigationView.backgroundColor = COLOR_With_Hex(red);
    [self.view addSubview:navigationView];
    
    UIButton *gobackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gobackButton setImage:[UIImage imageNamed:@"fanhuijiantou"] forState:UIControlStateNormal];
    gobackButton.frame = CGRectMake(0, 0, 40, 44);
    [navigationView addSubview:gobackButton];
    [gobackButton addTarget:self action:@selector(gobackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *huiShouYeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [huiShouYeButton setImage:[UIImage imageNamed:@"huishouye"] forState:UIControlStateNormal];
    huiShouYeButton.frame = CGRectMake(40, 0, 40, 44);
    [navigationView addSubview:huiShouYeButton];
    [huiShouYeButton addTarget:self action:@selector(huiShouYeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, SCREENH_HEIGHT-height)];
    [self.view addSubview:self.webView];
    self.webView.scrollView.bounces=NO;
    self.webView.delegate  = self;
    self.webView.backgroundColor = [UIColor whiteColor];

    
    self.zhuanquan = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.zhuanquan.label.text = NSLocalizedString(@"正在加载中...", @"HUD loading title");
   
    
    
    [self.webView loadRequest:request];
   
    
}

- (NSString *)getNowTimeTimestamp{
    
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
}

- (void)gobackButtonAction{
    [self.webView goBack];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL * url = [request URL];
    NSURL *urlHost = [NSURL URLWithString:self.urlStr];
    
    if ([urlHost.host isEqualToString:url.host]) {
        self.webView.frame = CGRectMake(0, height, SCREEN_WIDTH, SCREENH_HEIGHT-height);

    }else{
        self.webView.frame = CGRectMake(0, 44+height, SCREEN_WIDTH, SCREENH_HEIGHT-44-height);

    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.zhuanquan hideAnimated:YES];
    
    if (self.shifoudiyicijinlai == YES) {
        self.shifoudiyicijinlai = NO;
    }
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self.zhuanquan hideAnimated:YES];

}

- (void)huiShouYeButtonAction{
    if ([self checkProxySetting]) {
        return;
    }
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:50];
    [self.webView loadRequest:request];
    
}

- (BOOL)checkProxySetting {
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    
    NSDictionary *settings = proxies[0];
    
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
    {
        
        return NO;
    }
    else
    {
        
        return YES;
    }
}

@end
