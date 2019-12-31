//
//  SSH_MyMeessageModel.h
//  qianDanWang
//
//  Created by 畅轻 on 2019/9/25.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSH_MyMeessageModel : NSObject

@property(nonatomic, assign)NSInteger id;
@property(nonatomic, strong)NSString *msgType;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *content;
@property(nonatomic, strong)NSString *actiUrl;
@property(nonatomic, assign)NSNumber *createTime;
@property(nonatomic, strong)NSString *createUser;
@property(nonatomic, strong)NSString *regisStartTime;
@property(nonatomic, strong)NSString *regisEndTime;
@property(nonatomic, strong)NSString *isShow;
@property(nonatomic, assign)float     cellRowHeight;
@property(nonatomic, assign)BOOL      cellIsShow;

+ (NSArray *)getDataPushToModel:(NSArray *)dataArr;

@end

NS_ASSUME_NONNULL_END
