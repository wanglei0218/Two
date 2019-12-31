//
//  ACNetWorkClass.h
//  AdviserCrd
//
//  Created by 河神 on 2019/5/23.
//  Copyright © 2019 ￥￥￥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CREReponseSuccess)(id json);
typedef void (^CREReponseFail)(NSError *error);
typedef void (^SuccessBlock)(NSDictionary *dict, BOOL success); // 访问成功block
typedef void (^FYCodeBlock)(NSData *data);
typedef void (^FailureBlock)(NSError *error); // 访问失败block


@interface USERNetWorkClass : NSObject

+ (void)POSTUrl:(NSString *)url param:(NSDictionary *)param success:(CREReponseSuccess)success fail:(CREReponseFail)fail;
+ (void)GETUrl:(NSString *)url param:(NSDictionary *)param success:(CREReponseSuccess)success fail:(CREReponseFail)fail;


+ (void)PostFormDataUrl:(NSString *)url param:(id)param success:(CREReponseSuccess)success fail:(CREReponseFail)fail ;


+(void)ImageUrlString:(NSString *)url parameters:(id)parameters success:(FYCodeBlock)successBlock failure:(CREReponseFail)failureBlock;
+ (void)getWithUrl:(NSString *)url Params:(id)params successHander:(void (^)(id))success failHander:(void (^)(NSError *))fail;



//判断代理
+ (void)getWithUrlString:(NSString *)url parameters:(id)parameters success:(CREReponseSuccess)successBlock failure:(FailureBlock)failureBlock;



+ (void)POSTJsonUrl:(NSString *)url json:(NSDictionary *)param success:(CREReponseSuccess)success fail:(CREReponseFail)fail;


+(void)postWithUrlString:(NSString *)url parameters:(id)parameters success:(CREReponseSuccess)successBlock failure:(CREReponseFail)failureBlock;

@end

NS_ASSUME_NONNULL_END
