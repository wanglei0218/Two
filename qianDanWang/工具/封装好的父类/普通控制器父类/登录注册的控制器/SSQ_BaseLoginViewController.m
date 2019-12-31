//
//  SSQ_BaseLoginViewController.m
//  TaoYouDan
//
//  Created by LY on 2018/9/18.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSQ_BaseLoginViewController.h"

@interface SSQ_BaseLoginViewController ()

@end

@implementation SSQ_BaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.backView = [[UIView alloc] init];
    [self.view addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(getStatusHeight);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
