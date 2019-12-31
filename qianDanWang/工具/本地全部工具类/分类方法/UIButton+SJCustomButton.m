//
//  UIButton+SJCustomButton.m
//  jiaogeqian
//
//  Created by 神马的 on 2018/8/11.
//  Copyright © 2018年 zdtc. All rights reserved.
//

#import "UIButton+SJCustomButton.h"

@implementation UIButton (SJCustomButton)
+ (instancetype)customButtonWithTitle:(NSString *)title bgColor:(UIColor *)bgColor borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor radius:(CGFloat)radius {
    UIButton *customButton = [self buttonWithType:UIButtonTypeCustom];
    [customButton setTitle:title forState:UIControlStateNormal];
    [customButton setBackgroundColor:bgColor];
    customButton.layer.borderWidth = borderWidth;
    customButton.layer.borderColor = borderColor.CGColor;
    customButton.layer.cornerRadius = radius;
    return customButton;
}

- (void)setupAutoImagePadding:(CGFloat)padding {
    self.titleLabel.sd_layout
    .leftSpaceToView(self.imageView, padding)
    .centerXEqualToView(self.imageView)
    .heightIs(self.imageView.image.size.height);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:MAXFLOAT];
    [self setupAutoWidthWithRightView:self.titleLabel rightMargin:0];
}

/****************
 *
 ** 扩大按钮的触发区域
 *
 **/

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)setEnlargeEdge:(CGFloat) size
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}
- (CGRect)enlargedRect
{
    NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else {
        return self.bounds;
    }
}
// 下面的两个方法重写其中任何一个都可
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    CGRect rect = [self enlargedRect];
//    if (CGRectEqualToRect(rect, self.bounds)) {
//        return [super hitTest:point withEvent:event];
//    }
//    return CGRectContainsPoint(rect, point) ? YES : NO;
//}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}



@end
