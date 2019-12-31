//
//  XYBackVIew.h
//  QIngSongGou
//
//  Created by 申展铭 on 2019/5/24.
//  Copyright © 2019 FRTZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XPBackView : UIView<UIGestureRecognizerDelegate>

+ (instancetype)makeViewWithMask:(CGRect)frame andView:(UIView*)view;

+ (instancetype)makeViewWithMask:(CGRect)frame andImage:(NSString *)imageName withBtn:(NSString *)btnImage;

- (void)removeView;

-(void)block:(void(^)())block;

@end

NS_ASSUME_NONNULL_END
