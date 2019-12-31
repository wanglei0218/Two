//
//  USERAddressViewController.h
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/19.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface USERAddressViewController : USERRootViewController

@property (nonatomic,assign)NSInteger typeID;

@property (nonatomic,strong)void(^dataBlock)(NSInteger);

@end

NS_ASSUME_NONNULL_END
