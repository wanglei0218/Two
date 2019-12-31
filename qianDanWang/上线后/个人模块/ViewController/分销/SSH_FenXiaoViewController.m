//
//  SSH_FenXiaoViewController.m
//  SecondCarTao
//
//  Created by 新民 on 2019/5/28.
//  Copyright © 2019 幸运儿╮(￣▽￣)╭. All rights reserved.
//

#import "SSH_FenXiaoViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "SSH_ShareView.h"
#import <WebKit/WebKit.h>

@interface SSH_FenXiaoViewController ()<UIWebViewDelegate,SSH_ShareViewViewDelegate,UIGestureRecognizerDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) WKWebView *wkWebView;
@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic, strong) MBProgressHUD *zhuanquan;

@property(nonatomic,strong)SSH_ShareView *shareAlertView;

@property(nonatomic,strong)NSString *shareUrl;

@property(nonatomic,assign)NSInteger flag;

@property(nonatomic,strong)NSString *goodsImg;
@property(nonatomic,strong)NSString *sideTitle;
@property(nonatomic,strong)NSString *shareTitle;
@property(nonatomic,strong)NSURLRequest *request;

@property (nonatomic,strong) WKUserContentController *userContentController;
@property (nonatomic,strong) WKWebViewConfiguration *config;

@end

@implementation SSH_FenXiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.titleLabelNavi.text = @"xxx";
    self.normalBackView.backgroundColor = [UIColor whiteColor];
    
    [self setupWebView];
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBackLastUrl)];
    swip.delegate = self;
    [self.webView addGestureRecognizer:swip];
    [self.view addSubview:self.webView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    // 禁止使用系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 恢复使用系统自带的滑动手势
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)backBtnClicked {
    [self goBackLastUrl];
}

- (void)goBackLastUrl {
    if (self.otherUrl.length != 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.webView goBack];
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)setupWebView {
    self.webView = [[UIWebView alloc] init];
    self.webView.scrollView.bounces=NO;
    self.webView.delegate  = self;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        NSString *version= [UIDevice currentDevice].systemVersion;
        if(version.doubleValue >=11.0) {
            // 针对 9.0 以上的iOS系统进行处理
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }else{
            // 针对 9.0 以下的iOS系统进行处理
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }
    }];
    
    self.zhuanquan = [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
    self.zhuanquan.label.text = NSLocalizedString(@"", @"HUD loading title");

    //NSString *url = [NSString stringWithFormat:@"%@/#/home",[DENGFANGRequest shareInstance].httpHeadString];
    NSString *url = [DENGFANGSingletonTime shareInstance].fenXiaoLianJie;
    if (self.otherUrl.length != 0) {
//        url = [NSString stringWithFormat:@"http://192.168.0.129:8084/%@",self.otherUrl];
        url = [NSString stringWithFormat:@"%@%@",[DENGFANGSingletonTime shareInstance].fenXiaoLianJie,self.otherUrl];
    }
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
    self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [self.webView loadRequest:self.request];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.zhuanquan hideAnimated:YES];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.zhuanquan hideAnimated:YES];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGTokenKey];
    NSString *mobile = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGPhoneKey];
    NSString *name = [[NSUserDefaults standardUserDefaults] valueForKeyPath:DENGFANGRealNameKey];
    NSString *userid = [[NSUserDefaults standardUserDefaults] valueForKeyPath:DENGFANGUserIDKey];
    
    NSDictionary *userdata = [[NSUserDefaults standardUserDefaults] valueForKeyPath:DENGFANGLoginDataKey];
    
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    JSValue *passtoJs = self.jsContext[@"setstate"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = token;
    dict[@"mobile"] = mobile;
    dict[@"id"] = userid;
    dict[@"name"] = name;
    dict[@"userdata"] = userdata;
    
    NSString *dataString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    
    [passtoJs callWithArguments:@[dataString]];
    
    __weak typeof(self) weakSelf = self;
    //保存海报
    self.jsContext[@"savepostimg"] = ^(id data){
        NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic[@"postimg"]);
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL  URLWithString:dic[@"postimg"]]];
        UIImage *image = [UIImage imageWithData:imageData]; // 取得图片
    
        if (image == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [SSH_TOOL_GongJuLei showAlter:weakSelf.view WithMessage:@"图片正在下载..."];
            });
            return;
        }
        
        UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    };
    //分享海报
    self.jsContext[@"sharepostimg"] = ^(id data){
        NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic[@"postimg"]);
        weakSelf.flag = 0;
        weakSelf.goodsImg = dic[@"postimg"];
        //弹出分享
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.shareAlertView = [[SSH_ShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [weakSelf.shareAlertView showShareAlertView];
            weakSelf.shareAlertView.delegate = weakSelf;
            [weakSelf.zhuanquan hideAnimated:YES];
        });
        
    };
    //复制链接
    self.jsContext[@"copyurl"] = ^(id data){
        NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic[@"copyurl"]);
        
        UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = dic[@"copyurl"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SSH_TOOL_GongJuLei showAlter:weakSelf.view WithMessage:@"复制成功"];
        });
    };
    //分享链接
    self.jsContext[@"shareurl"] = ^(id data){
        NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@",dic);
        
        weakSelf.flag = 1;
        weakSelf.shareUrl = dic[@"shareurl"];
        weakSelf.goodsImg = dic[@"goodsImg"];
        weakSelf.sideTitle = dic[@"sideTitle"];
        weakSelf.shareTitle = dic[@"title"];
        //弹出分享
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.shareAlertView = [[SSH_ShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            [weakSelf.shareAlertView showShareAlertView];
            weakSelf.shareAlertView.delegate = weakSelf;
        });
        
    };
    
    //返回首页
    self.jsContext[@"backtoapp"] = ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    
    };
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"%@",[request.URL absoluteString]);
    if([[request.URL absoluteString] containsString:[DENGFANGSingletonTime shareInstance].fenXiaoLianJie]) {
        
        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
            NSString *version= [UIDevice currentDevice].systemVersion;
            if(version.doubleValue >=11.0) {
                // 针对 9.0 以上的iOS系统进行处理
                make.top.mas_equalTo(getStatusHeight);
            }else{
                // 针对 9.0 以下的iOS系统进行处理
                make.top.mas_equalTo(getStatusHeight);
            }
        }];
        
    } else {
        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
            NSString *version= [UIDevice currentDevice].systemVersion;
            if(version.doubleValue >=11.0) {
                // 针对 9.0 以上的iOS系统进行处理
                make.top.mas_equalTo(44 + getStatusHeight);
            }else{
                // 针对 9.0 以下的iOS系统进行处理
                make.top.mas_equalTo(44 + getStatusHeight);
            }
        }];
    }

    return YES;
}


-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"保存失败"];
        
    }else{
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"保存成功"];
    }
}


#pragma mark -分享内部的按钮点击代理
- (void)clickShareButtonAction:(int)index{
    
    SSDKPlatformType type;
    if (index == 0) {
        type = SSDKPlatformSubTypeWechatSession;
        
        if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
            [SSH_TOOL_GongJuLei showAlter:window WithMessage:@"您未安装微信"];
            return;
        }
    }else  if (index == 1) {
        if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
            [SSH_TOOL_GongJuLei showAlter:window WithMessage:@"您未安装微信"];
            return;
        }
        type = SSDKPlatformSubTypeWechatTimeline;
    }else{
        return;
    }
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString                  stringWithFormat:@"%@",self.goodsImg]]];
    
    UIImage *img = [UIImage imageWithData:data];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    [imageArray addObject:img==nil?@"":img];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.flag == 0) {
        [params SSDKSetupShareParamsByText:nil images:imageArray url:nil title:nil type:SSDKContentTypeAuto];
        
    }else if (self.flag == 1){
        [params SSDKSetupShareParamsByText:self.sideTitle images:imageArray url:[NSURL URLWithString:self.shareUrl] title:self.shareTitle type:SSDKContentTypeAuto];
    }
    
    [ShareSDK share:type parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {
            case SSDKResponseStateUpload:
                // 分享视频的时候上传回调，进度信息在 userData
                break;
            case SSDKResponseStateSuccess:
                //成功
                break;
            case SSDKResponseStateFail:
            {
                NSLog(@"--%@",error.description);
                //失败
                break;
            }
            case SSDKResponseStateCancel:
                //取消
                break;
                
            default:
                break;
        }
    }];
}


@end
