//
//  SSH_ShaiXuanModel.h
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/21.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//DENGFANGShaiXuanModel
@interface SSH_ShaiXuanModel : NSObject

@property(nonatomic,copy) NSString *claCode;

@property(nonatomic,copy) NSString *conditionName;

@property(nonatomic,copy) NSArray *tydClassifySon;

@end


@interface SSH_ShaiXuanSonModel : NSObject

@property(nonatomic,copy) NSString *classifySonCode;

@property(nonatomic,copy) NSString *classifySonName;

@end



NS_ASSUME_NONNULL_END
