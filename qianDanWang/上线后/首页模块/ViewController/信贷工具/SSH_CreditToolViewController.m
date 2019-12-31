//
//  SSH_CreditToolViewController.m
//  qianDanWang
//
//  Created by AN94 on 9/24/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_CreditToolViewController.h"
#import "SSH_CreditCollectionViewCell.h"
#import "SSH_CreditCollectionReusableView.h"
#import "SSH_CreditDetailsViewController.h"
#import "SSH_WangYeViewController.h"

@interface SSH_CreditToolViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *creditCollect;
@property (nonatomic,strong)NSArray *creditData;

@end

@implementation SSH_CreditToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabelNavi.text = @"信贷工具";
    self.creditData = @[@[@"等额本息",@"等额本金",@"先息后本",@"一次性还款本息",@"个税计算",@"汇率查询"],@[@"公积金查询",@"社保查询",@"车辆估值",@"房产估值"]];
    [self creditCollect];
}

- (UICollectionView *)creditCollect{
    if(!_creditCollect){
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.itemSize = CGSizeMake(WidthScale(120), WidthScale(120));
        flow.minimumLineSpacing = 5;
        flow.minimumInteritemSpacing = 5;
        flow.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
        
        _creditCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHightOnew, SCREEN_WIDTH, SCREENH_HEIGHT - getRectNavAndStatusHightOnew - SafeAreaBottomHEIGHT) collectionViewLayout:flow];
        _creditCollect.delegate = self;
        _creditCollect.dataSource = self;
        _creditCollect.backgroundColor = RGB(244, 244, 244);
        [_creditCollect registerNib:[UINib nibWithNibName:@"SSH_CreditCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"creditCollectionCell"];
        [_creditCollect registerClass:[SSH_CreditCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"creditCollectionHeader"];
        [self.view addSubview:_creditCollect];
    }
    return _creditCollect;
}

#pragma mark ======================网格数据源======================
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.creditData.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arr = self.creditData[section];
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SSH_CreditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"creditCollectionCell" forIndexPath:indexPath];
    
    NSArray *arr = self.creditData[indexPath.section];
    cell.backgroundColor = [UIColor whiteColor];
    cell.topImage.image = [UIImage imageNamed:arr[indexPath.row]];
    cell.bottomLabel.text = arr[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row <= 3){
            if (indexPath.row == 0) {
                [MobClick event:@"intreest"];
            } else if (indexPath.row == 1) {
                [MobClick event:@"principal"];
            } else if (indexPath.row == 2) {
                [MobClick event:@"first"];
            } else if (indexPath.row == 3) {
                [MobClick event:@"One-time"];
            }
            NSArray *arr = self.creditData[indexPath.section];
            SSH_CreditDetailsViewController *details = [[SSH_CreditDetailsViewController alloc]init];
            details.type = arr[indexPath.row];
            [self.navigationController pushViewController:details animated:YES];
        }else if (indexPath.row == 4){
            [MobClick event:@"Individual"];
            SSH_WangYeViewController *WYView = [[SSH_WangYeViewController alloc]init];
            WYView.webUrl = @"https://www.gerensuodeshui.cn/";
            [self.navigationController pushViewController:WYView animated:YES];
        }else if (indexPath.row == 5){
            [MobClick event:@"exchange"];
            SSH_WangYeViewController *WYView = [[SSH_WangYeViewController alloc]init];
            WYView.webUrl = @"http://qq.ip138.com/hl.asp";
            [self.navigationController pushViewController:WYView animated:YES];
        }
        
    }else{
        if(indexPath.row == 0){
            [MobClick event:@"providentfund"];
            SSH_WangYeViewController *WYView = [[SSH_WangYeViewController alloc]init];
            WYView.webUrl = @"https://www.shandianyidai.com/cxgjj/organization?channel=107&scene=126&firstPage=1&from=singlemessage&isappinstalled=0";
            [self.navigationController pushViewController:WYView animated:YES];
        }else if (indexPath.row == 1){
            [MobClick event:@"socialsecurity"];
            SSH_WangYeViewController *WYView = [[SSH_WangYeViewController alloc]init];
            WYView.webUrl = @"http://www.12333sb.com/";
            [self.navigationController pushViewController:WYView animated:YES];
        }else if (indexPath.row == 2){
            [MobClick event:@"vehicle evaluation"];
            SSH_WangYeViewController *WYView = [[SSH_WangYeViewController alloc]init];
            WYView.webUrl = @"http://www.bayiche.com/weixin/carmoney.php?scene=126";
            [self.navigationController pushViewController:WYView animated:YES];
        }else{
            [MobClick event:@"Realestatea"];
            SSH_WangYeViewController *WYView = [[SSH_WangYeViewController alloc]init];
            WYView.webUrl = @"https://bj.lianjia.com/yezhu/gujia/";
            [self.navigationController pushViewController:WYView animated:YES];
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        SSH_CreditCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"creditCollectionHeader" forIndexPath:indexPath];
        if(indexPath.section == 0){
            view.label.text = @"费率计算器";
        }else{
            view.label.text = @"风控查询工具";
        }
        return view;
    }else{
        return nil;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, WidthScale(30));
    
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
