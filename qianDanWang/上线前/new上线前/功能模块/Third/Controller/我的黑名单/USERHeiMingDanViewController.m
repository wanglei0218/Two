//
//  USERHeiMingDanViewController.m
//  qianDanWang
//
//  Created by 小锦鲤 on 2019/7/9.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "USERHeiMingDanViewController.h"
#import "USERHomeTableViewCell.h"
#import "USERHomeModel.h"
#import "USERTouSuModel.h"

@interface USERHeiMingDanViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *tableDataArr;
@property (nonatomic,strong)UIImageView *placeImage;


@end

@implementation USERHeiMingDanViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView.mj_header beginRefreshing];

    [self setTimerWithLenght:1.0f];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rootNaviBaseLine.hidden = NO;
    self.rootNaviBaseTitle.text = @"黑名单";
    
    self.tableDataArr = [[USERTouSuModel sharedHomeDataHandel] getAllDatas];
    
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view.
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, ScreenWidth, ScreenHeight-getRectNavAndStatusHight-getTabbarHeightNew) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = WidthScale(145);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.mj_header = [USERFirstNormalHeader headerWithRefreshingBlock:^{
            [self.placeImage removeFromSuperview];
            [self setTimerWithLenght:1.2];
        }];
    }
    return _tableView;
}

- (UIImageView *)placeImage{
    if(!_placeImage){
        _placeImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth / 2 - ScreenWidth * 0.513333 / 2, self.tableView.frame.size.height / 2 - ScreenWidth * 0.513333 / 2 , ScreenWidth * 0.513333, ScreenWidth * 0.513333)];
        _placeImage.image = [UIImage imageNamed:@"暂无数据"];
    }
    return _placeImage;
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
    
//    UILabel *headLable = [[UILabel alloc] initWithFrame:CGRectMake(WidthScale(15), WidthScale(15), ScreenWidth-WidthScale(30), WidthScale(40))];
//    headLable.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:WidthScale(18)];
//    headLable.textColor = COLOR_With_Hex(0x222222);
//    headLable.text = @"寻物启事";
//    [headView addSubview:headLable];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return WidthScale(0.1f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return WidthScale(0.1f);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    USERHomeModel *model = self.tableDataArr[indexPath.row];
//
//    USERSecondDetailsViewController *detailVC = [[USERSecondDetailsViewController alloc]init];
//    detailVC.goodsId = model.goodsId;
//    detailVC.qufenTag = 0;
//    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark ===============倒计时============
- (void)setTimerWithLenght:(int)inteval{
    __block int timeout = inteval; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
                if (self.tableDataArr.count == 0) {
                    [self.tableView addSubview:self.placeImage];
                }
            });
        }else{
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
