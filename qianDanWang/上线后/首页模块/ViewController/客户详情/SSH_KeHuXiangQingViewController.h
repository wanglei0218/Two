//
//  DENGFANGProductDetailViewController.h
//  DENGFANGSC
//
//  Created by 锦鳞附体^_^ on 2018/11/27.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//DENGFANGKeHuXiangQingViewController
@interface SSH_KeHuXiangQingViewController : SSQ_BaseNormalViewController

@property (nonatomic, strong) NSString *creditinfoId;//资源ID
@property (nonatomic, strong) NSString *orderNo;//订单号
@property (nonatomic, assign) NSInteger  pageType;// 1-资源详情页    2-订单详情页
@property(nonatomic,strong)NSString *isDiscount; //0:非折扣资源  1：折扣资源
@property (nonatomic, assign) int fromWhere;//从哪里进来详情页的，1:低价淘单详情 2:正常淘单详情 3:由订单请求后决定

@property(nonatomic,assign)CGFloat less;//高额专区cell需要减的高度

@property(nonatomic,assign)BOOL isQuanGuo;

@property (nonatomic,strong)NSString *shenQingTime; //申请时间


@end

NS_ASSUME_NONNULL_END
