//
//  SSH_ViewController.m
//  DENGFANGSC
//
//  Created by LY on 2019/1/9.
//  Copyright © 2019年 DENGFANG. All rights reserved.
//

#import "SSH_ViewController.h"
#import "SSH_HomeCreditxinxiListModel.h"//列表cell的Model
#import "SSH_DiJiaTaoListCell.h"//抢单cell
#import "SSH_KeHuXiangQingViewController.h" //产品详情页

@interface SSH_ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic,strong) UITableView * daTableView;
@property (nonatomic,strong) NSMutableArray * allListData;

@property (nonatomic,strong)NSMutableArray * selectDataArr;
@property (nonatomic,strong)NSMutableArray * selectHeaderArr;
@property (nonatomic,strong)NSMutableArray * allCellArr;//所有的cell

@property (nonatomic, assign) NSInteger pageNum;//页数
@property (nonatomic, strong) NSString *  count;//更新的条数

@property (nonatomic, strong) UIView *noDataFatherView;
@property (nonatomic, strong) UIImageView *noDataImageView;
@property (nonatomic, strong) UILabel *noDataTitleLabel;

@end

@implementation SSH_ViewController

#pragma mark - 数据请求：列表数据
-(void)getCreditinfoListData{
    NSString *userId = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGCreditinfoListURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:userId],@"rows":[NSNumber numberWithInteger:HomeRows],@"page":[NSNumber numberWithInteger:self.pageNum],@"area":[DENGFANGSingletonTime shareInstance].mapCity,@"identityType":@"",@"qualification":@"",@"customerStatus":@"",@"mortgageType":@"",@"loanStartLimit":@"50000",@"loanEndLimit":@"",@"isDiscount":@"0",@"onlineLoan":@"0"} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dijiaTaodanList-- %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            if (self.pageNum == 1) {
                [self.allListData removeAllObjects];
            }
            for (NSDictionary *dict in diction[@"data"]) {
                
                SSH_HomeCreditxinxiListModel *model = [[SSH_HomeCreditxinxiListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.allListData addObject:model];
            }
            self.count = [NSString stringWithFormat:@"%@",diction[@"count"]];
            
            [self.daTableView reloadData];
            
            [self.daTableView.mj_header endRefreshing];
            [self.daTableView.mj_footer endRefreshing];
            
            NSArray * arr = diction[@"data"];
            if ( arr.count == 0) {
                [self.daTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (self.allListData.count==0) {
                //                self.daTableView.hidden = YES;
                //                self.noDataFatherView.hidden = NO;
                self.noDataTitleLabel.text = @"该地区内暂时没有此类客户,\n去选择本省其他城市吧";
                
            }else{
                //                self.daTableView.hidden = NO;
                //                self.noDataFatherView.hidden = YES;
            }
        }else{
            [self.daTableView.mj_footer endRefreshing];
            [self.daTableView.mj_header endRefreshing];
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self.daTableView.mj_header endRefreshing];
        [self.daTableView.mj_footer endRefreshing];
    }];
}


#pragma mark - 设置列表无数据时的页面
- (void)setUpNoDataView{
    self.noDataFatherView = [[UIView alloc] init];
    //    [self.normalBackView addSubview:self.noDataFatherView];
    self.noDataFatherView.backgroundColor = ColorBackground_Line;
    //    [self.noDataFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.mas_equalTo(self.normalBackView);
    //    }];
    
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
    
    //    self.noDataFatherView.hidden = YES;
}
//cell侧滑自定义

- (void)dingWeiShuaXinList{
    self.pageNum = 1;
    [self getCreditinfoListData];
}
#pragma mark 开始啦
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text = self.titleString;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dingWeiShuaXinList) name:SelectedCityAction object:nil];
//    self.goBackButton.hidden = YES;
    
    self.pageNum = 1;
    self.count = [NSDate dateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    
    self.normalBackView.backgroundColor = ColorBackground_Line;
    
    self.allListData = [[NSMutableArray alloc]init];
    
    
    self.allCellArr = [[NSMutableArray alloc]init];
    
    self.selectHeaderArr = [[NSMutableArray alloc]init];
    self.selectDataArr = [[NSMutableArray alloc]init];
    
    
    [self setupTableView];
    //数据加载
    [self getCreditinfoListData];//获取列表数据
    
    [self setUpNoDataView];//设置列表无数据时的页面
    
    
    
    UIView * line = [[UIView alloc]init];
    line.frame = CGRectMake(0, getRectNavAndStatusHight-0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = GrayLineColor;
    [self.view addSubview:line];
    
}
- (void)setupTableView{
    
    self.daTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.normalBackView addSubview:self.daTableView];
    [self.daTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.daTableView.delegate = self;
    self.daTableView.dataSource = self;
    self.daTableView.separatorStyle = 0;
    self.daTableView.backgroundColor = ColorBackground_Line;
    
    if (@available(iOS 11.0, *)) {
        self.daTableView.estimatedRowHeight = 0;
        self.daTableView.estimatedSectionHeaderHeight = 0;
        self.daTableView.estimatedSectionFooterHeight = 0;
    } else {
        // Fallback on earlier versions
    }
    
    UIView * headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 8);
    headView.backgroundColor = ColorBackground_Line;
    self.daTableView.tableHeaderView = headView;
    
    self.daTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getCreditinfoListData];
    }];
    
    self.daTableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        self.pageNum = self.pageNum + 1;
        [self getCreditinfoListData];
    }];
}

#pragma mark - tableView里的方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SSH_HomeCreditxinxiListModel *model = self.allListData[indexPath.row];;
    
    SSH_KeHuXiangQingViewController * productDetail = [[SSH_KeHuXiangQingViewController alloc]init];
    productDetail.isDiscount = model.isDiscount;
    productDetail.creditinfoId = model.creditinfoId;
    productDetail.fromWhere = 2;
    productDetail.hidesBottomBarWhenPushed = YES;
    productDetail.pageType = 1;
    [self.navigationController pushViewController:productDetail animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SSH_DiJiaTaoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dijiataodancell"];
    if (!cell) {
        cell = [[SSH_DiJiaTaoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dijiataodancell"];
    }
    if (self.allListData.count > 0) {
        cell.fromWhere = 0;
        cell.homeCellModel = self.allListData[indexPath.row];
    }
    
    cell.selectionStyle = 0;
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewWithYourSelfView:self.noDataFatherView forRowCount:self.allListData.count];
    return self.allListData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 252;
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
