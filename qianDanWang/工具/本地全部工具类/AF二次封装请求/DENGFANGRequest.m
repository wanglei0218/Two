//
//  DENGFANGRequest.m
//  reViewApp
//
//  Created by  梁媛 on 2017/6/5.
//  Copyright © 2017年 chaoqianyan. All rights reserved.
//
//  
//
//

#import "DENGFANGRequest.h"

static DENGFANGRequest *_DENGFANGRequest = nil;

//NSString *httpHeadString = @"http://192.168.0.147:8082/";
//NSString *httpHeadString = @"http://192.168.0.155:8082/";
//NSString *httpHeadString = @"http://192.168.0.127:8082/";
//NSString *httpHeadString = [NSString stringWithFormat:@"http://%@/",[DENGFANGSingletonTime shareInstance].lianJieArr[2]];
static NSString *httpHeadStringTwo =  @"http://m.xinyongjiedai.com/";

@interface DENGFANGRequest()
//{
//    NSString *httpHeadString;
//}
@end


@implementation DENGFANGRequest

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _DENGFANGRequest = [[DENGFANGRequest alloc] init];
        [_DENGFANGRequest setUpDomainUrl];
    });
    return _DENGFANGRequest;
}
//线上线下
- (void)setUpDomainUrl {
    NSArray *arr = [DENGFANGSingletonTime shareInstance].lianJieArr;
    NSString *string = arr[3];//线上数据 2  线下数据 3
    self.httpHeadString = [NSString stringWithFormat:@"http://%@/",string];
}

- (void)getWithUrlString:(NSString *)UrlString parameters:(id)parameters success:(void (^)(id))success fail:(void (^)(NSError *))fail{
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    NSString *lastUrlString = [_httpHeadString stringByAppendingString:UrlString];
//    NSDictionary *param = [self setupCommonParam:parameters];
//    NSLog(@"主地址   = %@",lastUrlString);
//    NSLog(@"传的地址 = %@",UrlString);
//    NSLog(@"传的参数 = %@",parameters);
    [self postWithUrlString:UrlString parameters:parameters success:^(id responsObject) {
        if (success) {
            success(responsObject);
        }
    } fail:^(NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
//    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
//    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
//    NSDictionary *settings = proxies[0];
//    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
//
//            [manager GET:lastUrlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                if (success) {
//                    success(responseObject);
//                }
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"----------%@",error);
//                [DENGFANGHelperFunction showErrorAlter:SHAREDAPP.window];
//
//                if (fail) {
//                    fail(error);
//                }
//            }];
//
//        }
//    else {
//
//        return;
//    }
}

- (void)postWithUrlString:(NSString *)UrlString parameters:(id)parameters success:(void (^)(id))success fail:(void (^)(NSError *))fail{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manger.requestSerializer = [AFJSONRequestSerializer serializer];
//    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *lastUrlString = [_httpHeadString stringByAppendingString:UrlString];
    
    
    NSDictionary *param = [self setupCommonParam:parameters];
    
    NSLog(@"参数 == %@",param);
    NSLog(@"主地址   = %@",lastUrlString);
    
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = proxies[0];
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
            
            [manger POST:lastUrlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"---------%@",error);
                [DENGFANGHelperFunction showErrorAlter:SHAREDAPP.window];
                //[SSH_TOOL_GongJuLei showAlter:SHAREDAPP.window WithMessage:UrlString];
                
                if (fail) {
                    fail(error);
                }
            }];
        }
    else {
        
        return;
    }
    
}



- (void)postJsonWithparameters:(id)parameters success:(void (^)(id))success fail:(void (^)(NSError *))fail {
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFHTTPResponseSerializer *responSerializer = [AFJSONResponseSerializer serializer];
    responSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    manager.responseSerializer = responSerializer;
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://idasc.webank.com/api/server/getfaceid" parameters:parameters error:nil];
    request.timeoutInterval = 5.f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            !success ? : success(responseObject);
        }else {
            !fail ? : fail(error);
        }
    }];
    [task resume];
}


//暂时没用到
- (void)postWithUrl:(NSString *)url parameters:(id)parameters success:(void (^)(id))success fail:(void (^)(NSError *))fail {
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *lastUrlString = url;
    NSDictionary *param = [self setupCommonParam:parameters];
    
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = proxies[0];
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
        
        [manger POST:lastUrlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"---------%@/n/nurl=%@/n/n",error,url);
            if ([url containsString:@"dist/myAccount"]) {
                
            } else {
                [DENGFANGHelperFunction showErrorAlter:SHAREDAPP.window];
            }            
            
            if (fail) {
                fail(error);
            }
        }];
    }
    else {
        
        return;
    }
}

+(void)uploadImageWithURLString:(NSString *)URLString parameters:(id)parameters uploadDatas:(NSData *)uploadData progress:(void (^)(float))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *urlString = URLString;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    
    NSDictionary *settings = proxies[0];
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
            [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
                //上传的参数(上传图片，以文件流的格式)
                [formData appendPartWithFileData:uploadData
                                            name:@"file"
                                        fileName:fileName
                                        mimeType:@"image/jpeg"];
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                //打印下上传进度
                
                if (progress) {
                    progress(uploadProgress.fractionCompleted);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //上传成功
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [DENGFANGHelperFunction showErrorAlter:SHAREDAPP.window];
                NSLog(@"error == %@",error);
                //上传失败
                if (failure) {
                    failure(error);
                }
            }];
        }
    else {
        return;
    }
    
}
//上传多张图片
+ (void)uploadImagesWithURLString:(NSString *)URLString
                       parameters:(id)parameters
                   uploadDataArrs:(NSMutableArray *)dataArr
                         progress:(void (^)(float progress))progress
                          success:(void (^)(id reponse))success
                          failure:(void (^)(NSError *failure))failure{
    
    NSString *urlString = URLString;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = proxies[0];
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
            
            [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                for (int i = 0; i<dataArr.count; i++) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    NSString *str = [formatter stringFromDate:[NSDate date]];
                    NSString *fileName = [NSString stringWithFormat:@"%@-%d.jpg", str,i];
                    //上传的参数(上传图片，以文件流的格式)
                    [formData appendPartWithFileData:dataArr[i]
                                                name:@"file"
                                            fileName:fileName
                                            mimeType:@"image/jpeg"];
                }
                
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                //打印下上传进度
                
                if (progress) {
                    progress(uploadProgress.fractionCompleted);
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //上传成功
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [DENGFANGHelperFunction showErrorAlter:SHAREDAPP.window];
                
                //上传失败
                if (failure) {
                    failure(error);
                }
            }];
        }
    else {
        
        return;
    }
    
}

/**
 * 处理公用字段（flag/timestamp）
 */
- (NSDictionary *)setupCommonParam:(id)parameters {
    if (parameters) {
        if ([parameters isKindOfClass:[NSMutableDictionary class]]) {
            parameters[@"useTerminal"] = @"1";
            parameters[@"flag"] = @"1";
            if([DENGFANGSingletonTime shareInstance].useridString == 0){
                parameters[@"userId"] = @"";
            }else{
                parameters[@"userId"] = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
            }
            parameters[@"token"] = [DENGFANGSingletonTime shareInstance].tokenString;
            return [parameters copy];
        }else if ([parameters isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *mutableParam = [parameters mutableCopy];
            mutableParam[@"useTerminal"] = @"1";
            mutableParam[@"flag"] = @"1";
            if([DENGFANGSingletonTime shareInstance].useridString == 0){
                mutableParam[@"userId"] = @"";
            }else{
                mutableParam[@"userId"] = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
            }
            mutableParam[@"token"] = [DENGFANGSingletonTime shareInstance].tokenString;
            parameters = [mutableParam copy];
        }
        return parameters;
    }else {
        NSMutableDictionary *mutableParam = [parameters mutableCopy];
        mutableParam[@"useTerminal"] = @"1";
        mutableParam[@"flag"] = @"1";
        if([DENGFANGSingletonTime shareInstance].useridString == 0){
            mutableParam[@"userId"] = @"";
        }else{
            mutableParam[@"userId"] = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
        }
        mutableParam[@"token"] = [DENGFANGSingletonTime shareInstance].tokenString;
        return [mutableParam copy];
    }
}

#pragma mark -违章查询
- (NSString *)SaveToSearchCar{
    if (!_SaveToSearchCar) {
        _SaveToSearchCar = [httpHeadStringTwo stringByAppendingString:@"violation/addCarAndSelectViolation"];
    }
    return _SaveToSearchCar;
}

- (NSString *)UserCarInfo{
    if (!_UserCarInfo) {
        _UserCarInfo = [httpHeadStringTwo stringByAppendingString:@"violation/checkInfoOfCarByIdentify"];
    }
    return _UserCarInfo;
}

- (NSString *)KuaiSuChaXunWZ{
    if (!_KuaiSuChaXunWZ) {
        _KuaiSuChaXunWZ = [httpHeadStringTwo stringByAppendingString:@"violation/checkByidentifyId"];
    }
    return _KuaiSuChaXunWZ;
}

- (NSString *)SearchDrivingLicence{
    if (!_SearchDrivingLicence) {
        _SearchDrivingLicence = [httpHeadStringTwo stringByAppendingString:@"points/AddLicenseAndCheckPoints"];
    }
    return _SearchDrivingLicence;
}

- (NSString *)UserDriverInfo{
    if (!_UserDriverInfo) {
        _UserDriverInfo = [httpHeadStringTwo stringByAppendingString:@"points/unique"];
    }
    return _UserDriverInfo;
}


#pragma mark -后
- (NSString *)DENGFANGPicCodeURL{
    if (!_DENGFANGPicCodeURL) {
        _DENGFANGPicCodeURL = @"user/authCode";
    }
    return _DENGFANGPicCodeURL;
}

- (NSString *)DENGFANGGetVertifyCodeURL{
    if (!_DENGFANGGetVertifyCodeURL) {
        _DENGFANGGetVertifyCodeURL = @"user/sendVerifyCode";
    }
    return _DENGFANGGetVertifyCodeURL;
}

- (NSString *)DENGFANGLoginURL{
    if (!_DENGFANGLoginURL) {
        _DENGFANGLoginURL = @"base/login";
    }
    return _DENGFANGLoginURL;
}

- (NSString *)DENGFANGSetPasswordURL{
    if (!_DENGFANGSetPasswordURL) {
        _DENGFANGSetPasswordURL = @"user/updatePwd";
    }
    return _DENGFANGSetPasswordURL;
}

#pragma mark 首页
//首页 修改用户登录地址  /user/updateUserArea
-(NSString *)DENGFANGUpdateUserAreaURL{
    if (!_DENGFANGUpdateUserAreaURL) {
        _DENGFANGUpdateUserAreaURL = @"user/updateUserArea";
    }
    return _DENGFANGUpdateUserAreaURL;
}
//首页banner  含 中部的图
- (NSString *)DENGFANGBannerListURL{
    if (!_DENGFANGBannerListURL) {
        _DENGFANGBannerListURL = @"base/queryBannerList";
    }
    return _DENGFANGBannerListURL;
}
//首页 系统公告
- (NSString *)DENGFANGNoticeListURL{
    if (!_DENGFANGNoticeListURL) {
        _DENGFANGNoticeListURL = @"base/queryNoticeList";
    }
    return _DENGFANGNoticeListURL;
}
//首页 资源列表
- (NSString *)DENGFANGCreditinfoListURL{
    if (!_DENGFANGCreditinfoListURL) {
        _DENGFANGCreditinfoListURL = @"creditinfo/queryCreditinfoList";
    }
    return _DENGFANGCreditinfoListURL;
}
//首页 类型  （同筛选条件列表）/base/queryClassify
- (NSString *)DENGFANGClassifyURL{
    if (!_DENGFANGClassifyURL) {
        //        _DENGFANGClassifyURL = @"base/queryClassifyNew";
        _DENGFANGClassifyURL = @"base/searchClassifyNew"; //1.7版本
    }
    return _DENGFANGClassifyURL;
}
//首页 资源详情界面 /creditinfo/getCreditinfoById
-(NSString *)DENGFANGCreditinfoByIdURL{
    if (!_DENGFANGCreditinfoByIdURL) {
        _DENGFANGCreditinfoByIdURL = @"creditinfo/getCreditinfoById";
    }
    return _DENGFANGCreditinfoByIdURL;
}
//添加收藏  /collection/addMyCollection
-(NSString *)DENGFANGAddMyCollectionURL{
    if (!_DENGFANGAddMyCollectionURL) {
        _DENGFANGAddMyCollectionURL = @"collection/addMyCollection";
    }
    return _DENGFANGAddMyCollectionURL;
}
#pragma mark 客户管理
//客户管理 - 收藏列表  /collection/queryMyCollectionList
-(NSString *)DENGFANGMyCollectionListURL{
    if (!_DENGFANGMyCollectionListURL) {
        _DENGFANGMyCollectionListURL = @"collection/queryMyCollectionList";
    }
    return _DENGFANGMyCollectionListURL;
}
//客户管理 - 订单列表  /order/queryMyOrderList
-(NSString *)DENGFANGMyOrderListURL{
    if (!_DENGFANGMyOrderListURL) {
        _DENGFANGMyOrderListURL = @"order/queryMyOrderList";
    }
    return _DENGFANGMyOrderListURL;
}
//客户管理 - 订单列表详情页  /order/getOrderInfoById
-(NSString *)DENGFANGOrderInfoByIdURL{
    if (!_DENGFANGOrderInfoByIdURL) {
        _DENGFANGOrderInfoByIdURL = @"order/getOrderInfoById";
    }
    return _DENGFANGOrderInfoByIdURL;
}



//抢单
- (NSString *)DENGFANGQiangDanURL{
    if (!_DENGFANGQiangDanURL) {
        //        _DENGFANGQiangDanURL = @"order/grabOrder";
        _DENGFANGQiangDanURL = @"order/grabOrderNew"; //2.0
    }
    return _DENGFANGQiangDanURL;
}

//获取支付详情
- (NSString *)DENGFANGPayDetailURL{
    if (!_DENGFANGPayDetailURL) {
        _DENGFANGPayDetailURL = @"pay/getOrderInfo";
    }
    return _DENGFANGPayDetailURL;
}

//确认支付-金币
- (NSString *)DENGFANGSurePayJinBiURL{
    if (!_DENGFANGSurePayJinBiURL) {
        //        _DENGFANGSurePayJinBiURL = @"pay/payGold";
        _DENGFANGSurePayJinBiURL = @"pay/payGoldNew"; //2.0
    }
    return _DENGFANGSurePayJinBiURL;
}

//查询支付方式列表&充值金额&优惠金额
- (NSString *)DENGFANGPaymentMethodListURL{
    if (!_DENGFANGPaymentMethodListURL) {
        _DENGFANGPaymentMethodListURL = @"base/queryPaymentMethodList";
    }
    return _DENGFANGPaymentMethodListURL;
}

//生成支付订单-支付宝支付
- (NSString *)DENGFANGInsertPayRecordURL{
    if (!_DENGFANGInsertPayRecordURL) {
        _DENGFANGInsertPayRecordURL = @"alipay/insertPayRecord";
    }
    return _DENGFANGInsertPayRecordURL;
}

//获取支付宝签名
- (NSString *)DENGFANGGetAliPayValidCodeURL{
    if (!_DENGFANGGetAliPayValidCodeURL) {
        _DENGFANGGetAliPayValidCodeURL = @"alipay/getAlipayValidCode";
    }
    return _DENGFANGGetAliPayValidCodeURL;
}

//更新支付宝同步支付结果
- (NSString *)DENGFANGUpdateAliPayResult{
    if (!_DENGFANGUpdateAliPayResult) {
        _DENGFANGUpdateAliPayResult = @"alipay/updateSynchronizationResult";
    }
    return _DENGFANGUpdateAliPayResult;
}

//微信发起预支付接口
- (NSString *)DENGFANGWeiXinPayURL{
    if (!_DENGFANGWeiXinPayURL) {
        _DENGFANGWeiXinPayURL = @"weixin/new/appPay";
    }
    return _DENGFANGWeiXinPayURL;
}



#pragma mark 设置
//修改用户信息  /user/updateEuser
- (NSString *)DENGFANGUpdateEuserURL{
    if (!_DENGFANGUpdateEuserURL) {
        _DENGFANGUpdateEuserURL = @"user/updateEuser";
    }
    return _DENGFANGUpdateEuserURL;
}
//获取用户信息/user/getUserInfo
- (NSString *)DENGFANGUserInfoURL{
    if (!_DENGFANGUserInfoURL) {
        _DENGFANGUserInfoURL = @"user/getUserInfo";
    }
    return _DENGFANGUserInfoURL;
}
//用户认证  /auth/insertAuthRecord
- (NSString *)DENGFANGInsertAuthRecordURL{
    if (!_DENGFANGInsertAuthRecordURL) {
        _DENGFANGInsertAuthRecordURL = @"auth/insertAuthRecord";
    }
    return _DENGFANGInsertAuthRecordURL;
}
//用户认证失败  /auth/getDENGFANGAuthMark
//@property (nonatomic, strong) NSString *DENGFANGAuthMarkURL;
- (NSString *)DENGFANGAuthMarkURL{
    if (!_DENGFANGAuthMarkURL) {
        _DENGFANGAuthMarkURL = @"auth/getTydAuthMark";
    }
    return _DENGFANGAuthMarkURL;
}

//微信同步支付结果通知
- (NSString *)DENGFANGWeiXinPayStatusUpdateURL{
    if (!_DENGFANGWeiXinPayStatusUpdateURL) {
        _DENGFANGWeiXinPayStatusUpdateURL = @"weixin/synchronizedNotify";
    }
    return _DENGFANGWeiXinPayStatusUpdateURL;
}

//获取微信公众号
- (NSString *)DENGFANGGetWechatImgURL{
    if (!_DENGFANGGetWechatImgURL) {
        _DENGFANGGetWechatImgURL = @"sys/getWechatImgNew";
    }
    return _DENGFANGGetWechatImgURL;
}

//交易记录列表
- (NSString *)DENGFANGJiaoYiJiLuURL{
    if (!_DENGFANGJiaoYiJiLuURL) {
        _DENGFANGJiaoYiJiLuURL = @"pay/findTraRecordList";//@"pay/queryTraRecordList";
    }
    return _DENGFANGJiaoYiJiLuURL;
}

//意见反馈
- (NSString *)DENGFANGFeedbackURL{
    if (!_DENGFANGFeedbackURL) {
        _DENGFANGFeedbackURL = @"base/insertFeedBack";
    }
    return _DENGFANGFeedbackURL;
}

//交易明细详情
- (NSString *)DENGFANGJiaoYiDetailURL{
    if (!_DENGFANGJiaoYiDetailURL) {
        _DENGFANGJiaoYiDetailURL = @"pay/getTraRecordById";
    }
    return _DENGFANGJiaoYiDetailURL;
}

//帮助中心-常见问题
- (NSString *)DENGFANGHelpCenterURL{
    if (!_DENGFANGHelpCenterURL) {
        _DENGFANGHelpCenterURL = @"base/queryProblemList";
    }
    return _DENGFANGHelpCenterURL;
}

//设置支付密码
- (NSString *)DENGFANGSetPayPWURL{
    if (!_DENGFANGSetPayPWURL) {
        _DENGFANGSetPayPWURL = @"user/setPayPwd";
    }
    return _DENGFANGSetPayPWURL;
}

//修改支付密码
- (NSString *)DENGFANGModifyPayPWDURL{
    if (!_DENGFANGModifyPayPWDURL) {
        _DENGFANGModifyPayPWDURL = @"user/updatePayPwd";
    }
    return _DENGFANGModifyPayPWDURL;
}

//邀请有礼
- (NSString *)DENGFANGYaoQingYouLiURL{
    if (!_DENGFANGYaoQingYouLiURL) {
        _DENGFANGYaoQingYouLiURL = @"user/inviteGift";
    }
    return _DENGFANGYaoQingYouLiURL;
}

//我的佣金
- (NSString *)DENGFANGWoDeYongJinURL{
    if (!_DENGFANGWoDeYongJinURL) {
        _DENGFANGWoDeYongJinURL = @"user/queryMyInviteList";
    }
    return _DENGFANGWoDeYongJinURL;
}

#pragma mark 1.8.1版本
//客户管理 - 订单列表
-(NSString *)DENGFANGFindOrderListURL{
    if (!_DENGFANGMyOrderListURL) {
        _DENGFANGMyOrderListURL = @"order/findOrderList";
    }
    return _DENGFANGMyOrderListURL;
}

//客户管理 - 更新状态列表
-(NSString *)DENGFANGRecordQueListURL{
    if (!_DENGFANGRecordQueListURL) {
        _DENGFANGRecordQueListURL = @"record/queryState";
    }
    return _DENGFANGRecordQueListURL;
}

//客户管理 - 修改跟进状态
-(NSString *)DENGFANGOrderUpdataStateURL{
    if (!_DENGFANGOrderUpdataStateURL) {
        _DENGFANGOrderUpdataStateURL = @"order/updateState";
    }
    return _DENGFANGOrderUpdataStateURL;
}

//客户管理 - 订单详情
-(NSString *)DENGFANGOrderGetOrderByIdURL{
    if (!_DENGFANGOrderGetOrderByIdURL) {
        _DENGFANGOrderGetOrderByIdURL = @"order/getOrderById";
    }
    return _DENGFANGOrderGetOrderByIdURL;
}

//退单原因说明
- (NSString *)DENGFANGTuiDanYuanYinURL{
    if (!_DENGFANGTuiDanYuanYinURL) {
        _DENGFANGTuiDanYuanYinURL = @"refund/rules";
    }
    return _DENGFANGTuiDanYuanYinURL;
}

//申请退单
- (NSString *)DENGFANGTuiDanURL {
    if (!_DENGFANGTuiDanURL) {
        _DENGFANGTuiDanURL = @"single/saveBack";
    }
    return _DENGFANGTuiDanURL;
}
//获取身份证识别结果
-(NSString *)DENGFANGIDCardCheckUrl{
    if (!_DENGFANGIDCardCheckUrl) {
        _DENGFANGIDCardCheckUrl = @"auth/idCardOcrCheck";
    }
    return _DENGFANGIDCardCheckUrl;
}

//判断认证方式
-(NSString *)DENGFANGIDCardSysTemInfo{
    if (!_DENGFANGIDCardSysTemInfo) {
        _DENGFANGIDCardSysTemInfo = @"sys/getSysTemInfo";
    }
    return _DENGFANGIDCardSysTemInfo;
}

@end
