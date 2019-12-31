//
//  SSH_GeRenXinXiModel.h
//  DENGFANGSC
//
//  Created by huang on 2018/11/2.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//DENGFANGGeRenXinXiModel
@interface SSH_GeRenXinXiModel : NSObject

@property (nonatomic,strong)NSString * coinNum;//金币
@property (nonatomic, strong) NSString *uCoinNum;//优币数
@property (nonatomic,strong)NSString * photoUrl;//头像地址
@property (nonatomic,strong)NSString * isAuth;//认证状态  （0：未认证  1：已认证   2:认证中   3:认证失败）
@property(nonatomic,strong)NSString *isFaceCheck; ////是否人脸检测（0：未检测  1：已检测）
@property (nonatomic,strong)NSString * userId;//用户id
@property (nonatomic,strong)NSString * isPush;//推送状态 1：推送  0：不推送
@property (nonatomic,strong)NSString * isVip;//vip状态 1：是  0：不是
@property (nonatomic,strong)NSString * markUrl;//vip等级

@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *idCard;
@property (nonatomic, strong) NSString *enterpriseName;
@property (nonatomic, strong) NSString *enterpriseAddress;
@property (nonatomic, strong) NSString *idCardFaceUrl;
@property (nonatomic, strong) NSString *idCardBackUrl;
@property (nonatomic, strong) NSString *idCardPhotoUrl;
@property (nonatomic, strong) NSString *workCardUrl;
@property (nonatomic, strong) NSString *businessCardUrl;

@property (nonatomic,assign) BOOL isFinish;

@end

NS_ASSUME_NONNULL_END
