//
//  DENGFENGSingletonTime.h
//  jiaogeqian
//
//  Created by 神马的 on 2018/8/24.
//  Copyright © 2018年 zdtc. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^Did)(BOOL isYes);

@interface DENGFANGSingletonTime : NSObject

@property (nonatomic,assign) BOOL isOnline;

@property (nonatomic,copy) Did did;

@property (nonatomic,copy) NSString *timestamp;

@property (nonatomic,assign) BOOL isShow; //是否显示收藏提示标签

@property (nonatomic, strong) NSString *tokenString;
@property (nonatomic, assign) int useridString;
@property (nonatomic, strong) NSString *mobileString; //手机号
@property (nonatomic, strong) NSString *headImgUrlString;//头像
@property (nonatomic, strong) NSString *realName;//真实姓名
@property (nonatomic, strong) NSString *idCard;//身份证号
@property (nonatomic, strong) NSString *enterpriseName;//单位名称
@property (nonatomic, strong) NSString *enterpriseAddress;//单位地址
@property (nonatomic, strong) NSString *idCardFaceUrl;//身份证正面照地址
@property (nonatomic, strong) NSString *idCardBackUrl;//身份证背面照地址
@property (nonatomic, strong) NSString *renTiShiBieUrl;////人体检测照片地址
@property (nonatomic, strong) NSString *idCardPhotoUrl;//身份证合照
@property (nonatomic, strong) NSString *workCardUrl;//工牌照
@property (nonatomic, strong) NSString *businessCardUrl;//名片地址


@property (nonatomic, assign) int wxRetCode;//微信支付返回的结果：0：成功，-1：错误，-2：取消
@property (nonatomic, assign) int aliResultStatus;//支付宝返回的结果：9000:成功，其它：失败
@property (nonatomic, strong) NSString *aliFailMessage;//支付宝返回的失败结果描述

@property (nonatomic, strong) NSString *systemImgUrl;//公众号二维码
@property (nonatomic, strong) NSString *systemName;//公众号名称


@property (nonatomic, assign) BOOL isIndividualClickSetPwd;//是否是从个人中心跳转到的设置密码页

@property (nonatomic, strong) NSString *mapCity;//当前选择的城市

@property (nonatomic, assign) BOOL isTongguoIDRenZheng;//通过身份认证 0:未通过 1:通过

@property (nonatomic, strong) NSArray *name;//名称

@property(nonatomic,strong) NSString *dingWeiCity;

@property(nonatomic,strong)NSArray *lianJieArr;

@property(nonatomic,strong)NSString *fenXiaoLianJie;

@property(nonatomic,strong)NSString *weChatIDStr;

@property(nonatomic,strong)NSString *weChatSecret;

@property(nonatomic,strong)NSString *moJieIDStr;

@property(nonatomic,strong)NSString *UMengKeyStr;

@property(nonatomic,strong)NSString *JPushKeyStr;



+ (instancetype)shareInstance;


@end
