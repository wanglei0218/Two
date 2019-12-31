//
//  ACNetWorkClass.m
//  AdviserCrd
//
//  Created by 河神 on 2019/5/23.
//  Copyright © 2019 ￥￥￥. All rights reserved.
//

#import "USERNetWorkClass.h"

@implementation USERNetWorkClass


+ (void)POSTUrl:(NSString *)url param:(NSDictionary *)param success:(CREReponseSuccess)success fail:(CREReponseFail)fail {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress){
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        !success ? : success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !fail ? : fail(error);
    }];
}



+ (void)GETUrl:(NSString *)url param:(NSDictionary *)param success:(CREReponseSuccess)success fail:(CREReponseFail)fail {
    
    [[AFHTTPSessionManager manager] GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@",responseObject);
        //        NSLog(@"%@",responseObject);
        !success ? : success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !fail ? : fail(error);
    }];
    
}


//get请求
//get请求
//get请求
+(void)getWithUrl:(NSString *)url Params:(id)params successHander:(void (^)(id))success failHander:(void (^)(NSError *))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    
    NSString *encoded = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encoded parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
//        NSLog(@"请求成功---%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
//        NSLog(@"----%@----",error);
    }];
    
}

+ (void)PostFormDataUrl:(NSString *)url param:(id)param success:(CREReponseSuccess)success fail:(CREReponseFail)fail {
    
    AFHTTPRequestSerializer *requestSeriaizer = [AFHTTPRequestSerializer serializer];
    [requestSeriaizer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSMutableURLRequest *request = [requestSeriaizer requestWithMethod:@"POST" URLString:url parameters:param error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    AFHTTPResponseSerializer *responseSeriaizer = [AFHTTPResponseSerializer serializer];
    responseSeriaizer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    manager.responseSerializer = responseSeriaizer;
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            fail(error);
        } else {
            success(responseObject);
        }
    }];
    [dataTask resume];
    
}

//重新封装参数 加入app相关信息
+ (NSString *)parseParams:(NSDictionary *)params
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:params];
    [parameters setValue:@"ios" forKey:@"client"];
    [parameters setValue:@"请替换版本号" forKey:@"auth_version"];
    NSString* phoneModel = @"获取手机型号" ;
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];//ios系统版本号
    NSString *system = [NSString stringWithFormat:@"%@(%@)",phoneModel, phoneVersion];
    [parameters setValue:system forKey:@"system"];
    NSDate *date = [NSDate date];
    NSTimeInterval timeinterval = [date timeIntervalSince1970];
    [parameters setObject:[NSString stringWithFormat:@"%.0lf",timeinterval] forKey:@"auth_timestamp"];//请求时间戳
    NSString *devicetoken = @"请替换DeviceToken";
    [parameters setValue:devicetoken forKey:@"uuid"];
//    NSLog(@"请求参数:%@",parameters);
    
    NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString new];
    //实例化一个key枚举器用来存放dictionary的key
    
    //加密处理 将所有参数加密后结果当做参数传递
    //parameters = @{@"i":@"加密结果 抽空加入"};
    
    NSEnumerator *keyEnum = [parameters keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&", key, [params valueForKey:key]];
        [result appendString:keyValueFormat];
    }
    return result;
}





+(void)ImageUrlString:(NSString *)url parameters:(id)parameters success:(FYCodeBlock)successBlock failure:(CREReponseFail)failureBlock{
    NSMutableString *mutableUrl = [[NSMutableString alloc] initWithString:url];
    if ([parameters allKeys]) {
        [mutableUrl appendString:@"?"];
        for (id key in parameters) {
            NSString *value = [[parameters objectForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
        }
    }
    NSString *urlEnCode = [[mutableUrl substringToIndex:mutableUrl.length - 1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlEnCode]];
    NSURLSession *urlSession = [NSURLSession sharedSession];
    
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    YYQLog(@"\n%@",proxies);
    NSDictionary *settings = proxies[0];
    YYQLog(@"%@",[settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    YYQLog(@"%@",[settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    YYQLog(@"%@",[settings objectForKey:(NSString *)kCFProxyTypeKey]);
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
        {
            YYQLog(@"没设置代理");
            NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{                        failureBlock(error);
                    });
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{            successBlock(data);
                    });
                    
                }
            }];
            [dataTask resume];
            }else{
                YYQLog(@"设置了代理");
                return;
        }
}



+(void)getWithUrlString:(NSString *)url parameters:(id)parameters success:(CREReponseSuccess)successBlock failure:(FailureBlock)failureBlock{
    NSMutableString *mutableUrl = [[NSMutableString alloc] initWithString:url];
    if ([parameters allKeys]) {
        [mutableUrl appendString:@"?"];
        for (id key in parameters) {
            NSString *value = [[parameters objectForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [mutableUrl appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
        }
    }
    NSString *urlEnCode = [[mutableUrl substringToIndex:mutableUrl.length - 1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlEnCode]];
    NSURLSession *urlSession = [NSURLSession sharedSession];
    
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    YYQLog(@"\n%@",proxies);
    NSDictionary *settings = proxies[0];
    YYQLog(@"%@",[settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    YYQLog(@"%@",[settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    YYQLog(@"%@",[settings objectForKey:(NSString *)kCFProxyTypeKey]);
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
    {
        YYQLog(@"没设置代理");
        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{ FailureBlock(error);
                });
            } else {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock(dic);
                });
                
            }
        }];
        [dataTask resume];
    }
    else{
        YYQLog(@"设置了代理");
        return;
    }
}




+ (void)POSTJsonUrl:(NSString *)url json:(NSDictionary *)param success:(CREReponseSuccess)success fail:(CREReponseFail)fail{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFHTTPResponseSerializer *responSerializer = [AFJSONResponseSerializer serializer];
    responSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",nil];
    manager.responseSerializer = responSerializer;
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:param error:nil];
    request.timeoutInterval = 5.f;
    [request setValue:@"7b00acba04f74f2ba52e8fc0ad4f0751" forHTTPHeaderField:@"token"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    
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


+(void)postWithUrlString:(NSString *)url parameters:(id)parameters success:(CREReponseSuccess)successBlock failure:(CREReponseFail)failureBlock
{
    NSURL *nsurl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    //如果想要设置网络超时的时间的话，可以使用下面的方法：
    //NSMutableURLRequest *mutableRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    //设置请求类型
    request.HTTPMethod = @"POST";
    
    //将需要的信息放入请求头 随便定义了几个
    [request setValue:@"xxx" forHTTPHeaderField:@"Authorization"];//token
    [request setValue:@"xxx" forHTTPHeaderField:@"Gis-Lng"];//坐标 lng
    [request setValue:@"xxx" forHTTPHeaderField:@"Gis-Lat"];//坐标 lat
    [request setValue:@"xxx" forHTTPHeaderField:@"Version"];//版本
//    NSLog(@"POST-Header:%@",request.allHTTPHeaderFields);
    
    //把参数放到请求体内
    NSString *postStr = [USERNetWorkClass parseParams:parameters];
    request.HTTPBody = [postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) { //请求失败
            dispatch_async(dispatch_get_main_queue(), ^{                        failureBlock(error);
            });
            
        } else {  //请求成功
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{            successBlock(dic);
            });
            
        }
    }];
    [dataTask resume];  //开始请求
    
}



@end
