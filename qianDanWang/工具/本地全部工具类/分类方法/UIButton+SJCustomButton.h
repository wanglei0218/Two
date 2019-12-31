//
//  UIButton+SJCustomButton.h
//  jiaogeqian
//
//  Created by 神马的 on 2018/8/11.
//  Copyright © 2018年 zdtc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SJCustomButton)


/**
 创建按钮的类方法

 @param title 显示标题
 @param bgColor 背景颜色
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @param radius 圆角
 @return 设置好属性的按钮
 */
+ (instancetype)customButtonWithTitle:(NSString *)title bgColor:(UIColor *)bgColor borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor radius:(CGFloat)radius;


/**
 设置按钮的图片与字体之间的间距

 @param padding 间距大小
 */
- (void)setupAutoImagePadding:(CGFloat)padding;


//扩大按钮的触发区域
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
- (void)setEnlargeEdge:(CGFloat) size;

@end
