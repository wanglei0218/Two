//
//  DENGFANGIDShangChuanView.h
//  DENGFANGSC
//
//  Created by huang on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SSH_ShenFenUploadViewlDelegate <NSObject>

-(void)shangChuanZhengBtnClicked:(UIButton *)btn;

@end

//DENGFANGShenFenUploadView
@interface SSH_ShenFenUploadView : UIView
@property (nonatomic,strong)UIView * bigView;
@property (nonatomic,strong)UIImageView * bgImgView;
@property (nonatomic,strong)UIButton * phoneBtn; //相机的按钮
@property (nonatomic,strong)UILabel * myLabel;
@property (nonatomic,strong)UIButton * reSubmitBtn; //重新上传按钮

@property(nonatomic ,weak) id<SSH_ShenFenUploadViewlDelegate> delegate;

// 设置索引
-(void)setChildBtnTag:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
