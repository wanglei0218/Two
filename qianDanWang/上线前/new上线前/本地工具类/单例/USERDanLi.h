//
//  USERDanLi.h
//  USERPRODUCT
//
//  Created by 河神 on 2019/5/31.
//  Copyright © 2019 ***. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USERDanLi : NSObject

@property (nonatomic,copy) NSString *timestamp;

@property (nonatomic, strong) NSString *mapCity;//当前选择的城市

+ (instancetype)shareInstance;


@end

NS_ASSUME_NONNULL_END
