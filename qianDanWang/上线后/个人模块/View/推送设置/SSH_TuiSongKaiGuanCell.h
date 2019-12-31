//
//  SSH_TuiSongKaiGuanCell.h
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/13.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//DENGFANGTuiSongKaiGuanCell
@interface SSH_TuiSongKaiGuanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *tongZhiSwitch;

+ (id)cellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
