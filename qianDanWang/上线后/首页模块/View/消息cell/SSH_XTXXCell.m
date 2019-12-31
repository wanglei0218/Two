//
//  SSH_XTXXCell.m
//  qianDanWang
//
//  Created by 畅轻 on 2019/9/24.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_XTXXCell.h"

@interface SSH_XTXXCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *contentLab;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *shouQiLab;

@end

@implementation SSH_XTXXCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SSH_MyMeessageModel *)model {
    if (model) {
        _model = model;
        self.titleLab.text = model.title;
        self.contentLab.text = model.content;
        self.shouQiLab.hidden = !model.cellIsShow;
        self.img.image = model.cellIsShow ? [UIImage imageNamed:@"shangla"] : [UIImage imageNamed:@"xiala"];
    }
}

- (IBAction)openOrShut:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.cellHeightReload();
}

@end
