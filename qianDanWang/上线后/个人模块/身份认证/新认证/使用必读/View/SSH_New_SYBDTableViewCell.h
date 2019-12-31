//
//  SSH_New_SYBDTableViewCell.h
//  qianDanWang
//
//  Created by 小锦鲤 on 2019/8/21.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSH_New_SYBDTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (nonatomic, assign) BOOL TongYi;
@property (nonatomic, strong) void(^didSelectionButton)(UIButton *);

@end

NS_ASSUME_NONNULL_END
