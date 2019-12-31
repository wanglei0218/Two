//
//  SSQ_HiddenNavigationViewController.m
//  TaoYouDan
//
//  Created by LY on 2018/9/18.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSQ_HiddenNavigationViewController.h"

@interface SSQ_HiddenNavigationViewController ()

@end

@implementation SSQ_HiddenNavigationViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
