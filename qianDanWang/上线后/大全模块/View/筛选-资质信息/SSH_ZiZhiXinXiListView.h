//
//  SSH_ZiZhiXinXiListView.h
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/21.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SSH_ShaiXuanModel.h"

NS_ASSUME_NONNULL_BEGIN
//DENGFANGZiZhiXinXiListView
@interface SSH_ZiZhiXinXiListView : UIView

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIButton *inputButton;
@property(nonatomic,strong)UIImageView *qianTouImage1;


@property(nonatomic,strong)SSH_ShaiXuanModel *shaiXuanM;

@end

NS_ASSUME_NONNULL_END
