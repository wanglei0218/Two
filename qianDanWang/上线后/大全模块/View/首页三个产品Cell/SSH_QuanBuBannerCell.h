//
//  SSH_QuanBuBannerCell.h
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/18.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DCCycleScrollView.h"//轮播图
#import "SSH_BannersModel.h"

NS_ASSUME_NONNULL_BEGIN
//DENGFANGQuanBuBannerCell
@interface SSH_QuanBuBannerCell : UITableViewCell


+ (id)cellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;

@property(nonatomic,strong)UIButton *closeButton;

@property (nonatomic, strong) DCCycleScrollView *cycleScrollView;//轮播图

@property(nonatomic,strong)NSArray *dataArray;

@property(nonatomic,strong)void(^closeBlock)(void);

@end

NS_ASSUME_NONNULL_END
