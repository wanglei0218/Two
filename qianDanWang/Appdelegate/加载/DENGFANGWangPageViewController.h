//
//  YFwangyeViewController.h
//  YFRecycling
//
//  Created by 糖豆 on 2018/4/23.
//  Copyright © 2018年 糖豆. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^ FinishBlock)(BOOL isShow);

@interface DENGFANGWangPageViewController : UIViewController
@property (nonatomic , retain) NSString *urlStr;
@property (nonatomic , retain) NSString *colorstr;

/** 网页加载完成回调 */
@property (nonatomic,copy) FinishBlock finishBlock;




@end
