//
//  SSH_New_QiYeViewController.m
//  qianDanWang
//
//  Created by 小锦鲤 on 2019/8/20.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_New_QiYeViewController.h"
#import "ZHFAddTitleAddressView.h"

@interface SSH_New_QiYeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZHFAddTitleAddressViewDelegate>
{
    NSArray *tabViewTitleArr;
    NSString *detailString;
    UILabel *detailLab;
    UITextField *tfOne;
    UITextField *tfTwo;
    NSString *stringName;
    NSString *jiedaoName;
}
@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) UIView *tabViewFooter;
@property(nonatomic,strong)ZHFAddTitleAddressView * addTitleAddressView;

@end

@implementation SSH_New_QiYeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text = @"公司信息";
    tabViewTitleArr = @[@"公司名称",@"所在区域",@"详细地址"];
    
    [self.view addSubview: self.tabView];
    
}

- (UIView *)tabViewFooter {
    if (!_tabViewFooter) {
        _tabViewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
        UIButton *but = [[UIButton alloc] init];
        [_tabViewFooter addSubview:but];
        [but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(25);
            make.height.mas_offset(40);
            make.left.mas_offset(29);
            make.right.mas_offset(-29);
        }];
        [but setTitle:@"提交" forState:UIControlStateNormal];
        but.backgroundColor = ColorZhuTiHongSe;
        but.layer.cornerRadius = 20;
        [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [but addTarget:self action:@selector(submitMessage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tabViewFooter;
}

- (void)submitMessage {
    
    [self.view endEditing:YES];
    
    if (tfOne.text.length == 0) {
        [MBProgressHUD showError:@"请输入公司名称"];
        return;
    } else if (tfOne.text.length < 2) {
        [MBProgressHUD showError:@"请输入正确公司名称"];
        return;
    } else if (tfTwo.text.length == 0) {
        [MBProgressHUD showError:@"请输入公司详细地址"];
        return;
    } else if (detailString.length == 0) {
        [MBProgressHUD showError:@"请选择公司所在地址"];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:stringName forKey:@"com_name"];
    [[NSUserDefaults standardUserDefaults] setObject:jiedaoName forKey:@"com_jiedao"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (UITableView *)tabView {
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight + 5, ScreenWidth, ScreenHeight - getRectNavAndStatusHight - 5) style:UITableViewStyleGrouped];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.tableFooterView = self.tabViewFooter;
    }
    return _tabView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"0821"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"0821"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = tabViewTitleArr[indexPath.section];
    
    if (indexPath.section == 0 || indexPath.section == 2) {
        UITextField *tf = [[UITextField alloc] init];
        tf.placeholder = indexPath.section==0?@"请输入公司名称":@"街道,楼牌号";
        tf.tag = 100 + indexPath.section;
        tf.textAlignment = NSTextAlignmentRight;
        tf.font = UIFONTTOOL(14);
        tf.delegate = self;
        [cell addSubview:tf];
        if (indexPath.section == 0) {
            tfOne = tf;
        } else {
            tfTwo = tf;
        }
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-15);
            make.top.mas_offset(12);
            make.bottom.mas_offset(-13);
            make.width.mas_offset(ScreenWidth-100);
        }];
    } else {
        detailLab = cell.detailTextLabel;
        detailLab.font = UIFONTTOOL(14);
        detailLab.text = @"请选择省市区";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSString *version= [UIDevice currentDevice].systemVersion;
    if(version.doubleValue >=11.0) {
        return 0;
    }else{
        // 针对 9.0 以下的iOS系统进行处理
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *version= [UIDevice currentDevice].systemVersion;
    if(version.doubleValue >=11.0) {
        if (section == 0) {
            return 7;
        }
        return 0;
    }else{
        // 针对 9.0 以下的iOS系统进行处理
        if (section == 0) {
            return 7;
        }
        return 0.1;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"   ";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"   ";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.section == 1) {
        self.addTitleAddressView = [[ZHFAddTitleAddressView alloc]init];
        self.addTitleAddressView.title = @"选择地址";
        self.addTitleAddressView.delegate1 = self;
        self.addTitleAddressView.defaultHeight = 350;
        self.addTitleAddressView.titleScrollViewH = 37;
        self.addTitleAddressView.fileName = @"address";
        [self.view addSubview:[self.addTitleAddressView initAddressView]];
        [self.addTitleAddressView addAnimate];
    }
}
-(void)cancelBtnClick:(NSString *)titleAddress titleID:(NSString *)titleID{
    if (titleAddress.length == 0) {
        
    } else {
        detailLab.text = titleAddress;
        detailString = titleAddress;
        [[NSUserDefaults standardUserDefaults] setObject:detailString forKey:@"com_diqu"];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 100) {
        stringName = textField.text;
    } else {
        jiedaoName = textField.text;
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 100) {
        if (textField.text.length > 19) {
            if (![string isEqualToString:@""]) {
                return NO;
            }
        }
        return YES;
    } else {
        return YES;
    }
}

@end
