//
//  SSH_ZuiDuoCell.h
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/14.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SSH_LocationCityModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^DeleDteCityBlock)(NSString *selectedCity, NSInteger Id);

//DENGFANGZuiDuoCell
@interface SSH_ZuiDuoCell : UITableViewCell

/** 城市模型 */
@property (strong, nonatomic) SSH_LocationCityModel *cityModel;


@property (copy, nonatomic) DeleDteCityBlock delectedCityBlock;

@end

NS_ASSUME_NONNULL_END
