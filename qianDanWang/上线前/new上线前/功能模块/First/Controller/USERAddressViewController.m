//
//  USERAddressViewController.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/19.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERAddressViewController.h"
#import "USERFirstNormalHeader.h"
#import "USERAddressTableViewCell.h"
#import "USERAddXinxiViewController.h"

@interface USERAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *tableHeadView;
@property (nonatomic, strong)NSArray *tableDataArr;
@property (nonatomic, strong)UIButton *addBtn;

@end

@implementation USERAddressViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tableDataArr = [[USERAddress shareUSERAddress] getAllDatas];
    self.tableDataArr = [[self.tableDataArr reverseObjectEnumerator] allObjects];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rootNaviBaseImg.backgroundColor = [UIColor whiteColor];
    self.rootNaviBaseLine.hidden = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"USERAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    [self.view addSubview:self.tableView];
    

}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, ScreenWidth, ScreenHeight-getRectNavAndStatusHight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = WidthScale(115);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        self.tableView.tableHeaderView = self.tableHeadView;
        
        _tableView.mj_header = [USERFirstNormalHeader headerWithRefreshingBlock:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 2s后自动执行这个block里面的代码
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            });
        }];
        
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, WidthScale(220))];
        self.tableView.tableFooterView = footView;
        
        
        self.addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, WidthScale(25), ScreenWidth - WidthScale(60), WidthScale(44))];
        self.addBtn.center = CGPointMake(ScreenWidth/2, WidthScale(55));
        self.addBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:WidthScale(18)];
        self.addBtn.layer.cornerRadius = WidthScale(22);
        self.addBtn.layer.masksToBounds = YES;
        self.addBtn.backgroundColor = MAINCOLOR1;
        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"矩形2"] forState:UIControlStateNormal];
        [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [self.addBtn addTarget:self action:@selector(addBttonDidPress:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:self.addBtn];
        
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
    
    
    USERAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    USERAdd *model = self.tableDataArr[indexPath.row];
    
    cell.nameLabel.text = model.addName;
    cell.phoneLabel.text = model.addPhone;
    cell.addressLabel.text = [NSString stringWithFormat:@"%@%@",model.addCity,model.addxiangxi];
    
        
    cell.editBtnBlock = ^{
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定删除此信息？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            [[USERAddress shareUSERAddress] deleteDataByID:[[NSString stringWithFormat:@"%ld",model.addID] intValue]];
            self.tableDataArr = [[USERAddress shareUSERAddress] getAllDatas];
            [self.tableView reloadData];
        }];
        [alert addAction:cancelAction];
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    };
    
    cell.deleteBtnBlock = ^{
        
    };
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGFloat headViewHeight;
    if (self.tableDataArr.count==0) {
        headViewHeight = WidthScale(44)+WidthScale(158);
    }else{
        headViewHeight = WidthScale(44);
    }
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, headViewHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *headLable = [[UILabel alloc] initWithFrame:CGRectMake(WidthScale(15), WidthScale(8), ScreenWidth-WidthScale(30), WidthScale(40))];
    headLable.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:WidthScale(18)];
    headLable.textColor = COLOR_With_Hex(0x222222);
    headLable.text = @"联系人";
    [headView addSubview:headLable];
    
    CGSize size = [UIImage imageNamed:@"暂无数据"].size;
    CGFloat imageHeight = (ScreenWidth-WidthScale(256))*size.height/size.width;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(WidthScale(128), headLable.bottom+WidthScale(15), ScreenWidth-WidthScale(256), imageHeight)];
    image.image = [UIImage imageNamed:@"暂无数据"];
    
    if (self.tableDataArr.count==0) {
        [headView addSubview:image];
    }else{
        [image removeFromSuperview];
    }
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.tableDataArr.count == 0) {
        return WidthScale(44)+WidthScale(158);
    }
    return WidthScale(44);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return WidthScale(0.1f);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    USERAdd *model = self.tableDataArr[indexPath.row];
    self.dataBlock(model.addID);
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)addBttonDidPress:(UIButton *)sender{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:TOKEN];
    if (token.length == 0) {
        [self myLoginAction];
        return;
    }
    
    USERAddXinxiViewController *addxinxiVC = [[USERAddXinxiViewController alloc] init];
    [self.navigationController pushViewController:addxinxiVC animated:YES];
    
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
