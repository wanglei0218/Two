//
//  SSH_YongHuLieBiaoPayingAndQiangedCell.h
//  DENGFANGSC
//
//  Created by huang on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_KeHuGuanLiListModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DENGFANGClientListPayingAndQiangedCellDelegate <NSObject>

-(void)payAndPhoneBtnClicked:(UIButton *)btn;

@end

//DENGFANGYongHuLieBiaoPayingAndQiangedCell
@interface SSH_YongHuLieBiaoPayingAndQiangedCell : UITableViewCell

@property (strong, nonatomic) SSH_KeHuGuanLiListModel *payListCellModel;

@property (nonatomic, strong) UIView *huiseyuandian1;
@property (nonatomic, strong) UIView *huiseyuandian2;

@property (nonatomic, strong) UIView *backContentView;//背景View
@property (nonatomic, strong) UILabel *customNameLabel;//客户姓名
//@property (nonatomic, strong) UILabel *biaoqian1;//标签1
//@property (nonatomic, strong) UILabel *biaoqian2;//标签2
@property (nonatomic, strong) UILabel *timeLabel;//发布时间
@property (nonatomic, strong) UILabel *jieDuoShaoLabel;//多少
@property (nonatomic, strong) UILabel *daiDuoJiuLabel;//多久
@property (nonatomic, strong) UILabel *yongTuLabel;//用途
@property (nonatomic, strong) UIImageView *rightArrowImgView; //右箭头
@property (nonatomic, strong) UILabel *payTime;//倒计时  或  抢单时间

@property (nonatomic, strong) UIButton *payAndPhoneBtn; //去支付或打电话按钮
@property (nonatomic,copy)void(^phoneBtnBlock)(UIButton *sender);
@property(nonatomic ,weak) id<DENGFANGClientListPayingAndQiangedCellDelegate> delegate;
// 设置索引
-(void)setChildBtnTag:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
