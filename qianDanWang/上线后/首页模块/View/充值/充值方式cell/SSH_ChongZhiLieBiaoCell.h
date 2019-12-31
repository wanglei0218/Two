//
//  SSH_ChongZhiLieBiaoCell.h
//  DENGFANGSC
//
//  Created by huang on 2018/10/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DENGFANGChongZhiListCellDelegate <NSObject>

-(void)chongZhiRightBtnClicked:(UIButton *)btn;

@end

//DENGFANGChongZhiLieBiaoCell
@interface SSH_ChongZhiLieBiaoCell : UITableViewCell
@property (nonatomic, strong) UIImageView *leftImgView;//左侧icon
@property (nonatomic, strong) UILabel *cellTitle;//cell的标题
@property (nonatomic, strong) UIButton *rightBtn;//右侧的按钮
@property (nonatomic, strong) UIView *line;//线条

@property(nonatomic ,weak) id<DENGFANGChongZhiListCellDelegate> delegate;

// 设置索引
-(void)setChildBtnTag:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
