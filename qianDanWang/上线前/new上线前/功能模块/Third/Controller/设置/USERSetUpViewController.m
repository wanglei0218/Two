//
//  USERSetUpViewController.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/27.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERSetUpViewController.h"
#import "USERCodeLoginViewController.h"
#import "USERAgreementViewController.h"
#import "USERLoginViewController.h"

@interface USERSetUpViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *setTable;
@property (nonatomic,strong)NSArray *tableDataArr;
@property (nonatomic,strong)NSString *userName;
@property(nonatomic,strong)UIView *exitView;
@property(nonatomic,strong)UIButton *exitBtn;

@end

@implementation USERSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.rootNaviBaseTitle.text = @"设置";
    self.rootNaviBaseLine.hidden = NO;
    self.rootNaviBaseImg.backgroundColor = [UIColor whiteColor];
    self.tableDataArr = @[@"我的账户",@"隐私服务政策",@"安全中心"];
    
    [self setTable];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = BACKGROUND_Color;
    self.userName = [[NSUserDefaults standardUserDefaults]valueForKey:PHONE];
    [self.setTable reloadData];
}

- (UITableView *)setTable{
    if(!_setTable){
        _setTable = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth * 0.04, getRectNavAndStatusHight, ScreenWidth - ScreenWidth * 0.08, ScreenHeight - getRectNavAndStatusHight) style:UITableViewStyleGrouped];
        _setTable.delegate = self;
        _setTable.dataSource = self;
        _setTable.backgroundColor = BACKGROUND_Color;
        _setTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_setTable];
        
        _setTable.tableFooterView = self.exitView;
    }
    return _setTable;
}

- (UIView *)exitView{
    if (!_exitView) {
        _exitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , WidthScale(100))];
        _exitView.backgroundColor = [UIColor clearColor];
        
        // 退出登录
        self.exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.setTable.width, WidthScale(44))];
        self.exitBtn.center = CGPointMake(self.setTable.width/2, WidthScale(38));
        self.exitBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:WidthScale(18)];
        self.exitBtn.layer.cornerRadius = 8;
        self.exitBtn.layer.masksToBounds = YES;
        self.exitBtn.backgroundColor = TEXTFUCOLOR;
        [self.exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [self.exitBtn addTarget:self action:@selector(SignOutBttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [_exitView addSubview:self.exitBtn];
    }
    return _exitView;
}


#pragma mark ===================表格代理===================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"setCell"];
    }
    
    if(indexPath.row == 0){
        if(self.userName.length == 0 || [self.userName isEqualToString:@""]){
            cell.detailTextLabel.text = @"未登录";
        }else{
            NSString *name = [self.userName substringWithRange:NSMakeRange(3, 5)];
            NSString *all = [self.userName stringByReplacingOccurrencesOfString:name withString:@"*****"];
            cell.detailTextLabel.text = all;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.tableDataArr[indexPath.row];
    cell.layer.cornerRadius = 6;
    cell.layer.masksToBounds = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 1){
        NSLog(@"隐私");
        USERAgreementViewController *VC = [[USERAgreementViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if(indexPath.row == 2){
        NSLog(@"安全中心");
        USERCodeLoginViewController *codeVC = [[USERCodeLoginViewController alloc] init];
        codeVC.type = 2;
        [self.navigationController pushViewController:codeVC animated:YES];
    }
}


// 退出登录
- (void)SignOutBttonDidPress:(UIButton *)sender{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:TOKEN];
    if (token.length == 0) {
        USERLoginViewController *loginVC = [[USERLoginViewController alloc] init];
        UINavigationController *dengluNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:dengluNav animated:YES completion:nil];
        return;
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:TEXTSEN_Color forKey:@"titleTextColor"];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //响应事件
        NSLog(@"确定退出登录");
        NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        NSDictionary* dict = [defs dictionaryRepresentation];
        for(NSString *str in dict) {
            if ([str isEqualToString:TOKEN]) {
                [defs setValue:@"" forKey:TOKEN];
                [defs setValue:@"" forKey:PHONE];
            }
        }
        [defs synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    [defaultAction setValue:TEXTFUCOLOR forKey:@"titleTextColor"];
    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
