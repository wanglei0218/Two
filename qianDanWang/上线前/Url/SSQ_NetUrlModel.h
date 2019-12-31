//
//  SSQ_NetUrlModel.h
//  Danyoutao
//
//  Created by 幸运儿╮(￣▽￣)╭ on 2018/12/19.
//  Copyright © 2018 DENGFANG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


//首页的请求的url
static NSString *const mainHomeUrl = @"http://qc.cn/json.php?c=json&a=baxbat";
//热搜关键词
static NSString *const hotWordUrl = @"http://qc.cn/json.php?c=json&a=resou";
//详情页
static NSString *const detailUrl = @"http://qc.cn/json.php?c=json&a=show";

static NSString *const searchUrl = @"http://qc.cn/json.php?c=json&a=search";

//DENGFANGNetUrlModel
@interface SSQ_NetUrlModel : NSObject

@end

NS_ASSUME_NONNULL_END
