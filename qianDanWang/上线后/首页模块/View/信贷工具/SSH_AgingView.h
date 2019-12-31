//
//  SSH_ AgingView.h
//  qianDanWang
//
//  Created by AN94 on 9/25/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_AgingTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SSH_AgingViewDelegate <NSObject>

- (void)didSelecteTheBottomRightBtn;

- (void)didSelecteTheTableRowWithTitle:(NSString *)title;

@end

@interface SSH_AgingView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UILabel *topLabel;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)UITableView *agingTable;
@property (nonatomic,strong)NSArray *agingData;
@property (nonatomic,strong)id <SSH_AgingViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
