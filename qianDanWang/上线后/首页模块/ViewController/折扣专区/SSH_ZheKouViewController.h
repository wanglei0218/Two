//
//  SSH_ZheKouViewController.h
//  DENGFANGSC
//
//  Created by 新民 on 2019/4/16.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//DENGFANGZheKouViewController
@interface SSH_ZheKouViewController : SSQ_BaseNormalViewController

/** 区分高额专区、全国专区、折扣专区 */
@property(nonatomic,strong)NSString *flage;

@property(nonatomic,copy) NSString *titleText;

@property(nonatomic,assign)CGFloat less;

@end

NS_ASSUME_NONNULL_END
