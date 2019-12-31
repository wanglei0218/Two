//
//  DENGFANGLocationViewController.h
//  DENGFANGSC
//
//  Created by huang on 2018/10/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_LocationCityModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SSH_LocationViewControllerDelegate <NSObject>

- (void)sl_cityListSelectedCity:(NSString *)selectedCity Id:(NSInteger)Id displayCity:(NSString *)displayCity cityArray:(NSArray *)cityArray CityArrayString:(NSString *)cityArrayString;

//-(void)sl_cityListSelectedCityInformationDict:(NSDictionary *)dict;

@end

//DENGFANGDingWeiViewController
@interface SSH_DingWeiViewController : SSQ_BaseNormalViewController

/** 城市model */
@property (strong, nonatomic) SSH_LocationCityModel *cityModel;

/**  */
@property(nonatomic,strong)DENGFANGLocationCity *oneCityM;

/** 代理 */
@property (weak, nonatomic) id<SSH_LocationViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
