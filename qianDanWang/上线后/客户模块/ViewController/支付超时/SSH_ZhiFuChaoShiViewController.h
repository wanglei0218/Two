//
//  SSH_ZhiFuChaoShiViewController.h
//  DENGFANGSC
//
//  Created by 锦鳞附体^_^ on 2018/11/22.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//DENGFANGZhiFuChaoShiViewController
@interface SSH_ZhiFuChaoShiViewController : SSQ_BaseNormalViewController
@property (nonatomic, strong) NSString *creditinfoId;//资源ID
@property (nonatomic, strong) NSString *orderNo;//订单号
@property (nonatomic, assign) NSInteger  pageType;// 1-资源详情页    2-订单详情页
@end

NS_ASSUME_NONNULL_END
