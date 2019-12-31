//
//  SSH_BangZhuZhongXinController.m
//  DENGFANGSC
//
//  Created by LY on 2018/10/24.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_BangZhuZhongXinController.h"
#import "SSH_BangZhuZhongXinViewCell.h"
#import "SSH_BangZhuZhongXinModel.h"//帮助中心model

@interface SSH_BangZhuZhongXinController ()<UITableViewDataSource, UITableViewDelegate>{
    NSMutableDictionary *shouSuodiction;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SSH_BangZhuZhongXinViewCell *cell;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView *jiantouImgView;//sectionView上的箭头

@end

@implementation SSH_BangZhuZhongXinController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text = @"帮助中心";
    self.normalBackView.backgroundColor = ColorBackground_Line;
    self.dataArray = [NSMutableArray array];
    shouSuodiction = [NSMutableDictionary dictionary];
    [self getHelpeCenterData];
    [self setupView];
    
    
}

- (void)getHelpeCenterData{
    
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGHelpCenterURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil]} success:^(id responseObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            for (NSDictionary *dict in diction[@"data"]) {
                SSH_BangZhuZhongXinModel *model = [[SSH_BangZhuZhongXinModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
    } fail:^(NSError *error) {
        
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)setupView{
    self.view.backgroundColor = ColorBackground_Line;
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = ColorBackground_Line;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.normalBackView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
    }];
    self.cell = [self.tableView dequeueReusableCellWithIdentifier:@"DENGFANGHelpCenterTableViewCell"];
    self.tableView.estimatedRowHeight = 80;
    self.tableView.tableFooterView = [UIView new];
    //
//    UIView *bottomView = [[UIView alloc] init];
//    bottomView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:bottomView];
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(50);
//    }];
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    self.jiantouImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-12.5-15, 17, 12.5, 6.5)];
    [headView addSubview:self.jiantouImgView];
    _jiantouImgView.tag = 2000+section;
    NSString *string = [NSString stringWithFormat:@"%ld",section];
    if ([shouSuodiction[string] integerValue] == 1 ) {
        _jiantouImgView.image = [UIImage imageNamed:@"bangzhu_jiantou_shang"];
    }else{
        _jiantouImgView.image = [UIImage imageNamed:@"bangzhu_jiantou_xia"];
    }
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30-12.5, 40)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = ColorBlack222;
    [headView addSubview:titleLabel];
    SSH_BangZhuZhongXinModel *model = self.dataArray[section];
    titleLabel.text = model.problemTitle;
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
    [headView addSubview:lineLabel];
    lineLabel.backgroundColor = GrayLineColor;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView addSubview:button];
    button.frame = headView.bounds;
    [button addTarget:self action:@selector(clickSectionAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 6767030+section;
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = [NSString stringWithFormat:@"%ld",indexPath.section];
    if ([shouSuodiction[string] integerValue] == 1 ) {  //打开cell返回数组的count
        SSH_BangZhuZhongXinModel *model = self.dataArray[indexPath.section];
        CGFloat kHeight = [model.problemMsg boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
        
        return kHeight+30;
    }else{
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.cell = [[SSH_BangZhuZhongXinViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DENGFANGHelpCenterTableViewCell"];
    SSH_BangZhuZhongXinModel *model = self.dataArray[indexPath.section];
    self.cell.titleLabel.text = model.problemMsg;
    self.cell.selectionStyle = 0;
    
    
    return self.cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *string = [NSString stringWithFormat:@"%ld",section];
    
    if ([shouSuodiction[string] integerValue] == 1 ) {  //打开cell返回数组的count
        
        return 1;
    }else{
        
        return 0;
    }
}

- (void)clickSectionAction:(UIButton *)button{
    NSString *str = [NSString stringWithFormat:@"%ld",button.tag - 6767030];
    
    if ([shouSuodiction[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
        
        [shouSuodiction setObject:@"1" forKey:str];
        
    }else{//反之关闭cell
        
        [shouSuodiction setObject:@"0" forKey:str];
        
    }
    
    // [self.tableView reloadData];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[str integerValue]]withRowAnimation:UITableViewRowAnimationFade];//有动画的刷新
    
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
