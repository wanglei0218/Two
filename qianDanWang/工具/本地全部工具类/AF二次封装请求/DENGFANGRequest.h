//
//  DENGFANGRequest.h
//  reViewApp
//
//  Created by  梁媛 on 2017/6/5.
//  Copyright © 2017年 chaoqianyan. All rights reserved.
//
//
//

#import <Foundation/Foundation.h>

//extern NSString *httpHeadString;

@interface DENGFANGRequest : NSObject

@property (nonatomic,copy) NSString *httpHeadString;


+ (instancetype)shareInstance;

- (void)getWithUrlString:(NSString *)UrlString
              parameters:(id)parameters
                 success:(void (^)(id responseObject))success
                    fail:(void (^)(NSError *error))fail;

- (void)postWithUrlString:(NSString *)UrlString
               parameters:(id)parameters
                  success:(void (^)(id responsObject))success
                     fail:(void (^)(NSError *error))fail;

- (void)postWithUrl:(NSString *)url
         parameters:(id)parameters
            success:(void (^)(id responsObject))success
               fail:(void (^)(NSError *error))fail;

//上传单张
+ (void)uploadImageWithURLString:(NSString *)URLString
                      parameters:(id)parameters
                     uploadDatas:(NSData *)uploadData
                        progress:(void (^)(float progress))progress
                         success:(void (^)(id reponse))success
                         failure:(void (^)(NSError *failure))failure;


//上传多张图片
+ (void)uploadImagesWithURLString:(NSString *)URLString
                       parameters:(id)parameters
                   uploadDataArrs:(NSMutableArray *)dataArr
                         progress:(void (^)(float progress))progress
                          success:(void (^)(id reponse))success
                          failure:(void (^)(NSError *failure))failure;


- (void)postJsonWithparameters:(id)parameters success:(void (^)(id responsObject))success fail:(void (^)(NSError *error))fail;

#pragma mark- 登录注册
//图形验证码
@property (nonatomic, strong) NSString *DENGFANGPicCodeURL;
//获取短信验证码
@property (nonatomic, strong) NSString *DENGFANGGetVertifyCodeURL;
//登录
@property (nonatomic, strong) NSString *DENGFANGLoginURL;
//设置密码
@property (nonatomic, strong) NSString *DENGFANGSetPasswordURL;
#pragma mark 首页
//首页 修改用户登录地址  /user/updateUserArea
@property (nonatomic,strong) NSString *DENGFANGUpdateUserAreaURL;
//首页 banner  含 中部的图
@property (nonatomic,strong) NSString *DENGFANGBannerListURL;
//首页 系统公告
@property (nonatomic,strong) NSString *DENGFANGNoticeListURL;
//首页 资源列表
@property (nonatomic,strong) NSString *DENGFANGCreditinfoListURL;
//首页 类型  （同筛选条件列表）/base/queryClassify
@property (nonatomic,strong) NSString *DENGFANGClassifyURL;
//首页 资源详情界面 /creditinfo/getCreditinfoById
@property (nonatomic,strong) NSString *DENGFANGCreditinfoByIdURL;

//添加收藏  /collection/addMyCollection
@property (nonatomic,strong) NSString *DENGFANGAddMyCollectionURL;
#pragma mark 客户管理
//客户管理 - 收藏列表  /collection/queryMyCollectionList
@property (nonatomic,strong) NSString *DENGFANGMyCollectionListURL;
//客户管理 - 订单列表  /order/queryMyOrderList
@property (nonatomic,strong) NSString *DENGFANGMyOrderListURL;
//客户管理 - 订单列表详情页  /order/getOrderInfoById
@property (nonatomic,strong) NSString *DENGFANGOrderInfoByIdURL;

//抢单
@property (nonatomic, strong) NSString *DENGFANGQiangDanURL;
//获取支付详情
@property (nonatomic, strong) NSString *DENGFANGPayDetailURL;
//确认支付-金币
@property (nonatomic, strong) NSString *DENGFANGSurePayJinBiURL;
//查询支付方式列表&充值金额&优惠金额
@property (nonatomic, strong) NSString *DENGFANGPaymentMethodListURL;

//生成支付订单-支付宝支付
@property (nonatomic, strong) NSString *DENGFANGInsertPayRecordURL;
//获取支付宝签名
@property (nonatomic, strong) NSString *DENGFANGGetAliPayValidCodeURL;

//更新支付宝同步支付结果
@property (nonatomic, strong) NSString *DENGFANGUpdateAliPayResult;

//微信发起预支付接口
@property (nonatomic, strong) NSString *DENGFANGWeiXinPayURL;
//微信同步支付结果通知
@property (nonatomic, strong) NSString *DENGFANGWeiXinPayStatusUpdateURL;




#pragma mark 设置
//修改用户信息  /user/updateEuser
@property (nonatomic, strong) NSString *DENGFANGUpdateEuserURL;
//获取用户信息/user/getUserInfo
@property (nonatomic, strong) NSString *DENGFANGUserInfoURL;
//用户认证  /auth/insertAuthRecord
@property (nonatomic, strong) NSString *DENGFANGInsertAuthRecordURL;
//用户认证失败  /auth/getDENGFANGAuthMark
@property (nonatomic, strong) NSString *DENGFANGAuthMarkURL;

//获取微信公众号
@property (nonatomic, strong) NSString *DENGFANGGetWechatImgURL;

//交易记录列表
@property (nonatomic, strong) NSString *DENGFANGJiaoYiJiLuURL;
//意见反馈
@property (nonatomic, strong) NSString *DENGFANGFeedbackURL;

//交易明细详情
@property (nonatomic, strong) NSString *DENGFANGJiaoYiDetailURL;

//帮助中心-常见问题
@property (nonatomic, strong) NSString *DENGFANGHelpCenterURL;

//设置支付密码
@property (nonatomic, strong) NSString *DENGFANGSetPayPWURL;
//修改支付密码
@property (nonatomic, strong) NSString *DENGFANGModifyPayPWDURL;

//邀请有礼
@property (nonatomic, strong) NSString *DENGFANGYaoQingYouLiURL;

//我的佣金
@property (nonatomic, strong) NSString *DENGFANGWoDeYongJinURL;

//退单原因说明
@property (nonatomic, strong) NSString *DENGFANGTuiDanYuanYinURL;
//申请退单
@property (nonatomic, strong) NSString *DENGFANGTuiDanURL;

#pragma mark 1.8.1版本
//客户管理 - 订单列表
@property (nonatomic,strong) NSString *DENGFANGFindOrderListURL;
//客户管理 - 更新状态列表
@property (nonatomic,strong) NSString *DENGFANGRecordQueListURL;
//客户管理 - 修改跟进状态
@property (nonatomic,strong) NSString *DENGFANGOrderUpdataStateURL;
//客户管理 -订单详情
@property (nonatomic,strong) NSString *DENGFANGOrderGetOrderByIdURL;
//获取身份证识别结果
@property (nonatomic,strong) NSString *DENGFANGIDCardCheckUrl;
//
@property(strong,nonatomic)NSString *DENGFANGIDCardSysTemInfo;

//车辆查询
@property (nonatomic, strong) NSString *SaveToSearchCar;//添加车辆并查询
@property (nonatomic, strong) NSString *UserCarInfo;//查询添加的车辆信息
@property (nonatomic, strong) NSString *KuaiSuChaXunWZ;//快速查询违章
@property (nonatomic, strong) NSString *SearchDrivingLicence;//驾驶证扣分查询
@property (nonatomic, strong) NSString *UserDriverInfo;//查询个人驾照信息

@end
