//
//  USERTouSuModel.h
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/7/2.
//  Copyright © 2019 ***. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USERTouSuModel : NSObject

+(USERTouSuModel *)sharedHomeDataHandel;

-(void)addOneData:(id)data;
-(void)deleteDataByID:(int)delID;
-(id)getAllDatas;
-(void)deleteTable;

@end

NS_ASSUME_NONNULL_END
