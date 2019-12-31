//
//  SSH_SelectHeaderCollectionView.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/19.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_SelectHeaderCollectionView.h"

@implementation SSH_SelectHeaderCollectionView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = ColorBackground_Line;
        [self createView];
    }
    return self;
}
- (void)createView{ //220
    
    self.bgView = [[UIView alloc]init];
    self.bgView.frame = CGRectMake(0, 0, self.mj_w, self.mj_h);
    self.bgView.backgroundColor = COLORWHITE;
    [self addSubview:self.bgView];
    
    //标题
    self.smallLabel = [[UILabel alloc]init];
    [self.bgView addSubview:self.smallLabel];
    self.smallLabel.textColor = ColorBlack222;
    self.smallLabel.font = UIFONTTOOL13;
    [self.smallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(self.mj_w-10);
        make.height.mas_equalTo(29);
    }];
    
    //textField
    self.bgTextView = [[UIView alloc]init];
    [self.bgView addSubview:self.bgTextView];
    [self.bgTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.smallLabel.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(34);
    }];
    
    self.leftTextField = [[UITextField alloc]init];
    [self.bgTextView addSubview:self.leftTextField];
    [self.leftTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo((self.mj_w-24-20)/2);
    }];
    self.leftTextField.backgroundColor = ColorBackground_Line;
    self.leftTextField.font = UIFONTTOOL12;
    self.leftTextField.textColor = ColorBlack222;
//    self.leftTextField.placeholder = @"最低价";
    self.leftTextField.textAlignment = NSTextAlignmentCenter;
    self.leftTextField.layer.cornerRadius = 12;
    self.leftTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.leftTextField.clipsToBounds = YES;
//    [self.leftTextField setValue:ColorBlack999 forKeyPath:@"_placeholderLabel.textColor"];
//    [self.leftTextField setValue:UIFONTTOOL12 forKeyPath:@"_placeholderLabel.font"];
self.leftTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"最低价" attributes:@{NSFontAttributeName:UIFONTTOOL12,NSForegroundColorAttributeName:ColorBlack999}];
    
    //中间的线条
    UIView * line = [[UIView alloc]init];
    [self.bgTextView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftTextField.mas_right).offset(2);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(10);
        make.centerY.mas_equalTo(self.leftTextField);
    }];
    line.backgroundColor = ColorBlack222;
    
 
    self.rigthTextField = [[UITextField alloc]init];
    [self.bgTextView addSubview:self.rigthTextField];
    [self.rigthTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.mas_equalTo(self.leftTextField);
        make.left.mas_equalTo(line.mas_right).offset(2);
    }];
    self.rigthTextField.backgroundColor = ColorBackground_Line;
    self.rigthTextField.font = UIFONTTOOL12;
    self.rigthTextField.textColor = ColorBlack222;
//    self.rigthTextField.placeholder = @"最高价";
    self.rigthTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.rigthTextField.textAlignment = NSTextAlignmentCenter;
    self.rigthTextField.layer.cornerRadius = 12;
    self.rigthTextField.clipsToBounds = YES;
//    [self.rigthTextField setValue:ColorBlack999 forKeyPath:@"_placeholderLabel.textColor"];
//    [self.rigthTextField setValue:UIFONTTOOL12 forKeyPath:@"_placeholderLabel.font"];
    self.rigthTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"最高价" attributes:@{NSFontAttributeName:UIFONTTOOL12,NSForegroundColorAttributeName:ColorBlack999}];
    self.bgTextView.hidden = YES;
}

@end
