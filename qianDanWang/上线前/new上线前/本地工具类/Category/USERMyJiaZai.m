

#import "USERMyJiaZai.h"

@interface USERMyJiaZai()

@property (strong, nonatomic) CALayer * layer1;

@property (strong, nonatomic) CALayer * leftLayer;

@property (strong, nonatomic) CALayer * rightLayer;


@end


@implementation USERMyJiaZai


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

-(void)creatUI
{
    _layer1 = [CALayer layer];
    
    [self _configureLayer:_layer1 WithPosition:self.center];
    
    _leftLayer = [CALayer layer];
    
    [self _configureLayer:_leftLayer WithPosition:CGPointMake(self.center.x - 22.f, self.center.y)];
    
    _rightLayer = [CALayer layer];
    
    [self _configureLayer:_rightLayer WithPosition:CGPointMake(self.center.x + 22.f, self.center.y)];
    
    [self _addFirstAnimation];
    
    [NSTimer scheduledTimerWithTimeInterval:1.3f target:self selector:@selector(_addFirstAnimation) userInfo:nil repeats:YES];
    
}

/**配置子layer层*/
- (void)_configureLayer:(CALayer *)layer WithPosition:(CGPoint)position
{
    layer.bounds = CGRectMake(0, 0, 22.f, 22.f);
    
    layer.position = position;
    
    layer.backgroundColor = COLOR_With_Hex(0xe0c284).CGColor;
    
    layer.cornerRadius = 11.f;
    
    layer.masksToBounds = YES;
    
    [self.layer addSublayer:layer];
}

/**添加第一组动画*/
- (void)_addFirstAnimation
{
    [self _addAnimationGroupToLayer:_layer1 WithBasicValue:@0 WithDuration:0.5f WithScaleValue:@.75f];
    
    [self _addAnimationGroupToLayer:_leftLayer WithBasicValue:@-22 WithDuration:0.5f WithScaleValue:@.75f];
    
    [self _addAnimationGroupToLayer:_rightLayer WithBasicValue:@22 WithDuration:0.5f WithScaleValue:@.75f];
    
    [self performSelector:@selector(_addSecondAnimation) withObject:nil afterDelay:.5f];
}

/**添加第二组动画和第三组动画*/
- (void)_addSecondAnimation
{
    [self _addAnimationGroupToLayer:_layer1 WithBasicValue:@0 WithDuration:0.1f WithScaleValue:@1.f];
    
    [self _addAnimationGroupToLayer:_leftLayer WithBasicValue:@0 WithDuration:0.1f WithScaleValue:@1.f];
    
    [self _addAnimationGroupToLayer:_rightLayer WithBasicValue:@0 WithDuration:0.1f WithScaleValue:@1.f];
    
    //添加第三组动画
    [self _addThirdAnimationToLayer:_leftLayer WithPath:[UIBezierPath bezierPathWithArcCenter:self.center radius:22.f startAngle:M_PI endAngle:M_PI - 2 * M_PI clockwise:NO]];
    
    [self _addThirdAnimationToLayer:_rightLayer WithPath:[UIBezierPath bezierPathWithArcCenter:self.center radius:22.f startAngle:0 endAngle:0 - 2 * M_PI clockwise:NO]];
}

/**配置好第三组动画后添加给对应的layer层*/
- (void)_addThirdAnimationToLayer:(CALayer *)layer WithPath:(UIBezierPath *)path
{
    CAKeyframeAnimation * keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    keyFrame.path = path.CGPath;
    
    keyFrame.duration = 0.75f;
    
    [layer addAnimation:keyFrame forKey:nil];
}

/**配置好第一组或第二组组动画后添加给对应的layer层*/
- (void)_addAnimationGroupToLayer:(CALayer *)layer WithBasicValue:(NSNumber *)basicValue WithDuration:(CGFloat)duration WithScaleValue:(NSNumber *)scaleValue
{
    CABasicAnimation * scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    scale.toValue = scaleValue;
    
    CABasicAnimation * basic = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    
    basic.toValue = basicValue;
    
    CAAnimationGroup * group = [CAAnimationGroup animation];
    
    group.duration = duration;
    
    group.removedOnCompletion = NO;
    
    group.fillMode = kCAFillModeForwards;
    
    group.animations = @[basic,scale];
    
    [layer addAnimation:group forKey:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
