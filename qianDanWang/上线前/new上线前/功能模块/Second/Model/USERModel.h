//
//  USERModel.h
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/18.
//  Copyright © 2019 ***. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USERModel : NSObject

@property (nonatomic,assign)NSInteger ID;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *subTle;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *phoneNum;
@property (nonatomic,strong)NSString *elseName;
@property (nonatomic,strong)NSString *elsePhone;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString *address;

+ (NSArray *)creatModelWithArray:(NSArray *)array;


@end

NS_ASSUME_NONNULL_END
