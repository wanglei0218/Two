//
//  SSH_ShouYeListTableViewCell.h
//  DENGFANGSC
//
//  Created by LY on 2018/10/7.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_ImgANDLabelView.h"//左图右文字
#import "SSH_HomeCreditxinxiListModel.h"

@protocol SSH_HomeQiangDanTableViewCellDelegate <NSObject>

-(void)shouCangBtnClicked:(UIButton *)btn;

@end

//DENGFANGShouYeListTableViewCell
@interface SSH_ShouYeListTableViewCell : UITableViewCell


@property (strong, nonatomic) SSH_HomeCreditxinxiListModel *homeCellModel;

@property (nonatomic, strong) UIView *backContentView;//背景View
@property (nonatomic, strong) UILabel *customNameLabel;//客户姓名
@property (nonatomic, strong) UILabel *timeLabel;//发布时间
@property (nonatomic, strong) UILabel *jieDuoShaoLabel;//多少
@property (nonatomic, strong) UILabel *daiDuoJiuLabel;//多久
@property (nonatomic, strong) UILabel *yongTuLabel;//用途
@property (nonatomic, strong) UIImageView *beiQiangImgView;//单已被抢
@property (nonatomic, strong) UIImageView *yiShenHeImageView; //已审核
@property (nonatomic, strong) UIImageView *rightArrowImgView; //右箭头

@property (nonatomic, strong) UIView *huiseyuandian1;
@property (nonatomic, strong) UIView *huiseyuandian2;
@property (nonatomic, strong) UIView *lineLabel;

@property(nonatomic ,weak) id<SSH_HomeQiangDanTableViewCellDelegate> delegate;
@property (nonatomic, strong) UIButton *shouCangBtn; //产品详情页-收藏按钮
// 设置索引
-(void)setChildBtnTag:(NSInteger)tag;


@property(nonatomic,assign)CGFloat timeWidth;

@property(nonatomic,assign)CGFloat less;
/* 判断是否是全国专区 **/
@property(nonatomic,assign)BOOL isQuanGuo;

@end
