//
//  USERRootViewController.h
//  USERPRODUCT
//
//  Created by 河神 on 2019/5/29.
//  Copyright © 2019 ***. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface USERRootViewController : UIViewController

@property(strong,nonatomic)UIImageView *rootNaviBaseImg;
@property(strong,nonatomic)UIView *rootNaviBaseLine;
@property(strong,nonatomic)UILabel *rootNaviBaseTitle;
@property(nonatomic,strong)UIButton *rootGoBackBtn;
@property(nonatomic,strong)UIButton *rootRightBtn;

-(void)back:(id)sender;//返回按钮的触发方法

- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;       //修改view某侧的边框

-(void)changeTextLab:(UILabel *)myLabel stringArray:(NSArray *)strArray colorArray:(NSArray *)colorArray fontArray:(NSArray *)fontArray;// 改变指定label文本大小与颜色

- (void)myLoginAction;


@end

NS_ASSUME_NONNULL_END
