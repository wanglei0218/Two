//
//  SSH_DiErYeViewController.m
//  DENGFANGSC
//
//  Created by LY on 2018/9/17.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_DiErYeViewController.h"

#import "SSH_CategorySliderBar.h"


#import "SSH_SelectHeaderCollectionView.h"
#import "SSH_SelectCollectionCell.h"

#import "SSH_ClassifyModel.h" //筛选model
#import "SSH_HomeCreditxinxiListModel.h"

#import "SSH_ShouYeListTableViewCell.h"//首页抢单cell

#import "SSH_KeHuXiangQingViewController.h" //产品详情页

#import "SSH_ZiZhiXinXiHeaderCollectionView.h" //资质信息

#import "SSH_QuanBuBannerCell.h"

#import "SSH_ShaiXuanModel.h"

#import "SSH_BannersModel.h"

#import "DCCycleScrollView.h"//轮播图

#import "SSH_WangYeViewController.h"

#import "SSH_ChargeGiftViewController.h"
#import "SSH_YaoQingViewController.h"
#import "SSH_FenXiaoViewController.h"
#import "SSH_YanZhengMaDengLuController.h"
#import "SSH_DingWeiViewController.h"
#import "SSH_GeRenXinXiModel.h"

@interface SSH_DiErYeViewController ()<SSH_CategorySliderBarDelegate, UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,DCCycleScrollViewDelegate,SSH_LocationViewControllerDelegate>
{
    UILabel *keHuNumLab;//今日新增客户
    UILabel *jinENumLab;//今日新增贷款需求
}
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) SSH_CategorySliderBar *sliderBar;
@property (nonatomic,strong) UITableView * daTableView;
@property (nonatomic,strong) NSMutableArray * allListData;

@property (nonatomic, strong) UIButton *reloadButton; //刷新按钮
@property (nonatomic, strong) UIView *mengView; //蒙层
@property (nonatomic, strong) UIView *selectView; //筛选view
@property (nonatomic, strong) UICollectionView *collectView; //筛选Collectionview
@property (nonatomic,strong)NSMutableArray * selectDataArr;
@property (nonatomic,strong)NSMutableArray * selectHeaderArr;
@property (nonatomic,strong)NSMutableArray * selectCell1;//存客户状态cell
@property (nonatomic,strong)NSMutableArray * selectCell2;//存金额cell
@property (nonatomic,strong)NSMutableArray * selectCell3;//存资产抵押类型cell
@property (nonatomic,strong)NSMutableArray * selectCell4;//身份类型cell
@property (nonatomic,strong)NSMutableArray * selectCell5;//资质信息cell
@property (nonatomic,strong)NSMutableArray * allCellArr;//所有的cell
@property (nonatomic,assign)BOOL isRet;//是否进行了重置

@property (nonatomic, strong) SSH_SelectHeaderCollectionView *headerViewOne; //tou

//筛选各项数组 -- 接口获取的数据
@property (nonatomic,strong)NSMutableArray * customerArr;//客户状态
@property (nonatomic,strong)NSMutableArray * mortgageArr;//资产抵押类型
@property (nonatomic,strong)NSMutableArray * identityArr;//身份类型
@property (nonatomic,strong)NSMutableArray * loanArr;//金额
@property (nonatomic,strong)NSMutableArray * qualiArr;//资质信息

//获取数据传的值
@property (nonatomic,strong)NSString * loanStartLimit;//开始金额
@property (nonatomic,strong)NSString * loanEndLimit;//结束金额
@property (nonatomic,strong)NSMutableArray * qualification;//资质信息
@property (nonatomic,strong)NSMutableArray * customerStatus;//客户状态
@property (nonatomic,strong)NSMutableArray * mortgageType;//资产抵押类型
@property (nonatomic,strong)NSMutableArray * identityType;//身份类型
@property (nonatomic,strong)NSMutableArray * loanLimit;//存金额id的数组
@property (nonatomic, assign) NSInteger pageNum;//页数
@property (nonatomic, strong) NSString *  count;//更新的条数

//得到存储状态数组
@property (nonatomic,strong)NSString * getLoanStartLimit;//开始金额
@property (nonatomic,strong)NSString * getLoanEndLimit;//结束金额
@property (nonatomic,strong)NSMutableArray * getQualification;//资质信息
@property (nonatomic,strong)NSMutableArray * getCustomerStatus;//客户状态
@property (nonatomic,strong)NSMutableArray * getMortgageType;//资产抵押类型
@property (nonatomic,strong)NSMutableArray * getIdentityType;//身份类型
@property (nonatomic,strong)NSMutableArray * getLoanLimit;//存金额id的数组

@property (nonatomic, strong) UIView *noDataFatherView;
@property (nonatomic, strong) UIImageView *noDataImageView;
@property (nonatomic, strong) UILabel *noDataTitleLabel;

@property (nonatomic, assign) BOOL isShaiXuanStatus;//当前是否为筛选状态，0:不是，1:是

@property(nonatomic,assign) BOOL isFirst; //是不是加载全部这个版面的数据

@property(nonatomic,strong)NSArray *ziZhiArray; //资质信息
@property(nonatomic,strong)NSMutableArray *zhiMaFenXinYongKaArr;

@property(nonatomic,copy) NSString *zhiMaFenCode;
@property(nonatomic,copy) NSString *zhiMaFenName;
@property(nonatomic,copy) NSString *xinYongKaCode;
@property(nonatomic,copy) NSString *xinYongKaName;
@property(nonatomic,copy) NSString *shouRuCode;
@property(nonatomic,copy) NSString *shouRuName;
@property(nonatomic,strong)NSMutableArray *bannerArr;

@property(nonatomic,assign)BOOL isClose; // 是否点击过关闭按钮
@property(nonatomic,assign)CGFloat bannerCellHeight;

@property(nonatomic,strong)SSH_ZiZhiXinXiHeaderCollectionView *reusableView;
@property(nonatomic,strong)NSString * classifyName;

@property(nonatomic,strong)UILabel *displayLabel; //显示城市的label
@property (nonatomic, strong)UIButton * cityBtn;

@property (nonatomic, strong) SSH_GeRenXinXiModel *infoModel;

@end

@implementation SSH_DiErYeViewController

-(NSMutableArray *)bannerArr{
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

-(NSMutableArray *)zhiMaFenXinYongKaArr{
    if (!_zhiMaFenXinYongKaArr) {
        _zhiMaFenXinYongKaArr = [NSMutableArray array];
    }
    return _zhiMaFenXinYongKaArr;
}

#pragma mark - 第3个cell后的banner
-(void)getBannerListData{
    
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGBannerListURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil]} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"%@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            [self.bannerArr removeAllObjects];
            for (NSDictionary *dic in diction[@"data"]) {
                SSH_BannersModel *model = [[SSH_BannersModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                if ([model.bannerType isEqualToString:@"4"]) {
                    [self.bannerArr addObject:model];
                }
            }

            [self.daTableView reloadData];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
    }];
}

#pragma mark - 数据请求：顶部分类 && 筛选里的内容
#pragma mark - 数据请求：列表数据
-(void)getCreditinfoListData{
    //creditinfo/vip/queryCreditinfoStat
    NSString *userId = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
    [[DENGFANGRequest shareInstance] getWithUrlString:@"creditinfo/vip/queryCreditinfoStat" parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:userId]} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            NSDictionary *dic = diction[@"data"];
            self->keHuNumLab.text = [NSString stringWithFormat:@"%@",dic[@"todayCustomer"]];
            self->jinENumLab.text = [NSString stringWithFormat:@"%@",dic[@"todayLoanAmount"]];
        }else{
            
        }
    } fail:^(NSError *error) {
        
    }];
    //拼接成字符串
    NSString * identityType = [self.identityType componentsJoinedByString:@","];
    NSString * qualification = [self.qualification componentsJoinedByString:@","];
    NSString * customerStatus = [self.customerStatus componentsJoinedByString:@","];
    NSString * mortgageType = [self.mortgageType componentsJoinedByString:@","];
    NSString * loanLimit = [self.loanLimit componentsJoinedByString:@","];

    
    [[NSUserDefaults standardUserDefaults] setValue:customerStatus forKey:Big_CustomerStatus];
    [[NSUserDefaults standardUserDefaults] setValue:mortgageType forKey:Big_MortgageType];
    [[NSUserDefaults standardUserDefaults] setValue:identityType forKey:Big_IDEntityType];
    [[NSUserDefaults standardUserDefaults] setValue:loanLimit forKey:Big_LoanLimit];
    [[NSUserDefaults standardUserDefaults] setValue:self.loanStartLimit forKey:Big_LoanStartLimit];
    [[NSUserDefaults standardUserDefaults] setValue:self.loanEndLimit forKey:Big_LoanEndLimit];
    [[NSUserDefaults standardUserDefaults] setValue:qualification forKey:Big_Qualification];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self getUserDefaultState];
//    NSString *userId = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGCreditinfoListURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:userId],@"rows":[NSNumber numberWithInteger:HomeRows],@"page":[NSNumber numberWithInteger:self.pageNum],@"area":[DENGFANGSingletonTime shareInstance].mapCity,@"identityType":identityType,@"qualification":qualification,@"customerStatus":customerStatus,@"mortgageType":mortgageType,@"loanStartLimit":self.loanStartLimit,@"loanEndLimit":self.loanEndLimit,@"sesameCredit":self.zhiMaFenCode,@"isCreditCard":self.xinYongKaCode,@"inCome":self.shouRuCode,@"isDiscount":@"0",@"onlineLoan":@"0"} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"淘单大全 列表数据 %@",diction);
        
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
//            //在第6个产品后添加banner
//            if (self.isFirst && self.allListData.count != 0) { //全部
//                [self.allListData insertObject:@1 atIndex:6];
//            }
            
            [self.daTableView reloadData];
            
            [self.daTableView.mj_header endRefreshing];
            [self.daTableView.mj_footer endRefreshing];
            
            NSArray * arr = diction[@"data"];
            if ( arr.count == 0) {
                [self.daTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (self.allListData.count==0) {
//                self.daTableView.hidden = YES;
                self.noDataFatherView.hidden = NO;
                if (self.isShaiXuanStatus) {
                    self.noDataTitleLabel.text = @"没有满足筛选条件的客户！\n赶紧去重新筛选吧！";
                }else{
                    self.noDataTitleLabel.text = @"该地区内暂时没有此类客户,\n去选择本省其他城市吧";
                }
                
            }else{
//                self.daTableView.hidden = NO;
                self.noDataFatherView.hidden = YES;
            }
        }else{
            [self.daTableView.mj_footer endRefreshing];
            [self.daTableView.mj_header endRefreshing];
            [self.allListData removeAllObjects];
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        [self.daTableView.mj_header endRefreshing];
        [self.daTableView.mj_footer endRefreshing];
    }];
}
#pragma mark 取出存储筛选状态的数组
-(void)getUserDefaultState{
    
    self.getLoanStartLimit = [[NSUserDefaults standardUserDefaults] valueForKey:Big_LoanStartLimit];
    self.getLoanEndLimit = [[NSUserDefaults standardUserDefaults] valueForKey:Big_LoanEndLimit];
    
    NSString *custoStr = [[NSUserDefaults standardUserDefaults] valueForKey:Big_CustomerStatus];
    BOOL custoBool;
    if (custoStr.length>0) {
        self.getCustomerStatus = [[NSMutableArray alloc]initWithArray:[custoStr componentsSeparatedByString:@","]];
        custoBool = 1;
    }else{
        self.getCustomerStatus = [[NSMutableArray alloc]init];
        custoBool = 0;
    }
    
    NSString *mortStr = [[NSUserDefaults standardUserDefaults] valueForKey:Big_MortgageType];
    if (mortStr.length>0) {
        self.getMortgageType = [[NSMutableArray alloc]initWithArray:[mortStr componentsSeparatedByString:@","]];
    }else{
        self.getMortgageType = [[NSMutableArray alloc]init];
    }

    NSString *ideStr = [[NSUserDefaults standardUserDefaults] valueForKey:Big_IDEntityType];
    BOOL ideBool;
    if(ideStr.length > 0){
        self.getIdentityType = [[NSMutableArray alloc]initWithArray:[ideStr componentsSeparatedByString:@","]];
        ideBool = 1;
    }else{
        self.getIdentityType = [[NSMutableArray alloc]init];
        ideBool = 0;
    }

    NSString *loanStr = [[NSUserDefaults standardUserDefaults] valueForKey:Big_LoanLimit];
    BOOL loanBool;
    if (loanStr.length>0) {
        self.getLoanLimit = [[NSMutableArray alloc]initWithArray:[loanStr componentsSeparatedByString:@","]];
        loanBool = 1;
    }else{
        self.getLoanLimit = [[NSMutableArray alloc]init];
        loanBool = 0;
    }
    
    NSString *quaStr = [[NSUserDefaults standardUserDefaults] valueForKey:Big_Qualification];
    BOOL quaBool;
    if (quaStr.length>0) {
        self.getQualification = [[NSMutableArray alloc]initWithArray:[quaStr componentsSeparatedByString:@","]];
        quaBool = 1;
    }else{
        self.getQualification = [[NSMutableArray alloc]init];
        quaBool = 0;
    }
    
    if (quaBool || loanBool || ideBool || custoBool) {
        self.isShaiXuanStatus = 1;
    }else{
        self.isShaiXuanStatus = 0;
    }
    
}
-(void)exchangeData{
    self.identityType = [[NSMutableArray alloc]initWithArray:self.getIdentityType];
    self.qualification = [[NSMutableArray alloc]initWithArray:self.getQualification];
    self.loanLimit = [[NSMutableArray alloc]initWithArray:self.getLoanLimit];
    self.mortgageType = [[NSMutableArray alloc]initWithArray:self.getMortgageType];

    self.loanStartLimit = self.getLoanStartLimit;
    self.loanEndLimit = self.getLoanEndLimit;
}
#pragma mark 懒加载
-(NSMutableArray *)customerArr{
    if (!_customerArr) {
        _customerArr = [[NSMutableArray alloc]init];
    }
    return _customerArr;
}
-(NSMutableArray *)mortgageArr{
    if (!_mortgageArr) {
        _mortgageArr = [[NSMutableArray alloc]init];
    }
    return _mortgageArr;
}
-(NSMutableArray *)identityArr{
    if (!_identityArr) {
        _identityArr = [[NSMutableArray alloc]init];
    }
    return _identityArr;
}
-(NSMutableArray *)loanArr{
    if (!_loanArr) {
        _loanArr = [[NSMutableArray alloc]init];
    }
    return _loanArr;
}
-(NSMutableArray *)qualiArr{
    if (!_qualiArr) {
        _qualiArr = [[NSMutableArray alloc]init];
    }
    return _qualiArr;
}

-(UIView *)mengView{
    if (!_mengView) {
        _mengView = [[UIView alloc]init];
        _mengView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT);
        _mengView.backgroundColor = [UIColor blackColor];
        _mengView.alpha = 0.6;
        _mengView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mengViewTap)];
        [_mengView addGestureRecognizer:tap];
    }
    return _mengView;
}
-(void)mengViewTap{
    
    self.tabBarController.tabBar.hidden = NO;
    [UIView animateWithDuration:0.4f animations:^{
        self.selectView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH-84, SCREENH_HEIGHT);
        self.mengView.alpha = 0;
    }];
    [self.selectView endEditing:YES];
    
    
    
    self.mengView.hidden = YES;
    
    if (self.isRet) {
        self.pageNum = 1;
        [self.sliderBar setSelectIndex:0];
        
        [self getCreditinfoListData];
        self.isRet = NO;
    }
    [self restAllscreenArray:YES];
}

#pragma mark -重置所有的筛选数组
- (void)restAllscreenArray:(BOOL)isRemove {
    if (isRemove) {
        [self.allCellArr removeAllObjects];
        [self.selectCell2 removeAllObjects];
        [self.selectCell3 removeAllObjects];
    }
    [self.selectCell1 removeAllObjects];
//    [self.selectCell2 removeAllObjects];
//    [self.selectCell3 removeAllObjects];
    [self.selectCell4 removeAllObjects];
    [self.selectCell5 removeAllObjects];
}


-(UIView *)selectView{
    if (!_selectView) {
        _selectView = [[UIView alloc]init];
        _selectView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH-84, SCREENH_HEIGHT);
        _selectView.backgroundColor = COLORWHITE;
        _selectView.userInteractionEnabled = YES;
    }
    return _selectView;
}
#pragma mark 通知
- (void)homeSendNoti:(NSNotification *)text{
    [self homeSendReloadData:text.userInfo[@"claCode"]];
}

- (void)homeSendReloadData:(NSString *)text{
    [self.mortgageType removeAllObjects];
    [self.identityType removeAllObjects];
    [self.customerStatus removeAllObjects];
    [self.qualification removeAllObjects];
    self.loanStartLimit = @"";
    self.loanEndLimit = @"";
    
    if([text isEqualToString:FenLei_QuanBu]){
        [self.sliderBar setSelectIndex: 0];
    }else{
        for (int i = 0; i < self.mortgageArr.count; i++) {
            
            NSString * sID = [NSString stringWithFormat:@"%@",self.mortgageArr[i][@"claCode"]];
            if ([sID isEqualToString:text]) {
                [self.sliderBar setSelectIndex: i+1];
                
                self.pageNum = 1;
                [self.mortgageType addObject:text];
                
                [self getCreditinfoListData];
                
            }
        }
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HomeSendNoti" object:nil];
}

#pragma mark - 设置列表无数据时的页面
- (void)setUpNoDataView{
    if (self.noDataFatherView == nil) {
        self.noDataFatherView = [[UIView alloc] init];
        [self.daTableView addSubview:self.noDataFatherView];
//        self.noDataFatherView.backgroundColor = ColorBackground_Line;
        [self.noDataFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.top.mas_equalTo(0);
        }];
        
        self.noDataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiaoren_wushuju"]];
        [self.noDataFatherView addSubview:self.noDataImageView];
        [self.noDataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(290);
            make.width.mas_equalTo(139);
            make.height.mas_equalTo(113);
            make.centerX.mas_equalTo(self.daTableView);
        }];
        
        self.noDataTitleLabel = [[UILabel alloc] init];
        [self.noDataFatherView addSubview:self.noDataTitleLabel];
        self.noDataTitleLabel.font = [UIFont systemFontOfSize:15];
        self.noDataTitleLabel.textColor = Colorbdbdbd;
        self.noDataTitleLabel.textAlignment = 1;
        self.noDataTitleLabel.numberOfLines = 0;
        [self.noDataTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.daTableView.mas_width);
            make.top.mas_equalTo(self.daTableView.mas_bottom).offset(410);
        }];
        self.noDataFatherView.hidden = YES;
    }
}

- (void)dingWeiShuaXinList{
    self.pageNum = 1;
    [self getCreditinfoListData];
}

#pragma mark 开始啦
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTopLocationBtn]; //创建顶部定位按钮

    self.goBackButton.hidden = YES;
    
    
    self.zhiMaFenCode = @"";
    self.zhiMaFenName = @"请选择";
    self.xinYongKaCode = @"";
    self.xinYongKaName = @"请选择";
    self.shouRuCode = @"";
    self.shouRuName = @"请选择";
    
    self.bannerCellHeight = 8*2+5+(SCREEN_WIDTH-30)*75/345;
    self.isClose = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dingWeiShuaXinList) name:SelectedCityAction object:nil];
    self.isRet = NO;
    self.isFirst = YES;
    self.pageNum = 1;
    self.count = [NSDate dateToString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeSendNoti:) name:@"HomeSendNoti"object:nil];
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = ColorBackground_Line;

    
    //存储 传值 数据信息
    self.loanStartLimit = @"";
    self.loanEndLimit = @"";
    self.qualification = [[NSMutableArray alloc]init];
    self.customerStatus = [[NSMutableArray alloc]init];
    self.mortgageType = [[NSMutableArray alloc]init];
    self.identityType = [[NSMutableArray alloc]init];
    self.loanLimit = [[NSMutableArray alloc]init];
    

    self.allListData = [[NSMutableArray alloc]init];
 
    //新🆕
    //存储 传值 数据信息
    self.loanStartLimit = @"";
    self.loanEndLimit = @"";
    self.qualification = [[NSMutableArray alloc]init];
    self.customerStatus = [[NSMutableArray alloc]init];
    self.mortgageType = [[NSMutableArray alloc]init];
    self.identityType = [[NSMutableArray alloc]init];
    self.loanLimit = [[NSMutableArray alloc]init];
    self.allListData = [[NSMutableArray alloc]init];
    //    self.itemArray = [[NSMutableArray alloc]initWithObjects:@"全部", nil]; // 顶部左右滚动的数组
    self.itemArray = [[NSMutableArray alloc] init];
    self.selectCell1 = [[NSMutableArray alloc]init];
    self.selectCell2 = [[NSMutableArray alloc]init];
    self.selectCell3 = [[NSMutableArray alloc]init];
    self.selectCell4 = [[NSMutableArray alloc]init];
    self.selectCell5 = [[NSMutableArray alloc]init];
    self.allCellArr = [[NSMutableArray alloc]init];
    self.selectHeaderArr = [[NSMutableArray alloc]init];
    self.selectDataArr = [[NSMutableArray alloc]init];
    
    //数据加载
    [self getClassifyData];
    [self getCreditinfoListData];//获取列表数据
    [self getBannerListData];   //第三个cell后的banner
    
    [self setupTableView];
    [self setUpNoDataView];//设置列表无数据时的页面
    [self getCreditinfoListData];//得到资源列表
    
    [self.navigationController.view addSubview:self.mengView];
    [self.navigationController.view addSubview:self.selectView];
    
    self.mengView.hidden = YES;
    [self createSelectViewChildrenView];
    
    UIView * line = [[UIView alloc]init];
    line.frame = CGRectMake(0, getRectNavAndStatusHight-0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = COLOR_WITH_HEX(0x005DEF);
    [self.view addSubview:line];
    
    self.sliderBar.originIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick event:@"home-grab"];
    [self getDENGFANGUserInfoData];
}

#pragma mark 创建顶部定位按钮
-(void)createTopLocationBtn{
//    self.titleLabelNavi.text = @"小象抢单";
//    self.titleLabelNavi.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:18];
//    [self.navigationView borderForColor:Colorffffff borderWidth:0.5 borderType:UIBorderSideTypeBottom];
//    图标
    self.navigationView.backgroundColor = COLOR_WITH_HEX(0x0661F6);
    UIImageView * leftImg = [[UIImageView alloc]init];
    [self.navigationView addSubview:leftImg];
    leftImg.image = [UIImage imageNamed:@"dingwei"];
    [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(19);
        make.width.mas_equalTo(17);
        make.top.mas_equalTo((getRectNavHight-19)/2+getStatusHeight);
    }];
    
    //文字
    self.displayLabel = [[UILabel alloc]init];
    self.displayLabel.userInteractionEnabled = YES;
    [self.navigationView addSubview:self.displayLabel];
    self.displayLabel.text = [[SSH_TOOL_GongJuLei getSelectedCityName] isEqualToString:@""]?@"全国":[self isOneCityOrMoreCity:[SSH_TOOL_GongJuLei getSelectedCityName]];
    if ([self.displayLabel.text isEqualToString:@"全国"]) {
        [MobClick event:@"home-location"];
    }
    self.displayLabel.textColor = COLORWHITE;
    self.displayLabel.font = UIFONTTOOL15;
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftImg.mas_right).offset(7);
        make.height.mas_equalTo(getRectNavHight);
        make.top.mas_equalTo(getStatusHeight);
    }];
    //    self.displayLabel.backgroundColor = [UIColor cyanColor];
    
    //箭头
    UIImageView * rightImg = [[UIImageView alloc]init];
    [self.navigationView addSubview:rightImg];
    rightImg.image = [UIImage imageNamed:@"dingweijiantou"];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.displayLabel.mas_right).offset(9);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(6);
        make.centerY.mas_equalTo(self.displayLabel); //cityLabel
    }];
    //cityLabel
    CGFloat textW = [self getWidthWithTitle:self.displayLabel.text font:UIFONTTOOL15];
    
    //按钮点击事件
    self.cityBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.navigationView addSubview:self.cityBtn];
    self.cityBtn.backgroundColor = [UIColor clearColor];
    [self.cityBtn addTarget:self action:@selector(cityBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.cityBtn.frame = CGRectMake(5, getStatusHeight, textW+70, getRectNavHight);
    //    self.cityBtn.backgroundColor = [UIColor purpleColor];
    
}
- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}
-(void)cityBtnClicked{
    SSH_DingWeiViewController *locationVC = [[SSH_DingWeiViewController alloc]init];
    locationVC.hidesBottomBarWhenPushed = YES;
    locationVC.delegate = self;
    DENGFANGLocationCity *cityM = [[DENGFANGLocationCity alloc] init];
    cityM.name = self.displayLabel.text;
    locationVC.oneCityM = cityM;
    
    [self.navigationController pushViewController:locationVC animated:YES];
}
-(NSString *)isOneCityOrMoreCity:(NSString *)citys{
    if ([citys containsString:@","]) {
        NSArray *array = [citys componentsSeparatedByString:@","];
        return [NSString stringWithFormat:@"%@...",[array firstObject]];
    }
    return citys;
}
#pragma mark --------获取顶部数据
//数据请求：顶部分类 && 筛选里的内容
-(void)getClassifyData{
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGClassifyURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil],@"isDesc":@1} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];

        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            
            NSArray * allData = diction[@"data"];
            NSMutableArray * codeArr = [[NSMutableArray alloc]init];
            
            for (NSDictionary * dic in allData) {
                
                SSH_ClassifyModel * model = [[SSH_ClassifyModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.selectHeaderArr addObject:model];
                
                
                [codeArr addObject:dic[@"classifyCode"]];
                NSArray * morAllArr = dic[@"tydClassifyCondition"];
                //客户状态
                if ([dic[@"classifyCode"] isEqualToString: ShaiXuan_Customer_Status]) {
                    self.customerArr = [[NSMutableArray alloc]initWithArray:morAllArr];
                }
                //资产抵押类型
                if ([dic[@"classifyCode"] isEqualToString: ShaiXuan_Mortgage_Type]) {
                    self.mortgageArr = [[NSMutableArray alloc]initWithArray:morAllArr];
                    //                    for (NSDictionary * sdic in morAllArr) {
                    //                        [self.itemArray addObject:sdic[@"conditionName"]];
                    //                    }
                }
                
                //身份类型
                if ([dic[@"classifyCode"] isEqualToString: ShaiXuan_IDentity_Type]) {
                    self.identityArr = [[NSMutableArray alloc]initWithArray:morAllArr];
                }
                //金额
                if ([dic[@"classifyCode"] isEqualToString: ShaiXuan_Loan_Limit]) {
                    self.loanArr = [[NSMutableArray alloc]initWithArray:morAllArr];
                }
                //资质信息
                if ([dic[@"classifyCode"] isEqualToString: ShaiXuan_Qualification]) {
                    self.qualiArr  = [[NSMutableArray alloc]initWithArray:morAllArr];
                    self.ziZhiArray = [SSH_ShaiXuanModel mj_objectArrayWithKeyValuesArray:self.qualiArr];
                    
                    for (SSH_ShaiXuanModel *m in self.ziZhiArray) {
                        //                        if ([m.claCode isEqualToString:@"CREDIT_CARD"] || [m.claCode isEqualToString:@"SESAME"] || [m.claCode isEqualToString:@"INCOME"]) {
                        //                            [self.zhiMaFenXinYongKaArr addObject:m];
                        //                        }
                        if ([m.claCode isEqualToString:@"CREDIT_CARD"]){
                            for (int i=0; i<m.tydClassifySon.count; i++) {
                                SSH_ShaiXuanSonModel *son = m.tydClassifySon[i];
                                if ([son.classifySonName isEqualToString:@"请选择"]) {
                                    self.xinYongKaCode = son.classifySonCode;
                                }
                            }
                            [self.zhiMaFenXinYongKaArr addObject:m];
                        }else if ([m.claCode isEqualToString:@"SESAME"]){
                            for (int i=0; i<m.tydClassifySon.count; i++) {
                                SSH_ShaiXuanSonModel *son = m.tydClassifySon[i];
                                if ([son.classifySonName isEqualToString:@"请选择"]) {
                                    self.zhiMaFenCode = son.classifySonCode;
                                }
                            }
                            [self.zhiMaFenXinYongKaArr addObject:m];
                        }else if ([m.claCode isEqualToString:@"INCOME"]){
                            for (int i=0; i<m.tydClassifySon.count; i++) {
                                SSH_ShaiXuanSonModel *son = m.tydClassifySon[i];
                                if ([son.classifySonName isEqualToString:@"请选择"]) {
                                    self.shouRuCode = son.classifySonCode;
                                }
                            }
                            [self.zhiMaFenXinYongKaArr addObject:m];
                        }
                    }
                }
            }
            
            for (NSString * str in codeArr) {
                if ([str isEqualToString:ShaiXuan_Qualification]) {
                    [self.selectDataArr addObject:self.qualiArr];
                }else if ([str isEqualToString:ShaiXuan_Loan_Limit]){
                    [self.selectDataArr addObject:self.loanArr];
                }else if ([str isEqualToString:ShaiXuan_IDentity_Type]){
                    [self.selectDataArr addObject:self.identityArr];
                }else if ([str isEqualToString:ShaiXuan_Mortgage_Type]){
                    [self.selectDataArr addObject:self.mortgageArr];
                }else if ([str isEqualToString:ShaiXuan_Customer_Status]){
                    [self.selectDataArr addObject:self.customerArr];
                }
            }
            
            //            self.sliderBar.itemArray = self.itemArray;
            //            [self.collectView reloadData];
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                [self homeSendReloadData:self.selectID];
            //            });
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
    }];
    [self getTopListData];
}
- (void)getTopListData {
    [self.itemArray removeAllObjects];
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGClassifyURL parameters:@{@"classifyCode":ShaiXuan_Mortgage_Type,@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil],@"isDesc":@1} success:^(id responseObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSArray *maAllArr = diction[@"data"];
        NSDictionary *dic = maAllArr[0];
        NSArray * morAllArr = dic[@"tydClassifyCondition"];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSDictionary * sdic in morAllArr) {
            [self.itemArray addObject:sdic];
            [arr addObject:sdic[@"conditionName"]];
        }
        
        self.sliderBar.itemArray = arr;
        [self.collectView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self homeSendReloadData:self.selectID];
        });
        
    } fail:^(NSError *error) {
        
    }];
    
}

- (void)setupTableView{
    
    NSLog(@"%f,%f,%f",getRectNavAndStatusHight,SafeAreaAllBottomHEIGHT,SCREENH_HEIGHT);
    CGFloat height = getRectNavAndStatusHight + SafeAreaAllBottomHEIGHT;
    self.daTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - height) style:UITableViewStylePlain];
    [self.normalBackView addSubview:self.daTableView];
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
    
    [self getBannerListData];
    
    self.daTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self getCreditinfoListData];
        //        [self getTopListData];
        
    }];
    
    self.daTableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        self.pageNum = self.pageNum + 1;
        [self getCreditinfoListData];
    }];
    
    [self setupTableHeadView];
}

#pragma mark 设置tableView头部视图
- (void)setupTableHeadView{
    
    //headView
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44 + (SCREEN_WIDTH-30)*84/345+8)];//276
    self.daTableView.tableHeaderView = headView;
    headView.backgroundColor = ColorBackground_Line;
    
    //顶部信息展示view
    UIView *lunboView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH-30)*84/345+8)];
    lunboView.backgroundColor = COLOR_WITH_HEX(0x0762F6);
    [headView addSubview:lunboView];
//    lunboView.backgroundColor = COLORWHITE;

    UILabel *keHuLab = [[UILabel alloc] init];
    keHuLab.textColor = Colorffffff;
    keHuLab.font = [UIFont systemFontOfSize:12];
    keHuLab.text = [NSString stringWithFormat:@"今日新增%@款客户(人)",[DENGFANGSingletonTime shareInstance].name[1]];
    [lunboView addSubview:keHuLab];
    [keHuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *jinELab = [[UILabel alloc] init];
    jinELab.textColor = Colorffffff;
    jinELab.font = [UIFont systemFontOfSize:12];
    jinELab.text = [NSString stringWithFormat:@"今日总需%@款(元)",[DENGFANGSingletonTime shareInstance].name[1]];
    [lunboView addSubview:jinELab];
    [jinELab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(12);
    }];
    
    keHuNumLab = [[UILabel alloc] init];
    keHuNumLab.textColor = Colorffffff;
    keHuNumLab.font = [UIFont systemFontOfSize:24];
    keHuNumLab.text = [NSString stringWithFormat:@"0"];
    [lunboView addSubview:keHuNumLab];
    [keHuNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(keHuLab.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(24);
    }];
    
    jinENumLab = [[UILabel alloc] init];
    jinENumLab.textColor = Colorffffff;
    jinENumLab.font = [UIFont systemFontOfSize:24];
    jinENumLab.text = [NSString stringWithFormat:@"0"];
    [lunboView addSubview:jinENumLab];
    [jinENumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(jinELab.mas_bottom).offset(10);;
        make.left.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(24);
    }];
    
//    //5个分类按钮
//    UIView *categoryView = [[UIView alloc] init];
//    categoryView.backgroundColor = COLORWHITE;
//    [headView addSubview:categoryView];
//    [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.mas_equalTo(lunboView.bottom);
//        make.height.mas_equalTo(20);
//    }];
    //最新发布view
    UIView *mostNewView = [UIView new];
    [headView addSubview:mostNewView];
    mostNewView.backgroundColor = COLORWHITE;
    [mostNewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(lunboView.bottom);
        make.height.mas_equalTo(45);
    }];
    [mostNewView addSubview:self.sliderBar];
    //渐变view
    UIImageView * imgv = [[UIImageView alloc]init];
    imgv.image = [UIImage imageNamed:@"topmengview"];
    [self.sliderBar addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(36);
    }];
    
    [self.sliderBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-65);
    }];
    self.sliderBar.backgroundColor = [UIColor redColor];
    
    [mostNewView addSubview:self.reloadButton]; //筛选按钮
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    
}
-(void)setUpCollectionView{
    //确定是水平滚动,还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 13, self.selectView.mj_w, self.selectView.mj_h-20-getTabbarHeight) collectionViewLayout:flowLayout];
    self.collectView.dataSource=self;
    self.collectView.delegate=self;
    [self.collectView setBackgroundColor:[UIColor whiteColor]];
    self.collectView.showsHorizontalScrollIndicator = NO;
    self.collectView.showsVerticalScrollIndicator = NO;
    //注册Cell,必须要有
    [self.collectView registerClass:[SSH_SelectCollectionCell class] forCellWithReuseIdentifier:@"SSH_SelectCollectionCell"];
    
    [self.collectView registerClass:[SSH_SelectHeaderCollectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SSH_SelectHeaderCollectionView"];
    
    [self.collectView registerClass:[SSH_ZiZhiXinXiHeaderCollectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DENGFANGZiZhiXinXiHeaderCollectionView"];

    [self.selectView addSubview:self.collectView];

}
#pragma mark 重置淘单大全里面的筛选状态
-(void)resetTaoDanDaQuanShuaiXuanState{
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Big_CustomerStatus];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Big_MortgageType];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Big_IDEntityType];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Big_LoanLimit];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Big_LoanStartLimit];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Big_LoanEndLimit];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:Big_Qualification];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
#pragma mark 创建筛选界面上的view
-(void)createSelectViewChildrenView{
    
    //最底部按钮
    for (int i = 0; i < 2; i++) {
        UIButton * boBtn = [[UIButton alloc]init];
        boBtn.frame = CGRectMake(self.selectView.mj_w/2*i, self.selectView.mj_h-getTabbarHeight, self.selectView.mj_w/2, getTabbarHeight);
        boBtn.backgroundColor = ColorBackground_Line;
        [boBtn setTitle:@"重置" forState:UIControlStateNormal];
        [boBtn setTitleColor:ColorBlack222 forState:UIControlStateNormal];
        boBtn.titleLabel.font = UIFONTTOOL15;
        boBtn.tag = 10+i;
        if (i == 1) {
            boBtn.backgroundColor = ColorZhuTiHongSe;
            [boBtn setTitle:@"确定" forState:UIControlStateNormal];
            [boBtn setTitleColor:COLORWHITE forState:UIControlStateNormal];
        }
        [boBtn addTarget:self action:@selector(boBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectView addSubview:boBtn];
    }
    
}
-(void)boBtnClicked:(UIButton *)btn{
    if (btn.tag == 10) {
        NSLog(@"重置");
        ////////////////////////////////////////
        self.zhiMaFenCode = @"";
        self.zhiMaFenName = @"请选择";
        self.xinYongKaCode = @"";
        self.xinYongKaName = @"请选择";
        self.shouRuCode = @"";
        self.shouRuName = @"请选择";
        //重新刷新
        self.reusableView.zhiMaFenNameString = self.zhiMaFenName;
        self.reusableView.xinYongKaNameString = self.xinYongKaName;
        self.reusableView.shouRuNameString = self.shouRuName;
        self.reusableView.dataArray = self.zhiMaFenXinYongKaArr;
        self.reusableView.smallLabel.text = self.classifyName;
        ///////////////////////////////////////
        [self resetTaoDanDaQuanShuaiXuanState];
        [self getUserDefaultState];
        self.isRet = YES;
        [self.mortgageType removeAllObjects];
        [self.identityType removeAllObjects];
        [self.customerStatus removeAllObjects];
        [self.qualification removeAllObjects];
        [self.loanLimit removeAllObjects];
        self.loanStartLimit = @"";
        self.loanEndLimit = @"";
        self.headerViewOne.rigthTextField.text = @"";
        self.headerViewOne.leftTextField.text = @"";
        for (SSH_SelectCollectionCell * kongCell in self.allCellArr) {
            [self updateCollectionViewCellStatus:kongCell selected:NO Type:kongCell.classifyModel.classifyCode];
        }
        [self restAllscreenArray:NO];
    }else if (btn.tag == 11){
        [MobClick event:@"list-filter-ensure"];
        self.isRet = NO;
        self.tabBarController.tabBar.hidden = NO;
        [UIView animateWithDuration:0.4f animations:^{
            self.selectView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH-84, SCREENH_HEIGHT);
            self.mengView.alpha = 0;
        }];
        
        self.mengView.hidden = YES;

        NSLog(@"资质信息 = %@",self.qualification);
        NSLog(@"客户状态 = %@",self.customerStatus);
        NSLog(@"资产抵押 = %@",self.mortgageType);
        NSLog(@"身份 = %@",self.identityType);
        
        if (self.mortgageType.count == 1) {
            for (int i = 0; i < self.mortgageArr.count; i++) {
                NSString * code = [NSString stringWithFormat:@"%@",self.mortgageArr[i][@"claCode"]];
                if ([code isEqualToString:self.mortgageType[0]]) {
                    for (int j = 0; j < self.itemArray.count; j++) {
                        NSDictionary *dic = self.itemArray[j];
                        if ([dic[@"claCode"] isEqualToString:code]) {
                            [self.sliderBar setSelectIndex:j];
                        }
                    }
                    
                }
            }
        }else if (self.mortgageType.count > 1 || self.mortgageType.count == 0){
            [self.sliderBar setSelectIndex:0];
        }
        
        self.pageNum = 1;
        
        [self getCreditinfoListData];
        [self restAllscreenArray:YES];
    }
}
-(UIButton *)reloadButton{
    if (!_reloadButton) {
        _reloadButton = [[UIButton alloc]init];
        _reloadButton.frame = CGRectMake(SCREEN_WIDTH-65, getStatusHeight, 50, getRectNavHight);
        [_reloadButton setTitle:@"筛选" forState:UIControlStateNormal];
        [_reloadButton setImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
        _reloadButton.imageEdgeInsets = UIEdgeInsetsMake(0, _reloadButton.frame.size.width - _reloadButton.imageView.frame.origin.x - _reloadButton.imageView.frame.size.width+2, 0, 0);

        _reloadButton.titleLabel.font = UIFONTTOOL14;
        [_reloadButton setTitleColor:ColorBlack222 forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(reloadButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadButton;
}
#pragma mark 筛选
-(void)reloadButtonClicked{
    [MobClick event:@"list-filter"];
    self.mengView.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [UIView animateWithDuration:0.4f animations:^{
        self.selectView.frame = CGRectMake(84, 0, SCREEN_WIDTH-84, SCREENH_HEIGHT);
        self.mengView.alpha = 0.6;

    }];
    [self exchangeData];
    [self.collectView removeFromSuperview];
    
    [self setUpCollectionView];
}
- (SSH_CategorySliderBar *)sliderBar
{
    if (!_sliderBar) {
        _sliderBar = [[SSH_CategorySliderBar alloc]initWithFrame:CGRectMake(15, getStatusHeight, SCREEN_WIDTH-65-15, getRectNavHight)];
        _sliderBar.delegate = self;
    }
    return _sliderBar;
}

- (void)ZXPageViewDidScroll:(UIScrollView *)scrollView direction:(NSString *)direction{
    [self.sliderBar adjustIndicateViewX:scrollView direction:direction];
}
- (void)didSelectedIndex:(NSInteger)index{
    
    NSLog(@"点击了----%ld",(long)index);
    if (index == 0) {
        [MobClick event:@"home-all orders"];
        self.isFirst = YES;
        self.pageNum = 1;
        [self.mortgageType removeAllObjects];
        [self.identityType removeAllObjects];
        [self.customerStatus removeAllObjects];
        [self.qualification removeAllObjects];
        [self.loanLimit removeAllObjects];
        self.loanStartLimit = @"";
        self.loanEndLimit = @"";
        self.selectID = @"ALL";
        [self getCreditinfoListData];
    }else{
        if (index == 1) {
            [MobClick event:@"home-can graborders"];
        }
        self.isFirst = NO;
        self.pageNum = 1;
        [self.mortgageType removeAllObjects];
        NSDictionary *dic = self.itemArray[index];
        self.selectID = dic[@"claCode"];
        [self.mortgageType addObject:dic[@"claCode"]];
        
        [self getCreditinfoListData];
    }
}

#pragma mark - tableView里的方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SSH_HomeCreditxinxiListModel *model;
    model = self.allListData[indexPath.row];
    SSH_KeHuXiangQingViewController *productDetail = [SSH_KeHuXiangQingViewController new];
    productDetail.isDiscount = model.isDiscount;
    productDetail.creditinfoId = model.creditinfoId;
    productDetail.hidesBottomBarWhenPushed = YES;
    productDetail.pageType = 1;
    productDetail.fromWhere = 2;
    [self.navigationController pushViewController:productDetail animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger rowInteger;
    if (self.allListData.count<=3) {
        rowInteger = self.allListData.count;
    }else{
        rowInteger = 3;
    }
    
    SSH_ShouYeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"daquancell"];
    if (!cell) {
        cell = [[SSH_ShouYeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"daquancell"];
    }
    
    if (self.allListData.count > 0) {
        cell.homeCellModel = self.allListData[indexPath.row];
    }
    
    cell.selectionStyle = 0;
    return cell;
    
}

-(void)getDENGFANGUserInfoData{
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]};
    
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGUserInfoURL parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"获取用户信息 数据 %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {

            self.infoModel = [[SSH_GeRenXinXiModel alloc]init];
            if ([diction[@"data"] isKindOfClass:NSDictionary.class]) {
                [self.infoModel setValuesForKeysWithDictionary:diction[@"data"]];
            }
            if ([self.infoModel.isAuth intValue] == 1 && [self.infoModel.isFaceCheck intValue] == 1) {
                [DENGFANGSingletonTime shareInstance].isTongguoIDRenZheng = 1;
            }else{
                [DENGFANGSingletonTime shareInstance].isTongguoIDRenZheng = 0;
            }
            
        }
    } fail:^(NSError *error) {
        
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if(self.allListData.count == 0) {
//        self.noDataFatherView.hidden = NO;
//    } else {
//        self.noDataFatherView.hidden = YES;
//    }
    if([self.infoModel.isAuth intValue] == 1 && [self.infoModel.isFaceCheck intValue] == 1){
        [tableView tableViewWitingImageName:@"" forRowCount:self.allListData.count];
    }else{
        [tableView tableViewWitingImageName:@"syzwdd" forRowCount:self.allListData.count];
    }
    
    return self.allListData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger rowInteger;
    if (self.allListData.count<=3) {
        rowInteger = self.allListData.count;
    }else{
        rowInteger = 3;
    }
    return 188;
    
}

#pragma mark collectionView代理方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.selectHeaderArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray * row = self.selectDataArr[section];
    return row.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SSH_SelectCollectionCell * cell = (SSH_SelectCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SSH_SelectCollectionCell" forIndexPath:indexPath];
    
    
    SSH_ClassifyModel * model = self.selectHeaderArr[indexPath.section];
    cell.classifyModel = model;
    
    cell.singleLabel.text = self.selectDataArr[indexPath.section][indexPath.row][@"conditionName"];
    
    [self.allCellArr addObject:cell];
    
    NSString * codeStr =self.selectDataArr[indexPath.section][indexPath.row][@"claCode"];
    
//    DENGFANGClassifyModel * model = self.selectHeaderArr[indexPath.section];
    
    if ([model.classifyCode isEqualToString:ShaiXuan_Customer_Status]) {//客户状态
        for (NSString * haveStr in self.getCustomerStatus) {
            if ([haveStr isEqualToString:codeStr]) {
                [self updateCollectionViewCellStatus:cell selected:YES Type:ShaiXuan_Customer_Status];
            }
        }
        if (!model.isChecks) {
            NSString * str = [NSString stringWithFormat:@"%ld",indexPath.section];
            if (indexPath.row == 0) {
                [self.selectCell1 addObject:str];
            }
            [self.selectCell1 addObject:cell];
        }
    }else if ([model.classifyCode isEqualToString:ShaiXuan_Loan_Limit]){//金额
        NSString * idStr =self.selectDataArr[indexPath.section][indexPath.row][@"id"];
        for (NSString * haveStr in self.getLoanLimit) {
            if ([haveStr intValue] == [idStr intValue]) {
                [self updateCollectionViewCellStatus:cell selected:YES Type:ShaiXuan_Loan_Limit];
            }
        }
        if (!model.isChecks) {
            NSString * str = [NSString stringWithFormat:@"%ld",indexPath.section];
            if (indexPath.row == 0) {
                [self.selectCell2 addObject:str];
            }
            [self.selectCell2 addObject:cell];
        }
    }else if ([model.classifyCode isEqualToString:ShaiXuan_Mortgage_Type]){//资产抵押
        for (NSString * haveStr in self.getMortgageType) {
            if ([haveStr isEqualToString:codeStr]) {
                [self updateCollectionViewCellStatus:cell selected:YES Type:ShaiXuan_Mortgage_Type];
            }
        }
        if (!model.isChecks) {
            NSString * str = [NSString stringWithFormat:@"%ld",indexPath.section];
            if (indexPath.row == 0) {
                [self.selectCell3 addObject:str];
            }
            [self.selectCell3 addObject:cell];
        }
    }else if ([model.classifyCode isEqualToString:ShaiXuan_IDentity_Type]){//身份
        for (NSString * haveStr in self.getIdentityType) {
            if ([haveStr intValue] == [codeStr intValue]) {
                [self updateCollectionViewCellStatus:cell selected:YES Type:ShaiXuan_IDentity_Type];
            }
        }
        if (!model.isChecks) {
            NSString * str = [NSString stringWithFormat:@"%ld",indexPath.section];
            if (indexPath.row == 0) {
                [self.selectCell4 addObject:str];
            }
            [self.selectCell4 addObject:cell];
        }
    }else if ([model.classifyCode isEqualToString:ShaiXuan_Qualification]){//资质
        for (NSString * haveStr in self.getQualification) {
            if ([haveStr isEqualToString:codeStr]) {
                [self updateCollectionViewCellStatus:cell selected:YES Type:ShaiXuan_Qualification];
            }
        }
        if (!model.isChecks) {
            NSString * str = [NSString stringWithFormat:@"%ld",indexPath.section];
            if (indexPath.row == 0) {
                [self.selectCell5 addObject:str];
            }
            [self.selectCell5 addObject:cell];
        }
    }
    return cell;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-84-40)/3, 34);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    SSH_ClassifyModel * model = self.selectHeaderArr[indexPath.section];

    SSH_SelectHeaderCollectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SSH_SelectHeaderCollectionView" forIndexPath:indexPath];
    headerView.smallLabel.text = model.classifyName;

    SSH_ZiZhiXinXiHeaderCollectionView *ziZhiHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DENGFANGZiZhiXinXiHeaderCollectionView" forIndexPath:indexPath];
    
    ziZhiHeaderView.zhiMaFenNameString = self.zhiMaFenName;
    ziZhiHeaderView.xinYongKaNameString = self.xinYongKaName;
    ziZhiHeaderView.shouRuNameString = self.shouRuName;
    ziZhiHeaderView.dataArray = self.zhiMaFenXinYongKaArr;
    ziZhiHeaderView.smallLabel.text = model.classifyName;
    
    ziZhiHeaderView.MyBlock = ^(UIButton *button) {
        [self showAlertActionSheetIndex:button];
    };
    
    if ([model.classifyCode isEqualToString:ShaiXuan_Loan_Limit]) {
        headerView.bgTextView.hidden = NO;
        self.headerViewOne = headerView;
        headerView.leftTextField.text = self.loanStartLimit;
        headerView.rigthTextField.text = self.loanEndLimit;
        [headerView.rigthTextField addTarget:self action:@selector(moneyValueChange:) forControlEvents:UIControlEventEditingDidEnd];
        [headerView.leftTextField addTarget:self action:@selector(moneyValueChange:) forControlEvents:UIControlEventEditingDidEnd];
        ziZhiHeaderView.bgView.hidden = YES;
        return headerView;
    }else if ([model.classifyCode isEqualToString:ShaiXuan_Qualification]){
        ziZhiHeaderView.bgView.hidden = NO;
        self.classifyName = ziZhiHeaderView.smallLabel.text;
        self.reusableView = ziZhiHeaderView;
        return ziZhiHeaderView;
    }else{
        ziZhiHeaderView.bgView.hidden = YES;
        headerView.bgTextView.hidden = YES;
        return headerView;
    }
    

}


//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    SSH_ClassifyModel * model = self.selectHeaderArr[section];

    if ([model.classifyCode isEqualToString:ShaiXuan_Loan_Limit]) {
        CGSize size = {SCREEN_WIDTH-84,29+34};
        return size;
    }else if ([model.classifyCode isEqualToString:ShaiXuan_Qualification]){
        CGSize size={SCREEN_WIDTH-84,self.zhiMaFenXinYongKaArr.count*39+29};
        return size;
    }else{
        CGSize size = {SCREEN_WIDTH-84,29};
        return size;
    }

}
//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size={SCREEN_WIDTH-84,10};
    return size;
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SSH_SelectCollectionCell * cell = (SSH_SelectCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];//即为要得到的cell
    
    if (self.selectCell1.count > 0) { //客户状态
        NSString * fir = self.selectCell1[0];
        if (indexPath.section == [fir intValue]) {
            NSMutableArray * arr = [[NSMutableArray alloc]initWithArray:self.selectCell1];
//            [self.selectCell1 removeAllObjects];
            [arr removeObject:fir];
            [arr removeObjectAtIndex:indexPath.row];
            [self.customerStatus removeAllObjects];
            for (SSH_SelectCollectionCell * cell1 in arr) {
                [self updateCollectionViewCellStatus:cell1 selected:NO Type:ShaiXuan_Customer_Status];
            }
        }
    }
    
    if (self.selectCell2.count > 0) { //金额
        NSString * fir = self.selectCell2[0];
        if (indexPath.section == [fir intValue]) {
            NSMutableArray * arr = [[NSMutableArray alloc]initWithArray:self.selectCell2];
            [arr removeObject:fir];
            [arr removeObjectAtIndex:indexPath.row];
            [self.loanLimit removeAllObjects];
            for (SSH_SelectCollectionCell * cell1 in arr) {
                [self updateCollectionViewCellStatus:cell1 selected:NO Type:ShaiXuan_Loan_Limit];
            }
        }
    }
    
    if (self.selectCell3.count > 0) {//资产抵押
        NSString * fir = self.selectCell3[0];
        if (indexPath.section == [fir intValue]) {
            NSMutableArray * arr = [[NSMutableArray alloc]initWithArray:self.selectCell3];
            [arr removeObject:fir];
            [arr removeObjectAtIndex:indexPath.row];
            [self.mortgageType removeAllObjects];
            for (SSH_SelectCollectionCell * cell1 in arr) {
                [self updateCollectionViewCellStatus:cell1 selected:NO Type:ShaiXuan_Mortgage_Type];
            }
        }
    }
    
    if (self.selectCell4.count > 0) {//身份
        NSString * fir = self.selectCell4[0];
        if (indexPath.section == [fir intValue]) {
            NSMutableArray * arr = [[NSMutableArray alloc]initWithArray:self.selectCell4];
            [arr removeObject:fir];
            [arr removeObjectAtIndex:indexPath.row];
            [self.identityType removeAllObjects];
            for (SSH_SelectCollectionCell * cell1 in arr) {
                [self updateCollectionViewCellStatus:cell1 selected:NO Type:ShaiXuan_IDentity_Type];
            }
        }
    }
    
    if (indexPath.section == 0) {
        NSLog(@"1");
    }else if (indexPath.section == 1){
        NSLog(@"2");
    }else if (indexPath.section == 2){
        NSLog(@"3");
        if (indexPath.row == 0) {
            [MobClick event:@"list-filter-work"];
        }else if (indexPath.row == 1){
            [MobClick event:@"list-filter-free"];
        }else if (indexPath.row == 2){
            [MobClick event:@"list-filter-government"];
        }else if (indexPath.row == 3){
            [MobClick event:@"list-filter-business"];
        }
    }else{
        if (indexPath.row == 0) {
            [MobClick event:@"list-filter-sesame"];
        }else if (indexPath.row == 1){
            [MobClick event:@"list-filter-fund"];
        }else if (indexPath.row == 2){
            [MobClick event:@"list-filter-social"];
        }else if (indexPath.row == 3){
            [MobClick event:@"list-filter-secure"];
        }else if (indexPath.row == 4){
            [MobClick event:@"list-filter-loan"];
        }else if (indexPath.row == 5){
            [MobClick event:@"list-filter-credit"];
        }else if (indexPath.row == 6){
            [MobClick event:@"list-filter-car"];
        }else{
            [MobClick event:@"list-filter-house"];
        }
    }
    
    if (self.selectCell5.count > 0) {//资质
        NSString * fir = self.selectCell5[0];
        if (indexPath.section == [fir intValue]) {
            NSMutableArray * arr = [[NSMutableArray alloc]initWithArray:self.selectCell5];
            [arr removeObject:fir];
            [arr removeObjectAtIndex:indexPath.row];
            [self.qualification removeAllObjects];
            for (SSH_SelectCollectionCell * cell1 in arr) {
                [self updateCollectionViewCellStatus:cell1 selected:NO Type:ShaiXuan_Qualification];
            }
        }
    }
    
    SSH_ClassifyModel * model = self.selectHeaderArr[indexPath.section];
    BOOL isShow = YES;
    if([cell.singleLabel.textColor isEqual:COLORWHITE]){ //取消选中
        if ([model.classifyCode isEqualToString:ShaiXuan_Qualification]) {
            [self.qualification removeObject:self.selectDataArr[indexPath.section][indexPath.row][@"claCode"]];
            [self updateCollectionViewCellStatus:cell selected:NO Type:ShaiXuan_Qualification];
        }else if ([model.classifyCode isEqualToString:ShaiXuan_IDentity_Type]){
            [self updateCollectionViewCellStatus:cell selected:NO Type:ShaiXuan_IDentity_Type];
            [self.identityType removeObject:self.selectDataArr[indexPath.section][indexPath.row][@"claCode"]];
        }else if ([model.classifyCode isEqualToString:ShaiXuan_Customer_Status]){
            [self updateCollectionViewCellStatus:cell selected:NO Type:ShaiXuan_Customer_Status];
            [self.customerStatus removeObject:self.selectDataArr[indexPath.section][indexPath.row][@"claCode"]];
        }else if ([model.classifyCode isEqualToString:ShaiXuan_Mortgage_Type]){
            [self updateCollectionViewCellStatus:cell selected:NO Type:ShaiXuan_Mortgage_Type];
            [self.mortgageType removeObject:self.selectDataArr[indexPath.section][indexPath.row][@"claCode"]];
        }else if ([model.classifyCode isEqualToString:ShaiXuan_Loan_Limit]){
            [self updateCollectionViewCellStatus:cell selected:NO Type:ShaiXuan_Loan_Limit];
            [self.loanLimit removeObject:self.selectDataArr[indexPath.section][indexPath.row][@"id"]];
            isShow = NO;
            self.headerViewOne.rigthTextField.text = @"";
            self.headerViewOne.leftTextField.text = @"";
            self.loanStartLimit = @"";
            self.loanEndLimit = @"";
        }
    }else{//选中
        if ([model.classifyCode isEqualToString:ShaiXuan_Qualification]) {
            [self updateCollectionViewCellStatus:cell selected:YES Type:ShaiXuan_Qualification];
            [self.qualification addObject:self.selectDataArr[indexPath.section][indexPath.row][@"claCode"]];
        }else if ([model.classifyCode isEqualToString:ShaiXuan_IDentity_Type]){
            [self updateCollectionViewCellStatus:cell selected:YES Type:ShaiXuan_IDentity_Type];
            [self.identityType addObject:self.selectDataArr[indexPath.section][indexPath.row][@"claCode"]];
        }else if ([model.classifyCode isEqualToString:ShaiXuan_Customer_Status]){
            [self updateCollectionViewCellStatus:cell selected:YES Type:ShaiXuan_Customer_Status];
            [self.customerStatus addObject:self.selectDataArr[indexPath.section][indexPath.row][@"claCode"]];
        }else if ([model.classifyCode isEqualToString:ShaiXuan_Mortgage_Type]){
            [self updateCollectionViewCellStatus:cell selected:YES Type:ShaiXuan_Mortgage_Type];
            [self.mortgageType addObject:self.selectDataArr[indexPath.section][indexPath.row][@"claCode"]];
        }else if ([model.classifyCode isEqualToString:ShaiXuan_Loan_Limit]){
            [self updateCollectionViewCellStatus:cell selected:YES Type:ShaiXuan_Loan_Limit];
            [self.loanLimit addObject:self.selectDataArr[indexPath.section][indexPath.row][@"id"]];
            isShow = YES;
        }
    }
    
    if (self.selectCell2.count>0) {
        NSString * fir = self.selectCell2[0];
        if (indexPath.section == [fir intValue]) {
            NSString * endStr = [NSString stringWithFormat:@"%@", self.selectDataArr[indexPath.section][indexPath.row][@"loanEndLimit"]];
            NSString * starStr = [NSString stringWithFormat:@"%@", self.selectDataArr[indexPath.section][indexPath.row][@"loanStartLimit"]];
            
            if ([endStr isEqualToString:@"<null>"]) {
                endStr = @"";
            }
            if ([starStr isEqualToString:@"<null>"]) {
                starStr = @"";
            }
            if (isShow) {
                self.headerViewOne.rigthTextField.text = endStr;
                self.headerViewOne.leftTextField.text = starStr;
                
                self.loanEndLimit = endStr;
                self.loanStartLimit = starStr;
            }
        }
    }
   
}

#pragma mark -输入框代理方法
- (void)moneyValueChange:(UITextField *)textField {
    if (textField == self.headerViewOne.leftTextField) {
        self.loanStartLimit = textField.text;
    }else if (textField == self.headerViewOne.rigthTextField) {
        self.loanEndLimit = textField.text;
    }
    if (self.selectCell2.count > 0) {
        NSString * fir = self.selectCell2[0];
        SSH_ClassifyModel * model = self.selectHeaderArr[[fir integerValue]];
        if ([model.classifyCode isEqualToString:ShaiXuan_Loan_Limit]){
            NSMutableArray * arr = [[NSMutableArray alloc]initWithArray:self.selectCell2];
            [self.selectCell2 removeAllObjects];
            [self.loanLimit removeAllObjects];
            for (id cell1 in arr) {
                if ([cell1 isKindOfClass:[SSH_SelectCollectionCell class]]) {
                    [self updateCollectionViewCellStatus:cell1 selected:NO Type:ShaiXuan_Loan_Limit];
                }
            }
        }
    }
}


-(void)updateCollectionViewCellStatus:(SSH_SelectCollectionCell *)myCollectionCell selected:(BOOL)selected Type:(NSString *)type
{
    myCollectionCell.singleLabel.textColor = selected ? COLORWHITE:ColorBlack222;
    
    if ([type isEqualToString:ShaiXuan_Qualification] || [type isEqualToString:ShaiXuan_IDentity_Type]) {
        myCollectionCell.singleLabel.backgroundColor = selected ? ColorZhuTiHongSe:[UIColor whiteColor];
    }else{
        
        myCollectionCell.singleLabel.backgroundColor = selected ? ColorZhuTiHongSe:ColorBackground_Line;
    }
    
}

-(void)showAlertActionSheetIndex:(UIButton *)btn{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    SSH_ShaiXuanModel *m = self.zhiMaFenXinYongKaArr[btn.tag];
    
    for (int i=0; i<m.tydClassifySon.count; i++) {
        SSH_ShaiXuanSonModel *son = m.tydClassifySon[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:son.classifySonName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [btn setTitle:son.classifySonName forState:UIControlStateNormal];
            
            if ([m.claCode isEqualToString:@"SESAME"]) { //芝麻分
                self.zhiMaFenCode = son.classifySonCode;
                self.zhiMaFenName = son.classifySonName;
            }else if ([m.claCode isEqualToString:@"CREDIT_CARD"]){ //信用卡
                self.xinYongKaCode = son.classifySonCode;
                self.xinYongKaName = son.classifySonName;
            }else{ //收入
                self.shouRuCode = son.classifySonCode;
                self.shouRuName = son.classifySonName;
            }
        }];
        [alertVc addAction:action];
        [action setValue:COLOR_WITH_HEX(0x222222) forKey:@"titleTextColor"];
    }
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [actionCancel setValue:COLOR_WITH_HEX(0xe63c3f) forKey:@"titleTextColor"];
    [alertVc addAction:actionCancel];
    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark - 关闭轮播banner
-(void)closeBanner{
    self.isClose = YES;
    self.bannerCellHeight = 0;
    [self.daTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

//- (void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    
//    SSH_BannersModel *model = self.bannerArr[index];
//    
//    [self activeClickActionWithType:model.linkType webUrl:model.url];
//    
//}


- (void)activeClickActionWithType:(NSString *)type webUrl:(NSString *)webUrl{
    
    if ([type isEqualToString:@"1"] || [type isEqualToString:@"2"]) {
        NSString *token = [DENGFANGSingletonTime shareInstance].tokenString;
        
        if ([token isEqualToString:@""] || token == nil) {
            SSH_YanZhengMaDengLuController *verVC = [[SSH_YanZhengMaDengLuController alloc] init];
            verVC.isShowTiaoGuo = 0;
            SSQ_HiddenNavigationViewController *naviVC = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:verVC];
            [self presentViewController:naviVC animated:NO completion:nil];
        }else{
            if ([type isEqualToString:@"2"]) {
                
                SSH_YaoQingViewController *yaoqingVC = [[SSH_YaoQingViewController alloc] init];
                yaoqingVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:yaoqingVC animated:YES];
            }else if ([type isEqualToString:@"1"]){//充值有礼
                
                SSH_ChargeGiftViewController *chargeGiftVC = [[SSH_ChargeGiftViewController alloc] init];
                chargeGiftVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chargeGiftVC animated:YES];
            }
        }
    }else{//邀请有礼
        [MobClick event:@"home-floating"];
        if ([webUrl containsString:[DENGFANGSingletonTime shareInstance].fenXiaoLianJie]) {
            SSH_FenXiaoViewController *vc = [[SSH_FenXiaoViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            SSH_WangYeViewController *webVC = [[SSH_WangYeViewController alloc] init];
            webVC.webUrl = webUrl;
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}

#pragma mark 定位界面传过来的值
- (void)sl_cityListSelectedCity:(NSString *)selectedCity Id:(NSInteger)Id displayCity:(NSString *)displayCity cityArray:(NSArray *)cityArray CityArrayString:(NSString *)cityArrayString{
    
    [SSH_TOOL_GongJuLei saveSelectCityName:cityArrayString];
    self.pageNum = 1;
    self.displayLabel.text = displayCity;
    if ([self.displayLabel.text isEqualToString:@"全国"]) {
        [MobClick event:@"home-location"];
    }
    CGFloat textW1 = [self getWidthWithTitle:displayCity font:UIFONTTOOL15];
    self.cityBtn.frame = CGRectMake(5, getStatusHeight, textW1+70, getRectNavHight);
    
    [DENGFANGSingletonTime shareInstance].mapCity = cityArrayString;
    [[NSUserDefaults standardUserDefaults] setValue:cityArrayString forKey:SelectedCityName];
    [[NSUserDefaults standardUserDefaults] setValue:displayCity forKey:@"displayCity"];
    [[NSUserDefaults standardUserDefaults] setInteger:Id forKey:SelectedCityIDName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self getCreditinfoListData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SelectedCityAction object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
    
    
