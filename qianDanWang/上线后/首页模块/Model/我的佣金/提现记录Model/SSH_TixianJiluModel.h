//
//  SSH_TixianJiluModel.h
//  DENGFANGSC
//
//  Created by LY on 2019/1/24.
//  Copyright © 2019年 DENGFANG. All rights reserved.
//

#import <Foundation/Foundation.h>

//DENGFANGTixianJiluModel
@interface SSH_TixianJiluModel : NSObject

@property (nonatomic, strong) NSString *grantStatus;//0待发放、1已发放、2不予发放
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *withdrawCash;//提现金额
@property (nonatomic, strong) NSString *bankNumber;

@end
