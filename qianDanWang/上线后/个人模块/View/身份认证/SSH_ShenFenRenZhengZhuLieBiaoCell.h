//
//  SSH_ShenFenRenZhengZhuLieBiaoCell.h
//  DENGFANGSC
//
//  Created by huang on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//DENGFANGShenFenRenZhengZhuLieBiaoCell
@interface SSH_ShenFenRenZhengZhuLieBiaoCell : UITableViewCell

@property (nonatomic,strong)UILabel * leftLabel;//左侧label
@property (nonatomic,strong)UITextField * myTextField;
@property (nonatomic,strong)UIImageView * myImageView;//认证图片
@property (nonatomic,strong)UIImageView * arrowImageView;//箭头图片
@property (nonatomic,strong)UIView * lineView;//线条view

/**
 *  block 参数为textField.text
 */
@property (copy, nonatomic) void(^block)(NSString *);

@end

NS_ASSUME_NONNULL_END
