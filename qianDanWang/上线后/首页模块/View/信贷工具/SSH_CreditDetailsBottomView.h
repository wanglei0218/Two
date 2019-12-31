//
//  SSH_CreditDetailsBottomVIew.h
//  qianDanWang
//
//  Created by AN94 on 9/24/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SSH_CreditDetailsBottomViewDelegate <NSObject>

- (void)didSelecteTheBtnWithTarget:(NSInteger)tag;

@end

@interface SSH_CreditDetailsBottomView : UIView

@property (nonatomic,strong)UILabel *topLabel;              ///<顶部
@property (nonatomic,strong)UIButton *leftBtn;              ///<立即计算
@property (nonatomic,strong)UIButton *rightBtn;             ///<重新计算
@property (nonatomic,strong)id <SSH_CreditDetailsBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
