//
//  SSH_GongGaoController.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/4/16.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_GongGaoController.h"

@interface SSH_GongGaoController ()

@end

@implementation SSH_GongGaoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text = @"公告";
    self.navigationView.backgroundColor = ColorZhuTiHongSe;
    
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = COLOR_WITH_HEX(0x222222);
    titleLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.frame = CGRectMake(0, getRectNavAndStatusHight+11, SCREEN_WIDTH, 15);
    [self.view addSubview:titleLab];
    titleLab.text = self.systemM.title;
    
    
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.text = [NSString stringWithFormat:@"      %@",self.systemM.content];
    contentLab.textColor = COLOR_WITH_HEX(0x666666);
    contentLab.font = [UIFont systemFontOfSize:13];
    contentLab.textAlignment = NSTextAlignmentLeft;
    contentLab.numberOfLines = 0;
    contentLab.frame = CGRectMake(15, CGRectGetMaxY(titleLab.frame)+8, SCREEN_WIDTH-30, 1);
    [UILabel changeSpaceForLabel:contentLab withLineSpace:6 WordSpace:1];
    [self.view addSubview:contentLab];
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.textColor = COLOR_WITH_HEX(0x666666);
    timeLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.frame = CGRectMake(15, CGRectGetMaxY(contentLab.frame)+11, SCREEN_WIDTH-30, 13);
    [self.view addSubview:timeLab];
    timeLab.text = self.systemM.createTime;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
