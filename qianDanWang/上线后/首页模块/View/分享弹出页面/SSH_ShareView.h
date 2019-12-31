//
//  SSH_ShareView.h
//  jiaogeqian
//
//  Created by LY on 2018/8/24.
//  Copyright © 2018年 zdtc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSH_ShareViewViewDelegate <NSObject>

- (void)clickShareButtonAction:(int)index;

@end

//DENGFANGShareView
@interface SSH_ShareView : UIView

@property (nonatomic, weak) id<SSH_ShareViewViewDelegate> delegate;

- (void)showShareAlertView;
- (void)closeCurrentView;

@end
