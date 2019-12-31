//
//  SSH_SelectCollectionCell.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/21.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_SelectCollectionCell.h"

@implementation SSH_SelectCollectionCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        [self createViewCell];
    }
    return self;
}

-(void)setClassifyModel:(SSH_ClassifyModel *)classifyModel
{
    _classifyModel = classifyModel;
    
    [self createViewCell];
}

-(void)createViewCell{
    self.bgView = [[UIView alloc]init];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.singleLabel = [[UILabel alloc]init];
    [self.bgView addSubview:self.singleLabel];
//    self.singleLabel.backgroundColor = CCRandomColor;
    if ([self.classifyModel.classifyCode isEqualToString:ShaiXuan_Qualification] || [self.classifyModel.classifyCode isEqualToString:ShaiXuan_IDentity_Type]) {
        self.singleLabel.backgroundColor = [UIColor whiteColor];
    }else{
        self.singleLabel.backgroundColor = ColorBackground_Line;
    }
    self.singleLabel.textColor = ColorBlack222;
    self.singleLabel.font = UIFONTTOOL12;
    self.singleLabel.layer.cornerRadius = 12;
    self.singleLabel.clipsToBounds = YES;
    self.singleLabel.layer.borderWidth = 0.5;
    self.singleLabel.layer.borderColor = (ColorBackground_Line).CGColor;
    self.singleLabel.textAlignment = NSTextAlignmentCenter;
    [self.singleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
}
@end
