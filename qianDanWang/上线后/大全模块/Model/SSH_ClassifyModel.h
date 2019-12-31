//
//  SSH_ClassifyModel.h
//  DENGFANGSC
//
//  Created by huang on 2018/10/30.
//  Copyright © 2018年 LY. All rights reserved.
//

//筛选model

#import <Foundation/Foundation.h>
@class SSH_ClassifyConditionModel;


NS_ASSUME_NONNULL_BEGIN
//DENGFANGClassifyModel、、
@interface SSH_ClassifyModel : NSObject



@property (nonatomic,strong) NSString * classifyName; //类型名称
@property (nonatomic, assign) long classifyID;//类型id
@property (nonatomic,strong) NSString * classifyCode; //类型编码
/** 是否单选 */
@property (assign, nonatomic, getter=isChecks) BOOL isChecks; //0-单选  1-多选
@end


//DENGFANGClassifyConditionModel
@interface SSH_ClassifyConditionModel : NSObject

@property (nonatomic,strong) NSString * conditionName; //名称
@property (nonatomic, assign) long conditionID;//id
@property (nonatomic,strong) NSString * claCode; //编码

@end






NS_ASSUME_NONNULL_END
