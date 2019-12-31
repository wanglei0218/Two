//
//  TYDHomeLocationListCell.h
//  TYDSC
//
//  Created by huang on 2018/10/25.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYDLocationCity;
@class ShangChengLocationCityModel;
NS_ASSUME_NONNULL_BEGIN

@interface ShangChengCityListCell : UITableViewCell
/** model */
@property (strong, nonatomic) TYDLocationCity *city;
@end

NS_ASSUME_NONNULL_END
