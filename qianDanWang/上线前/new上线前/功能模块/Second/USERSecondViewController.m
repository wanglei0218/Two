//
//  USERSecondViewController.m
//  USERPRODUCT
//
//  Created by 河神 on 2019/5/29.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERSecondViewController.h"
#import "USERSecondTableViewCell.h"
#import "USERFirstNormalHeader.h"
#import "USERModel.h"
#import "USERSecondDetailsViewController.h"

@interface USERSecondViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *tableHeadView;
@property (nonatomic, strong)NSArray *tableDataArr;
@property (nonatomic, strong)NSArray *myDataArray;

@end

@implementation USERSecondViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:TOKEN];
    if (token.length > 0) {
        self.myDataArray = [[USERDataHandle sharedDataHandle] getAllDatas];
        self.myDataArray = [[self.myDataArray reverseObjectEnumerator] allObjects];
    }else{
        self.myDataArray = [NSArray array];
    }
    
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.rootGoBackBtn.hidden = YES;
    
    UIImageView *bgimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-SafeAreaAllBottomHEIGHT)];
    bgimage.image = [UIImage imageNamed:@"3"];
    [self.view addSubview:bgimage];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"USERSecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
    
    
    NSArray *array = @[
                       @{
                           @"ID":@"100",
                           @"sataus":@"1",
                           @"name":@"王先生",
                           @"elseName":@"李女士",
                           @"elsePhone":@"17673117963",
                           @"title":@"顺路",
                           @"subTle":@"广告推广",
                           @"phoneNum":@"13263437981",
                           @"price":@"¥0",
                           @"time":@"2019-10-14"
                           },
                       @{
                           @"ID":@"101",
                           @"sataus":@"1",
                           @"name":@"高先生",
                           @"elseName":@"李女士",
                           @"elsePhone":@"18612310682",
                           @"title":@"家务",
                           @"subTle":@"打扫卫生清理死角除虫",
                           @"phoneNum":@"13501094932",
                           @"price":@"¥150",
                           @"time":@"2019-10-14"
                           },
                       @{
                           @"ID":@"102",
                           @"sataus":@"1",
                           @"name":@"宋先生",
                           @"elseName":@"李女士",
                           @"elsePhone":@"18612245623",
                           @"title":@"顺路",
                           @"subTle":@"带东西去朋友家",
                           @"phoneNum":@"13501094932",
                           @"price":@"¥20",
                           @"time":@"2019-10-14"
                           },
                       @{
                           @"ID":@"103",
                           @"sataus":@"1",
                           @"name":@"杨先生",
                           @"elseName":@"李女士",
                           @"elsePhone":@"15663237401",
                           @"title":@"搬家",
                           @"subTle":@"搬运家具",
                           @"phoneNum":@"18830984328",
                           @"price":@"¥120",
                           @"time":@"2019-10-14"
                           },
                       @{
                           @"ID":@"104",
                           @"sataus":@"1",
                           @"name":@"孟先生",
                           @"elseName":@"杨先生",
                           @"elsePhone":@"15933283425",
                           @"title":@"搬家",
                           @"subTle":@"搬运家具",
                           @"phoneNum":@"13263425254",
                           @"price":@"¥60",
                           @"time":@"2019-10-12"
                           }
                       ];
    
    self.tableDataArr = [USERModel creatModelWithArray:array];
    
}

#pragma mark ------------ 导航栏隐藏 (scrollViewDidScroll) --------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 222) { // 首页主表格
        
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > getStatusHeight){
            CGFloat alpha = offsetY / getRectNavAndStatusHight;
            if (alpha<1.0f) {
                self.rootNaviBaseImg.alpha = alpha;
            }else{
                self.rootNaviBaseImg.alpha = 1;
            }
        }else{
            
            self.rootNaviBaseImg.alpha = 0;
        }
    }
    
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -getStatusHeight, ScreenWidth, ScreenHeight-SafeAreaAllBottomHEIGHT+getStatusHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = WidthScale(115);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tag = 222;
        _tableView.backgroundColor = BACKGROUND_Color;
        
        self.tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, getStatusHeight)];
        self.tableView.tableHeaderView = self.tableHeadView;
        self.tableHeadView.backgroundColor = [UIColor whiteColor];
        
        _tableView.mj_header = [USERFirstNormalHeader headerWithRefreshingBlock:^{

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 2s后自动执行这个block里面的代码
                [self.tableView.mj_header endRefreshing];
            });
        }];
        
//        _tableView.mj_footer = [USERMYGeneralRefrshFooter footerWithRefreshingBlock:^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                // 2s后自动执行这个block里面的代码
//                [self.tableView.mj_footer endRefreshing];
//            });
//        }];
        
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return self.myDataArray.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    USERSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        USERModel *model = self.myDataArray[indexPath.row];
        cell.titleLabel.text = model.title;
        cell.subTleLabel.text = model.subTle;
        cell.phoneNum.text = model.phoneNum;
        cell.jiageLabel.text = model.price;
        cell.timeLabel.text = model.time;
        
    }else{
        USERModel *model = self.tableDataArr[indexPath.row];
        
        cell.titleLabel.text = model.title;
        cell.subTleLabel.text = model.subTle;
        cell.phoneNum.text = model.elsePhone;
        cell.jiageLabel.text = model.price;
        cell.timeLabel.text = model.time;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, WidthScale(44)+getStatusHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *headLable = [[UILabel alloc] initWithFrame:CGRectMake(WidthScale(15), getStatusHeight, ScreenWidth-WidthScale(30), WidthScale(44))];
    headLable.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:WidthScale(18)];
    headLable.textColor = COLOR_With_Hex(0x222222);
    [headView addSubview:headLable];
    if (section == 0) {
        headLable.text = @"我的发布";
    }else{
        headLable.text = @"全部帮忙";
    }
    
    return headView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    CGFloat footViewHeight;
    if (self.myDataArray.count == 0) {
        footViewHeight = WidthScale(158);
    }else{
        footViewHeight = 0;
    }
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, footViewHeight)];
    
    CGSize size = [UIImage imageNamed:@"暂无数据"].size;
    CGFloat imageHeight = (ScreenWidth-WidthScale(240))*size.height/size.width;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(WidthScale(120), WidthScale(15), ScreenWidth-WidthScale(240), imageHeight)];
    
    if (section == 0) {
        image.image = [UIImage imageNamed:@"暂无发布"];
        if (self.myDataArray.count==0) {
            [footView addSubview:image];
        }else{
            [footView removeFromSuperview];
        }
    }else{
        image.image = [UIImage imageNamed:@"暂无帮忙"];
        [footView addSubview:image];
    }
    
    
    
    return footView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return WidthScale(44)+getStatusHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if (self.myDataArray.count == 0) {
            return WidthScale(158);
        }
        return WidthScale(0.1f);
    }else{
        return WidthScale(158);
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    USERSecondDetailsViewController *detailVC = [[USERSecondDetailsViewController alloc]init];

    if (indexPath.section == 0) {
        USERModel *model = self.myDataArray[indexPath.row];
        detailVC.goodsId = model.ID;
        detailVC.qufenTag = 2;
    }else{
        USERModel *model = self.tableDataArr[indexPath.row];
        detailVC.goodsId = model.ID;
        detailVC.qufenTag = 1;
    }
    
    
    [self.navigationController pushViewController:detailVC animated:YES];
}



@end
