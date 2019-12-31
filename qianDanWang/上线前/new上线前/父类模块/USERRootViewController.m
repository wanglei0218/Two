//
//  USERRootViewController.m
//  USERPRODUCT
//
//  Created by 河神 on 2019/5/29.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERRootViewController.h"
#import "USERLoginViewController.h"

@interface USERRootViewController ()

@end

@implementation USERRootViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = BACKGROUND_Color;
    
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //顶部导航背景
    self.rootNaviBaseImg = [[UIImageView alloc] init];
    [self.view addSubview:self.rootNaviBaseImg];
    self.rootNaviBaseImg.sd_layout
    .heightIs(getRectNavAndStatusHight)
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view);
    self.rootNaviBaseImg.userInteractionEnabled = YES;
    
    self.rootNaviBaseLine = [[UIView alloc] init];
    self.rootNaviBaseLine.backgroundColor = RGB(226, 226, 226);
    self.rootNaviBaseLine.hidden = YES;
    [self.rootNaviBaseImg addSubview:self.rootNaviBaseLine];
    self.rootNaviBaseLine.sd_layout
    .topSpaceToView(self.rootNaviBaseImg, getRectNavAndStatusHight-0.5f)
    .leftEqualToView(self.rootNaviBaseImg)
    .rightEqualToView(self.rootNaviBaseImg)
    .heightIs(0.5f);
    [self addShadowToView:self.rootNaviBaseLine withColor:RGB(226, 226, 226)];
    
    //导航返回按钮
    self.rootGoBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rootNaviBaseImg addSubview:self.rootGoBackBtn];
    self.rootGoBackBtn.sd_layout
    .leftSpaceToView(self.rootNaviBaseImg, 15)
    .topSpaceToView(self.rootNaviBaseImg, getStatusHeight+7)
    .widthIs(30).heightIs(30);
    [self.rootGoBackBtn setImage:[UIImage imageNamed:@"btnbackhui"] forState:UIControlStateNormal];
    [self.rootGoBackBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //导航主标题
    self.rootNaviBaseTitle = [[UILabel alloc] init];
    [self.rootNaviBaseImg addSubview:self.rootNaviBaseTitle];
    self.rootNaviBaseTitle.sd_layout
    .leftSpaceToView(self.rootNaviBaseImg, 60)
    .topEqualToView(self.rootGoBackBtn)
    .widthIs(ScreenWidth-120).heightIs(30);
    self.rootNaviBaseTitle.font = [UIFont systemFontOfSize:18];
    self.rootNaviBaseTitle.textColor = [UIColor whiteColor];
    self.rootNaviBaseTitle.textColor = TEXTMAINCOLOR;
    self.rootNaviBaseTitle.textAlignment = NSTextAlignmentCenter;
    
    //导航右侧按钮
    self.rootRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rootNaviBaseImg addSubview:self.rootRightBtn];
    self.rootRightBtn.sd_layout
    .rightSpaceToView(self.rootNaviBaseImg, 15)
    .topSpaceToView(self.rootNaviBaseImg, getStatusHeight+7)
    .widthIs(30).heightIs(30);
    self.rootRightBtn.hidden = YES;
    
}

// back按钮触发方法
-(void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


// 用来添加viewd某侧的边框
- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}


- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    
    theView.layer.shadowColor = theColor.CGColor;
    theView.layer.shadowOffset = CGSizeMake(0,0);
    theView.layer.shadowOpacity = 0.5;
    theView.layer.shadowRadius = 5;
    // 单边阴影 顶边
    float shadowPathWidth = theView.layer.shadowRadius;
    CGRect shadowRect = CGRectMake(0, theView.bounds.size.width+shadowPathWidth/2.0, theView.bounds.size.width, shadowPathWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    theView.layer.shadowPath = path.CGPath;
    
}

// 改变指定label文本大小与颜色
-(void)changeTextLab:(UILabel *)myLabel stringArray:(NSArray *)strArray colorArray:(NSArray *)colorArray fontArray:(NSArray *)fontArray {
    
    NSMutableAttributedString *mutAttStr = [[NSMutableAttributedString alloc] initWithString:myLabel.text];
    NSString *_str =nil;
    UIFont *_font =nil;
    NSRange _range =NSMakeRange(0,0);
    
    for (int i=0; i<strArray.count; i++) {
        _str = strArray[i];
        NSUInteger location = [[mutAttStr string] rangeOfString:_str].location;
        NSUInteger length = [[mutAttStr string] rangeOfString:_str].length;
        _range = NSMakeRange(location, length);
        // 改变颜色
        if (colorArray.count >= (i+1)) {
            [mutAttStr addAttribute:NSForegroundColorAttributeName value:colorArray[i] range:_range];
        }
        // 改变字体大小
        if (fontArray.count >= (i+1)) {
            
            _font = [UIFont systemFontOfSize:WidthScale([fontArray[i] floatValue])];
            [mutAttStr addAttribute:NSFontAttributeName value:_font range:_range];
        }
    }
    [myLabel setAttributedText:mutAttStr];
    
}


- (void)myLoginAction{
    
    USERLoginViewController *loginVC = [[USERLoginViewController alloc] init];
    UINavigationController *dengluNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:dengluNav animated:YES completion:nil];
}

@end
