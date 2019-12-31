//
//  SSH_New_QYZPTableViewCell.h
//  qianDanWang
//
//  Created by 小锦鲤 on 2019/8/21.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSH_New_QYZPTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImagView;
@property (nonatomic, strong) void(^blackDidButton)(UIButton *);

@end

NS_ASSUME_NONNULL_END
