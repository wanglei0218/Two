//
//  SSH_New_BDViewController.m
//  qianDanWang
//
//  Created by 小锦鲤 on 2019/8/20.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_New_BDViewController.h"
#import "SSH_New_SYBDTableViewCell.h"

static NSString *BDcellID = @"SSH_New_SYBDTableViewCell.h";
@interface SSH_New_BDViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *titleArr;
    NSArray *detailArr;
    BOOL _One;
    BOOL _Two;
    BOOL _Three;
    BOOL _Four;
}
@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) UIView *tabViewHeader;

@end

@implementation SSH_New_BDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _One = [[NSUserDefaults standardUserDefaults] boolForKey:@"bdOne"];
    _Two = [[NSUserDefaults standardUserDefaults] boolForKey:@"bdTwo"];
    _Three = [[NSUserDefaults standardUserDefaults] boolForKey:@"bdThree"];
    _Four = [[NSUserDefaults standardUserDefaults] boolForKey:@"bdFour"];
    
    titleArr = @[@"不威胁，恐吓客户",@"不欺骗，欺诈客户",@"不得向用户索取不雅照片",@"不得向用户收取非正当用费用"];
    detailArr = @[
                  [NSString stringWithFormat:@"在联系%@款客户时不得威胁,恐吓，侮辱客户",[DENGFANGSingletonTime shareInstance].name[2]],
                  [NSString stringWithFormat:@"不得虚构事实，隐瞒真相以误导，欺骗%@款用户，不得有任何欺诈%@款客户行为",[DENGFANGSingletonTime shareInstance].name[2],[DENGFANGSingletonTime shareInstance].name[2]],
                  [NSString stringWithFormat:@"不得向%@款用户索取不雅照片",[DENGFANGSingletonTime shareInstance].name[2]],
                  [NSString stringWithFormat:@"不得收取不正当服务费用，不得以“畅易%@”等名义向%@款用户收取任何费用。不得以“畅易%@”的工作人员的身份与%@款客户沟通",[DENGFANGSingletonTime shareInstance].name[1],[DENGFANGSingletonTime shareInstance].name[2],[DENGFANGSingletonTime shareInstance].name[1],[DENGFANGSingletonTime shareInstance].name[2]]
                  ];
    
    self.titleLabelNavi.text = @"使用必读";
    [self.view addSubview:self.tabView];
}

- (UIView *)tabViewHeader {
    if (!_tabViewHeader) {
        _tabViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        _tabViewHeader.backgroundColor = COLOR_WITH_HEX(0xffebd8);
        UILabel *lab = [[UILabel alloc] init];
        lab.font = UIFONTTOOL(12);
        lab.textColor = COLOR_WITH_HEX(0xea7302);
        lab.text = @"通知:";
        [_tabViewHeader addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(12);
            make.height.mas_offset(12);
            make.left.mas_offset(15);
            make.width.mas_offset(30);
        }];
        UILabel *labOne = [[UILabel alloc] init];
        labOne.font = UIFONTTOOL(12);
        labOne.textColor = COLOR_WITH_HEX(0xea7302);
        labOne.text = @"1、您需要同意以下每一项，才可以使用小象抢单服务；";
        [_tabViewHeader addSubview:labOne];
        [labOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(12);
            make.height.mas_offset(12);
            make.left.mas_offset(50);
        }];
        UILabel *labTwo = [[UILabel alloc] init];
        labTwo.font = UIFONTTOOL(12);
        labTwo.textColor = COLOR_WITH_HEX(0xea7302);
        labTwo.text = @"2、如发现以下行为，封号处理，金币不予退还。";
        [_tabViewHeader addSubview:labTwo];
        [labTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(27);
            make.height.mas_offset(12);
            make.left.mas_offset(50);
        }];
    }
    return _tabViewHeader;
}

- (UITableView *)tabView {
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, ScreenWidth, ScreenHeight - getRectNavAndStatusHight - SafeAreaAllBottomHEIGHT) style:UITableViewStyleGrouped];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.tableHeaderView = self.tabViewHeader;
        _tabView.tableFooterView = [UIView new];
        _tabView.estimatedRowHeight = 40;
        [_tabView registerNib:[UINib nibWithNibName:@"SSH_New_SYBDTableViewCell" bundle:nil] forCellReuseIdentifier:BDcellID];
    }
    return _tabView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SSH_New_SYBDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BDcellID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.TongYi = _One;
    } else if (indexPath.section == 1) {
        cell.TongYi = _Two;
    } else if (indexPath.section == 2) {
        cell.TongYi = _Three;
    } else if (indexPath.section == 3) {
        cell.TongYi = _Four;
    }
    cell.titleLab.text = titleArr[indexPath.section];
    cell.detailLab.text = detailArr[indexPath.section];
    cell.didSelectionButton = ^(UIButton * sender) {
        if (indexPath.section == 0) {
            sender.userInteractionEnabled = NO;
            [sender setTitle:@"我同意" forState:UIControlStateNormal];
            sender.backgroundColor = COLOR_WITH_HEX(0xbbbbbb);
            self->_One = YES;
            [[NSUserDefaults standardUserDefaults] setBool:self->_One forKey:@"bdOne"];
        } else if (indexPath.section == 1) {
            [sender setTitle:@"我同意" forState:UIControlStateNormal];
            sender.backgroundColor = COLOR_WITH_HEX(0xbbbbbb);
            self->_Two = YES;
            [[NSUserDefaults standardUserDefaults] setBool:self->_Two forKey:@"bdTwo"];
        } else if (indexPath.section == 2) {
            [sender setTitle:@"我同意" forState:UIControlStateNormal];
            sender.backgroundColor = COLOR_WITH_HEX(0xbbbbbb);
            self->_Three = YES;
            [[NSUserDefaults standardUserDefaults] setBool:self->_Three forKey:@"bdThree"];
        } else if (indexPath.section == 3) {
            [sender setTitle:@"我同意" forState:UIControlStateNormal];
            sender.backgroundColor = COLOR_WITH_HEX(0xbbbbbb);
            self->_Four = YES;
            [[NSUserDefaults standardUserDefaults] setBool:self->_Four forKey:@"bdFour"];
        }
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"   ";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"   ";
}

@end
