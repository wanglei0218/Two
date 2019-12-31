//
//  RechargeFristerCollectionViewCell.h
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_MemberModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RechargeFristerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *back;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

- (void)setRechargeFristerCollectionViewCellControlContentWithModel:(SSH_MemberModel *)model;

@end

NS_ASSUME_NONNULL_END
