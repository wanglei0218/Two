//
//  SSH_DingYueHaoModel.m
//  DENGFANGSC
//
//  Created by LY on 2018/11/6.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_DingYueHaoModel.h"

@implementation SSH_DingYueHaoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(CGSize)contentText1Size{
    
    return [_contentText1 sizeWithFont:[UIFont systemFontOfSize:13] maxW:305-30];
}

-(CGSize)contentText2Size{
    
    return [_contentText2 sizeWithFont:[UIFont systemFontOfSize:13] maxW:305-30];
}

@end
