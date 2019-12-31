//
//  SSH_ShouyeChanpingXiangQingModel.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/31.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ShouyeChanpingXiangQingModel.h"

@implementation SSH_ShouyeChanpingXiangQingModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setValue:(id)value forKey:(NSString *)key{
    //    NSLog(@"key:%@----value:%@",key,value);
    if (value) {
//                NSLog(@"有值：key:%@----value:%@",key,value);
        [super setValue:value forKey:key];

    }else{
//                NSLog(@"无值：key:%@----value:%@",key,value);
        [super setValue:@"<null>" forKey:key];

    }
    if ([key isEqualToString:@"liabilities"]) {
//        NSLog(@"liabilities---%@",value);
    }
}

@end
