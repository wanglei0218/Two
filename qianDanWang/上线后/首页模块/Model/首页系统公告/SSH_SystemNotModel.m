//
//  SSH_SystemNotModel.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/4/19.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_SystemNotModel.h"

@implementation SSH_SystemNotModel

-(NSString *)createTime
{
    NSTimeInterval interval = [_createTime doubleValue] / 1000.0;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    return [fmt stringFromDate:date];
}

@end
