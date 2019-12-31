//
//  SSH_MemeberSecondeCollectionViewCell.h
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_MemberModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSH_MemeberSecondeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomMoney;

- (void)setSSH_MemberSecondeControlContentWithModel:(SSH_MemberModel *)model;

@end

NS_ASSUME_NONNULL_END
