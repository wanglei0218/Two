//
//  SSH_BannersModel.h
//  DENGFANGSC
//
//  Created by LY on 2018/12/17.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

//DENGFANGBannersModel
@interface SSH_BannersModel : NSObject

@property (nonatomic, strong) NSString *bannerImgUrl;
@property (nonatomic, strong) NSString *bannerColor;
@property (nonatomic, strong) NSString *bannerType;//0:H5链接  1:充值有礼  2：邀请有礼 3:悬浮按钮
@property (nonatomic, strong) NSString *linkType;//0:H5链接  1:充值有礼  2：邀请有礼
@property (nonatomic, strong) NSString *url;

@end
