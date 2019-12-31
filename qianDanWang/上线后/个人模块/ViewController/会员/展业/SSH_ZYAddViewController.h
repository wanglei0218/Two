//
//  SSH_ZYAddViewController.h
//  qianDanWang
//
//  Created by AN94 on 9/17/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SSH_ZYAddViewControllerDelegate <NSObject>

- (void)didEnterTheEditContentWithIntro:(NSString *)intro phone:(NSString *)phone;

@end

@interface SSH_ZYAddViewController : SSQ_BaseNormalViewController

@property (nonatomic,strong)id <SSH_ZYAddViewControllerDelegate> delegate;
@property (nonatomic,strong)NSString *phoneNum;

@end

NS_ASSUME_NONNULL_END
