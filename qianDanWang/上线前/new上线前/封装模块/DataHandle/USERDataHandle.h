//
//  USERDataHandle.h
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/26.
//  Copyright © 2019 ***. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USERDataHandle : NSObject

+(USERDataHandle *)sharedDataHandle;


-(void)addOneData:(id)user;
-(void)deleteDataByID:(int)delID;
-(id)getAllDatas;
-(void)deleteTable;

@end

NS_ASSUME_NONNULL_END
