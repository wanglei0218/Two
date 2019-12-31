//
//  SSH_HotCityListCell.h
//  DENGFANGSC
//
//  Created by huang on 2018/10/25.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SSH_LocationCityModel;


NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectedCityBlock)(NSString *selectedCity, NSInteger Id);


//DENGFANGHotCityListCell
@interface SSH_HotCityListCell : UITableViewCell

@property(nonatomic,assign)int num;

/** 城市模型 */
@property (strong, nonatomic) SSH_LocationCityModel *cityModel;
/** 城市选择block */
@property (copy, nonatomic) SelectedCityBlock selectedCityBlock;

@end

NS_ASSUME_NONNULL_END
