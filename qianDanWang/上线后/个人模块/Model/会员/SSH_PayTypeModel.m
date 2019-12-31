
//
//  SSH_PayTypeModel.m
//  qianDanWang
//
//  Created by AN94 on 9/23/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_PayTypeModel.h"

@implementation SSH_PayTypeModel

+ (instancetype)shardeInstance{
    SSH_PayTypeModel *model = [[SSH_PayTypeModel alloc]init];
    return model;
}

- (NSArray *)getPayTypeWithData:(NSArray *)data{
    NSMutableArray *modelArr = [NSMutableArray array];
    
    for (NSDictionary *dic in data) {
        SSH_PayTypeModel *model = [[SSH_PayTypeModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [modelArr addObject:model];
    }
    
    return [modelArr copy];
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        self.ID = value;
    }
}

@end
