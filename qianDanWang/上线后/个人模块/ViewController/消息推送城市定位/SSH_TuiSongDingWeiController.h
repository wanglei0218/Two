//
//  SSH_TuiSongDingWeiController.h
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/30.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSQ_BaseNormalViewController.h"
#import "SSH_LocationCityModel.h"

@protocol SSH_TuiSongDingWeiControllerDelegate <NSObject>

- (void)chooseCityString:(NSString *)selectedCity;

@end

//DENGFANGTuiSongDingWeiController
@interface SSH_TuiSongDingWeiController : SSQ_BaseNormalViewController

/** 城市model */
@property (strong, nonatomic) SSH_LocationCityModel *cityModel;

@property(nonatomic,strong) NSString *citysString;

/** 代理 */
@property(nonatomic,weak)id<SSH_TuiSongDingWeiControllerDelegate> delegate;

@end
