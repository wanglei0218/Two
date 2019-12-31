//
//  SSH_ShoyYeAcitvityCell.m
//  DENGFANGSC
//
//  Created by huang on 2018/10/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ShoyYeAcitvityCell.h"

@implementation SSH_ShoyYeAcitvityCell

- (void)setMiddleImageArr:(NSArray *)middleImageArr {
    _middleImageArr = middleImageArr;
    NSInteger activeCount = middleImageArr.count;
    if (activeCount == 0) {
        self.firstImgView.hidden = YES;
        self.secondImgView.hidden = YES;
        self.thirdImgView.hidden = YES;
    }else if (activeCount == 1){
        
        [self.firstImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
        }];
        [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",middleImageArr[0][@"bannerImgUrl"]]];
        [self.firstImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"690x150"]];
        self.firstImgView.hidden = NO;
        self.secondImgView.hidden = YES;
        self.thirdImgView.hidden = YES;
    }else if (activeCount == 2){
        
        [self.firstImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
            make.width.mas_equalTo((SCREEN_WIDTH-7-30)/2);
        }];
        
        [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [self.secondImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.firstImgView.mas_right).offset(7);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
            make.width.mas_equalTo((SCREEN_WIDTH-7-30)/2);
        }];
        [self.secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        NSURL *oneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",middleImageArr[0][@"bannerImgUrl"]]];
        NSURL *secondUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",middleImageArr[1][@"bannerImgUrl"]]];
        [self.firstImgView sd_setImageWithURL:oneUrl placeholderImage:[UIImage imageNamed:@"306x315"]];
        [self.secondImgView sd_setImageWithURL:secondUrl placeholderImage:[UIImage imageNamed:@"306x315"]];
        self.firstImgView.hidden = NO;
        self.secondImgView.hidden = NO;
        self.thirdImgView.hidden = YES;
        
    }else if (activeCount == 3){
        [self.firstImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
            make.width.mas_equalTo(SCREEN_WIDTH*153/375);
        }];
        [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [self.secondImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo((SCREEN_WIDTH*153/375*158/153-8)/2*185/75);
            make.height.mas_equalTo((SCREEN_WIDTH*153/375*158/153-8)/2);
        }];
        [self.secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [self.thirdImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.secondImgView.mas_bottom).offset(8);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo((SCREEN_WIDTH*153/375*158/153-8)/2*185/75);
            make.height.mas_equalTo((SCREEN_WIDTH*153/375*158/153-8)/2);
        }];
        
        [self.thirdButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        NSURL *oneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",middleImageArr[0][@"bannerImgUrl"]]];
        NSURL *secondUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",middleImageArr[1][@"bannerImgUrl"]]];
        NSURL *thirdUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",middleImageArr[2][@"bannerImgUrl"]]];
        [self.firstImgView sd_setImageWithURL:oneUrl placeholderImage:[UIImage imageNamed:@"306x315"]];
        [self.secondImgView sd_setImageWithURL:secondUrl placeholderImage:[UIImage imageNamed:@"338x150"]];
        [self.thirdImgView sd_setImageWithURL:thirdUrl placeholderImage:[UIImage imageNamed:@"369x150"]];
        self.firstImgView.hidden = NO;
        self.secondImgView.hidden = NO;
        self.thirdImgView.hidden = NO;
    }
}

- (void)setActiveCount:(NSInteger)activeCount{
    if (activeCount == 0) {
        self.firstImgView.hidden = YES;
        self.secondImgView.hidden = YES;
        self.thirdImgView.hidden = YES;
    }else if (activeCount == 1){
        
        [self.firstImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
        }];
        [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
//        self.firstImgView.image = [UIImage imageNamed:@"690x150"];
        self.firstImgView.hidden = NO;
        self.secondImgView.hidden = YES;
        self.thirdImgView.hidden = YES;
    }else if (activeCount == 2){
        
        [self.firstImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
            make.width.mas_equalTo((SCREEN_WIDTH-7-30)/2);
        }];

        [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];

        [self.secondImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.firstImgView.mas_right).offset(7);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
            make.width.mas_equalTo((SCREEN_WIDTH-7-30)/2);
        }];
        [self.secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
//        self.firstImgView.image = [UIImage imageNamed:@"306x315"];
//        self.secondImgView.image = [UIImage imageNamed:@"306x315"];

        
        self.firstImgView.hidden = NO;
        self.secondImgView.hidden = NO;
        self.thirdImgView.hidden = YES;
        
    }else if (activeCount == 3){
        [self.firstImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
            make.width.mas_equalTo(SCREEN_WIDTH*153/375);
        }];
        [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [self.secondImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo((SCREEN_WIDTH*153/375*158/153-8)/2*185/75);
            make.height.mas_equalTo((SCREEN_WIDTH*153/375*158/153-8)/2);
        }];
        [self.secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        [self.thirdImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.secondImgView.mas_bottom).offset(8);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo((SCREEN_WIDTH*153/375*158/153-8)/2*185/75);
            make.height.mas_equalTo((SCREEN_WIDTH*153/375*158/153-8)/2);
        }];
        
        [self.thirdButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
//        self.firstImgView.image = [UIImage imageNamed:@"306x315"];
//        self.secondImgView.image = [UIImage imageNamed:@"338x150"];
//        self.thirdImgView.image = [UIImage imageNamed:@"369x150"];

        self.firstImgView.hidden = NO;
        self.secondImgView.hidden = NO;
        self.thirdImgView.hidden = NO;
    }
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = ColorBackground_Line;
        [self createHomePageImgView];
    }
    return self;
}
-(void)createHomePageImgView{
    
    self.backView = [[UIView alloc] init];
    [self addSubview:self.backView];
    self.backView.backgroundColor = COLORWHITE;
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
    }];
    
    self.firstImgView = [[UIImageView alloc] init];
    self.firstImgView.tag = 400;
    [self.backView addSubview:self.firstImgView];
    self.firstImgView.userInteractionEnabled = YES;
    [self.firstImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.width.mas_equalTo((SCREEN_WIDTH-7-30)/2);
    }];
    
    self.secondImgView = [[UIImageView alloc] init];
    self.secondImgView.tag = 401;
    [self.backView addSubview:self.secondImgView];
    self.secondImgView.userInteractionEnabled = YES;
    [self.secondImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo((SCREEN_WIDTH*153/375*158/153-8)/2*185/75);
        make.height.mas_equalTo((SCREEN_WIDTH*153/375*158/153-8)/2);
    }];

    self.thirdImgView = [[UIImageView alloc] init];
    self.thirdImgView.tag = 402;
    [self.backView addSubview:self.thirdImgView];
    self.thirdImgView.userInteractionEnabled = YES;
    [self.thirdImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.secondImgView.mas_bottom).offset(8);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo((SCREEN_WIDTH*153/375*158/153-8)/2*185/75);
        make.height.mas_equalTo((SCREEN_WIDTH*153/375*158/153-8)/2);
    }];

    self.firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.firstImgView addSubview:self.firstButton];
    self.firstButton.tag = 410;
    [self.firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.secondImgView addSubview:self.secondButton];
    self.secondButton.tag = 411;
    [self.secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    self.thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.thirdImgView addSubview:self.thirdButton];
    self.thirdButton.tag = 412;
    [self.thirdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
