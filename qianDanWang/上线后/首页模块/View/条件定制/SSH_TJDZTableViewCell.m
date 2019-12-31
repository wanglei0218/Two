//
//  SSH_TJDZTableViewCell.m
//  qianDanWang
//
//  Created by 畅轻 on 2019/9/20.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_TJDZTableViewCell.h"
#import "SSH_TJDZCollectionViewCell.h"

@interface SSH_TJDZTableViewCell ()

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation SSH_TJDZTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = ColorBackground_Line;
        [self settingCellStyle];
    }
    return self;
}

- (void)settingCellStyle {
    
    
    
}

- (void)setTitleStr:(NSString *)titleStr {
    if (titleStr) {
        _titleStr = titleStr;
        [self.contentView addSubview:self.titleLab];
        self.titleLab.text = titleStr;
    }
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 200, 16)];
        _titleLab.font = UIFONTTOOL16;
        _titleLab.textColor = ColorBlack222;
    }
    return _titleLab;
}

- (void)setNumber:(NSInteger)number {
    if (number) {
        _number = number;
        NSInteger intA = (number/3);
        float a = (float)intA;
        float b = (number/3.);
        if (a < b) {
            intA = intA + 1;
        }
        _collecView.frame = CGRectMake(30, 45, SCREEN_WIDTH - 60, intA*45);
    }
}

- (UICollectionView *)collecView {
    if (!_collecView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(97.5, 32.5);
        layout.minimumLineSpacing = 12;
        NSInteger intA = (self.number/3);
        float a = (float)intA;
        float b = (self.number/3.);
        if (a < b) {
            intA = intA + 1;
        }
        
        _collecView = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 45, SCREEN_WIDTH - 60, intA*45) collectionViewLayout:layout];
        _collecView.backgroundColor = UIColor.clearColor;
        [_collecView registerClass:[SSH_TJDZCollectionViewCell class] forCellWithReuseIdentifier:@"SSH_TJDZCollectionViewCell"];
        [self.contentView addSubview:self.collecView];
    }
    return _collecView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
