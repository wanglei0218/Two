//
//  USERGuanYuViewController.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/27.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERGuanYuViewController.h"

@interface USERGuanYuViewController ()

@end

@implementation USERGuanYuViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.rootNaviBaseImg.backgroundColor = [UIColor whiteColor];
    self.rootNaviBaseLine.hidden = NO;
    self.rootNaviBaseTitle.text = @"关于";
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
