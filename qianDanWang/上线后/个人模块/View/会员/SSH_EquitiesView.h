//
//  SSH_EquitiesView.h
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SSH_EquitiesViewDelegate <NSObject>

- (void)didSelecteTheKnow;

@end

@interface SSH_EquitiesView : UIView

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *lineLabel;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)id <SSH_EquitiesViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
