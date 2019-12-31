//
//  SSH_PayTypeModel.h
//  qianDanWang
//
//  Created by AN94 on 9/23/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSH_PayTypeModel : NSObject

/*
 "id": 1,
 "paymentName": "支付宝",
 "status": "1",
 "mark": null,
 "payType": "1"
 */

@property (nonatomic,strong)NSString *ID;                       ///<id
@property (nonatomic,strong)NSString *paymentName;              ///<名称
@property (nonatomic,strong)NSString *payType;                  ///<支付方式

+ (instancetype)shardeInstance;

- (NSArray *)getPayTypeWithData:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END
