//
//  SSH_RechargeSecondeTableViewCell.h
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSH_RechargeSecondeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (nonatomic, strong)void(^selectionButton)(UIButton *);

@end

NS_ASSUME_NONNULL_END
