//
//  SSH_ZYJumpView.h
//  qianDanWang
//
//  Created by AN94 on 9/20/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SSH_ZYJumpViewDelegate <NSObject>

- (void)didSelecteTheBtnWithTarget:(NSInteger)tag;

@end

@interface SSH_ZYJumpView : UIView

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)id <SSH_ZYJumpViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
