//
//  USERTongYongViewController.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/20.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERTongYongViewController.h"
#import "USERFirstNormalHeader.h"
#import "USERSecondTableViewCell.h"
#import "USERSecondDetailsViewController.h"

@interface USERTongYongViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIImageView *placeImage;
@property (nonatomic,strong)UITableView *dealDetails;
@property (nonatomic,strong)UILabel *placeLabel;
@property (nonatomic,strong)NSArray *tableDataArray;


@end

@implementation USERTongYongViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.titleStr isEqualToString:@"求助记录"]) {
        self.tableDataArray = [[USERAllQiuZhuData sharedAllDataHandle] getAllDatas];
    }
    
    [self.dealDetails.mj_header beginRefreshing];
    
    [self setTimerWithLenght:1.0f];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rootNaviBaseImg.backgroundColor = [UIColor whiteColor];
    self.rootNaviBaseLine.hidden = NO;
    self.rootNaviBaseTitle.text = self.titleStr;
    
    [self.dealDetails registerNib:[UINib nibWithNibName:@"USERSecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self dealDetails];

}

- (UITableView *)dealDetails{
    if(!_dealDetails){
        _dealDetails = [[UITableView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHight, ScreenWidth, ScreenHeight - getRectNavAndStatusHight - SafeAreaBottomHEIGHT) style:UITableViewStyleGrouped];
        _dealDetails.dataSource = self;
        _dealDetails.delegate = self;
        _dealDetails.backgroundColor = [UIColor whiteColor];
        _dealDetails.separatorColor = [UIColor clearColor];
        _dealDetails.rowHeight = WidthScale(115);
        _dealDetails.mj_header = [USERFirstNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.dealDetails reloadData];
                // 2s后自动执行这个block里面的代码
                [self.dealDetails.mj_header endRefreshing];
            });
            
            
            
        }];
        [self.view addSubview:_dealDetails];
    }
    return _dealDetails;
}

- (UIImageView *)placeImage{
    if(!_placeImage){
        _placeImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth / 2 - ScreenWidth * 0.513333 / 2, _dealDetails.frame.size.height / 2 - ScreenWidth * 0.513333 / 2 , ScreenWidth * 0.513333, ScreenWidth * 0.513333)];
        _placeImage.image = [UIImage imageNamed:@"暂无数据"];
    }
    return _placeImage;
}

#pragma mark ================表格代理============
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    USERSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    USERModel *model = self.tableDataArray[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.subTleLabel.text = model.subTle;
    cell.phoneNum.text = model.phoneNum;
    cell.jiageLabel.text = model.price;
    cell.timeLabel.text = model.time;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.dealDetails deselectRowAtIndexPath:indexPath animated:YES];
    
    USERSecondDetailsViewController *detailVC = [[USERSecondDetailsViewController alloc]init];
    
    USERModel *model = self.tableDataArray[indexPath.row];
    detailVC.goodsId = model.ID;
    detailVC.qufenTag = 3;
    
    [self.navigationController pushViewController:detailVC animated:YES];
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
                [self.dealDetails.mj_header endRefreshing];
                [self.dealDetails reloadData];
                if (self.tableDataArray.count == 0) {
                    [self.dealDetails addSubview:self.placeImage];
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
