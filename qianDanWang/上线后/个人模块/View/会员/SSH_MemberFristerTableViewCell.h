//
//  SSH_MemberTableViewCell.h
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_MemeberFristerCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SSH_MemberFristerTableViewCellDelegate <NSObject>

- (void)didSelecteTheFristerCellWithTarget:(NSInteger)tag;

@end

@interface SSH_MemberFristerTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *fristCollect;
@property (nonatomic,strong)NSArray *collectData;
@property (nonatomic,strong)id <SSH_MemberFristerTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
