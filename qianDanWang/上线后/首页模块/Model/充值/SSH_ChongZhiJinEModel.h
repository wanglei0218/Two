//
//  SSH_ChongZhiJinEModel.h
//  DENGFANGSC
//
//  Created by LY on 2018/11/8.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

//DENGFANGChongZhiJinEModel
@interface SSH_ChongZhiJinEModel : NSObject

@property (nonatomic, strong) NSString *rechargeId;//金额ID
@property (nonatomic, strong) NSString *coin;//金币
@property (nonatomic, strong) NSString *relMoney;//售价
@property (nonatomic, strong) NSString *discount;//送金币
@property (nonatomic, strong) NSString *labelExplain;//黄色标签：（送10优币等等）

@end
