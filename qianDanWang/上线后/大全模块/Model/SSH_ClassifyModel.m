//
//  SSH_ClassifyModel.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/30.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ClassifyModel.h"

@implementation SSH_ClassifyModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.classifyID = [value longValue];
    }
}
@end


@implementation SSH_ClassifyConditionModel



@end
