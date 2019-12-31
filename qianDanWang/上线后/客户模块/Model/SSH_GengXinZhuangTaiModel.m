//
//  SSH_GengXinZhuangTaiModel.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/5/13.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_GengXinZhuangTaiModel.h"

@implementation SSH_GengXinZhuangTaiModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = [value integerValue];
    }
}

@end
