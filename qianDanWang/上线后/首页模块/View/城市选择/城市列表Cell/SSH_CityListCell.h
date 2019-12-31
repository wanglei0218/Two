//
//  SSH_CityListCell.h
//  DENGFANGSC
//
//  Created by huang on 2018/10/25.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DENGFANGLocationCity;
@class SSH_LocationCityModel;
NS_ASSUME_NONNULL_BEGIN

//DENGFANGCityListCell
@interface SSH_CityListCell : UITableViewCell
/** model */
@property (strong, nonatomic) DENGFANGLocationCity *city;
@end

NS_ASSUME_NONNULL_END
