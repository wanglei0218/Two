//
//  SSH_CategoryItemView.h
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/29.
//  Copyright © 2017年 zhaoxu. All rights reserved.
//

#import <UIKit/UIKit.h>
//ZXCategoryItemView
@interface SSH_CategoryItemView : UICollectionViewCell

@property (nonatomic, copy) NSString *itemContent;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, assign) NSInteger index;

@end
