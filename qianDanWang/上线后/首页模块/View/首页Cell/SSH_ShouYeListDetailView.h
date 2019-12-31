//
//  SSH_ShouYeListDetailView.h
//  DENGFANGSC
//
//  Created by 新民 on 2019/4/22.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_HomeCreditxinxiListModel.h"

NS_ASSUME_NONNULL_BEGIN
//DENGFANGShouYeListDetailView
@interface SSH_ShouYeListDetailView : UIView

@property (strong, nonatomic) SSH_HomeCreditxinxiListModel *homeCellModel;

/* 判断是否是全国专区 **/
@property(nonatomic,assign)BOOL isQuanGuo;

/* 判断是否是在详情页显示这个view **/
@property(nonatomic,assign)BOOL isDetail;

@end

NS_ASSUME_NONNULL_END
