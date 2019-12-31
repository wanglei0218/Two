//
//  SSH_MemberModel.m
//  qianDanWang
//
//  Created by AN94 on 9/23/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_MemberModel.h"

@implementation SSH_MemberModel

+ (instancetype)shardeInstance{
    SSH_MemberModel *model = [[SSH_MemberModel alloc]init];
    return model;
}

- (NSArray *)getvipModelWithData:(NSArray *)data{
    
    NSMutableArray *modelArr = [NSMutableArray array];
    
    for (NSDictionary *dic in data) {
        
        SSH_MemberModel *model = [[SSH_MemberModel alloc]init];
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
