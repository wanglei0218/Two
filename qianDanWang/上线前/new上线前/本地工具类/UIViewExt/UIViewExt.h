/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);
CGRect CGR(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
@interface UIView (ViewFrameGeometry)
@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;
/** UIView 的中心点X值 */
@property CGFloat centerX;
@property CGFloat centerY;

@property CGFloat height;
@property CGFloat width;

/** UIView 的坐标X点 */
@property CGFloat x;
/** UIView 的坐标Y点 */
@property CGFloat y;


/** UIView的最大X值 */
@property CGFloat maxX;
/** UIView的最大Y值 */
@property CGFloat maxY;


@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;
@end