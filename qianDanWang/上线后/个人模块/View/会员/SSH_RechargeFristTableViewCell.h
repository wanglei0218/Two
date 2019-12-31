//
//  SSH_RechargeFristTableViewCell.h
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeFristerCollectionViewCell.h"
#import "SSH_MemberModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SSH_RechargeFristTableViewCellDelegate <NSObject>

- (void)didSelecteTheRechargeItemWithModel:(SSH_MemberModel *)model;

@end

@interface SSH_RechargeFristTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)NSArray *collectData;
@property (nonatomic,strong)UICollectionView *rechargeFristerCollect;
@property (nonatomic,strong)NSMutableArray *indexArr;
@property (nonatomic,assign)int type;
@property (nonatomic,strong)id <SSH_RechargeFristTableViewCellDelegate>  delegate;

@end

NS_ASSUME_NONNULL_END
