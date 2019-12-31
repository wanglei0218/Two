//
//  SSH_XinKeHuGuanLiController.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/5/10.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_XinKeHuGuanLiController.h"
#import "SSH_GeHuGuanLiCell.h"
#import "SSH_XinKeHuGuanLiModel.h"
#import "SSH_GengXinZhuangTaiModel.h"
#import "SSH_KeHuXiangQingViewController.h"

@interface SSH_XinKeHuGuanLiController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *backView;
/** 指示器view */
@property(nonatomic,weak)UIView *indicatorView;
/** 当前选中按钮 */
@property(nonatomic,weak)UIButton *selectedBtn;
/** 滑动View */
@property(nonatomic,weak)UIView *titleView;

@property(nonatomic,strong)UITableView *clientTableView;

@property (nonatomic,strong)NSString *sortStr;//默认值1：降序   0：升序
@property (nonatomic,assign)NSInteger orderStatus;//0：全部 1：未付中 2：成功
@property (nonatomic, assign) NSInteger pageNum;//页数
@property (nonatomic, assign) NSInteger lastRecordId;

@property (nonatomic, strong) UIView *noDataFatherView;
@property (nonatomic, strong) UIImageView *noDataImageView;
@property (nonatomic, strong) UILabel *noDataTitleLabel;
@property (nonatomic, strong) UIButton *noDataButton;

@property(nonatomic,strong)UIView *grayView; //蒙版

@property(nonatomic,strong)NSMutableArray *allListData;

@property(nonatomic,strong)SSH_XinKeHuGuanLiModel *listModel;
@property(nonatomic,strong)SSH_GengXinZhuangTaiModel *gengXinListM;

@property(nonatomic,strong)NSMutableArray *gengXinArray;
@property(nonatomic,strong)UIButton *selectBtn;

@property(nonatomic,strong)NSString *orderNo; //订单号
@property(nonatomic,assign)NSInteger refreshCellRow; //刷新的对应cell
@property(nonatomic,assign)NSInteger genJinID; //更新状态的id
@property(nonatomic,strong)NSString *updateStatus; //更新的状态

@end

@implementation SSH_XinKeHuGuanLiController

-(NSMutableArray *)allListData{
    if (!_allListData) {
        _allListData = [NSMutableArray array];
    }
    return _allListData;
}

-(NSMutableArray *)gengXinArray{
    if (!_gengXinArray) {
        _gengXinArray = [NSMutableArray array];
    }
    return _gengXinArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.clientTableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text = @"客户管理";
    self.lineView.hidden = NO;
    self.goBackButton.hidden = YES;
    self.normalBackView.backgroundColor = ColorBackground_Line;
    
    self.lastRecordId = 1;
    self.sortStr = @"1";
    self.orderStatus = 0;
    self.genJinID = 1;
    self.pageNum = 1;
    
    [self setTitleView];
    [self createTableView];
    [self setUpNoDataView];
    
    [self getDENGFANGFindOrderListData];
    [self getDENGFANGRecordQueListData];
}

- (void)createTableView{
    
    self.clientTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleView.mj_h, SCREEN_WIDTH, SCREENH_HEIGHT-self.titleView.mj_h-Height_NavBar-Height_TabBar) style:UITableViewStylePlain];
    [self.normalBackView addSubview:self.clientTableView];
    self.clientTableView.delegate = self;
    self.clientTableView.dataSource = self;
    self.clientTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.clientTableView.backgroundColor = ColorBackground_Line;
    if (@available(iOS 11.0, *)) {
        self.clientTableView.estimatedRowHeight = 0;
        self.clientTableView.estimatedSectionHeaderHeight = 0;
        self.clientTableView.estimatedSectionFooterHeight = 0;
    } else {
        // Fallback on earlier versions
    }
    
    [self.clientTableView registerClass:[SSH_GeHuGuanLiCell class] forCellReuseIdentifier:NSStringFromClass([SSH_GeHuGuanLiCell class])];
    
    self.clientTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loanNewData)];
    
    self.clientTableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loanMoreData)];
    
}

-(void)setTitleView{
    //添加滑动标题View
    UIView *titleView = [[UIView alloc] init];
    titleView.x = 0;
    titleView.y = 0;
    titleView.width = self.view.width;
    titleView.height = 40;
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [self.normalBackView addSubview:titleView];
    self.titleView = titleView;
    
    //添加红色指示View
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.height = 1.5;
    indicatorView.y = titleView.height - indicatorView.height;
    indicatorView.backgroundColor = ColorZhuTiHongSe;
    
    self.indicatorView = indicatorView;
    
    
    
    //添加二个按钮
    NSArray *titleArr = @[@"新订单",@"已处理"];
    CGFloat btnW = titleView.width / titleArr.count;
    CGFloat btnH = titleView.height;
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIButton *btn = [[UIButton alloc ] init];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = i * btnW;
        btn.y = 0;
        btn.tag = i+1;
        
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_WITH_HEX(0x222222) forState:UIControlStateNormal];
        [btn setTitleColor:ColorZhuTiHongSe forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(clickTitlebutton:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:btn];
        
        // 添加到titleLabels数组
//        [self.titleLabels addObject:btn];
        
        
        //默认第一个
        if (i == 0) {
            btn.enabled = NO;
            self.selectedBtn = btn;
            
            //默认第一个
            [btn.titleLabel sizeToFit];
            self.indicatorView.width = btn.titleLabel.width;
            self.indicatorView.centerX = btn.centerX;
            
        }
        
        //保证在self.titleView.subviews最后面
        [titleView addSubview:indicatorView];
    }
}

-(void)clickTitlebutton:(UIButton *)button{
    
    self.selectedBtn.enabled = YES;
    button.enabled = NO;
    self.selectedBtn = button;
    if (button.tag == 0) {
        [MobClick event:@"management"];
    } else {
        [MobClick event:@"management-all"];
    }
    [UIView animateWithDuration:0.25 animations:^{
        
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
        ;
    }];
    
    self.pageNum = 1;
    self.lastRecordId = button.tag;
    [self getDENGFANGFindOrderListData];
    
}

#pragma mark - 设置列表无数据时的页面
- (void)setUpNoDataView{
    
    self.noDataFatherView = [[UIView alloc] init];
    self.noDataFatherView.backgroundColor = ColorBackground_Line;
    
    self.noDataImageView = [[UIImageView alloc] init];
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
    
    self.noDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.noDataFatherView addSubview:self.noDataButton];
    self.noDataButton.layer.masksToBounds = YES;
    self.noDataButton.layer.cornerRadius = 15;
//    self.noDataButton.backgroundColor = ColorZhuTiHongSe;
    self.noDataButton.titleLabel.font = UIFONTTOOL13;
//    [self.noDataButton setTitle:@"马上去收藏" forState:UIControlStateNormal];
    [self.noDataButton addTarget:self action:@selector(maShangQuCollection) forControlEvents:UIControlEventTouchUpInside];
    [self.noDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.noDataTitleLabel.mas_bottom).offset(50);
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.noDataFatherView);
    }];
}

- (void)maShangQuCollection{
    self.tabBarController.selectedIndex = 0;
}

-(void)loanNewData{
    self.pageNum = 1;
    [self getDENGFANGFindOrderListData];
}
-(void)loanMoreData{
    self.pageNum = self.pageNum + 1;
    [self getDENGFANGFindOrderListData];
}



#pragma mark - tableView里的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    [tableView tableViewWithYourSelfView:self.noDataFatherView forRowCount:self.allListData.count];
    return self.allListData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SSH_GeHuGuanLiCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SSH_GeHuGuanLiCell class]) forIndexPath:indexPath];
    
    cell.selectionStyle = 0;
    cell.model = self.allListData[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(SSH_GeHuGuanLiCell *) weakCell = cell;
    cell.phoneBtnBlock = ^(UIButton * _Nonnull sender, BOOL flag) {
        if (flag) { //拨打电话
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",weakCell.model.mobile];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [weakSelf.view addSubview:callWebview];
        }else{   //更新状态
            weakSelf.orderNo = weakCell.model.orderNo;
            weakSelf.refreshCellRow = indexPath.row;
            [self gengXinZhuangTaiView];
        }
    };
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SSH_KeHuXiangQingViewController * productDetail = [[SSH_KeHuXiangQingViewController alloc] init];
    SSH_XinKeHuGuanLiModel * model1 = self.allListData[indexPath.row];
    productDetail.fromWhere = 3;
    productDetail.creditinfoId = model1.creditId;
    productDetail.pageType = 2;
    productDetail.orderNo = model1.orderNo;
    productDetail.shenQingTime = [NSString stringWithFormat:@"%@",model1.createTime];
    productDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:productDetail animated:YES];
}




-(void)gengXinZhuangTaiView{
    
    self.grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.tabBarController.view addSubview:self.grayView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toAction:)];
    [self.grayView addGestureRecognizer:tapGestureRecognizer];
    
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 12;
    [self.grayView addSubview:backView];
    self.backView = backView;
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"更新跟进状态";
    titleLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    titleLab.textColor = COLOR_WITH_HEX(0x222222);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.layer.cornerRadius = 12;
    [backView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    UIView *btnView = [[UIView alloc] init];
    [backView addSubview:btnView];
    
    CGFloat btnW = (SCREEN_WIDTH-15*4-12*2)/3;
    CGFloat btnH = 32;
    UIButton *btn;
    for (int i = 0; i < self.gengXinArray.count; i++) {
        self.gengXinListM = self.gengXinArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.gengXinListM.updateStatus forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:13]];
        [button setTitleColor:COLOR_WITH_HEX(0x222222) forState:UIControlStateNormal];
        [button setTitleColor:COLOR_WITH_HEX(0xffffff) forState:UIControlStateDisabled];
        [button setBackgroundImage:[UIImage imageNamed:@"按钮未选中"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"按钮选中"] forState:UIControlStateDisabled];
         [button addTarget:self action:@selector(gengXinListButton:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:button];
        button.tag = i;
        btn = button;
        
        int col = i/3; //0 0 0
        int row = i%3; //0 1 2
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15+(btnW+12)*row);
            make.top.mas_equalTo((btnH+12)*col);
            make.width.mas_equalTo(btnW);
            make.height.mas_equalTo(btnH);
        }];
        
        
        
    }
    
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(titleLab.mas_bottom);
        make.bottom.mas_equalTo(btn.mas_bottom).offset(15);
    }];
    
    [btnView layoutIfNeeded];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.grayView.mas_centerY);
        make.height.mas_equalTo(btnView.height+45+40);
    }];
    
    UIButton *yiChuLiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yiChuLiBtn setTitle:@"标记为已处理" forState:UIControlStateNormal];
    [yiChuLiBtn setTitleColor:COLOR_WITH_HEX(0xe63c3f) forState:UIControlStateNormal];
    [yiChuLiBtn addTarget:self action:@selector(clickYiChuLiButton) forControlEvents:UIControlEventTouchUpInside];
    yiChuLiBtn.layer.cornerRadius = 12;
    [backView addSubview:yiChuLiBtn];
    [yiChuLiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(btnView.mas_bottom);
        make.width.mas_equalTo(backView).multipliedBy(0.5);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = COLOR_WITH_HEX(0xdbdbdb);
    [btnView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0.5);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(btnView).multipliedBy(0.5);
    }];
    
    UIButton *gengXinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [gengXinBtn setTitle:@"更新状态" forState:UIControlStateNormal];
    [gengXinBtn setBackgroundImage:[UIImage imageNamed:@"更新状态"] forState:UIControlStateNormal];
    [gengXinBtn setTitleColor:COLOR_WITH_HEX(0xffffff) forState:UIControlStateNormal];
    [gengXinBtn addTarget:self action:@selector(clickGengXinButton) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:gengXinBtn];
    [gengXinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(yiChuLiBtn.mas_right);
        make.top.mas_equalTo(btnView.mas_bottom);
        make.right.bottom.mas_equalTo(0);
    }];
    
}

-(void)toAction:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.backView];
    if (point.y < 0 || point.y > self.backView.height) {
        [self.grayView removeFromSuperview];
        self.orderNo = nil;
    }
}

-(void)gengXinListButton:(UIButton *)btn{
    
    self.selectBtn.enabled = YES;
    btn.enabled = NO;
    self.selectBtn = btn;
    
    self.gengXinListM = self.gengXinArray[btn.tag];
    self.genJinID = self.gengXinListM.ID;
    self.updateStatus = self.gengXinListM.updateStatus;
    
    NSLog(@"genJinID == %ld",(long)self.genJinID);
}

//更新状态
-(void)clickGengXinButton{
    //更新 状态
    [self getOrderUpdataURL];
}
//标记为已处理
-(void)clickYiChuLiButton{
    //标记为已处理
    [self getYiChuLiBiaoJi];
}

#pragma mark - 退出登录事件
- (void)tuiChuLoginAction{
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:DENGFANGTokenKey];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:DENGFANGUserIDKey];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:DENGFANGPhoneKey];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:DENGFANGShowPhoneKey];
    
    [DENGFANGSingletonTime shareInstance].tokenString = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGTokenKey];
    [DENGFANGSingletonTime shareInstance].mobileString = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGPhoneKey];
    [DENGFANGSingletonTime shareInstance].useridString = 0;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DENGFANGLogOutObserverName object:nil];
    
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - 订单列表
-(void)getDENGFANGFindOrderListData{
    
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"rows":[NSNumber numberWithInteger:HomeRows],@"page":[NSNumber numberWithInteger:self.pageNum],@"sort":self.sortStr,@"orderStatus":[NSNumber numberWithInteger:self.orderStatus],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString],@"lastRecordId":@(self.lastRecordId)};
    
    NSLog(@"%@",dic);
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGFindOrderListURL parameters:dic success:^(id responsObject) {
//        [self.allListData removeAllObjects];
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"allData-- %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            if (self.pageNum == 1) {
                [self.allListData removeAllObjects];
            }
            for (NSDictionary *dict in diction[@"data"]) {
                SSH_XinKeHuGuanLiModel *model = [[SSH_XinKeHuGuanLiModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dict];
                
                [self.allListData addObject:model];
            }
            
            [self.clientTableView reloadData];
            [self.clientTableView.mj_header endRefreshing];
            [self.clientTableView.mj_footer endRefreshing];

            NSArray * arr = diction[@"data"];
            if ( arr.count == 0) {
                [self.clientTableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (self.allListData.count == 0) {
                
                self.noDataImageView.image = [UIImage imageNamed:@"一个客户都没有"];
                [self.noDataButton setTitle:@"马上去抢客户" forState:UIControlStateNormal];
                self.noDataButton.backgroundColor = ColorZhuTiHongSe;
                self.noDataButton.hidden = NO;
                if (self.orderStatus == 0 ) {
                    self.noDataTitleLabel.text = @"一个客户都没有";
                }else {
                    self.noDataTitleLabel.text = @"一个客户都没有抢";
                }
            }else{
                
            }
        }else if ([diction[@"code"] isEqualToString:@"10014"]){
            [self tuiChuLoginAction];
        }else if ([diction[@"code"] isEqualToString:@"10004"]) {
            [self tuiChuLoginAction];
            [SSH_ZhangHaoDongJieView showInSuperView:diction[@"msg"]];
        }else{
            [self.clientTableView.mj_header endRefreshing];
            [self.clientTableView.mj_footer endRefreshing];
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
        [self.clientTableView.mj_header endRefreshing];
        [self.clientTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 更新状态列表
-(void)getDENGFANGRecordQueListData{
    
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]};
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGRecordQueListURL parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"更新状态List -- %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            for (NSDictionary *dict in diction[@"data"]) {
                SSH_GengXinZhuangTaiModel *model = [[SSH_GengXinZhuangTaiModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dict];
                
                [self.gengXinArray addObject:model];
            }
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark - 修改跟进状态
-(void)getOrderUpdataURL{
    
    if (self.orderNo == nil || [self.orderNo isEqualToString:@""]) {
        [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请选择更新状态"];
        return;
    }
    
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString],@"orderNo":self.orderNo,@"lastRecordId":@(self.genJinID)};
    
//    NSLog(@"%ld",self.genJinID);
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGOrderUpdataStateURL parameters:dic success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"更新状态List -- %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [SSH_TOOL_GongJuLei showAlter:self.normalBackView WithMessage:@"更新成功！"];
            self.listModel = self.allListData[self.refreshCellRow];
            
            self.listModel.updateStatus = self.updateStatus;
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.refreshCellRow inSection:0];
            [self.clientTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            [self.grayView removeFromSuperview];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
            [self.grayView removeFromSuperview];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark - 标记为已处理
-(void)getYiChuLiBiaoJi{
    
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString],@"orderNo":self.orderNo,@"lastRecordId":@(2)};
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGOrderUpdataStateURL parameters:dic success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"更新状态List -- %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            [self.allListData removeObjectAtIndex:self.refreshCellRow];
            
        
             [SSH_TOOL_GongJuLei showAlter:self.normalBackView WithMessage:@"标记为已处理！"];
        
            [self.clientTableView reloadData];
            [self.grayView removeFromSuperview];
            
            if (self.allListData.count == 0) {
                self.noDataImageView.image = [UIImage imageNamed:@"一个客户都没有"];
                [self.noDataButton setTitle:@"马上去抢客户" forState:UIControlStateNormal];
                self.noDataButton.backgroundColor = ColorZhuTiHongSe;
                self.noDataButton.hidden = NO;
                if (self.orderStatus == 0 ) {
                    self.noDataTitleLabel.text = @"一个客户都没有";
                }else {
                    self.noDataTitleLabel.text = @"一个客户都没有抢";
                }
            }
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
            [self.grayView removeFromSuperview];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}


@end
