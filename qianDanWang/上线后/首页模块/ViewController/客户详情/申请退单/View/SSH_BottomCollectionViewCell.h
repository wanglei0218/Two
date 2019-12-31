//
//  BottomCollectionViewCell.h
//  DENGFANGSC
//
//  Created by 河神 on 2019/5/11.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSH_BottomCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIButton *deleteBtn;
@property (nonatomic,strong)void (^deleteBtnTarget)(void);

@end

NS_ASSUME_NONNULL_END
