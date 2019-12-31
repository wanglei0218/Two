//
//  SSH_ZhiYeViewController.h
//  DENGFANGSC
//
//  Created by 河神 on 2019/5/15.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^judgeIsUploadBlock)(BOOL isUpload);
//DENGFANGZhiYeViewController
@interface SSH_ZhiYeViewController : SSQ_BaseNormalViewController

//身份证名字
@property(nonatomic,strong) NSString *card_name;
//身份证号码
@property(nonatomic,strong) NSString *card_id;

@property (nonatomic, assign) int isAuth;
@property (nonatomic,copy) judgeIsUploadBlock block;

@end

NS_ASSUME_NONNULL_END
