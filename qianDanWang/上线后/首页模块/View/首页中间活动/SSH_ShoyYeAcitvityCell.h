//
//  SSH_ShoyYeAcitvityCell.h
//  DENGFANGSC
//
//  Created by huang on 2018/10/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//DENGFANGShoyYeAcitvityCell
@interface SSH_ShoyYeAcitvityCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;//背景view

@property (nonatomic,strong) UIImageView * firstImgView;//第一张图
@property (nonatomic,strong) UIImageView * secondImgView;//第二张图
@property (nonatomic,strong) UIImageView * thirdImgView;//第三张图

@property (nonatomic,strong) UIButton * firstButton;//第一个按钮
@property (nonatomic,strong) UIButton * secondButton;//第二个按钮
@property (nonatomic,strong) UIButton * thirdButton;//第三个按钮

@property (nonatomic, assign) NSInteger activeCount;//活动的个数

@property (nonatomic,copy) NSArray *middleImageArr;

@end

NS_ASSUME_NONNULL_END
