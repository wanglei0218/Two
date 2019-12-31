//
//  SSH_MemberHeaderView.h
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SSH_MemberHeaderViewDelegate <NSObject>

- (void)didSelecteTheMemberHeaderView;

@end

@interface SSH_MemberHeaderView : UIView

@property (nonatomic,strong)UIImageView *imageView;                         ///<背景图
@property (nonatomic,strong)UIImageView *headerImage;                       ///<头像
@property (nonatomic,strong)UILabel *nameLabel;                             ///<用户名称
@property (nonatomic,strong)UILabel *dayLabel;                              ///<会员期限
@property (nonatomic,strong)UIImageView *typeImage;                         ///<会员等级
@property (nonatomic,strong)UIImageView *rightImage;                        ///<开通或续费
@property (nonatomic,strong)id <SSH_MemberHeaderViewDelegate> delagate;      ///<代理

- (void)setMemberHeaderViewContentWithData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
