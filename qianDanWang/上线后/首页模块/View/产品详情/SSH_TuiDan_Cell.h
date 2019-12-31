//
//  SSH_TuiDan_Cell.h
//  qianDanWang
//
//  Created by 畅轻 on 2019/12/18.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSH_TuiDan_Cell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *detailLab;
@property (strong, nonatomic) void(^didSelectedBut)(UIButton *);

@end

NS_ASSUME_NONNULL_END
