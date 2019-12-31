//
//  SSH_DiJiaTaoListCell.h
//  DENGFANGSC
//
//  Created by LY on 2018/11/27.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_ImgANDLabelView.h"//左图右文字
#import "SSH_HomeCreditxinxiListModel.h"
#import "SSH_LabelANDLabelView.h"

@protocol SSH_HomeQiangDanTableViewCellDelegate <NSObject>

-(void)shouCangBtnClicked:(UIButton *)btn;
- (void)phoneButtonClicked:(UIButton *)sender;
@end
//DENGFANGDiJiaTaoListCell
@interface SSH_DiJiaTaoListCell : UITableViewCell

@property (strong, nonatomic) SSH_HomeCreditxinxiListModel *homeCellModel;

@property (nonatomic, assign) int fromWhere;//0:低价淘单列表 1:低价淘单详情 2:正常淘单详情
@property (nonatomic, strong) SSH_LabelANDLabelView *jieKuanJinEView;//金额
@property (nonatomic, strong) SSH_LabelANDLabelView *jieKuanQiXianView;//期限
@property (nonatomic, strong) SSH_LabelANDLabelView *yongTuView;//用途
@property (nonatomic, strong) UIView *sixLabelBackView;//六个标签的背景view
@property (nonatomic, strong) UIView *phoneNumberView;//手机号的view
@property (nonatomic, strong) UILabel *phoneLabel;//手机号label
@property (nonatomic, strong) UIButton *phoneBtn;//打电话按钮
@property (nonatomic, strong) UIButton *shouCangAlertButton;//收藏提示按钮
@property (nonatomic, strong) UIView *bottomGrayView;//底部灰色view
@property (nonatomic, strong) UIView *threeLineLabel;//第三条线

@property (nonatomic, strong) UIView *backContentView;//背景View
@property (nonatomic, strong) UILabel *customNameLabel;//客户姓名
//@property (nonatomic, strong) UILabel *biaoqian1;//标签1
//@property (nonatomic, strong) UILabel *biaoqian2;//标签2
@property (nonatomic, strong) UILabel *timeLabel;//发布时间
@property (nonatomic, strong) UIImageView *beiQiangImgView;//单已被抢
@property (nonatomic, strong) UIImageView *rightArrowImgView; //右箭头


@property (nonatomic, strong) UIView *huiseyuandian1;
@property (nonatomic, strong) UIView *huiseyuandian2;
@property (nonatomic, strong) UIView *lineLabel;

@property(nonatomic ,weak) id<SSH_HomeQiangDanTableViewCellDelegate> delegate;
@property (nonatomic, strong) UIButton *shouCangBtn; //产品详情页-收藏按钮
@property (nonatomic, strong) UILabel *dijiadan_label;//是否展示低价单

@property(nonatomic,strong)UIImageView *yiShenHeImageView;
@property(nonatomic,assign)CGFloat timeWidth;

@property(nonatomic,assign)CGFloat liulanWidth;
@property(nonatomic,strong)UILabel *liulanLab;

// 设置索引
-(void)setChildBtnTag:(NSInteger)tag;

@property(nonatomic,assign)CGFloat less;

/* 判断是否是全国专区 **/
@property(nonatomic,assign)BOOL isQuanGuo;

@end
