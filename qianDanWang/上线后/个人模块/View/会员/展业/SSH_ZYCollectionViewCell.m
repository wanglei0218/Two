//
//  SSH_ZYCollectionViewCell.m
//  qianDanWang
//
//  Created by AN94 on 9/16/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_ZYCollectionViewCell.h"

@implementation SSH_ZYCollectionViewCell


- (void)setCellCortolContentWithModel:(SSH_ZYModel *)model{
    /*
     @property (weak, nonatomic) IBOutlet UIImageView *backImage;
     @property (weak, nonatomic) IBOutlet UIImageView *rightTopImage;
     @property (weak, nonatomic) IBOutlet UILabel *nameLabel;
     @property (weak, nonatomic) IBOutlet UIImageView *headIamge;
     @property (weak, nonatomic) IBOutlet UILabel *numLabel;
     
     @property (nonatomic,strong)NSString *ID;                               ///<海报ID
     @property (nonatomic,strong)NSString *postersName;                      ///<海报名称
     @property (nonatomic,strong)NSString *postersUrl;                       ///<海报图片
     @property (nonatomic,strong)NSString *useNum;                           ///<使用数量
     @property (nonatomic,strong)NSString *isVip;                            ///<是否是vip海报
     @property (nonatomic,strong)NSString *isShow;                           ///<
     @property (nonatomic,strong)NSString *sort;                             ///<
     @property (nonatomic,strong)NSString *createTime;                       ///<时间
     
     */
    
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:model.postersUrl]];
    if([model.isVip isEqualToString:@"0"]){
        self.rightTopImage.hidden = YES;
    }else{
        self.rightTopImage.hidden = NO;
    }
    self.nameLabel.text = model.postersName;
    self.numLabel.text = [NSString stringWithFormat:@"%@人已使用",model.useNum];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
