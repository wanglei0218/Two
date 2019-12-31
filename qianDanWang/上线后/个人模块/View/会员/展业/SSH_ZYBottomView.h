//
//  SSH_ZYBottomView.h
//  qianDanWang
//
//  Created by AN94 on 9/17/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_ZYBottomViewCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SSH_ZYBottomViewDelegate <NSObject>

- (void)didSelecteTheCollectItemWithTarget:(NSInteger)tag;

@end

@interface SSH_ZYBottomView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)NSArray *collectionData;
@property (nonatomic,strong)UICollectionView *collect;
@property (nonatomic,strong)id <SSH_ZYBottomViewDelegate> delagte;

@end

NS_ASSUME_NONNULL_END
