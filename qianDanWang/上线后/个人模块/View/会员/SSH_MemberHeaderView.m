//
//  SSH_MemberHeaderView.m
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_MemberHeaderView.h"

@implementation SSH_MemberHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /*
         @property (nonatomic,strong)UIImageView *imageView;                         ///<背景图
         @property (nonatomic,strong)UIImageView *headerImage;                       ///<头像
         @property (nonatomic,strong)UILabel *nameLabel;                             ///<用户名称
         @property (nonatomic,strong)UILabel *dayLabel;                              ///<会员期限
         @property (nonatomic,strong)UIImageView *typeImage;                         ///<会员等级
         @property (nonatomic,strong)UIImageView *rightImage;                        ///<开通或续费
         */
        [self addSubview:self.imageView];
        [self addSubview:self.headerImage];
        [self addSubview:self.nameLabel];
        [self addSubview:self.dayLabel];
        [self addSubview:self.typeImage];
        [self addSubview:self.rightImage];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelecteTheHeaderView)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor redColor];
        
    }
    return self;
}

- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WidthScale(105))];
        _imageView.userInteractionEnabled = YES;
        _imageView.image = [UIImage imageNamed:@"bg1"];
    }
    return _imageView;
}

- (UIImageView *)headerImage{
    if(!_headerImage){
        _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(WidthScale(18), WidthScale(28), WidthScale(49), WidthScale(49))];
        _headerImage.userInteractionEnabled = YES;
        _headerImage.layer.cornerRadius = WidthScale(49)/2;
        _headerImage.layer.masksToBounds = YES;
    }
    return _headerImage;
}

- (UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = COLOR_WITH_HEX(0xfefefe);
        _nameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nameLabel;
}

- (UILabel *)dayLabel{
    if(!_dayLabel){
        _dayLabel = [[UILabel alloc]init];
        _dayLabel.textColor = COLOR_WITH_HEX(0x56628c);
        _dayLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dayLabel;
}

- (UIImageView *)typeImage{
    if(!_typeImage){
        _typeImage = [[UIImageView alloc]init];
        _typeImage.userInteractionEnabled = YES;
    }
    return _typeImage;
}

- (UIImageView *)rightImage{
    if(!_rightImage){
        _rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - WidthScale(95), WidthScale(40), WidthScale(80), WidthScale(25))];
        _rightImage.userInteractionEnabled = YES;
    }
    return _rightImage;
}

#pragma mark ================赋值方法==============
- (void)setMemberHeaderViewContentWithData:(NSDictionary *)data{
    
    //头像
    NSString *photoUrl = [data objectForKey:@"photoUrl"];
    
    if(photoUrl != nil){
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[data objectForKey:@"photoUrl"]]];
    }else{
        self.headerImage.image = [UIImage imageNamed:@"头像"];
    }
    //昵称
    NSString *name = [data objectForKey:@"newMobile"] == nil?[data objectForKey:@"mobile"]:[data objectForKey:@"newMobile"];
    self.nameLabel.text = name;
    //是否是vip
    NSString *isVip = [data objectForKey:@"isVip"];
    //是否已认证
//    NSString *isAuth = [data objectForKey:@"isAuth"];
    
    if([isVip isEqualToString:@"0"]){
        self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headerImage.frame) + WidthScale(14), WidthScale(44), name.length * WidthScale(14), WidthScale(20));
        
        self.rightImage.image = [UIImage imageNamed:@"kaitong"];
        
    }else{
        
        if(IS_PhoneXAll){
            
            if(IS_IPHONEX){
                self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headerImage.frame) + WidthScale(14), WidthScale(30), name.length * WidthScale(10), WidthScale(20));
            }else{
                self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headerImage.frame) + WidthScale(14), WidthScale(30), name.length * WidthScale(10), WidthScale(20));
            }
            
        }else{
            self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headerImage.frame) + WidthScale(14), WidthScale(30), name.length * WidthScale(10), WidthScale(20));
        }
        
        self.dayLabel.frame = CGRectMake(CGRectGetMaxX(self.headerImage.frame) + WidthScale(14), CGRectGetMaxY(self.nameLabel.frame) + WidthScale(13), WidthScale(150), WidthScale(20));
        
        self.dayLabel.text = [NSString stringWithFormat:@"%@到期",[data objectForKey:@"vipEndTime"]];
        
        self.typeImage.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + WidthScale(5), WidthScale(35), WidthScale(40), WidthScale(14));
    
        NSString *markUrl = [data objectForKey:@"markUrl"];
        
        [self.typeImage sd_setImageWithURL:[NSURL URLWithString:markUrl]];
        
        self.rightImage.image = [UIImage imageNamed:@"xvfei"];
        
    }
    
}

#pragma mark ================按钮点击方法===============
- (void)didSelecteTheHeaderView{
    if([self.delagate respondsToSelector:@selector(didSelecteTheMemberHeaderView)]){
        [self.delagate didSelecteTheMemberHeaderView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
