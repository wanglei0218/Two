//
//  FIWebViewSingleModel.h
//  FinancialInvest
//
//  Created by 幸运儿╮(￣▽￣)╭ on 2019/1/15.
//  Copyright © 2019 幸运儿╮(￣▽￣)╭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface DENGFANGWebViewSingleModel : NSObject

/** <#注释#> */
@property (nonatomic,strong)  WKWebView *singleWebView;

/** 当前毫秒数 */
@property (nonatomic,strong) NSString *timeStamp;

+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
