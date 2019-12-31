//
//  SSH_HomeCreditxinxiListModel.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/26.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_HomeCreditxinxiListModel.h"

@implementation SSH_HomeCreditxinxiListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value == nil) {
        value = @"<null>";
    }
    [super setValue:value forKey:key];
}

@end
