//
//  USERFirstViewController.m
//  USERPRODUCT
//
//  Created by 河神 on 2019/5/29.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERFirstViewController.h"
#import "USERFirstNormalHeader.h"
#import "USERHomeModel.h"
#import "USERHomeTableViewCell.h"
#import "ShangChengDingWeiViewController.h"
#import "USERFirstDetailsViewController.h"
#import "USERFirstTypeCollectionViewCell.h"
#import "USERSecondDetailsViewController.h"
#import "USERHomeDataHandel.h"
#import "USERTouSuModel.h"

@interface USERFirstViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,TYDLocationViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *tableHeadView;
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)NSArray *banneImageArr;
@property (nonatomic, strong)NSArray *tableDataArr;

@property (nonatomic, strong)UICollectionView *collcetionView;
@property (nonatomic, strong)NSArray *collectDataArr;

@property (nonatomic, assign) NSInteger cityID;//城市id

@end

@implementation USERFirstViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden = NO;
    
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rootNaviBaseTitle.text = @"首页";
    self.rootNaviBaseImg.image = [UIImage imageNamed:@"shouye_navbg"];
    self.rootNaviBaseImg.backgroundColor = [UIColor whiteColor];

    
    self.rootGoBackBtn.sd_layout
    .leftSpaceToView(self.rootNaviBaseImg, 15)
    .topSpaceToView(self.rootNaviBaseImg, getStatusHeight+7)
    .widthIs(105).heightIs(30);
    self.rootGoBackBtn.titleLabel.font = [UIFont systemFontOfSize:WidthScale(14)];
    [self.rootGoBackBtn setImage:[UIImage imageNamed:@"dizhi"] forState:UIControlStateNormal];
    [self.rootGoBackBtn setTitle:@" 全国" forState:UIControlStateNormal];
    [self.rootGoBackBtn addTarget:self action:@selector(goTodingweiView) forControlEvents:UIControlEventTouchUpInside];
    [self.rootGoBackBtn setTitleColor:COLOR_With_Hex(0x222222) forState:UIControlStateNormal];
    
    self.collectDataArr = @[@"顺路",@"家务",@"搬家",@"跑腿",@"带路",@"代驾"];
    
    [self.view addSubview:self.tableView];
    [self createBannerView];
    [self creatQiuZhuStyle];
    
}

#pragma mark 顶部banner轮播
-(void)createBannerView{
    
//    self.banneImageArr = @[@"http://app.ubanger.com/Public/upload/home/slider/20190202/5c552b1488ad1.png",@"http://app.ubanger.com/Public/upload/home/slider/20190201/5c5422b08b0c5.png",@"http://app.ubanger.com/Public/upload/home/slider/20190202/5c552b3a957ad.png"];
    self.banneImageArr = @[@"banner1",@"banner2",@"banner3"];
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, WidthScale(135)) delegate:self placeholderImage:nil];
    self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"圆点_实"];
    self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"圆点_透明"];
    self.cycleScrollView.autoScrollTimeInterval = 4.0;
    self.cycleScrollView.pageControlDotSize = CGSizeMake(5, 5);
    [self.tableHeadView addSubview:self.cycleScrollView];
    self.cycleScrollView.localizationImageNamesGroup = self.banneImageArr;
    
}

#pragma mark ------------ CreatCollectionView ----------

- (void)creatQiuZhuStyle{
    
    UIImageView *typeVIew = [[UIImageView alloc] initWithFrame:CGRectMake(WidthScale(0), self.cycleScrollView.bottom+WidthScale(15), ScreenWidth, (ScreenWidth-WidthScale(60))/8*2+WidthScale(30.0f)+WidthScale(135))];
    typeVIew.userInteractionEnabled = YES;
    typeVIew.image = [UIImage imageNamed:@"lianxiren_beijing"];
    [self.tableHeadView addSubview:typeVIew];
    
    
    UILabel *hotType = [[UILabel alloc] initWithFrame:CGRectMake(WidthScale(38), WidthScale(25), WidthScale(100), WidthScale(18))];
    hotType.text = @"热门求助类型";
    hotType.textColor = TEXTMAINCOLOR;
    hotType.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:WidthScale(16)];
    [typeVIew addSubview:hotType];
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //该方法也可以设置itemSize
    layout.itemSize = CGSizeMake((ScreenWidth-WidthScale(120))/3, (ScreenWidth-WidthScale(100))/8);
    
    //2.初始化collectionView
    self.collcetionView = [[UICollectionView alloc]initWithFrame:CGRectMake(WidthScale(30), hotType.bottom+WidthScale(10), ScreenWidth-WidthScale(60),(ScreenWidth-WidthScale(60))/8*2+WidthScale(15.0f)) collectionViewLayout:layout];
    [self.view addSubview:self.collcetionView];
    self.collcetionView.showsVerticalScrollIndicator = NO;
    self.collcetionView.showsHorizontalScrollIndicator = NO;

    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.collcetionView registerNib:[UINib nibWithNibName:@"USERFirstTypeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCellID"];
    //4.设置代理
    self.collcetionView.delegate = self;
    self.collcetionView.dataSource = self;
    self.collcetionView.scrollEnabled = NO;
    self.collcetionView.backgroundColor = [UIColor whiteColor];
    [typeVIew addSubview:self.collcetionView];
    
    
    UIButton *fabuBtn = [[UIButton alloc] initWithFrame:CGRectMake(WidthScale(45), self.collcetionView.bottom+WidthScale(20), ScreenWidth-WidthScale(90), WidthScale(44))];
    fabuBtn.layer.cornerRadius = 8;
    fabuBtn.layer.masksToBounds = YES;
    fabuBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:WidthScale(16)];
    fabuBtn.backgroundColor = MAINCOLOR1;
    [fabuBtn setBackgroundImage:[UIImage imageNamed:@"矩形2"] forState:UIControlStateNormal];
    [fabuBtn setTitle:@"发布求助" forState:UIControlStateNormal];
    [fabuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fabuBtn addTarget:self action:@selector(zidingyiTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [typeVIew addSubview:fabuBtn];
    
}

- (void)zidingyiTypeButtonClick:(UIButton *)sender{
    
    USERFirstDetailsViewController *detailsVC = [[USERFirstDetailsViewController alloc] init];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

#pragma mark --------- UICollectionViewDataSource ------------

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    USERFirstTypeCollectionViewCell *collCell = (USERFirstTypeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellID" forIndexPath:indexPath];
    
    collCell.layer.cornerRadius = 4;
    collCell.layer.masksToBounds = YES;
    
    collCell.titleLabel.text = self.collectDataArr[indexPath.row];
    collCell.bgImage.image = [UIImage imageNamed:self.collectDataArr[indexPath.row]];
    
    return collCell;
}

#pragma mark -------------- UICollectionViewDelegate ----------------
// 设置section分区的四边距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
}

//点击collectionViewCell触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.collcetionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
    USERFirstDetailsViewController *detailVC = [[USERFirstDetailsViewController alloc] init];
    detailVC.typeName = self.collectDataArr[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    
    NSString *strid = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN];
    if (strid.length == 0 || strid == nil || [strid isEqualToString:@""]) {

        return;
    }
    
}

// 两行cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}

// 两列cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, ScreenWidth, ScreenHeight-getRectNavAndStatusHight-getTabbarHeightNew) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = WidthScale(145);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, WidthScale(135)+(ScreenWidth-WidthScale(60))/8*2+WidthScale(30.0f)+WidthScale(100)+WidthScale(65))];
        self.tableView.tableHeaderView = self.tableHeadView;
        self.tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.mj_header = [USERFirstNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self requestData];
                // 2s后自动执行这个block里面的代码
                [self.tableView.mj_header endRefreshing];
            });
        }];
        
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    USERHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[USERHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    USERHomeModel *model = self.tableDataArr[indexPath.row];
    
    cell.wupinLabel.text = [NSString stringWithFormat:@"物品类型：%@",model.wupingming];
    [self changeTextLab:cell.wupinLabel stringArray:@[@"物品类型：",model.wupingming] colorArray:@[COLOR_With_Hex(0x222222),MAINCOLOR1] fontArray:@[@"12",@"12"]];
    
    cell.timeLable.text = [NSString stringWithFormat:@"%@",model.shijian];
    
    cell.addressLable.text = [NSString stringWithFormat:@"丢失地址：%@",model.didian];
    [self changeTextLab:cell.addressLable stringArray:@[@"丢失地址：",model.didian] colorArray:@[COLOR_With_Hex(0x222222),COLOR_With_Hex(0x999999)] fontArray:@[@"12",@"12"]];

    cell.tedianLable.text = [NSString stringWithFormat:@"物品特征：%@",model.tedian];
    [self changeTextLab:cell.tedianLable stringArray:@[@"物品特征：",model.tedian] colorArray:@[COLOR_With_Hex(0x222222),COLOR_With_Hex(0x999999)] fontArray:@[@"12",@"12"]];

    [cell.phoneButton setTitle:[NSString stringWithFormat:@"  %@",model.lianxifangshi] forState:UIControlStateNormal];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, WidthScale(60))];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *headLable = [[UILabel alloc] initWithFrame:CGRectMake(WidthScale(15), WidthScale(15), ScreenWidth-WidthScale(30), WidthScale(40))];
    headLable.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:WidthScale(18)];
    headLable.textColor = COLOR_With_Hex(0x222222);
    headLable.text = @"寻物启事";
    [headView addSubview:headLable];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return WidthScale(60);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return WidthScale(0.1f);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    USERHomeModel *model = self.tableDataArr[indexPath.row];

    USERSecondDetailsViewController *detailVC = [[USERSecondDetailsViewController alloc]init];
    detailVC.goodsId = model.goodsId;
    detailVC.qufenTag = 0;
    [self.navigationController pushViewController:detailVC animated:YES];
}

//数据请求
- (void)requestData{
    [USERNetWorkClass getWithUrlString:@"http://121.43.187.125/ftpmz/home/Index/suoyouxunwu" parameters:[NSDictionary dictionary] success:^(id  _Nonnull json) {
        
//        self.tableDataArr = [USERHomeModel creatModelWithArray:json];
        
        NSArray *jsonArr = @[
                            @{
                                @"wupingming":@"钱包",
                                @"didian":@"东莞市红心广场",
                                @"shijian":@"10-12 10:30",
                                @"tedian":@"一个破旧的钱包，里面有100多元钱和一张银行卡",
                                @"lianxifangshi":@"15897128368",
                                @"userid":@"3"
                            },
                            @{
                                @"wupingming":@"雨伞",
                                @"didian":@"广州火车站",
                                @"shijian":@"10-11 12:35",
                                @"tedian":@"一把可折叠的雨伞，红色的，非常旧不值什么钱",
                                @"lianxifangshi":@"15512981280",
                                @"userid":@"2"
                            },
                            @{
                                @"wupingming":@"背包",
                                @"didian":@"广州市高铁站",
                                @"shijian":@"10-10 15:30",
                                @"tedian":@"背包里没什么贵重物品，有一本书和一件衣服，说出书名即可",
                                @"lianxifangshi":@"13632903257",
                                @"userid":@"1"
                            },
                            @{
                                @"wupingming":@"外套",
                                @"didian":@"广州市高铁站",
                                @"shijian":@"10-10 18:00",
                                @"tedian":@"一件黑色皮衣、拉链式的外套，失主看到认领",
                                @"lianxifangshi":@"13413829765",
                                @"userid":@"4"
                            },
                            @{
                                @"wupingming":@"手提包",
                                @"didian":@"广州市高铁站",
                                @"shijian":@"10-10 19:20",
                                @"tedian":@"一个黑色的男士小提包，提包里几个文件",
                                @"lianxifangshi":@"13876610926",
                                @"userid":@"5"
                            },
                            @{
                                @"wupingming":@"雨伞",
                                @"didian":@"苏州市 阳澄湖",
                                @"shijian":@"10-14 13:00",
                                @"tedian":@"一把黑色的遮阳伞，可自动折叠，刚买一个月，希望捡到的好心人归还。",
                                @"lianxifangshi":@"15936045686",
                                @"userid":@"18"
                            },
                            @{
                                @"wupingming":@"身份证",
                                @"didian":@"南京高铁站到精金花园",
                                @"shijian":@"2019.10.12",
                                @"tedian":@"身份证",
                                @"lianxifangshi":@"15151832361",
                                @"userid":@"25"
                            },
                            @{
                                @"wupingming":@"日记本",
                                @"didian":@"苏州 项城区",
                                @"shijian":@"10-13 10:39",
                                @"tedian":@"黑色日记本",
                                @"lianxifangshi":@"13658632758",
                                @"userid":@"18"
                            },
                            @{
                                @"wupingming":@"黑色钱包",
                                @"didian":@"八卦岭附近",
                                @"shijian":@"2019年10月12号晚8点左右",
                                @"tedian":@"保罗polo 身份证 驾照银行卡",
                                @"lianxifangshi":@"13510929208",
                                @"userid":@"36"
                            },
                            @{
                                @"wupingming":@"背包",
                                @"didian":@"厦门软二",
                                @"shijian":@"2019.10.12 上午10点",
                                @"tedian":@"黑色",
                                @"lianxifangshi":@"15880212022",
                                @"userid":@"37"
                            },
                            @{
                                @"wupingming":@"零钱包",
                                @"didian":@"上海浦东国际机场，春秋摆渡车",
                                @"shijian":@"2019年9月30曰",
                                @"tedian":@"内有身份证2张银行卡2张，三十几元零钱，零钱包黑白两色",
                                @"lianxifangshi":@"18817900373",
                                @"userid":@"90"
                            },
                            @{
                                @"wupingming":@"行李箱",
                                @"didian":@"深圳岗厦站到竹子林",
                                @"shijian":@"2019-10-10 上午11点",
                                @"tedian":@"格子行李箱",
                                @"lianxifangshi":@"15899789072",
                                @"userid":@"117"
                            },
                            @{
                                @"wupingming":@"证件身份证",
                                @"didian":@"江苏省张家港市王府广场极速网咖",
                                @"shijian":@"2019/10/6",
                                @"tedian":@"身份证姓名马林东乡族",
                                @"lianxifangshi":@"15250363559",
                                @"userid":@"276"
                            }
                                ];
        
        
        
        NSArray *array1 = [[USERHomeDataHandel sharedHomeDataHandel] getAllDatas];
        NSArray *array = [[USERTouSuModel sharedHomeDataHandel] getAllDatas];
        
        if (array1.count == 0) {

            for (NSDictionary *dic in jsonArr) {
                USERHomeModel *model = [[USERHomeModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [[USERHomeDataHandel sharedHomeDataHandel] addOneData:model];
                
                if (array.count!=0) {
                    for (int i=0; i<array.count; i++) {
                        USERHomeModel *one = array[i];
                        if (one.userid != model.userid) {
                            [[USERHomeDataHandel sharedHomeDataHandel] deleteDataByID:model.goodsId];
                        }
                    }
                }
            }
        }else{
            
            for (int y=0; y<array1.count; y++) {
                USERHomeModel *model = array1[y];
                if (array.count!=0) {
                    for (int i=0; i<array.count; i++) {
                        USERHomeModel *one = array[i];
                        if (one.userid == model.userid) {
                            [[USERHomeDataHandel sharedHomeDataHandel] deleteDataByID:model.goodsId];
                        }
                    }
                }
            }
        }
        
        
        self.tableDataArr = [[USERHomeDataHandel sharedHomeDataHandel] getAllDatas];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [SVProgressHUD showWithStatus:@"网络连接失败"];
    }];
}

- (void)goTodingweiView{
    
    ShangChengDingWeiViewController *locationVC = [[ShangChengDingWeiViewController alloc]init];
    locationVC.delegate = self;
    locationVC.cityModel.selectedCity = self.rootGoBackBtn.titleLabel.text;
    locationVC.cityModel.selectedCityId = self.cityID;
    [self.navigationController pushViewController:locationVC animated:YES];
}

#pragma mark 定位界面传过来的值
- (void)sl_cityListSelectedCity:(NSString *)selectedCity Id:(NSInteger)Id {
    
    [[NSUserDefaults standardUserDefaults] setValue:selectedCity forKey:SelectedCityKeyNew];
    [self.rootGoBackBtn setTitle:[NSString stringWithFormat:@"  %@",selectedCity] forState:UIControlStateNormal];
    self.cityID = Id;
    [[NSUserDefaults standardUserDefaults] setValue:selectedCity forKey:SelectedCityNameNew];
    
}


@end
