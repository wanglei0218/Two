//
//  SSH_PageCollectionView.h
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/29.
//  Copyright © 2017年 zhaoxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(_reuseIdentifier)

@property (nonatomic, copy) NSString *reuseIdentifier;          //复用标识
@property (nonatomic, copy) NSString *isInScreen;

@end

@class SSH_PageCollectionView;

@protocol SSH_PageCollectionViewDelegate <NSObject>

@optional
- (void)ZXPageViewDidEndChangeIndex:(SSH_PageCollectionView *)pageView currentView:(UIView *)view;

- (void)ZXPageViewDidScroll:(UIScrollView *)scrollView direction:(NSString *)direction;

- (void)ZXPageViewWillBeginDragging:(SSH_PageCollectionView *)pageView;

@end

@protocol SSH_PageCollectionViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInSSH_PageCollectionView:(SSH_PageCollectionView *)SSH_PageCollectionView;
- (UIView *)SSH_PageCollectionView:(SSH_PageCollectionView *)SSH_PageCollectionView
              viewForItemAtIndex:(NSInteger)index;

@end
//DENGFANGPageCollectionView
@interface SSH_PageCollectionView : UIView

@property (nonatomic, weak) id<SSH_PageCollectionViewDelegate> delegate;
@property (nonatomic, weak) id<SSH_PageCollectionViewDataSource> dataSource;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) NSString *noAnimationIndex;
@property (nonatomic, assign) BOOL isAnimation;

- (void)reloadPageView;

- (void)registerClass:(Class)viewClass forViewWithReuseIdentifier:(NSString *)identifier;

- (UIView *)dequeueReuseViewWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

- (void)moveToIndex:(NSInteger)index animation:(BOOL)animation;

@end
