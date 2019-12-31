//
//  SSH_TJDZCollectionViewCell.m
//  qianDanWang
//
//  Created by 畅轻 on 2019/9/20.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_TJDZCollectionViewCell.h"

@implementation SSH_TJDZCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorBackground_Line;
    }
    return self;
}




- (void)setTitleStr:(NSString *)titleStr {
    if (titleStr) {
        _titleStr = titleStr;
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = titleStr;
        _titleLab.font = UIFONTTOOL13;
        _titleLab.textColor = ColorBlack222;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
        _titleLab.layer.cornerRadius = 16;
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.edges.mas_equalTo(self);
        }];
        self.layer.cornerRadius = 16;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = COLOR_WITH_HEX(0x0560F6);
        self.titleLab.textColor = UIColor.whiteColor;
    } else {
        self.backgroundColor = ColorBackground_Line;
        self.titleLab.textColor = ColorBlack222;
    }
}

@end
