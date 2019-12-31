//
//  SSH_ZheKouViewController.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/4/16.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_ZheKouViewController.h"
#import "SSH_HomeCreditxinxiListModel.h"
#import "SSH_KeHuXiangQingViewController.h"
#import "SSH_ShouYeListTableViewCell.h"

@interface SSH_ZheKouViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView *topBgVie;

@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong) NSMutableArray * allListData;

@property(nonatomic,strong)UILabel *topLabel;

@property (nonatomic, assign) NSInteger pageNum;//页数

@property(nonatomic,strong)NSMutableDictionary *dict;

/* 1 记录高额专区  车产、房产处理 **/
//@property(nonatomic,assign)int gaoEZhuanQu;
/* 判断是否是全国专区 **/
@property(nonatomic,assign)BOOL isQuanGuo;

@property (nonatomic, strong) UIView *noDataFatherView;
@property (nonatomic, strong) UIImageView *noDataImageView;
@property (nonatomic, strong) UILabel *noDataTitleLabel;

@property(nonatomic,strong) UIButton *closeButton;

@end

@implementation SSH_ZheKouViewController

-(NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.normalBackView.backgroundColor = ColorBackground_Line;
    self.titleLabelNavi.text = self.titleText;
    self.pageNum = 1;
    
    self.allListData = [NSMutableArray array];
    
    [self setupTopLabel];
    
    [self setupTableView];
    
    if ([self.flage isEqualToString:@"DISCOUNT"]) {
        [self getDENGFANGSystemData];
    }
    
    [self getListData];
    
    [self setUpNoDataView];//设置列表无数据时的页面
}

#pragma mark - 设置列表无数据时的页面
- (void)setUpNoDataView{
    self.noDataFatherView = [[UIView alloc] init];
    [self.normalBackView addSubview:self.noDataFatherView];
    self.noDataFatherView.backgroundColor = ColorBackground_Line;
    [self.noDataFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.normalBackView);
    }];
    
    self.noDataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiaoren_wushuju"]];
    [self.noDataFatherView addSubview:self.noDataImageView];
    [self.noDataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(79.5);
        make.width.mas_equalTo(139);
        make.height.mas_equalTo(113);
        make.centerX.mas_equalTo(self.noDataFatherView);
    }];
    
    self.noDataTitleLabel = [[UILabel alloc] init];
    [self.noDataFatherView addSubview:self.noDataTitleLabel];
    self.noDataTitleLabel.font = [UIFont systemFontOfSize:15];
    self.noDataTitleLabel.textColor = Colorbdbdbd;
    self.noDataTitleLabel.textAlignment = 1;
    self.noDataTitleLabel.numberOfLines = 0;
    [self.noDataTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.noDataImageView.mas_bottom).offset(14.5);
    }];
    
    self.noDataFatherView.hidden = YES;
}

-(void)setupTopLabel{
    
    UIView *bgview = [[UIView alloc] init];
    bgview.backgroundColor = COLOR_WITH_HEX(0xfdd9da);
    [self.view addSubview:bgview];
    self.topBgVie = bgview;
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton addTarget:self action:@selector(closeTopView) forControlEvents:UIControlEventTouchUpInside];
    [self.topBgVie addSubview:self.closeButton];
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"认证关闭"] forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = COLOR_WITH_HEX(0xe63c3f);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = UIFONTTOOL(11);
    [self.topBgVie addSubview:label];
    self.topLabel = label;
}

-(void)closeTopView{
    
    [self.topBgVie removeFromSuperview];
    self.topBgVie.frame = CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, 0);
    self.tableView.frame = CGRectMake(self.tableView.mj_x, self.tableView.mj_y+self.topBgVie.height, self.tableView.mj_w, self.tableView.mj_h+self.topBgVie.height);
}

-(void)setupTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getRectNavAndStatusHight+2);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    self.tableView.backgroundColor = ColorBackground_Line;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getListData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        self.pageNum = self.pageNum + 1;
        [self getListData];
    }];
}

#pragma mark 获取顶部认证数据
//首页未认证：NOT_AUTH  打折专区：DISCOUNT_AREA
-(void)getDENGFANGSystemData{
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil],@"sysTemCode":@"DISCOUNT_AREA"};
    
    NSString *url = @"sys/getSysTemInfo";
    
    [[DENGFANGRequest shareInstance] postWithUrlString:url parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            self.topLabel.text = diction[@"data"][@"systemMsg"];
            CGSize size = [self.topLabel.text sizeWithFont:UIFONTTOOL(11) maxW:SCREEN_WIDTH-10-10-17-10];
            self.topBgVie.frame = CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, size.height+6);
            self.closeButton.frame = CGRectMake(SCREEN_WIDTH-10-17, (self.topBgVie.height-17)*0.5, 17, 17);
            self.topLabel.frame = CGRectMake(10, 3, SCREEN_WIDTH-10-10-17-10, size.height);
            self.tableView.frame = CGRectMake(self.tableView.mj_x, self.tableView.mj_y+self.topBgVie.height, self.tableView.mj_w, self.tableView.mj_h+self.topBgVie.height);
            
        }
    } fail:^(NSError *error) {
    }];
}

#pragma mark - 资源列表数据请求
-(void)getListData{
    NSString *userId = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
    self.dict[@"timestamp"] = [NSString yf_getNowTimestamp];
    self.dict[@"signs"] = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:userId];
    self.dict[@"rows"] = [NSNumber numberWithInteger:HomeRows];
    self.dict[@"page"] = [NSNumber numberWithInteger:self.pageNum];
    self.dict[@"area"] = [DENGFANGSingletonTime shareInstance].mapCity;
    if ([self.flage isEqualToString:@"LARGE_AMOUNT"]) { //高额专区
        self.dict[@"loanStartLimit"] = [NSNumber numberWithInteger:50000];
        self.dict[@"isDiscount"] = @"0";
        self.dict[@"onlineLoan"] = @"0";
//        self.gaoEZhuanQu = 1;
    }else if ([self.flage isEqualToString:@"ONLINE_LOAN"]){ //全国专区
        self.dict[@"isDiscount"] = @"0";
        self.dict[@"onlineLoan"] = @"1";
        self.isQuanGuo = YES;
    }else{                       //折扣专区DISCOUNT
        self.dict[@"isDiscount"] = @"1";
        self.dict[@"onlineLoan"] = @"0";
    }
    
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGCreditinfoListURL parameters:self.dict success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"shouyeList--%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            if (self.pageNum == 1) {
                [self.allListData removeAllObjects];
                [self.tableView.mj_footer setHidden:NO];
                //                self.hud.hidden = YES;
                //                self.hud.removeFromSuperViewOnHide = YES;
            }
            
            for (NSDictionary *dict in diction[@"data"]) {
                
                SSH_HomeCreditxinxiListModel *model = [[SSH_HomeCreditxinxiListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.allListData addObject:model];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            NSArray * arr = diction[@"data"];
            if ( arr.count == 0) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView.mj_footer setHidden:YES];
            }
            
        }else{
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
        
        
        if (self.allListData.count==0) {
            self.tableView.hidden = YES;
            self.noDataFatherView.hidden = NO;
            self.noDataTitleLabel.text = @"该地区内暂时没有此类客户,\n去选择其他城市吧";
        }else{
            self.tableView.hidden = NO;
            self.noDataFatherView.hidden = YES;
        }
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        //        self.hud.hidden = YES;
        //        self.hud.removeFromSuperViewOnHide = YES;
    }];
}

#pragma mark - tableView里的方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SSH_HomeCreditxinxiListModel *model = self.allListData[indexPath.row];;
    
    SSH_KeHuXiangQingViewController *productDetail = [SSH_KeHuXiangQingViewController new];
//    productDetail.gaoEZhuanQu = self.gaoEZhuanQu;
    productDetail.isQuanGuo = self.isQuanGuo;
    productDetail.isDiscount = model.isDiscount;
    productDetail.creditinfoId = model.creditinfoId;
    productDetail.hidesBottomBarWhenPushed = YES;
    productDetail.pageType = 1;
    productDetail.fromWhere = 2;
    [self.navigationController pushViewController:productDetail animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SSH_ShouYeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"daquancell"];
    if (!cell) {
        cell = [[SSH_ShouYeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"daquancell"];
    }
//    cell.gaoEZhuanQu = self.gaoEZhuanQu;
    cell.isQuanGuo = self.isQuanGuo;
    cell.homeCellModel = self.allListData[indexPath.row];
    self.less = cell.less;
    cell.selectionStyle = 0;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allListData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 178 - self.less;
}

@end
