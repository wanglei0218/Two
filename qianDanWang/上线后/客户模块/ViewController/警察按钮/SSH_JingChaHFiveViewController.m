//
//  SSH_JingChaHFiveViewController.m
//  qianDanWang
//
//  Created by 小锦鲤 on 2019/6/25.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_JingChaHFiveViewController.h"
#import <WebKit/WebKit.h>

@interface SSH_JingChaHFiveViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong)WKWebView *webView;

@end

@implementation SSH_JingChaHFiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text = [NSString stringWithFormat:@"信%@经理风控管理",[DENGFANGSingletonTime shareInstance].name[1]];
    [self.view addSubview:self.webView];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *urlS = [NSString stringWithFormat:@"http://m.thgjzg.cn/static/index.html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlS]]];
    
}

- (WKWebView *)webView {
    if (!_webView) {
        // 进行配置控制器
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        // 实例化对象
        configuration.userContentController = [WKUserContentController new];
        
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, ScreenWidth, ScreenHeight - getRectNavAndStatusHight) configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.opaque = NO;
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.UIDelegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
        if (@available(ios 11.0,*)){ _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;}
    }
    return _webView;
}

// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面开始加载时调用");
    
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"当内容开始返回时调用");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{//这里修改导航栏的标题，动态改变
    NSLog(@"页面加载完成之后调用");
    
    
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载失败时调用");
}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"接收到服务器跳转请求之后再执行");
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"在收到响应后，决定是否跳转");
    NSLog(@"%@",navigationResponse);
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

//页面跳转
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
    
    
    decisionHandler(policy);
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
