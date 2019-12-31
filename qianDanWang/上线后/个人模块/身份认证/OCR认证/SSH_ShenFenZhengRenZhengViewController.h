//
//  SSH_ShenFenZhengRenZhengViewController.h
//  DENGFANGSC
//
//  Created by 河神 on 2019/5/15.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^judgeIsUploadBlock)(BOOL isUpload);
//DENGFANGShenFenZhengRenZhengViewController
@interface SSH_ShenFenZhengRenZhengViewController : SSQ_BaseNormalViewController

@property (nonatomic, assign) int isAuth;
@property (nonatomic,copy) judgeIsUploadBlock block;

@end

NS_ASSUME_NONNULL_END
