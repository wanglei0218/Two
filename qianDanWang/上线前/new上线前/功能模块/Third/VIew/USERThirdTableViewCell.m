//
//  USERThirdTableViewCell.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/18.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERThirdTableViewCell.h"

@implementation USERThirdTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithCreatViewUI];
    }
    return self;
}

-(void)initWithCreatViewUI{
    
    self.bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_beijing"]];
    [self addSubview:self.bgImgView];
    self.bgImgView.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self, WidthScale(10))
    .bottomSpaceToView(self, 0);
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];
    bgView.sd_layout
    .leftSpaceToView(self, WidthScale(15))
    .rightSpaceToView(self, WidthScale(15))
    .topSpaceToView(self, 0)
    .heightIs(WidthScale(69));
    
    
    self.iconImg = [[UIImageView alloc] init];
    [bgView addSubview:self.iconImg];
    self.iconImg.sd_layout
    .leftSpaceToView(bgView, WidthScale(13))
    .centerYEqualToView(bgView)
    .heightIs(WidthScale(21))
    .widthIs(WidthScale(21));
    
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.textColor = COLOR_With_Hex(0x222222);
    self.titleLab.font = [UIFont systemFontOfSize:WidthScale(15)];
    [bgView addSubview:self.titleLab];
    self.titleLab.sd_layout
    .leftSpaceToView(bgView, WidthScale(18))
    .centerYEqualToView(self.iconImg)
    .heightIs(WidthScale(15));
    [self.titleLab setSingleLineAutoResizeWithMaxWidth:WidthScale(150)];
    
    UIImageView *jiantouImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiao_jiantou"]];
    [bgView addSubview:jiantouImg];
    jiantouImg.sd_layout
    .rightSpaceToView(bgView, WidthScale(13))
    .centerYEqualToView(bgView)
    .heightIs(WidthScale(18))
    .widthIs(WidthScale(18));
    
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
