//
//  TYDHomeLocationHotCityCell.h
//  TYDSC
//
//  Created by huang on 2018/10/25.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShangChengLocationCityModel;


NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectedCityBlock)(NSString *selectedCity, NSInteger Id);


@interface ShangChengHotCityListCell : UITableViewCell


/** 城市模型 */
@property (strong, nonatomic) ShangChengLocationCityModel *cityModel;
/** 城市选择block */
@property (copy, nonatomic) SelectedCityBlock selectedCityBlock;

@end

NS_ASSUME_NONNULL_END
