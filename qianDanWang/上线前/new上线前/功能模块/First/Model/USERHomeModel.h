//
//  USERHomeModel.h
//  USERPRODUCT
//
//  Created by 河神 on 2019/5/31.
//  Copyright © 2019 ***. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USERHomeModel : NSObject

@property (nonatomic,assign)int goodsId;
@property (nonatomic,strong)NSString *wupingming;
@property (nonatomic,strong)NSString *didian;
@property (nonatomic,strong)NSString *shijian;
@property (nonatomic,strong)NSString *tedian;
@property (nonatomic,strong)NSString *lianxifangshi;
@property (nonatomic,assign)NSInteger userid;

+(NSArray *)creatModelWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
