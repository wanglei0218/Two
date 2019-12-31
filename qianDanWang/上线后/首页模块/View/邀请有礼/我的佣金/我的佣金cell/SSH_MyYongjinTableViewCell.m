//
//  SSH_MyYongjinTableViewCell.m
//  DENGFANGSC
//
//  Created by LY on 2019/1/22.
//  Copyright © 2019年 DENGFANG. All rights reserved.
//

#import "SSH_MyYongjinTableViewCell.h"

@implementation SSH_MyYongjinTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self wodeyongjinLayout];
    }
    return self;
}

- (void)wodeyongjinLayout{
    
    for (int i = 0; i < 4; i++) {
        UILabel *yaoQing_zhuangtai_Label = [[UILabel alloc] init];
        [self addSubview:yaoQing_zhuangtai_Label];
        yaoQing_zhuangtai_Label.textAlignment = 1;
        yaoQing_zhuangtai_Label.backgroundColor = [UIColor whiteColor];
        yaoQing_zhuangtai_Label.font = [UIFont systemFontOfSize:12];
        
        if (i== 3) {
            [yaoQing_zhuangtai_Label borderForColor:GrayLineColor borderWidth:0.5 borderType:UIBorderSideTypeBottom & UIBorderSideTypeRight];
        }else{
            [yaoQing_zhuangtai_Label borderForColor:GrayLineColor borderWidth:0.5 borderType:UIBorderSideTypeBottom & UIBorderSideTypeRight];
        }
        if (i>1) {
            yaoQing_zhuangtai_Label.textColor = COLOR_With_Hex(0xf66d35);
        }else{
            yaoQing_zhuangtai_Label.textColor = ColorBlack222;
        }
        
        [yaoQing_zhuangtai_Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ScreenWidth*i/4);
            make.width.mas_equalTo(ScreenWidth/4);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(45);
        }];
        
        [self.labelArray addObject:yaoQing_zhuangtai_Label];
    }
}

- (NSMutableArray<UILabel *> *)labelArray{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
