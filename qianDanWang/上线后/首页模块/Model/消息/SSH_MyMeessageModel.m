//
//  SSH_MyMeessageModel.m
//  qianDanWang
//
//  Created by 畅轻 on 2019/9/25.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_MyMeessageModel.h"

@implementation SSH_MyMeessageModel

+ (NSArray *)getDataPushToModel:(NSArray *)dataArr {
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSDictionary *dic in dataArr) {
        SSH_MyMeessageModel *model = [[SSH_MyMeessageModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        model.cellIsShow = NO;
        model.cellRowHeight = [self backCellForRowHeightWithString:model.content];
        [mArr addObject:model];
    }
    return mArr;
}

+ (CGFloat)backCellForRowHeightWithString:(NSString *)string {
    return [SSH_TOOL_GongJuLei labelHeightLabelWithWidth:(ScreenWidth - 70) text:string font:14];
}

@end
