//
//  SSQ_NEW_YtjudgeNeter.h
//  CCFinance
//
//  Created by liangyuan on 16/8/5.
//  Copyright © 2016年 chaoqianyan. All rights reserved.
//

#import <Foundation/Foundation.h>
//DENGFANG_YtjudgeNeter
@interface SSQ_NEW_YtjudgeNeter : NSObject
@property (nonatomic,assign,readonly,getter=YTIsConnectioner) BOOL YT_YTConnectioner;
@property (nonatomic,copy,readonly) NSString* YT_ytNetStatuser;

+(instancetype)YT_YTShareJudgeNeter;



@end
