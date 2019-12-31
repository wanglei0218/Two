//
//  SSH_MemberSecondeTableViewCell.h
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_MemeberSecondeCollectionViewCell.h"
#import "SSH_MemberModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SSH_MemberSecondeTableViewCellDelegate <NSObject>

- (void)didSelecteTheSecondeItemWithTarget:(NSInteger)tag;

@end

@interface SSH_MemberSecondeTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UIImageView *imageV;
@property (nonatomic,strong)UICollectionView *secondeCollect;
@property (nonatomic,strong)NSArray *collectData;
@property (nonatomic,strong)id <SSH_MemberSecondeTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
