//
//  USERModel.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/18.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERModel.h"

@implementation USERModel

+ (NSArray *)creatModelWithArray:(NSArray *)array{
    
    NSMutableArray *marr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        USERModel *model = [[USERModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [marr addObject:model];
    }
    return [marr copy];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
