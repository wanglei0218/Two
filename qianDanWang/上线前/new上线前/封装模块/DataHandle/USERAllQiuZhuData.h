//
//  USERAllQiuZhuData.h
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/28.
//  Copyright © 2019 ***. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USERAllQiuZhuData : NSObject

+(USERDataHandle *)sharedAllDataHandle;

-(void)addOneData:(id)user;
-(void)deleteDataByID:(int)delID;
-(id)getAllDatas;
-(void)deleteTable;

@end

NS_ASSUME_NONNULL_END
