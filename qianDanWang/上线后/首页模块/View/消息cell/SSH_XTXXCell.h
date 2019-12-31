//
//  SSH_XTXXCell.h
//  qianDanWang
//
//  Created by 畅轻 on 2019/9/24.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_MyMeessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSH_XTXXCell : UITableViewCell

@property (nonatomic, strong) SSH_MyMeessageModel *model;
@property (nonatomic, strong) void(^cellHeightReload)(void);

@end

NS_ASSUME_NONNULL_END
