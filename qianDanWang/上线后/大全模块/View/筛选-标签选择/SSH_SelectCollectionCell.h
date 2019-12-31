//
//  SSH_SelectCollectionCell.h
//  DENGFANGSC
//
//  Created by huang on 2018/10/21.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_ClassifyModel.h"
NS_ASSUME_NONNULL_BEGIN
//DENGFANGSelectCollectionCell
@interface SSH_SelectCollectionCell : UICollectionViewCell
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)UILabel * singleLabel;
@property(nonatomic,strong)SSH_ClassifyModel *classifyModel;
@end

NS_ASSUME_NONNULL_END
