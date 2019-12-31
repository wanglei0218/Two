//
//  SSH_MemeberSecondeCollectionViewCell.m
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_MemeberSecondeCollectionViewCell.h"

@implementation SSH_MemeberSecondeCollectionViewCell

- (void)setSSH_MemberSecondeControlContentWithModel:(SSH_MemberModel *)model{
    /*
     cell.topImage.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
     cell.topLabel.text = [dic objectForKey:@"name"];
     cell.centerLabel.text = [dic objectForKey:@"content"];
     cell.bottomMoney.text = [dic objectForKey:@"money"];
     */
    
    /*
     @property (nonatomic,strong)NSString *ID;                   ///<id
     @property (nonatomic,strong)NSString *vipName;              ///<名称
     @property (nonatomic,strong)NSString *vipAmount;            ///<现价
     @property (nonatomic,strong)NSString *vipMaxAmount;         ///<原价
     @property (nonatomic,strong)NSString *vipDays;              ///<会员期限
     @property (nonatomic,strong)NSString *vipRefund;            ///<可退单次数
     @property (nonatomic,strong)NSString *createTime;           ///<创建时间
     @property (nonatomic,strong)NSString *vipIcon;              ///<图标
     */
    
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:model.vipIcon]];
    self.topLabel.text = model.vipName;
    self.centerLabel.text = [NSString stringWithFormat:@"%@次退单权限\n%@天会员期限",model.vipRefund,model.vipDays];
//    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:model.vipMaxAmount];
//    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, model.vipMaxAmount.length)];
    self.bottomMoney.text = [NSString stringWithFormat:@"%@元",model.vipAmounts];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
