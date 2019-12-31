//
//  SSH_ShenFenZhengTiJiaoController.h
//  DENGFANGSC
//
//  Created by huang on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^judgeIsUploadBlock)(BOOL isUpload);
//ShenFenZhengTiJiaoController
@interface SSH_ShenFenZhengTiJiaoController : SSQ_BaseNormalViewController

@property (nonatomic, assign) int isAuth;
@property (nonatomic,copy) judgeIsUploadBlock block;

@end

NS_ASSUME_NONNULL_END
