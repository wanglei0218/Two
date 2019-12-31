//
//  USERAgreementViewController.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/18.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERAgreementViewController.h"
#import <WebKit/WebKit.h>

@interface USERAgreementViewController ()<WKUIDelegate,WKNavigationDelegate>
{
    NSString *_agtStr;
}

@property (nonatomic, strong) WKWebView *agtWkWebVw;
@property(nonatomic,strong)MBProgressHUD *showHUD;

@end

@implementation USERAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rootNaviBaseTitle.text = @"隐私协议";
    self.rootNaviBaseLine.hidden = NO;
    self.rootNaviBaseImg.backgroundColor = [UIColor whiteColor];
    _agtStr = @"http://www.gzblue.top/yinsi.htm";
    
    self.agtWkWebVw = [[WKWebView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, ScreenWidth, ScreenHeight-getRectNavAndStatusHight)];
    [self.view addSubview:self.agtWkWebVw];
    self.agtWkWebVw.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.agtWkWebVw.UIDelegate = self;
    self.agtWkWebVw.navigationDelegate = self;
    self.agtWkWebVw.allowsBackForwardNavigationGestures = YES;
    self.agtWkWebVw.backgroundColor = [UIColor whiteColor];
    
    self.showHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.showHUD.label.text = NSLocalizedString(@"正在加载中", @"HUD loading title");
    NSURL *url = [NSURL URLWithString:_agtStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:2];
    [self.agtWkWebVw loadRequest:request];
    
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
//    NSLog(@"失败了");
    [self.showHUD hideAnimated:YES];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.showHUD hideAnimated:YES];
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
