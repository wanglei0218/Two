//
//  SSH_FengXianBaKongViewController.m
//  qianDanWang
//
//  Created by 小锦鲤 on 2019/6/27.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_FengXianBaKongViewController.h"


@interface SSH_FengXianBaKongViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *quanImg;
@property (weak, nonatomic) IBOutlet UIButton *quanBut;
@property (weak, nonatomic) IBOutlet UIButton *tongYiBut;

@end

@implementation SSH_FengXianBaKongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text = [NSString stringWithFormat:@"信%@经理风控管理",[DENGFANGSingletonTime shareInstance].name[1]];
    self.normalBackView.hidden = YES;
    
    self.goBackButton.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.thgjzg.cn/static/index.html"]]];
    [self.tongYiBut setEnabled:YES];
    self.tongYiBut.backgroundColor = ColorZhuTiHongSe;
    self.quanImg.image = [UIImage imageNamed:@"对"];
}

- (IBAction)quanButtonDidPress:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        [self.tongYiBut setEnabled:NO];
        self.quanImg.image = [UIImage imageNamed:@"圈"];
        self.tongYiBut.backgroundColor = COLOR_WITH_HEX(0x666666);
    } else {
        [self.tongYiBut setEnabled:YES];
        self.quanImg.image = [UIImage imageNamed:@"对"];
        self.tongYiBut.backgroundColor = ColorZhuTiHongSe;
    }
}

- (IBAction)tongYiButtonDidPress:(UIButton *)sender {
    [MobClick event:@"Opening page"];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"fx"];
    [self dismissViewControllerAnimated:YES completion:^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"taoChuQieHuan" object:nil];
    }];
}

@end
