//
//  SSH_GeHuGuanLiCell.h
//  DENGFANGSC
//
//  Created by 新民 on 2019/5/11.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SSH_XinKeHuGuanLiModel;
//DENGFANGGeHuGuanLiCell
@interface SSH_GeHuGuanLiCell : UITableViewCell

@property (nonatomic, strong) UIButton *phoneButton; //打电话按钮
@property(nonatomic,strong) UIButton *gengXinButton; //更新状态
@property (nonatomic,copy)void(^phoneBtnBlock)(UIButton *sender,BOOL flag);
@property(nonatomic,strong) SSH_XinKeHuGuanLiModel *model;

@end

NS_ASSUME_NONNULL_END
