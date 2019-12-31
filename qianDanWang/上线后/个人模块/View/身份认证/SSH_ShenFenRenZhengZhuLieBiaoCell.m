//
//  SSH_ShenFenRenZhengZhuLieBiaoCell.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/23.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ShenFenRenZhengZhuLieBiaoCell.h"

@implementation SSH_ShenFenRenZhengZhuLieBiaoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createIDAuthMainListCell];
    }
    return self;
}

- (void)createIDAuthMainListCell{
    
    //左侧label
    self.leftLabel = [[UILabel alloc]init];
    self.leftLabel.frame = CGRectMake(15, 0.5, 66, 54.5);
    [self.contentView addSubview:self.leftLabel];
    self.leftLabel.textColor = Color000;
    self.leftLabel.font = UIFONTTOOL15;

    
    //线
    self.lineView = [[UIView alloc]init];
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor = GrayLineColor;
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-0.5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    //输入框
    self.myTextField = [[UITextField alloc]init];
    [self.contentView addSubview:self.myTextField];
    self.myTextField.font = UIFONTTOOL13;
    self.myTextField.textColor = Color000;
//    [self.myTextField setValue:ColorBlack999 forKeyPath:@"_placeholderLabel.textColor"];
//    [self.myTextField setValue:UIFONTTOOL13 forKeyPath:@"_placeholderLabel.font"];
    self.myTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:UIFONTTOOL13,NSForegroundColorAttributeName:ColorBlack999}];
    [self.myTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftLabel.mas_right).offset(30);
        make.top.bottom.mas_equalTo(0.5);
        make.right.mas_equalTo(-15);
    }];
    [self.myTextField addTarget:self action:@selector(textfieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    //箭头
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wodejiantou"]];
    [self.contentView addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(7.5);
        make.height.mas_equalTo(13);
        make.centerY.mas_equalTo(self);
    }];
    self.arrowImageView.hidden = YES;
    
    //实名
    self.myImageView = [[UIImageView alloc] init];
    self.myImageView.hidden = YES;
    self.myImageView.image = [UIImage imageNamed:@"ID-1"];
    [self.contentView addSubview:self.myImageView];
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowImageView.mas_left).offset(-8);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(self);
    }];
}

#pragma mark - private method
- (void)textfieldTextDidChange:(UITextField *)textField {
    if (self.block) {
        self.block(self.myTextField.text);
    }
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.myTextField becomeFirstResponder];
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
