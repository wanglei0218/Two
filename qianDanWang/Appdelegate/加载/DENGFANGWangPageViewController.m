//
//  YFwangyeViewController.m
//  YFRecycling
//
//  Created by 糖豆 on 2018/4/23.
//  Copyright © 2018年 糖豆. All rights reserved.
//

#import "DENGFANGWangPageViewController.h"
#import "DENGFANGWebViewSingleModel.h"
#import "SSQ_NEW_NetWorkEnginer.h"

@interface DENGFANGWangPageViewController ()<WKUIDelegate,WKNavigationDelegate>{
    NSString * _trackViewUrl;
    float height;
    NSArray *hostArr;
}

@property (nonatomic, strong) MBProgressHUD *zhuanquan;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BOOL shifoudiyicijinlai;
@property (nonatomic, strong) NSString *shouyeUrl;//首页URL

@property (nonatomic,strong) UIView *navigationView;

@end

@implementation DENGFANGWangPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.shifoudiyicijinlai = YES;
    
 
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, getStatusHeight, ScreenWidth, 44)];
    
    [self.view addSubview:self.navigationView];
    UIButton *gobackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gobackButton setImage:[UIImage imageNamed:@"fanhuijiantou"] forState:UIControlStateNormal];
    gobackButton.frame = CGRectMake(0, 0, 40, 44);
    [self.navigationView addSubview:gobackButton];
    [gobackButton addTarget:self action:@selector(gobackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *huiShouYeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [huiShouYeButton setImage:[UIImage imageNamed:@"huishouye"] forState:UIControlStateNormal];
    huiShouYeButton.frame = CGRectMake(40, 0, 40, 44);
    [self.navigationView addSubview:huiShouYeButton];
    [huiShouYeButton addTarget:self action:@selector(huiShouYeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.webView = [DENGFANGWebViewSingleModel sharedInstance].singleWebView;
    self.webView.frame = CGRectMake(0, height, ScreenWidth, ScreenHeight-height);
//    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, height, kScreenWidth, kScreenHeight-height)];
    self.webView.allowsBackForwardNavigationGestures = YES;

    
    
    [self.view addSubview:self.webView];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;

    self.webView.scrollView.bounces=NO;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    
}



- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:50];
    [mutableRequest setValue:@"chunked" forHTTPHeaderField:@"transfer-encoding"];
    
    [self.webView loadRequest:mutableRequest];
}

- (void)setColorstr:(NSString *)colorstr {
    _colorstr = colorstr;
    unsigned long red = strtoul([_colorstr UTF8String], 0, 16);
    self.view.backgroundColor = COLOR_WITH_HEX(red);
    self.navigationView.backgroundColor = COLOR_WITH_HEX(red);
    
}


- (NSString *)getNowTimeTimestamp{
    
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
}

- (void)gobackButtonAction{
    [self.webView goBack];
}


//开始请求时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
//    NSLog(@"开始请求。。。。。。。。。。。。。。。。。。。。。%@",[NSString getNowDateStrFromForMatter:@"yyyy-MM-dd hh:mm:ss"]);
    
    
    if (self.shifoudiyicijinlai) {
        NSString *startTimeStamp = [DENGFANGWebViewSingleModel sharedInstance].timeStamp;
        NSString *nowTimeStamp = [self getNowTimeTimestamp];
        if ([nowTimeStamp longLongValue] - [startTimeStamp longLongValue] > 1*1000) {
            if (self.finishBlock) {
                self.finishBlock(YES);
            }
        }
    }
   
    
    NSURL * url = webView.URL;
    NSURL *huh = [NSURL URLWithString:self.urlStr];
    if ([huh.host isEqualToString:url.host]) {
        self.webView.frame = CGRectMake(0, getStatusHeight, ScreenWidth, ScreenHeight-getStatusHeight);
    }else{
        self.webView.frame = CGRectMake(0, 44+getStatusHeight, ScreenWidth, ScreenHeight-44-getStatusHeight);
    }
}

/// 4 开始获取到网页内容时返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
//     NSLog(@"获取到网页内容。。。。。。。。。。。。。。。。。。。。。%@",[NSString getNowDateStrFromForMatter:@"yyyy-MM-dd hh:mm:ss"]);
    if (self.shifoudiyicijinlai) {
        NSString *startTimeStamp = [DENGFANGWebViewSingleModel sharedInstance].timeStamp;
        NSString *nowTimeStamp = [self getNowTimeTimestamp];
        if ([nowTimeStamp longLongValue] - [startTimeStamp longLongValue] > 1.5*1000) {
            if (self.finishBlock) {
                self.finishBlock(YES);
            }
        }
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
//    NSLog(@"加载完成。。。。。。。。。。。。。。。。。。。。。%@",[NSString getNowDateStrFromForMatter:@"yyyy-MM-dd hh:mm:ss"]);
    if (self.shifoudiyicijinlai == YES) {
        if (self.finishBlock) {
            self.finishBlock(NO);
        }
        [self updateApp];
        self.shifoudiyicijinlai = NO;
    }
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"失败了");
    [self.zhuanquan hideAnimated:YES];
}

- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler{
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    NSURL *url = navigationAction.request.URL;
    NSString *host = [url host];
    if ([host isEqualToString:@"itunes.apple.com"] &&
        [[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        policy = WKNavigationActionPolicyAllow;
    }else if (url.scheme && !host && [[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        policy = WKNavigationActionPolicyAllow;
    }
    
    
//    else if ([url.scheme containsString:@"itms-services"]){
//        [[UIApplication sharedApplication] openURL:url];
//        policy = WKNavigationActionPolicyAllow;
//    }
    decisionHandler(policy);
}

#pragma mark -uidelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:^{}];
    });
}





- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    //  js 里面的alert实现，如果不实现，网页的alert函数无效  ,
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:^{}];
    });
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:note delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
        
        alert.tag = 999;
        [alert show];
        
    }
    
}
//判断用户点击了哪一个按钮
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:      (NSInteger)buttonIndex
{
    if (alertView.tag == 999) {
        if (buttonIndex == 1) { //点击”升级“按钮，就从打开app store上应用的详情页面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_trackViewUrl]];
        }
    }
}
- (void)huiShouYeButtonAction{
    if ([SSQ_NEW_NetWorkEnginer YT_ytProxySettinger]) {
        return;
    }
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:50];
    [self.webView loadRequest:request];
    
}


-(NSString *)readCurrentCookie{
    
//    NSHTTPCookieStorage*cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//
    NSMutableString *cookieString = [[NSMutableString alloc] init];
//
//    NSMutableString *domain = [[NSMutableString alloc] initWithString:@"http://192.168.0.140:8886/#/home"];
//
//    NSArray *domainArr = [domain componentsSeparatedByString:@":"];
//
//    NSMutableString *domainString = [NSMutableString stringWithString:domainArr[1]];
//
//    [domainString deleteCharactersInRange:NSMakeRange(0, 2)];
//
//    NSHTTPCookie *currentCookie= [[NSHTTPCookie alloc] init];
//
//    for (NSHTTPCookie*cookie in [cookieJar cookies]) {
//
//        NSLog(@"cookie:%@", cookie);
//
//        if ([cookie.domain isEqualToString:domainString]) {
//
//            currentCookie = cookie;
//
//            //多个字段之间用“；”隔开
//
//            [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
//
//        }
//
//    }
//
//    //删除最后一个“；”
//
//    [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
    
    cookieString = [NSMutableString stringWithString:@"appName=DaWangDaiKuan;developerSign=SGK"];
    return cookieString;
    
}
@end
