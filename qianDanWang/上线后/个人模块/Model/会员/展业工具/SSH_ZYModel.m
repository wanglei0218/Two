//
//  SSH_ZYModel.m
//  qianDanWang
//
//  Created by AN94 on 9/20/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_ZYModel.h"

@implementation SSH_ZYModel

+ (instancetype)shardeInstance{
    SSH_ZYModel *model = [[SSH_ZYModel alloc]init];
    return model;
}

- (NSArray *)getSSH_ZYModelArrWithData:(NSArray *)data{
    NSMutableArray *mArr = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in data) {
        
        SSH_ZYModel *model = [[SSH_ZYModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [mArr addObject:model];
    }
    
    return [mArr copy];
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        self.ID = value;
    }
}

@end
