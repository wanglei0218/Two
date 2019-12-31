//
//  SSH_ZiZhiXinXiHeaderCollectionView.h
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/15.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_ShaiXuanModel.h"

NS_ASSUME_NONNULL_BEGIN
//DENGFANGZiZhiXinXiHeaderCollectionView
@interface SSH_ZiZhiXinXiHeaderCollectionView : UICollectionReusableView

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)NSArray *dataArray;


@property(nonatomic,copy) void(^MyBlock)(UIButton *);

///////////
//@property(nonatomic,strong)UIView *zhiMaFenBgView;
//@property(nonatomic,strong)UIView *xinYongKaBgView;
//@property(nonatomic,strong)UIButton *zhiMaButton;
//@property(nonatomic,strong)UIButton *xinYongKaButton;

@property(nonatomic,strong)UILabel * smallLabel;//标题label

@property(nonatomic,copy) NSString *zhiMaFenNameString;
@property(nonatomic,copy) NSString *xinYongKaNameString;
@property(nonatomic,copy) NSString *shouRuNameString;

@end

NS_ASSUME_NONNULL_END
