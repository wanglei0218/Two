//
//  SSH_XTXXImageCell.h
//  qianDanWang
//
//  Created by 畅轻 on 2019/9/25.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_MyMeessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSH_XTXXImageCell : UITableViewCell

@property (nonatomic, strong) SSH_MyMeessageModel *model;
@property (nonatomic, strong) void(^cellHeightReload)(void);
@property (nonatomic, assign) float imgViewHeight;
@property (strong, nonatomic) IBOutlet UIImageView *contentImg;

@end

NS_ASSUME_NONNULL_END
