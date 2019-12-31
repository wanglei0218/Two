//
//  NSMutableArray+DENGFANGNoRepeatArray.m
//  TaoYouDan
//
//  Created by 锦鳞附体^_^ on 2018/11/26.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "NSMutableArray+DENGFANGNoRepeatArray.h"

@implementation NSMutableArray (DENGFANGNoRepeatArray)

- (void)tyd_NoRepeatDataAdd:(id)data {
    NSString *orderID = (NSString *)data;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",orderID];
    NSArray *resultArr = [self filteredArrayUsingPredicate:predicate];
    if (!resultArr.count) {
        [self addObject:data];
    }
}
@end
