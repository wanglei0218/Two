//
//  SSH_XTXXImageCell.m
//  qianDanWang
//
//  Created by 畅轻 on 2019/9/25.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_XTXXImageCell.h"

@interface SSH_XTXXImageCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *contentLab;
@property (strong, nonatomic) IBOutlet UILabel *shouQiLab;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgViewH;

@end

@implementation SSH_XTXXImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SSH_MyMeessageModel *)model {
    if (model) {
        _model = model;
        self.titleLab.text = model.title;
        self.contentLab.text = model.content;
        [self.contentImg sd_setImageWithURL:[NSURL URLWithString:model.actiUrl]];
        if (model.cellIsShow) {
            float w = self.contentImg.image.size.width;
            float h = self.contentImg.image.size.height;
            self.imgViewH.constant = (h / w) * (ScreenWidth - 64);
        }else {
            self.imgViewH.constant = 40;
        }
        
//        float w = self.contentImg.size.width;
//        float h = self.contentImg.size.height;
//        self.contentImg.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>) (h / w) * (ScreenWidth - 64);
//        [self.contentImg mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo((h / w) * (ScreenWidth - 64));
//        }];
        self.shouQiLab.hidden = !model.cellIsShow;
        self.img.image = model.cellIsShow ? [UIImage imageNamed:@"shangla"] : [UIImage imageNamed:@"xiala"];
    }
}

- (IBAction)openOrshutButton:(UIButton *)sender {
    sender.selected = !sender.selected;
//    float w = self.contentImg.size.width;
//    float h = self.contentImg.size.height;
//    [self.contentImg mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo((h / w) * (ScreenWidth - 64));
//    }];
    self.cellHeightReload();
}

- (float)imgViewHeight {
    if (_imgViewHeight == 0.) {
        _imgViewHeight = self.contentImg.frame.size.height;
    }
    return _imgViewHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
