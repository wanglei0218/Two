//
//  SSH_TuiDanViewController.h
//  DENGFANGSC
//
//  Created by 河神 on 2019/5/10.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//DENGFANGTuiDanViewController
@interface SSH_TuiDanViewController : SSQ_BaseNormalViewController

@property (nonatomic, strong) NSString *shenQingTimeStr;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *singleState;
@property (nonatomic, strong)void(^remindTuiDan)(void);

@end

NS_ASSUME_NONNULL_END
