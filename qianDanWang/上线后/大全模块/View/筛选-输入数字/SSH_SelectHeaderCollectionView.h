//
//  SSH_SelectHeaderCollectionView.h
//  DENGFANGSC
//
//  Created by huang on 2018/10/19.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//DENGFANGSelectHeaderCollectionView
@interface SSH_SelectHeaderCollectionView : UICollectionReusableView

@property(nonatomic,strong)UIView * bgView;//背景view
@property(nonatomic,strong)UILabel * smallLabel;//标题label
@property(nonatomic,strong)UIView * bgTextView;//textField的背景
@property(nonatomic,strong)UITextField * leftTextField; //最低价
@property(nonatomic,strong)UITextField * rigthTextField;//最高价

@end

NS_ASSUME_NONNULL_END
