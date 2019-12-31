//
//  XYBackVIew.m
//  QIngSongGou
//
//  Created by 申展铭 on 2019/5/24.
//  Copyright © 2019 FRTZ. All rights reserved.
//

#import "XPBackView.h"

@implementation XPBackView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
        }
    return self;
}

//蒙层添加到Window上

+ (instancetype)makeViewWithMask:(CGRect)frame andView:(UIView *)view{
    XPBackView *mview = [[self alloc]initWithFrame:frame];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:mview];
    [mview addSubview:view];
    return mview;
}

+ (instancetype)makeViewWithMask:(CGRect)frame andImage:(NSString *)imageName withBtn:(NSString *)btnImage{
    XPBackView *mview = [[self alloc]initWithFrame:frame];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:mview];
    CGSize size = [UIImage imageNamed:imageName].size;

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((mview.width - size.width) / 2, (mview.height - size.height) / 2, size.width, size.height)];
    imageView.image = [UIImage imageNamed:imageName];
    [mview addSubview:imageView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((mview.width - WidthScale(35)) / 2, CGRectGetMaxY(imageView.frame) + WidthScale(26) , WidthScale(35), WidthScale(35))];
    [btn setImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
    [btn addTarget:mview action:@selector(didSelecteTheBackViewBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [mview addSubview:btn];
    
    return mview;
}


- (void)removeView{
    [self removeFromSuperview];
}

- (void)didSelecteTheBackViewBackBtn{
    [self removeFromSuperview];
}

-(void)block:(void(^)())block{
    [self removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // self.contentView为子控件
    if ([touch.view isDescendantOfView:self.subviews[0]]) {
        return NO;
    }
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
