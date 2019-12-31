//
//  SSH_SystemNotModel.h
//  DENGFANGSC
//
//  Created by 新民 on 2019/4/19.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//DENGFANGSystemNotModel
@interface SSH_SystemNotModel : NSObject

//@property(nonatomic,assign)NSInteger id;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *sort;
@property(nonatomic,copy) NSString *isShow;
@property(nonatomic,copy) NSString *createTime;
@property(nonatomic,copy) NSString *createUser;
@property(nonatomic,copy) NSString *updateTime;
@property(nonatomic,copy) NSString *updateUser;


@end

NS_ASSUME_NONNULL_END
