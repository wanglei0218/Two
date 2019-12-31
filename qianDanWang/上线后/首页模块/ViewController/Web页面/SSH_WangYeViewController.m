//
//  JGSecondProductWebViewController.m
//  jiaogeqian
//
//  Created by 神马的 on 2018/8/25.
//  Copyright © 2018年 zdtc. All rights reserved.
//

#import "SSH_WangYeViewController.h"


@interface SSH_WangYeViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic, strong) MBProgressHUD *zhuanquan;

@property (strong,nonatomic) UIButton * colseButton;//关闭按钮

@end

@implementation SSH_WangYeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.goBackButton addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabelNavi.text = self.titleString;
    self.lineView.hidden = NO;
    
    [self createCloseBtn];
    [self setupWebView];
    
}
-(void)createCloseBtn{
    self.colseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.colseButton setImage:[[UIImage imageNamed:@"wangyeguanbi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.colseButton addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:self.colseButton];
    [self.colseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goBackButton.mas_right);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(17);
    }];
}
//关闭按钮点击事件
-(void)closeBtnClicked{
//    [self.colseButton removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)backBtnClicked{
    if ([self.webView canGoBack]) {
        [self.webView goBack];

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setupWebView {
    self.webView = [[UIWebView alloc] init];
    self.webView.scrollView.bounces=NO;
    self.webView.delegate  = self;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.normalBackView addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.webUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    [self.webView loadRequest:request];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [self.zhuanquan hideAnimated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
