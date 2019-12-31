//
//  SSH_GeRenZhongXinListCell.h
//  DENGFANGSC
//
//  Created by LY on 2018/10/17.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
//DENGFANGGeRenZhongXinListCell
@interface SSH_GeRenZhongXinListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftImgView;//左侧icon
@property (nonatomic, strong) UILabel *cellTitle;//cell的标题
@property(nonatomic,strong) UIImageView *hotImage;
@property (nonatomic, strong) UILabel *rightJinBiLabel;//右边金币个数
@property (nonatomic, strong) UIImageView *rightYiShiMing;//右边已实名图片

@end
