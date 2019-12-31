//
//  SSH_ZYModel.h
//  qianDanWang
//
//  Created by AN94 on 9/20/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSH_ZYModel : NSObject

/*
 "id": 1,
 "postersName": "cs",
 "postersUrl": "sss",
 "useNum": 112,
 "isVip": "1",
 "isShow": "1",
 "sort": 1,
 "createTime": 1568950238000
 */

@property (nonatomic,strong)NSString *ID;                               ///<海报ID
@property (nonatomic,strong)NSString *postersName;                      ///<海报名称
@property (nonatomic,strong)NSString *postersUrl;                       ///<海报图片
@property (nonatomic,strong)NSString *useNum;                           ///<使用数量
@property (nonatomic,strong)NSString *isVip;                            ///<是否是vip海报
@property (nonatomic,strong)NSString *isShow;                           ///<
@property (nonatomic,strong)NSString *sort;                             ///<
@property (nonatomic,strong)NSString *createTime;                       ///<时间

+ (instancetype)shardeInstance;

- (NSArray *)getSSH_ZYModelArrWithData:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END
