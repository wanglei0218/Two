//
//  SSH_TJDZTableViewCell.h
//  qianDanWang
//
//  Created by 畅轻 on 2019/9/20.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSH_TJDZTableViewCell : UITableViewCell

@property(nonatomic, strong) NSString *titleStr;
@property(nonatomic, strong) UICollectionView *collecView;
@property(nonatomic, assign) NSInteger number;

@end

NS_ASSUME_NONNULL_END
