//
//  SSH_XZCSViewController.h
//  qianDanWang
//
//  Created by 畅轻 on 2019/9/26.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSQ_BaseNormalViewController.h"
#import "SSH_LocationCityModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SSH_LocationViewControllerDelegate <NSObject>

- (void)sl_cityListSelectedCity:(NSString *)selectedCity Id:(NSInteger)Id displayCity:(NSString *)displayCity cityArray:(NSArray *)cityArray CityArrayString:(NSString *)cityArrayString;

@end

@interface SSH_XZCSViewController : SSQ_BaseNormalViewController

/** 城市model */
@property (strong, nonatomic) SSH_LocationCityModel *cityModel;

/**  */
@property(nonatomic,strong)DENGFANGLocationCity *oneCityM;

/** 代理 */
@property (weak, nonatomic) id<SSH_LocationViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
