//
//  SSH_ZFCGViewController.m
//  DENGFANGSC
//
//  Created by LY on 2018/11/1.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_ZFCGViewController.h"
#import "SSH_ZFCGCell.h"

@interface SSH_ZFCGViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *leftTitleArray;
@property (nonatomic, strong) NSArray *rightValueArray;

@end

@implementation SSH_ZFCGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftTitleArray = @[@"支付金额：",@"商品面值：",@"充值优惠：",@"支付方式："];
    
    self.rightValueArray = @[self.zhifuMoney,self.mianzhiJinbi,self.huozengJinbi,self.zhifuStyle];
    [self setupView];
    
}





- (void)setupView{
    
    self.navigationView.hidden = YES;
    [self.normalBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(getStatusHeight);
    }];
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.normalBackView addSubview:self.myTableView];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = 0;
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.myTableView.backgroundColor = COLORWHITE;
    [self setupTableHeadView];
    [self setupTableFootView];
}

- (void)setupTableFootView{
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    self.myTableView.tableFooterView = footView;
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.backgroundColor = ColorZhuTiHongSe;
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    finishButton.titleLabel.font = UIFONTTOOL15;
    [footView addSubview:finishButton];
    finishButton.layer.masksToBounds = YES;
    finishButton.layer.cornerRadius = 20;
    [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32.5);
        make.right.mas_equalTo(-32.5);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(50.5);
    }];
    [finishButton addTarget:self action:@selector(finishButtonAciton) forControlEvents:UIControlEventTouchUpInside];
}


//完成
- (void)finishButtonAciton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupTableHeadView{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280)];
    self.myTableView.tableHeaderView = headView;
    headView.backgroundColor = ColorBackground_Line;
    
    UIView *headWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
    [headView addSubview:headWhiteView];
    headWhiteView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *chenggongImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhifu_chenggong"]];
    [headWhiteView addSubview:chenggongImgView];
    [chenggongImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.top.mas_equalTo(30);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(200);
    }];
    
    UILabel *payChenggongLable = [[UILabel alloc] init];
    [headWhiteView addSubview:payChenggongLable];
    payChenggongLable.text = @"支付成功";
    payChenggongLable.textColor = ColorBlack222;
    [payChenggongLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(chenggongImgView.mas_right).offset(12);
        make.top.mas_equalTo(45);
        make.right.mas_equalTo(-32.5);
        make.height.mas_equalTo(17);
    }];
    
    UILabel *chuliLabel = [[UILabel alloc] init];
    [headWhiteView addSubview:chuliLabel];
    chuliLabel.text = @"系统正在处理中";
    chuliLabel.textColor = ColorBlack222;
    [chuliLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(payChenggongLable);
        make.top.mas_equalTo(payChenggongLable.mas_bottom).offset(55.5);
    }];
    
    UILabel *chuliMiaoShuLabel = [[UILabel alloc] init];
    [headWhiteView addSubview:chuliMiaoShuLabel];
    chuliMiaoShuLabel.text = @"预计充值到账时间需要1分钟，因实际不可控原因，部分订单可能会出现延迟，请您以实际到账时间为准";
    chuliMiaoShuLabel.textColor = ColorBlack999;
    chuliMiaoShuLabel.font = UIFONTTOOL13;
    chuliMiaoShuLabel.numberOfLines = 0;
    [chuliMiaoShuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(chuliLabel);
        make.top.mas_equalTo(chuliLabel.mas_bottom).offset(10);
    }];
    
    UILabel *daozhangLabel = [[UILabel alloc] init];
    [headWhiteView addSubview:daozhangLabel];
    daozhangLabel.text = @"充值到账";
    daozhangLabel.textColor = ColorBlack222;
    [daozhangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(chuliLabel);
        make.bottom.mas_equalTo(chenggongImgView.mas_bottom).offset(-5);
    }];
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseid = @"SSH_ZFCGCell";
    SSH_ZFCGCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseid];
    if (!cell) {
        cell = [[SSH_ZFCGCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseid];
    }
    cell.titleNameLabel.text = self.leftTitleArray[indexPath.row];
    cell.valueLabel.text = self.rightValueArray[indexPath.row];
    cell.selectionStyle = 0;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
