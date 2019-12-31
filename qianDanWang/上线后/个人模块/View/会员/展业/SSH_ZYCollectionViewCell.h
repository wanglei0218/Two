//
//  SSH_ZYCollectionViewCell.h
//  qianDanWang
//
//  Created by AN94 on 9/16/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_ZYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSH_ZYCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightTopImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headIamge;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

- (void)setCellCortolContentWithModel:(SSH_ZYModel *)model;

@end

NS_ASSUME_NONNULL_END
