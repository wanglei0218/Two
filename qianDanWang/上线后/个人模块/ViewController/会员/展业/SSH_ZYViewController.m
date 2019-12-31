//
//  SSH_ZYViewController.m
//  qianDanWang
//
//  Created by AN94 on 9/16/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_ZYViewController.h"
#import "SSH_ZYCollectionViewCell.h"
#import "SSH_ZYDetailsViewController.h"
#import "SSH_ZYModel.h"
#import "SSH_ZYJumpView.h"
#import "SSH_RechargeViewController.h"

@interface SSH_ZYViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,SSH_ZYJumpViewDelegate>

@property (nonatomic,strong)UICollectionView *contentCollect;
@property (nonatomic,strong)UIScrollView *topScroll;
@property (nonatomic,strong)NSArray *topTitle;
@property (nonatomic,strong)NSMutableArray *contentData;
@property (nonatomic,strong)UILabel *topBottomLabel;
@property (nonatomic,strong)SSH_ZYJumpView *jumpView;
@property (nonatomic,assign)int page;
@property (nonatomic,assign)int pages;
@property (nonatomic,assign)int isVip;

@end

@implementation SSH_ZYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.topTitle = @[@"全部",@"非会员海报",@"会员海报"];
    
    self.page = 1;
    self.isVip = 2;
    
    self.contentData = [[NSMutableArray alloc]init];
    self.titleLabelNavi.text = @"展业工具";
    [self topBottomLabel];
    [self topScroll];
    [self contentCollect];
    [self jumpView];
    [self.contentCollect.mj_header beginRefreshing];
    
}

- (void)backBtnClicked {
    [super backBtnClicked];
    
    [MobClick event:@"Exhibitiontoolreturn"];
    
}

#pragma mark ======================懒加载====================
- (UILabel *)topBottomLabel{
    if(!_topBottomLabel){
        _topBottomLabel = [[UILabel alloc]init];
        _topBottomLabel.backgroundColor = ColorE63c3f;
    }
    return _topBottomLabel;
}

- (UIScrollView *)topScroll{
    if(!_topScroll){
        _topScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHightOnew, SCREEN_WIDTH, HeightScale(44))];
        
        CGFloat charsWidth = 0.0;
        
        if(!IS_PhoneXAll){
            charsWidth = WidthScale(15);
        }else{
            if(IS_IPHONEX){
                charsWidth = WidthScale(15);
            }else{
                charsWidth = WidthScale(13);
            }
        }
        
        CGFloat btnDis = WidthScale(55);
        NSMutableArray *btnWidthArr = [[NSMutableArray alloc]init];
        CGFloat beforeWidth = 0.0;
        
        for (int i = 0 ; i < self.topTitle.count ; i++) {
            
            CGFloat btnWidth = 0.0;
            NSString *str = self.topTitle[i];
            btnWidth = str.length * charsWidth;
            [btnWidthArr addObject:[NSNumber numberWithFloat:btnWidth]];
            
        }
        
        for (int i = 0 ; i < self.topTitle.count ; i++){
            
            NSNumber *btnWidth = btnWidthArr[i];
            
            if (i > 0){
                
                NSNumber *width = btnWidthArr[i - 1];

                beforeWidth += width.floatValue;
                
            }
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnDis * i + btnDis + beforeWidth, 0, btnWidth.floatValue, HeightScale(44))];
            
            btn.tag = i;
            
            NSAttributedString *normalAttr = [[NSAttributedString alloc]initWithString:self.topTitle[i] attributes:@{
                                                NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                NSForegroundColorAttributeName:[UIColor blackColor]
                                                }];
            
            NSAttributedString *selecteAttr = [[NSAttributedString alloc]initWithString:self.topTitle[i] attributes:@{
                                                        NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                        NSForegroundColorAttributeName:ColorE63c3f
                                                        }];
            
            [btn setAttributedTitle:normalAttr forState:UIControlStateNormal];
            [btn setAttributedTitle:selecteAttr forState:UIControlStateSelected];
            
            [btn addTarget:self action:@selector(didSelecteTheTopBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            if(i == 0){
                btn.selected = YES;
                self.topBottomLabel.frame = CGRectMake(btnDis, HeightScale(42), btn.frame.size.width, 2);
                [self.topScroll addSubview:self.topBottomLabel];
            }
            
            [self.topScroll addSubview:btn];
        }
        
        [self.view addSubview:self.topScroll];
        
    }
    return _topScroll;
}

- (UICollectionView *)contentCollect{
    if(!_contentCollect){
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.itemSize = CGSizeMake(WidthScale(168), HeightScale(354));
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.sectionInset = UIEdgeInsetsMake(HeightScale(10), WidthScale(14), HeightScale(10), WidthScale(14));
        flow.minimumLineSpacing = HeightScale(10);
        flow.minimumInteritemSpacing = WidthScale(9);
        
        _contentCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.topScroll.maxY, SCREEN_WIDTH , ScreenHeight - self.topScroll.maxY - SafeAreaBottomHEIGHT) collectionViewLayout:flow];
        _contentCollect.delegate = self;
        _contentCollect.dataSource = self;
        _contentCollect.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self getSSH_ZYDataWithPage:self.page isVip:self.isVip];
        }];
        
        _contentCollect.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            self.page ++;
            [self getSSH_ZYDataWithPage:self.page isVip:self.isVip];
        }];
        
        _contentCollect.backgroundColor = COLOR_With_Hex(0xf9f9f9);
        [_contentCollect registerNib:[UINib nibWithNibName:@"SSH_ZYCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ZYCollectionViewcell"];
        [self.view addSubview:self.contentCollect];
    }
    return _contentCollect;
}

- (SSH_ZYJumpView *)jumpView{
    if(!_jumpView){
        _jumpView = [[SSH_ZYJumpView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4, (SCREENH_HEIGHT - WidthScale(120)) / 2, SCREEN_WIDTH / 2, WidthScale(120))];
        _jumpView.delegate = self;
    }
    return _jumpView;
}

#pragma mark =====================自定义代理====================
- (void)didSelecteTheBtnWithTarget:(NSInteger)tag{
    if(tag == 1){
        [self.jumpView removeFromSuperview];
    }else{
        SSH_RechargeViewController *recharge = [[SSH_RechargeViewController alloc]init];
        recharge.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:recharge animated:YES];
    }
}

- (void)presentViewToSelfWithMsg:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SSH_RechargeViewController *recharge = [[SSH_RechargeViewController alloc]init];
        recharge.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:recharge animated:YES];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:actionConfirm];
    [alert addAction:actionCancel];
    [actionCancel setValue:COLOR_WITH_HEX(0x222222) forKey:@"titleTextColor"];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark =====================按钮点击方法===================
- (void)didSelecteTheTopBtn:(UIButton *)sender{
    
    for (UIView *view in self.topScroll.subviews) {
        
        if([view isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)view;
            
            if(btn.tag == sender.tag){
                btn.selected = YES;
                
                [UIView animateWithDuration:0.138 animations:^{
                    self.topBottomLabel.frame = CGRectMake(btn.maxX - btn.frame.size.width, HeightScale(42), btn.frame.size.width, 2);
                }];
                
            }else{
                btn.selected = NO;
            }
            
        }
    }
    
    if(sender.tag == 0){
        self.isVip = 2;
    }else if (sender.tag == 1){
        self.isVip = 0;
        [MobClick event:@"free"];
    }else{
        [MobClick event:@"Memberuse"];
        self.isVip = 1;
    }
    
    [self.contentCollect.mj_header beginRefreshing];
    
}

#pragma mark =====================网格数据源====================
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SSH_ZYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZYCollectionViewcell" forIndexPath:indexPath];
    
    SSH_ZYModel *model = self.contentData[indexPath.row];
    [cell setCellCortolContentWithModel:model];
    
    return cell;
}

//- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (indexPath.row == 0){
//        return CGSizeMake(WidthScale(168), HeightScale(65));
//    }else{
//        return CGSizeMake(WidthScale(168), HeightScale(354));
//    }
//    
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SSH_ZYModel *model = self.contentData[indexPath.row];
    [self isVipOrNOWithID:model.ID];
}

#pragma mark ==================获取数据==================
- (void)getSSH_ZYDataWithPage:(int)page isVip:(int)isVip{
    
    NSString *userId = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]];
    
    NSDictionary *param = @{
                            @"rows":@"10",
                            @"page":[NSNumber numberWithInt:page],
                            @"userId":userId,
                            @"isVip":[NSNumber numberWithInt:isVip],
                            @"timestamp":[NSString yf_getNowTimestamp],
                            @"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%@",userId]]
                            };
    
    [[DENGFANGRequest shareInstance]postWithUrlString:@"vip/posterTool/queryPosterToolList" parameters:param success:^(id responsObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
        if(![[dic objectForKey:@"code"] isEqualToString:@"200"]){
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:dic[@"msg"]];
            return ;
        }
        
        NSString *str = [dic objectForKey:@"pages"];
        self.pages = str.intValue;
        
        if(page == 1){
            [self.contentData removeAllObjects];
        }else if (page > self.pages){
            return;
        }
        
        NSArray *beforArr = [dic objectForKey:@"data"];
        NSArray *modelArr = [[SSH_ZYModel shardeInstance]getSSH_ZYModelArrWithData:beforArr];
        [self.contentData addObjectsFromArray:modelArr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentCollect.mj_header endRefreshing];
            [self.contentCollect.mj_footer endRefreshing];
            [self.contentCollect reloadData];
        });
        
        
    } fail:^(NSError *error) {
        
    }];
}

//判断是否是会员
- (void)isVipOrNOWithID:(NSString *)ID{
    NSString *userId = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]];
    NSString *mobile = [DENGFANGSingletonTime shareInstance].mobileString;
    
    NSDictionary *param = @{
                            @"postersId":ID,
                            @"mobile":mobile,
                            @"userId":userId,
                            @"timestamp":[NSString yf_getNowTimestamp],
                            @"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%@%@",userId,mobile]]
                            };
    
    [[DENGFANGRequest shareInstance] postWithUrlString:@"vip/posterTool/queryPoster" parameters:param success:^(id responsObject) {
       
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
        if([[dic objectForKey:@"code"] isEqualToString:@"100001"]){
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.backView = [XPBackView makeViewWithMask:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT) andView:self.jumpView];
                [self presentViewToSelfWithMsg:dic[@"msg"]];
            });
            return ;
        }
        
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            SSH_ZYDetailsViewController *details = [[SSH_ZYDetailsViewController alloc]init];
            details.data = dataDic;
            details.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:details animated:YES];
            
        });
        
    } fail:^(NSError *error) {
        
    }];
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
