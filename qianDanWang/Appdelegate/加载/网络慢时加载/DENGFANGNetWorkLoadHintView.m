//
//  NetWorkLoadHintView.m
//  FinancialInvest
//
//  Created by 幸运儿╮(￣▽￣)╭ on 2019/1/21.
//  Copyright © 2019 幸运儿╮(￣▽￣)╭. All rights reserved.
//

#import "DENGFANGNetWorkLoadHintView.h"
#import <UIImage+GIF.h>

#define LoadViewRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

static CGFloat imageWidth = 184.5;
@interface DENGFANGNetWorkLoadHintView()


/** 动图的View */
@property (nonatomic,strong) UIView *gifView;
/** 描述语 */
@property (nonatomic,strong) UILabel *infoLabel;

/** 动图加载框 */
@property (nonatomic,strong) UIImageView *loadImageView;

/** 普通启动页 */
@property (nonatomic,strong) UIImageView *startImageView;


@end


@implementation DENGFANGNetWorkLoadHintView

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _infoLabel.textColor = LoadViewRGB(169, 176, 192);
        _infoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _infoLabel;
}


- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    
    self.backgroundColor = [UIColor whiteColor];
    //启动页
    self.startImageView = [[UIImageView alloc] initWithFrame:screenFrame];
    self.startImageView.image = [UIImage imageNamed:@"LaunchImage"];
    if (IS_IPHONE5) {
        self.startImageView.image = [UIImage imageNamed:@"launch_5"];
    } else if (IS_IPHONE6) {
        self.startImageView.image = [UIImage imageNamed:@"launch_6"];
    } else if (IS_IPHONE6PLUS) {
        self.startImageView.image = [UIImage imageNamed:@"launch_6Plus"];
    } else if (IS_IPHONEX) {
        self.startImageView.image = [UIImage imageNamed:@"launch_X"];
    }  else if (IS_IPHONEMAX) {
        self.startImageView.image = [UIImage imageNamed:@"launch_XMAX"];
    } else if (IS_IPHONE_Xr){
        self.startImageView.image = [UIImage imageNamed:@"launch_XR"];
    }
    [self addSubview:self.startImageView];
    
    //动图view
    self.gifView = [[UIView alloc] initWithFrame:CGRectMake(0, 124, screenFrame.size.width, screenFrame.size.width)];
    //动图imageView
    CGFloat loadImageViewX = (screenFrame.size.width - imageWidth)/2;
    self.loadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(loadImageViewX, 0, imageWidth, imageWidth)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"网络较差提示" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_imageWithGIFData:data];
    self.loadImageView.image = image;
    [self.gifView addSubview:self.loadImageView];
    
    //提示语
    self.infoLabel.text = @"网络开小差了努力加载中";
    self.infoLabel.frame = CGRectMake(20, imageWidth+10, screenFrame.size.width-40, 30);
    [self.gifView addSubview:self.infoLabel];
    
    [self addSubview:self.gifView];
    
    self.gifView.alpha = 0;
}

- (void)setNetWorkStatue:(NetWorkStatues)netWorkStatue {
    if (netWorkStatue == NetWorkStatuesBad) {
        [UIView animateWithDuration:0.2 animations:^{
            self.startImageView.hidden = YES;
            self.gifView.alpha = 1;
        }];
    }else if (netWorkStatue == NetWorkStatuesFine) {
        self.gifView.alpha = 0;
        self.startImageView.hidden = NO;
    }
}

- (void)netWorkViewRemoveFromSuperView {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (instancetype)netWorkLoadHintViewInitWithFrame:(CGRect)viewFrame {
    DENGFANGNetWorkLoadHintView *netWorkView = [[DENGFANGNetWorkLoadHintView alloc] init];
    netWorkView.frame = viewFrame;
    return netWorkView;
}

@end
