//
//  USERHomeModel.m
//  USERPRODUCT
//
//  Created by 河神 on 2019/5/31.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERHomeModel.h"
#import "USERHomeDataHandel.h"

@implementation USERHomeModel

+ (NSArray *)creatModelWithArray:(NSArray *)array{
    
    NSMutableArray *marr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        USERHomeModel *model = [[USERHomeModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [[USERHomeDataHandel sharedHomeDataHandel] addOneData:model];
        [marr addObject:model];
    }
    return [marr copy];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    if ([key isEqualToString:@"id"]) {
//        self.ID = [value integerValue];
//    }
}

@end
