//
//  TYDLocationViewController.h
//  TYDSC
//
//  Created by huang on 2018/10/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShangChengLocationCityModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TYDLocationViewControllerDelegate <NSObject>

- (void)sl_cityListSelectedCity:(NSString *)selectedCity Id:(NSInteger)Id;

@end

@interface ShangChengDingWeiViewController : USERRootViewController

/** 城市model */
@property (strong, nonatomic) ShangChengLocationCityModel *cityModel;

/** 代理 */
@property (weak, nonatomic) id<TYDLocationViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
