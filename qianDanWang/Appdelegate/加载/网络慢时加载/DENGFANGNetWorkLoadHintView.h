//
//  NetWorkLoadHintView.h
//  FinancialInvest
//
//  Created by 幸运儿╮(￣▽￣)╭ on 2019/1/21.
//  Copyright © 2019 幸运儿╮(￣▽￣)╭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,NetWorkStatues) {
    NetWorkStatuesFine,
    NetWorkStatuesBad
};

@interface DENGFANGNetWorkLoadHintView : UIView

+ (instancetype)netWorkLoadHintViewInitWithFrame:(CGRect)viewFrame;

/**
 * 当前网络显示图
 * NetWorkStatues netWorkStatue
 * NetWorkStatuesFine启动图 NetWorkStatuesBad网络差的图
 **/
@property (nonatomic,assign) NetWorkStatues netWorkStatue;

- (void)netWorkViewRemoveFromSuperView;
@end

NS_ASSUME_NONNULL_END
