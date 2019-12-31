//
//  SSH_TuiDanYuanYinChoose.m
//  DENGFANGSC
//
//  Created by 河神 on 2019/5/13.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_TuiDanYuanYinChoose.h"

@implementation SSH_TuiDanYuanYinChoose


+ (NSArray *)creatArrayWithArray:(NSArray *)array{
    
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        SSH_TuiDanYuanYinChoose *model = [[SSH_TuiDanYuanYinChoose alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [mArr addObject:model];
    }
    return [mArr copy];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = [value integerValue];
    }
}

@end
