//
//  SSH_RenZhengWlView.h
//  qianDanWang
//
//  Created by 畅轻 on 2019/12/30.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SSH_ShenFenUploadViewlDelegate <NSObject>

-(void)shangChuanZhengBtnClicked:(UIButton *)btn;

@end


@interface SSH_RenZhengWlView : UIView

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
