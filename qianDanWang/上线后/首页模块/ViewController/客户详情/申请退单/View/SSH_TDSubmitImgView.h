//
//  SSH_TDSubmitImgView.h
//  DENGFANGSC
//
//  Created by 河神 on 2019/5/11.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSH_XPTextView.h"
#import "SSH_BottomCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

//DENGFANGTDSubmitImgView
@interface SSH_TDSubmitImgView : UIView<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UIView *textShowView;
@property (nonatomic,strong)SSH_XPTextView *textView;
@property (nonatomic,strong)UICollectionView *imageCollection;
@property (nonatomic,strong)NSMutableArray *imageArr;
@property (nonatomic,strong)void (^didSelectTheAddImageBtn)(void);
@property (nonatomic,strong)void (^bottomTextViewText)(NSString *str);
@property (nonatomic,strong)void (^removerImage)(NSInteger tag);

@property (nonatomic,strong)UILabel *WordContLab;
@property (nonatomic,strong)UILabel *collShowLab;
@property (nonatomic,strong)UILabel *textShowLab;


@end

NS_ASSUME_NONNULL_END
