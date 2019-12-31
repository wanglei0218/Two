//
//  SSH_ChongZhiLieBiaoCell.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ChongZhiLieBiaoCell.h"

@implementation SSH_ChongZhiLieBiaoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createChongZhiListCell];
    }
    return self;
}

- (void)createChongZhiListCell{
    self.leftImgView = [[UIImageView alloc]init];
    [self addSubview:self.leftImgView];
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(26);
        make.centerY.mas_equalTo(self);
    }];
    
    
    self.cellTitle = [[UILabel alloc]init];
    [self addSubview:self.cellTitle];
    self.cellTitle.textColor = ColorBlack222;
    self.cellTitle.font = UIFONTTOOL15;
    [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImgView.mas_right).offset(16);
        make.top.mas_equalTo(0.5);
        make.bottom.mas_equalTo(-0.5);
        make.width.mas_equalTo(200);
    }];
    
    self.line = [[UIView alloc]init];
    self.line.backgroundColor = ColorBackground_Line;
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.rightBtn];
    [self.rightBtn setImage:[UIImage imageNamed:@"chongzhifangshi_no"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"chongzhifangshi_sel"] forState:UIControlStateSelected];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(25);
        make.centerY.mas_equalTo(self);
    }];
    [self.rightBtn addTarget:self action:@selector(chongZhiRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)setChildBtnTag:(NSInteger)tag{
    self.rightBtn.tag = tag;
}
-(void)chongZhiRightBtnClicked:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(chongZhiRightBtnClicked:)]) {
        [self.delegate chongZhiRightBtnClicked:btn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
