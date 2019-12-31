//
//  SSH_TuiDanYuanYinChoose.h
//  DENGFANGSC
//
//  Created by 河神 on 2019/5/13.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//DENGFANGTuiDanYuanYinChoose
@interface SSH_TuiDanYuanYinChoose : NSObject

@property (nonatomic,assign) NSInteger ID;
@property (nonatomic,assign) NSInteger rules;
@property (nonatomic,strong) NSString *refundRules;
@property (nonatomic,strong) NSString *ruleDescription;
@property (nonatomic,strong) NSString *refundAmount;
@property (nonatomic,strong) NSString *sort;
@property (nonatomic,strong) NSString *isShow;
@property (nonatomic,assign) NSInteger createTime;

+ (NSArray *)creatArrayWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
