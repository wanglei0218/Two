//
//  FIWebViewSingleModel.m
//  FinancialInvest
//
//  Created by 幸运儿╮(￣▽￣)╭ on 2019/1/15.
//  Copyright © 2019 幸运儿╮(￣▽￣)╭. All rights reserved.
//

#import "DENGFANGWebViewSingleModel.h"

@implementation DENGFANGWebViewSingleModel

static DENGFANGWebViewSingleModel *_webViewModel;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_webViewModel) {
            _webViewModel = [super allocWithZone:zone];
            [_webViewModel setupWebView];
            [_webViewModel getNowTimeStamp];
        }
    });
    return _webViewModel;
}
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

- (void)setupWebView {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.suppressesIncrementalRendering = YES;
    self.singleWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];

}

- (void)getNowTimeStamp {
    NSDate *datenow = [NSDate date];
    self.timeStamp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
}




@end
