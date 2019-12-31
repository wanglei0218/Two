//
//  SSH_HCDragingView.m
//  HCAnimaTextBox
//
//  Created by Mac on 2018/7/23.
//

#import "SSH_HCDragingView.h"
#import "UIView+Layout.h"

#define kScreenW    [UIScreen mainScreen].bounds.size.width
#define kScreenH    [UIScreen mainScreen].bounds.size.height

#define kNavigaMargin   64
#define kTabBarMargin   49

@interface SSH_HCDragingView()

@property (nonatomic, strong) UIView *containerView;
/** 拖动手势 */
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
/** 悬浮按钮 */
@property (nonatomic, strong) UIButton *dragButton;
/** 消息数量角标 */
@property (nonatomic, strong) UILabel *badegLabel;
/** 悬浮按钮宽高(默认宽高相等) */
@property (nonatomic, assign) CGFloat dragWidthHeight;

@end

@implementation SSH_HCDragingView

#pragma mark - LifeCycle

- (instancetype)initWithFrame:(CGRect)frame containerView:(UIView *)view {
    
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0.0;
        self.backgroundColor = [UIColor clearColor];
        if (view) {
            _dragWidthHeight = frame.size.width;
            self.containerView = view;
            [self initSubview];
        }
    }
    return self;
}


- (void)initSubview
{
    self.dragButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dragButton.frame = self.bounds;
    [self.dragButton addTarget:self action:@selector(dragDidEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.dragButton];
    
    CGFloat w = self.frame.size.width * 0.26;
    CGFloat x = (self.frame.size.width - w) - w * 0.39;
    CGFloat y = w  - w * 0.4;
    self.badegLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, w)];
    self.badegLabel.textAlignment = NSTextAlignmentCenter;
    self.badegLabel.font = [UIFont systemFontOfSize:9];
    self.badegLabel.layer.cornerRadius = w * 0.5;
    self.badegLabel.layer.masksToBounds = YES;
    self.badegLabel.backgroundColor = [UIColor redColor];
    self.badegLabel.textColor = [UIColor whiteColor];
    self.badegLabel.hidden = YES;
    [self addSubview:self.badegLabel];
    
    // 添加手势
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDidEvent:)];
    [self.pan setMinimumNumberOfTouches:1];
    [self.pan cancelsTouchesInView];
    [self.pan delaysTouchesEnded];
    [self.pan setEnabled:YES];
    [self addGestureRecognizer:self.pan];
}


- (void)dragDidEvent:(UIButton *)button
{
    if (self.didEventBlock) {
        self.didEventBlock();
    }
}

#pragma mark - Setter && Getter

- (void)show {
    
    self.alpha = 1.0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.containerView addSubview:self];
        [self.containerView bringSubviewToFront:self];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.dragButton.alpha = 0.0;
        [self.dragButton removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)setDragImage:(NSString *)dragImage {
    
    _dragImage = dragImage;
    
    
    if ([dragImage containsString:@"http"]) {
        [self.dragButton sd_setImageWithURL:[NSURL URLWithString:dragImage] forState:UIControlStateNormal];
    }else{
        [self.dragButton setImage:[UIImage imageNamed:dragImage] forState:UIControlStateNormal];
    }
}

- (void)setBadge:(NSInteger)badge {
    
    _badge = badge;
    
    if (badge <= 0) {
        self.badegLabel.hidden = YES;
        return;
    }
    self.badegLabel.hidden = NO;
    self.badegLabel.text = [NSString stringWithFormat:@"%ld", badge];
}

#pragma mark - UIPanGestureRecognizer Handel

- (void)panGestureDidEvent:(UIPanGestureRecognizer *)pan {
    // 移动状态
    UIGestureRecognizerState state =  pan.state;
    
    switch (state) {
            //ttyydd-如果手势状态是开始，不做操作
        case UIGestureRecognizerStateBegan:
            
            break;
            //ttyydd-如果手势状态是改变，那么手势移动到哪里，控件就到哪里
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [pan translationInView:self.containerView];
            pan.view.center = CGPointMake(pan.view.center.x + translation.x, pan.view.center.y + translation.y);
        }
            break;
            //ttyydd-如果手势状态是结束，那么开始做需求操作：左右边靠边停靠，上下边不能停
        case UIGestureRecognizerStateEnded:
        {
            CGPoint translation = [pan translationInView:self.containerView];
            //ttyydd-X:0,Y:h/2
            CGPoint stopPoint = CGPointMake(0, kScreenH / 2.0);
            
            //ttyydd-如果手势的中心点X偏左
            if (pan.view.center.x < kScreenW / 2.0) {
                stopPoint = CGPointMake(_dragWidthHeight/2.0, pan.view.center.y + translation.y);
            }else{//ttyydd-如果手势的中心点X偏右
                stopPoint = CGPointMake(kScreenW - _dragWidthHeight/2.0, pan.view.center.y + translation.y);
            }
            
            if (stopPoint.x - _dragWidthHeight/2.0 <= 0) {
                stopPoint = CGPointMake(_dragWidthHeight/2.0, stopPoint.y);
            }
            
            if (stopPoint.x + _dragWidthHeight/2.0 >= kScreenW) {
                stopPoint = CGPointMake(kScreenW - _dragWidthHeight/2.0, stopPoint.y);
            }
            
            if (stopPoint.y - _dragWidthHeight/2.0 <= 0) {
                stopPoint = CGPointMake(stopPoint.x, _dragWidthHeight/2.0);
            }
            
            if (stopPoint.y + _dragWidthHeight/2.0 >= self.containerView.height) {
                stopPoint = CGPointMake(stopPoint.x, self.containerView.height - _dragWidthHeight/2.0);
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                pan.view.center = stopPoint;
            }];
        }
            break;
            
        default:
            break;
    }
    
    [pan setTranslation:CGPointMake(0, 0) inView:self];
}


@end
