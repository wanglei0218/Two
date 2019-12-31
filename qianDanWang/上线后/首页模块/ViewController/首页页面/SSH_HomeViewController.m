//
//  SSH_HomeViewController.m
//  DENGFANGSC
//
//  Created by LY on 2018/9/17.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_HomeViewController.h"
//高德定位
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
//view
#import "SSH_ShoyYeAcitvityCell.h" //首页中间的图片cell
#import "SSH_ShouyeFenleiCell.h"//首页分类CollectionCell
#import "SSH_ShouYeListTableViewCell.h"//首页抢单cell
#import "DCCycleScrollView.h"//轮播图
#import "SSH_HCDragingView.h"//悬浮按钮
#import "SSH_New_RZViewController.h"

//controller
#import "SSH_YanZhengMaDengLuController.h"//验证码登录控制器
#import "SSH_ZhifuXiangQingViewController.h"//支付详情控制器
#import "SSH_KeHuXiangQingViewController.h" //产品详情页
#import "SSH_DingWeiViewController.h" //定位界面
#import "SSH_WangYeViewController.h"//跳转到网页
#import "SSH_KeHuXiangQingViewController.h" //新详情页
//#import "SSH_YaoQingYouLiViewController.h"//邀请有礼
#import "SSH_YaoQingViewController.h"//新邀请
#import "SSH_ChargeGiftViewController.h"//充值有礼
//model
#import "SSH_HomeCreditxinxiListModel.h" //资源列表cell的model
#import "SSH_BannersModel.h"//banner的model
#import "SSH_ViewController.h"//高额专区
#import "SSH_ZheKouViewController.h" //折扣专区
#import "SSH_GongGaoController.h" //公告
#import "SSH_GeRenXinXiModel.h" //个人信息
#import "SSH_SystemNotModel.h"  //系统公告
#import "SSH_FengXianBaKongViewController.h"    //风险把控

#import "SSH_ShenFenZhengRenZhengViewController.h"

#import "SSH_FenXiaoViewController.h"
#import "SSH_ZYViewController.h"
#import "SSH_MemberViewController.h"
#import "SSH_ZDQDViewController.h"

/**
 第二界面
 */
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
#import "SSH_XTXXViewController.h"

#import "SSH_YanZhengMaDengLuController.h"
/**
 第二界面
 */
#import <CoreLocation/CoreLocation.h>
#import "SSH_CreditToolViewController.h"

static NSString *const TableViewCellREUSEID = @"DENGFANGHomePageViewCell";
static NSString *const CollectionViewCellREUSEID = @"DENGFANGHomeTypeCollectionViewCellREUSEID";
static NSString *const tableViewImgCell = @"SSH_ShoyYeAcitvityCell";
/*
 
 */
static NSInteger oneOpenApp;
@interface SSH_HomeViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,SSH_LocationViewControllerDelegate,DCCycleScrollViewDelegate,SDCycleScrollViewDelegate,SDCycleScrollViewDelegate,SSH_CategorySliderBarDelegate,UITextFieldDelegate,CLLocationManagerDelegate>
{
    UIView *_lunboView;
    BOOL isShowFX;//是否展示分销
    BOOL isVip;//是否是VIP
}
@property (nonatomic, strong)CLLocationManager *cll;//定位

@property (nonatomic, strong) UITableView *danTableView;
@property (nonatomic, strong) UICollectionView *categoryCollectionView;//5个分类按钮的collectionView
@property (nonatomic, strong) SDCycleScrollView *textCycleScrollView;//头条文字轮播
@property (nonatomic, strong) DCCycleScrollView *cycleScrollView;//轮播图

//@property (nonatomic, strong) UILabel *cityLabel;//显示城市的Label
@property (nonatomic, assign) NSInteger cityID;//城市id
@property (nonatomic, strong)UIButton * cityBtn;

@property (nonatomic, strong) AMapLocationManager *locationManager; //定位

@property (nonatomic, strong) NSMutableArray * bannerArr; //banner数组
@property (nonatomic, strong) NSMutableArray * middleImgArr; //中间图片数组
@property (nonatomic, strong) NSMutableArray * noticeArr; //滚动的系统公告数组

@property (nonatomic, strong) UILabel *  topInfoLabel;//刷新数据时，顶部显示的信息
@property (nonatomic, strong) UIView *  topAuthView;//认证背景view
@property (nonatomic, strong) UILabel *  topAuthLabel;//认证
@property (nonatomic, assign) NSInteger pageNum;//页数
@property (nonatomic, strong) NSString *  count;//更新的条数
@property (nonatomic, strong) NSMutableArray * allListData; //

@property (nonatomic, strong) NSMutableArray * allClassData; //首页中部五个分类按钮
@property (nonatomic, strong) UIView *footerView;//tableView的footerView
@property (nonatomic, strong) NSString *updateTime;//最新的数据都更新时间
@property (nonatomic, strong) SSH_BannersModel *bannerModel;
@property (nonatomic, strong) SSH_HCDragingView *dragingView;//悬浮按钮
@property (nonatomic, strong) UIButton *refreshButton;


@property (nonatomic, strong) UIView *grayView; //蒙版
@property (nonatomic, strong) UIView *whiteView; //提示窗

@property(nonatomic,strong)UILabel *displayLabel; //显示城市的label
//@property(nonatomic,copy) NSString *dingWeiCity;  //定位到的城市

@property(nonatomic,strong)SSH_YanZhengMaDengLuController *yanZhengMaVC;

@property(nonatomic,strong)SSH_BannersModel *popViewModel;

@property(nonatomic,strong) UIImageView *adImgView;

@property(nonatomic,assign)BOOL isDingWeiSuccess;

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)SSH_GeRenXinXiModel *infoModel;

@property(nonatomic,strong)SSH_SystemNotModel *systemNotM; //系统公告

@property(nonatomic,assign)BOOL isShowPopView;

#pragma make ------第二
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) SSH_CategorySliderBar *sliderBar;
@property (nonatomic,strong) UITableView * daTableView;
//@property (nonatomic,strong) NSMutableArray * allListData;
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
//@property (nonatomic, assign) NSInteger pageNum;//页数
//@property (nonatomic, strong) NSString *  count;//更新的条数
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
//@property(nonatomic,strong)NSMutableArray *bannerArr;
@property(nonatomic,assign)BOOL isClose; // 是否点击过关闭按钮
@property(nonatomic,assign)CGFloat bannerCellHeight;
@property(nonatomic,strong)SSH_ZiZhiXinXiHeaderCollectionView *reusableView;
@property(nonatomic,strong)NSString * classifyName;
#pragma make ------第二结束

@end

@implementation SSH_HomeViewController


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //点击推送通知的时候，进入详情或者链接也，隐藏掉banner
    [self.whiteView removeFromSuperview];
    [self.grayView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick event:@"home"];
    NSString *token = [DENGFANGSingletonTime shareInstance].tokenString;
    if ([token isEqualToString:@""] || token == nil) {
        
    } else {
        [self getDENGFANGUserInfoData];
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"fx"]) {
            SSQ_HiddenNavigationViewController *nav = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:[SSH_FengXianBaKongViewController new]];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
    
    [self getCreditinfoListData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getOpenFenXiao];
    oneOpenApp = 0;
    
    self.cll = [[CLLocationManager alloc] init];
    [CLLocationManager locationServicesEnabled];
    [self.cll startUpdatingHeading];
    self.cll.delegate = self;
    [self.cll requestWhenInUseAuthorization];
    
    //    [self setupDongTaiTu];
    
    [DENGFANGSingletonTime shareInstance].mapCity = [SSH_TOOL_GongJuLei getSelectedCityName];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLoginPage) name:DENGFANGLogOutObserverName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLoginPageChangPhoneNumber) name:@"changePhoneNumber" object:nil];
    [self createTopLocationBtn]; //创建顶部定位按钮
    
    [self setupMap];//定位
    
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerNotiFaction) name:@"taoChuQieHuan" object:nil];
    
    self.pageNum = 1;
    self.updateTime = [NSString yf_getNowTimestamp];
    self.bannerArr = [[NSMutableArray alloc]init];
    self.middleImgArr = [[NSMutableArray alloc]init];
    self.noticeArr = [[NSMutableArray alloc]init];
    self.allListData = [[NSMutableArray alloc]init];
    self.allClassData = [[NSMutableArray alloc]init];
    
    
    [self getNoticeListData];//得到系统公告列表
    self.cityID = 1;
    
    NSString *token = [DENGFANGSingletonTime shareInstance].tokenString;
    if (!([token isEqualToString:@""] || token == nil)) {
        [self getDENGFANGUserInfoData]; //获取用户信息判断用户是否认证
    }
    
    //判断程序是否为第一次启动,根据这个来判断是否要在启动app时弹出登录页
    BOOL isFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:DENGFANGIs_First_Launch];
    if (!isFirstLaunch) {
        [self firstOpenAppToLogin:1];
        [[NSUserDefaults standardUserDefaults] setBool:1 forKey:DENGFANGIs_First_Launch];
    }else{
        [self getPopView]; //不是第一次进入
    }
    
    self.goBackButton.hidden = YES;
    self.navigationView.backgroundColor = COLORWHITE;
    
    [self.view addSubview:self.topInfoLabel];
    self.topInfoLabel.hidden = YES;
    
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
    //筛选用
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
    
    UIView * line = [[UIView alloc]init];
    line.frame = CGRectMake(0, getRectNavAndStatusHight-0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = GrayLineColor;
    //    [self.view addSubview:line];
    
    
    self.sliderBar.originIndex = 0;
}


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
#pragma mark 获取用户信息
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
            
            //（0：未认证  1：已认证   2:认证中   3:认证失败）
            //（0：未检测  1：已检测）
            if ([self.infoModel.isAuth intValue] == 1 && [self.infoModel.isFaceCheck intValue] == 1) { //已认证
                [DENGFANGSingletonTime shareInstance].isTongguoIDRenZheng = 1;
            }else if ([self.infoModel.isAuth intValue] == 0 || [self.infoModel.isFaceCheck intValue] == 0){
                [DENGFANGSingletonTime shareInstance].isTongguoIDRenZheng = 0;
                if (oneOpenApp == 0) {
                    [self getDENGFANGSystemData];
                    oneOpenApp++;
                }
            }else if ([self.infoModel.isAuth intValue] == 2){
                
            }else if ([self.infoModel.isAuth intValue] == 3){
                if (oneOpenApp == 0) {
                    [self getDENGFANGSystemData];
                    oneOpenApp++;
                }
            }
            self->isVip = [self.infoModel.isVip boolValue];
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];
    
}

#pragma mark 首页未认证
//首页未认证：NOT_AUTH  打折专区：DISCOUNT_AREA  认证：FACE_AUTH_MSG
-(void)getDENGFANGSystemData{
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil],@"sysTemCode":@"FACE_AUTH_MSG"};
    
    NSString *url = @"sys/getSysTemInfo";
    
    [[DENGFANGRequest shareInstance] postWithUrlString:url parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            if (![diction[@"data"] isKindOfClass:NSDictionary.class]) {
                return;
            }
            
            if (!(diction[@"data"][@"systemMsg"] == nil || [diction[@"data"][@"systemMsg"] isEqualToString:@""])) {
                [self showRenZhengView:diction[@"data"][@"systemMsg"]];
            }
        }
    } fail:^(NSError *error) {
        
    }];
}

-(void)showRenZhengView:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"认证提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"马上认证" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        SSH_New_RZViewController *rz = [[SSH_New_RZViewController alloc] init];
        rz.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rz animated:YES];
        
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"稍后认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [actionCancel setValue:COLOR_WITH_HEX(0x222222) forKey:@"titleTextColor"];
    
    [alert addAction:actionConfirm];
    [alert addAction:actionCancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 上传登录地址 DENGFANGUpdateUserAreaURL
-(void)getDENGFANGUpdateUserAreaData{
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGUpdateUserAreaURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"loginArea":[DENGFANGSingletonTime shareInstance].dingWeiCity==nil?@"":[DENGFANGSingletonTime shareInstance].dingWeiCity,@"filterCity":[DENGFANGSingletonTime shareInstance].mapCity} success:^(id responsObject) {
        
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"上传登录地址  %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            
        }else{
//            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark - 获取banner列表
-(void)getBannerListData{
    
    //    NSString *strUrl = [DENGFANGRequest shareInstance].DENGFANGBannerListURL;
    //psotWithUrlString
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGBannerListURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil]} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"banner_list%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [self.middleImgArr  removeAllObjects];
            [self.bannerArr removeAllObjects];
            
            for (NSDictionary *dic in diction[@"data"]) {
                SSH_BannersModel *model = [[SSH_BannersModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                if ([model.bannerType isEqualToString:@"0"]) {
                    [self.bannerArr addObject:model];
                }else if ([model.bannerType isEqualToString:@"1"]){
                    [self.middleImgArr addObject:dic];
                }else if ([model.bannerType isEqualToString:@"2"]){
                    self.bannerModel = model;
                    [self.dragingView show];
                    [self.dragingView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.mas_equalTo(-65);
                        make.right.mas_equalTo(-10);
                        make.width.height.mas_equalTo(60);
                    }];
                }else if ([model.bannerType isEqualToString:@"3"]){ //首页弹窗
                    self.popViewModel = model;
                    [self.adImgView sd_setImageWithURL:[NSURL URLWithString:self.popViewModel.bannerImgUrl] placeholderImage:[UIImage imageNamed:@"placehoder"]];
                }
            }
            //后台关闭了banner
            if (self.popViewModel == nil || [self.popViewModel isEqual:@""]) {
                self.isShowPopView = YES;
                [self.whiteView removeFromSuperview];
                [self.grayView removeFromSuperview];
            }
            
            if ([self.bannerModel.bannerType isEqualToString:@"2"]) {
                self.dragingView.hidden = NO;
                self.refreshButton.hidden = YES;
            }else{
                self.refreshButton.hidden = NO;
                self.dragingView.hidden = YES;
            }
            
            NSMutableArray * imgArr = [[NSMutableArray alloc]init];
            for (int i = 0; i < self.bannerArr.count; i++) {
                SSH_BannersModel *model = self.bannerArr[i];
                [imgArr addObject:model.bannerImgUrl];
            }
            
            self.cycleScrollView.imgArr = imgArr;
            NSInteger rowInteger;
            if (self.allListData.count<=2) {
                rowInteger = self.allListData.count;
            }else{
                rowInteger = 2;
            }
            [self.danTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rowInteger inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];
}

- (void)cycleScrollView:(DCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    if (cycleScrollView == self.cycleScrollView) {
        SSH_BannersModel *model = self.bannerArr[index];
        [self activeClickActionWithType:model.linkType webUrl:model.url];
        if (index == 0) {
            [MobClick event:@"home-banner1"];
        }else if (index == 1){
            [MobClick event:@"home-banner2"];
        }else if (index == 2){
            [MobClick event:@"home-banner3"];
        }
    }else{
        [MobClick event:@"home-announcement"];
        SSH_GongGaoController *vc = [[SSH_GongGaoController alloc] init];
        vc.systemM = self.noticeArr[index];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//系统公告
-(void)getNoticeListData{
    
    NSString *url = @"sys/notice/querySystemNoticeList";
    //postWithUrlString
    [[DENGFANGRequest shareInstance] postWithUrlString:url parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil]} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"scrollText %@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            [self.noticeArr addObjectsFromArray:[SSH_SystemNotModel mj_objectArrayWithKeyValuesArray:diction[@"data"]]];
            
            if (self.noticeArr.count > 0) {
                NSMutableArray * textArr = [[NSMutableArray alloc]init];
                for (SSH_SystemNotModel * sysM in self.noticeArr) {
                    [textArr addObject:sysM.title];
                }
                self.textCycleScrollView.titlesGroup = textArr;
            }
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];
}
#pragma mark --------------------⤵️⤵️⤵️⤵️⤵️⤵️新版
//数据请求：顶部分类 && 筛选里的内容
-(void)getClassifyData{
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGClassifyURL parameters:@{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil],@"isDesc":@1} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        //        NSLog(@"淘单大全  分类 %@",diction);
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

//数据请求：列表数据
-(void)getCreditinfoListData{
    
    NSString *str = [DENGFANGSingletonTime shareInstance].mapCity;
    NSString *userId = [NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString];
    if ([userId isEqualToString:@"0"]) {
        [self.daTableView.mj_header endRefreshing];
        [self.daTableView.mj_footer endRefreshing];
        return;
    }
    [[DENGFANGRequest shareInstance] getWithUrlString:@"creditinfo/vip/queryCreditinfoOne" parameters:
     @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:userId],@"flag":@"1",@"city":[DENGFANGSingletonTime shareInstance].mapCity.length == 0? @"":[DENGFANGSingletonTime shareInstance].mapCity} success:^(id responsObject) {
         NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
         //        NSLog(@"淘单大全 列表数据 %@",diction);
         
         if ([diction[@"code"] isEqualToString:@"200"]) {
             
             [self.allListData removeAllObjects];
             
             NSDictionary *dict = diction[@"data"];
             if ([dict isKindOfClass:[NSNull class]]) {
                 SSH_HomeCreditxinxiListModel *model = [[SSH_HomeCreditxinxiListModel alloc] init];
                 [model setValuesForKeysWithDictionary:@{}];
                 [self.allListData addObject:model];
                 return;
             } else {
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
                 self.noDataFatherView.hidden = NO;
                 if (self.isShaiXuanStatus) {
                     self.noDataTitleLabel.text = @"没有满足筛选条件的客户！\n赶紧去重新筛选吧！";
                 }else{
                     self.noDataTitleLabel.text = @"该地区内暂时没有此类客户,\n去选择本省其他城市吧";
                 }
                 
             }else{
                 self.daTableView.hidden = NO;
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
//取出存储筛选状态的数组
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
//懒加载
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

//重置所有的筛选数组
- (void)restAllscreenArray:(BOOL)isRemove {
    if (isRemove) {
        [self.allCellArr removeAllObjects];
        [self.selectCell2 removeAllObjects];
        [self.selectCell3 removeAllObjects];
    }
    [self.selectCell1 removeAllObjects];
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
//通知
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
    //单条移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"taoChuQieHuan" object:nil];
}
//设置列表无数据时的页面
- (void)setUpNoDataView{
    if (self.noDataFatherView == nil) {
        self.noDataFatherView = [[UIView alloc] init];
        [self.daTableView addSubview:self.noDataFatherView];
        self.noDataFatherView.backgroundColor = ColorBackground_Line;
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
#pragma mark --------------------⬆️⬆️⬆️⬆️⬆️⬆️新版
#pragma mark --------------------创建顶部定位按钮
-(void)createTopLocationBtn{
    
    //文字
    self.displayLabel = [[UILabel alloc]init];
    self.displayLabel.userInteractionEnabled = YES;
    [self.navigationView addSubview:self.displayLabel];
    self.displayLabel.text = @"欢迎来到小象抢单";
    if ([self.displayLabel.text isEqualToString:@"全国"]) {
        [MobClick event:@"home-location"];
    }
    //    self.displayLabel.textColor = COLORWHITE;
    self.displayLabel.font = UIFONTTOOL15;
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(getRectNavHight);
        make.top.mas_equalTo(getStatusHeight);
    }];
    
    //    CGFloat textW = [self getWidthWithTitle:self.displayLabel.text font:UIFONTTOOL15];
    //按钮点击事件
    self.cityBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.navigationView addSubview:self.cityBtn];
    [self.cityBtn setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
    [self.cityBtn addTarget:self action:@selector(cityBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(12+getStatusHeight);
        make.width.height.mas_equalTo(20);
    }];
    
}

#pragma mark 定位
- (void)setupMap{
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
    }];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout = 2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error){
            NSLog(@"222");
            if (error.code == AMapLocationErrorLocateFailed){
                self.isDingWeiSuccess = NO;//第一次下载定位失败，点击跳过，不询问询问是否切换城市
//                self.displayLabel.text = [[SSH_TOOL_GongJuLei getSelectedCityName] isEqualToString:@""]?@"全国":[self isOneCityOrMoreCity:[SSH_TOOL_GongJuLei getSelectedCityName]];
                [DENGFANGSingletonTime shareInstance].mapCity = @"";
                if ([self.displayLabel.text isEqualToString:@"全国"]) {
                    [MobClick event:@"home-location"];
                }
                return;
            }
        }else{
            NSLog(@"333");
            self.isDingWeiSuccess = YES; //第一次下载定位成功后，点击跳过，询问是否切换城市
            [DENGFANGSingletonTime shareInstance].dingWeiCity = regeocode.city;
            
            [self getCreditinfoListData];
            if ([DENGFANGSingletonTime shareInstance].tokenString == nil || [[DENGFANGSingletonTime shareInstance].tokenString isEqualToString:@""]) {
                
                return;
            }else{
//                [self getDENGFANGUpdateUserAreaData]; //定位城市成功就要上传登入城市
            }
        }
    }];
}

//判断第一次进入应用，如果定位和显示的位置不一样就提示是否切换城市
-(void)setupChangeCity{
    NSString *flagCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"CITY"];
    if ([flagCity isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"CITY"];
        
        NSString *mess = [NSString stringWithFormat:@"当前选择的地区为全国，是否切换到%@？",[DENGFANGSingletonTime shareInstance].dingWeiCity];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:mess preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"切换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            self.displayLabel.text = [DENGFANGSingletonTime shareInstance].dingWeiCity;
            [SSH_TOOL_GongJuLei saveSelectCityName:[DENGFANGSingletonTime shareInstance].dingWeiCity];
            [DENGFANGSingletonTime shareInstance].mapCity = [DENGFANGSingletonTime shareInstance].dingWeiCity;
            self.pageNum = 1;
            [self getCreditinfoListData];
            
            if ([DENGFANGSingletonTime shareInstance].tokenString == nil || [[DENGFANGSingletonTime shareInstance].tokenString isEqualToString:@""]) {
                
                return;
            }else{
                [self getDENGFANGUpdateUserAreaData];
            }
        }];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
//            self.displayLabel.text = @"全国";
            [SSH_TOOL_GongJuLei saveSelectCityName:@"全国"];
            if ([self.displayLabel.text isEqualToString:@"全国"]) {
                [MobClick event:@"home-location"];
            }
            self.pageNum = 1;
            [self getCreditinfoListData];
            
            if ([DENGFANGSingletonTime shareInstance].tokenString == nil || [[DENGFANGSingletonTime shareInstance].tokenString isEqualToString:@""]) {
                
                return;
            }else{
                [self getDENGFANGUpdateUserAreaData];
            }
        }];
        
        [alert addAction:actionConfirm];
        [alert addAction:actionCancel];
        [actionCancel setValue:COLOR_WITH_HEX(0x222222) forKey:@"titleTextColor"];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

-(NSString *)isOneCityOrMoreCity:(NSString *)citys{
    if ([citys containsString:@","]) {
        NSArray *array = [citys componentsSeparatedByString:@","];
        return [NSString stringWithFormat:@"%@...",[array firstObject]];
    }
    return citys;
}

- (void)setLoginPageChangPhoneNumber{
    [self firstOpenAppToLogin:0];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:DENGFANGTokenKey];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:DENGFANGUserIDKey];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:DENGFANGPhoneKey];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:DENGFANGIsPayPwd];
    
    [DENGFANGSingletonTime shareInstance].tokenString = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGTokenKey];
    [DENGFANGSingletonTime shareInstance].mobileString = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGPhoneKey];
    [DENGFANGSingletonTime shareInstance].useridString = [[[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGUserIDKey] intValue];
    
    SSH_YanZhengMaDengLuController *verVC = [[SSH_YanZhengMaDengLuController alloc] init];
    verVC.isShowTiaoGuo = 0;
    SSQ_HiddenNavigationViewController *naviVC = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:verVC];
    [self presentViewController:naviVC animated:YES completion:nil];
    
    
}

- (void)setLoginPage{
    [self firstOpenAppToLogin:0];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:DENGFANGTokenKey];
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:DENGFANGUserIDKey];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:DENGFANGPhoneKey];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:DENGFANGIsPayPwd];
    
    [DENGFANGSingletonTime shareInstance].tokenString = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGTokenKey];
    [DENGFANGSingletonTime shareInstance].mobileString = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGPhoneKey];
    [DENGFANGSingletonTime shareInstance].useridString = [[[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGUserIDKey] intValue];
    
}


#pragma mark ---------蒙版提示
-(void)getPopView{
    [MobClick event:@"home-pop"];
    self.grayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //[[UIApplication sharedApplication].keyWindow addSubview:self.grayView];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.grayView];
    self.grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    
    self.whiteView = [[UIView alloc] init];
    [self.grayView addSubview:self.whiteView];
    self.whiteView.layer.masksToBounds = YES;
    self.whiteView.layer.cornerRadius = 6;
    CGFloat wHeight = (SCREEN_WIDTH-30)*369/345;
    self.whiteView.frame = CGRectMake(15, (ScreenHeight-wHeight)/2, ScreenWidth-30, wHeight);
    
    UIImageView *adImgView = [[UIImageView alloc] initWithFrame:self.whiteView.bounds];
    [self.whiteView addSubview:adImgView];
    
    [adImgView sd_setImageWithURL:[NSURL URLWithString:self.popViewModel.bannerImgUrl] placeholderImage:[UIImage imageNamed:@"placehoder"]];
    NSLog(@"popViewModel == %@",self.popViewModel);
    self.adImgView = adImgView;
    
    UIButton *button = [UIButton new];
    [self.whiteView addSubview:button];
    button.frame = self.whiteView.bounds;
    [button addTarget:self action:@selector(clickAdImgView:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 500;
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.grayView addSubview:closeButton];
    
    [closeButton setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeCurrentView) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake((ScreenWidth-35)/2, CGRectGetMaxY(self.whiteView.frame)+30, 35, 35);
    //    closeButton.backgroundColor = [UIColor redColor];
    
}

#pragma mark 首页弹窗点击事件
- (void)clickAdImgView:(UIButton *) sender{
    
    [self.whiteView removeFromSuperview];
    [self.grayView removeFromSuperview];
    
    [self activeClickActionWithType:self.popViewModel.linkType webUrl:self.popViewModel.url];
}

- (void)closeCurrentView{
    [MobClick event:@"home-pop-close"];
    [self.whiteView removeFromSuperview];
    [self.grayView removeFromSuperview];
}

-(void)setupDongTaiTu{
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shouye_dongtai.gif" ofType:nil]];
    UIImageView *wIg = [[UIImageView alloc] initWithImage:[UIImage sd_imageWithGIFData:gifData]];
    
    self.hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //自定义
    self.hud.mode = MBProgressHUDModeCustomView;
    [self.hud setOffset:CGPointMake(0, 70)];
    self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.bezelView.color = [UIColor clearColor];
    
    self.hud.customView = wIg;
}

#pragma mark ----------通知触发
//- (void)registerNotiFaction {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (self.isDingWeiSuccess) { //第一次定位且成功
//            [self setupChangeCity];
//        }
//    });
//}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"获取定位信息 --- 成功");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"获取定位信息 --- 失败");
}

#pragma mark -------------新版🆕🆕🆕🆕
- (void)setupTableView{
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
    }];
    
    
    [self setupTableHeadView];
    [self setupTableFooterView];
}

#pragma mark - tableView里的方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SSH_HomeCreditxinxiListModel *model;
    model = self.allListData[indexPath.row];
    if (model.name == nil) {
        return;
    }
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
    //    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    [tableView tableViewWitingImageName:@"xiaoren_wushuju" forRowCount:self.allListData.count];
    if(self.allListData.count == 0) {
        [self setUpNoDataView];
        [tableView tableViewWitingImageName:@"syzwdd" forRowCount:0];
        return 0;
    }
    return 1;
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

- (void)activeClickActionWithType:(NSString *)type webUrl:(NSString *)webUrl{
    
    if ([type isEqualToString:@"1"] || [type isEqualToString:@"2"]) {
        NSString *token = [DENGFANGSingletonTime shareInstance].tokenString;
        
        if ([token isEqualToString:@""] || token == nil) {
            SSH_YanZhengMaDengLuController *verVC = [[SSH_YanZhengMaDengLuController alloc] init];
            verVC.isShowTiaoGuo = 0;
            SSQ_HiddenNavigationViewController *naviVC = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:verVC];
            [self presentViewController:naviVC animated:YES completion:nil];
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

#pragma mark -------------新版⬆️⬆️⬆️⬆️
- (SSH_HCDragingView *)dragingView{
    if (!_dragingView) {
        _dragingView = [[SSH_HCDragingView alloc] initWithFrame:CGRectMake(ScreenWidth-60, 100, 60, 60) containerView:self.normalBackView];
        _dragingView.dragImage = self.bannerModel.bannerImgUrl;
        
        __weak typeof(self)weakSelf = self;
        _dragingView.didEventBlock = ^{
            //点击事件
            [weakSelf activeClickActionWithType:weakSelf.bannerModel.linkType webUrl:weakSelf.bannerModel.url];
        };
    }
    return _dragingView;
}
- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}
-(void)cityBtnClicked{
    [MobClick event:@"home-notice"];
    NSString *token = [DENGFANGSingletonTime shareInstance].tokenString;
    if ([token isEqualToString:@""] || token == nil) {
        SSH_YanZhengMaDengLuController *verVC = [[SSH_YanZhengMaDengLuController alloc] init];
        verVC.isShowTiaoGuo = 0;
        SSQ_HiddenNavigationViewController *naviVC = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:verVC];
        [self presentViewController:naviVC animated:YES completion:nil];
    } else {
        SSH_XTXXViewController *mesgVC = [[SSH_XTXXViewController alloc] init];
        mesgVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mesgVC animated:YES];
    }
}
- (SSH_CategorySliderBar *)sliderBar {
    if (!_sliderBar) {
        _sliderBar = [[SSH_CategorySliderBar alloc]init];
        _sliderBar.delegate = self;
    }
    return _sliderBar;
}
#pragma mark ------------------设置tableView头部视图
- (void)setupTableHeadView{
    //headView
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 62+(SCREEN_WIDTH-30)*84/345+16)];//276
    self.daTableView.tableHeaderView = headView;
    headView.backgroundColor = ColorBackground_Line;
    
    //轮播view
    _lunboView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH-30)*84/345+8)];
    [headView addSubview:_lunboView];
    _lunboView.backgroundColor = Colorffb5b7;
    self.navigationView.backgroundColor = Colorffb5b7;
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"shouye_beijing"];
    [_lunboView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self->_lunboView.mas_bottom).offset(-8);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(15);
    }];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = ColorBackground_Line;
    [_lunboView addSubview:bgColorView];
    [bgColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self->_lunboView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(8);
    }];
    
    //轮播图
    self.cycleScrollView = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_WIDTH-30)*84/345) shouldInfiniteLoop:YES];//100
    self.cycleScrollView.itemWidth = SCREEN_WIDTH-30;
    self.cycleScrollView.itemSpace = 15;
    self.cycleScrollView.imgCornerRadius = 4;
    self.cycleScrollView.delegate = self;
    [self.cycleScrollView.delegate cycleScrollView:self.cycleScrollView endScrollerAtIndex:0];
    self.cycleScrollView.cellPlaceholderImage = [UIImage imageNamed:@"banner-690x168"];
    [_lunboView addSubview:self.cycleScrollView];
    
    
    
    //文字轮播
    UIView *touTiaoView = [[UIView alloc] init];
    touTiaoView.backgroundColor = COLORWHITE;
    touTiaoView.layer.cornerRadius = 8;
    [headView addSubview:touTiaoView];
    [touTiaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self->_lunboView.bottom);
        make.height.mas_equalTo(30);
    }];
    
    UIImageView *toutiaoImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tongzhi"]];
    toutiaoImgView.contentMode = UIViewContentModeScaleAspectFit;
    [touTiaoView addSubview:toutiaoImgView];
    [toutiaoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(touTiaoView);
    }];
    
    self.textCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@""]];
    [touTiaoView addSubview:self.textCycleScrollView];
    //    self.textCycleScrollView.userInteractionEnabled = NO;
    self.textCycleScrollView.autoScrollTimeInterval = 4;
    self.textCycleScrollView.onlyDisplayText = YES;
    self.textCycleScrollView.titlesGroup = @[];
    self.textCycleScrollView.titleLabelTextColor = ColorBlack222;
    self.textCycleScrollView.titleLabelTextFont = UIFONTTOOL12;
    self.textCycleScrollView.titleLabelBackgroundColor = COLORWHITE;
    self.textCycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.textCycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(toutiaoImgView.mas_right).offset(12);
        make.right.mas_equalTo(-45);
        make.top.bottom.mas_equalTo(0);
    }];
    //    home-announcement
    //最新发布view
    UIView *mostNewView = [UIView new];
    [headView addSubview:mostNewView];
    mostNewView.backgroundColor = COLORWHITE;
    mostNewView.layer.cornerRadius = 8;
    [mostNewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(touTiaoView.mas_bottom).offset(8);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *newLab = [[UILabel alloc] init];
    newLab.text = @"最新订单";
    newLab.font = [UIFont systemFontOfSize:16];
    newLab.textColor = Color000;
    [mostNewView addSubview:newLab];
    [newLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(16);
        make.centerY.mas_equalTo(mostNewView).offset(-7);
    }];
    
    UIImageView *jianTou = [[UIImageView alloc] init];
    jianTou.image = [UIImage imageNamed:@"jiantou_xuanze"];
    [mostNewView addSubview:jianTou];
    [jianTou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-9);
        make.centerY.mas_equalTo(mostNewView).offset(-7);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(6);
    }];
    
    UILabel *moreLab = [[UILabel alloc] init];
    moreLab.text = @"更多";
    moreLab.textColor = ColorBlack999;
    moreLab.font = [UIFont systemFontOfSize:11];
    [mostNewView addSubview:moreLab];
    [moreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(jianTou.mas_left).offset(-6);
        make.height.mas_equalTo(12);
        make.centerY.mas_equalTo(jianTou.mas_centerY);
    }];
    
    UIButton *moreBut = [[UIButton alloc] init];
    moreBut.backgroundColor = UIColor.clearColor;
    [mostNewView addSubview:moreBut];
    [moreBut addTarget:self action:@selector(toSelectionIndex) forControlEvents:UIControlEventTouchUpInside];
    [moreBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(jianTou.mas_right);
        make.left.mas_equalTo(moreLab.mas_left);
        make.top.mas_equalTo(moreLab.mas_top);
        make.bottom.mas_equalTo(moreLab.mas_bottom);
    }];
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = ColorBackground_Line;
    [mostNewView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(mostNewView.mas_bottom).offset(-13);
        make.height.mas_equalTo(0.5);
        make.left.right.mas_equalTo(0);
    }];
}

- (void)toSelectionIndex {
    [MobClick event:@"home-more"];
    NSString *token = [DENGFANGSingletonTime shareInstance].tokenString;
    if ([token isEqualToString:@""] || token == nil) {
        SSH_YanZhengMaDengLuController *verVC = [[SSH_YanZhengMaDengLuController alloc] init];
        verVC.isShowTiaoGuo = 0;
        SSQ_HiddenNavigationViewController *naviVC = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:verVC];
        [self presentViewController:naviVC animated:YES completion:nil];
    } else {
        self.tabBarController.selectedIndex = 1;
    }
}

- (void)cycleScrollView:(DCCycleScrollView *)cycleScrollView endScrollerAtIndex:(NSInteger)index {
    if (self.bannerArr.count == 0) {
        return;
    }
    SSH_BannersModel *model = self.bannerArr[index];
    self.navigationView.backgroundColor = [self colorWithHexString:model.bannerColor alpha:1.0];
    _lunboView.backgroundColor = [self colorWithHexString:model.bannerColor alpha:1.0];
}

- (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha {
    
    // 删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) {
        
        return [UIColor clearColor];
        
    }
    
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
    
}

#pragma mark -----------------设置tableView底部视图
- (void)setupTableFooterView {
    //headView
    float footViewHeight = (591*(SCREEN_WIDTH-30))/345;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, footViewHeight)];//276
    footView.backgroundColor = ColorBackground_Line;
    self.daTableView.tableFooterView = footView;
    float quanYiViewHeight = (291.5*(SCREEN_WIDTH-30))/345+40;
    UIView *quanYiView = [[UIView alloc] initWithFrame:CGRectMake(15, 4, SCREEN_WIDTH - 30, quanYiViewHeight)];
    [footView addSubview:quanYiView];
    quanYiView.backgroundColor = COLORWHITE;
    quanYiView.layer.cornerRadius = 8;
    
    UILabel *newLab = [[UILabel alloc] init];
    newLab.text = @"权益服务";
    newLab.font = [UIFont systemFontOfSize:16];
    newLab.textColor = Color000;
    [quanYiView addSubview:newLab];
    [newLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(16);
        make.top.mas_equalTo(12);
    }];
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = ColorBackground_Line;
    [quanYiView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(0.5);
        make.left.right.mas_equalTo(0);
    }];
    
    float butHeight = (81*((SCREEN_WIDTH - 69)/2))/153;
    NSArray *imgArrOne = @[@"huiyuan_taocan",@"zidong_qiangdan",@"xindai_gongju"];
    NSArray *imgArrTwo = @[@"tuiguang_zhuanqian",@"liji_qiangdan",@"zhanye_gongju"];
    for (int i = 0; i < 3; i++) {
        UIButton *butOne = [[UIButton alloc] initWithFrame:CGRectMake(15, 55 + butHeight*i + 9*i, (SCREEN_WIDTH - 69)/2, butHeight)];
        butOne.layer.cornerRadius = 6;
        butOne.tag = 1000+i;
        [butOne setBackgroundImage:[UIImage imageNamed:imgArrOne[i]] forState:UIControlStateNormal];
        [butOne addTarget:self action:@selector(buttonOneAndTwoDidSelection:) forControlEvents:UIControlEventTouchUpInside];
        [quanYiView addSubview:butOne];
        
        UIButton *butTwo = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 69)/2 + 24, 55 + butHeight*i + 9*i, (SCREEN_WIDTH - 69)/2, butHeight)];
        butTwo.layer.cornerRadius = 6;
        butTwo.tag = 2000+i;
        [butTwo setBackgroundImage:[UIImage imageNamed:imgArrTwo[i]] forState:UIControlStateNormal];
        [butTwo addTarget:self action:@selector(buttonOneAndTwoDidSelection:) forControlEvents:UIControlEventTouchUpInside];
        [quanYiView addSubview:butTwo];
    }
    
    UIView *aboutView = [[UIView alloc] initWithFrame:CGRectZero];
    
//                         CGRectMake(15, 345*332/(SCREEN_WIDTH - 30)+12, SCREEN_WIDTH - 30, HeightScale(137))];
    [footView addSubview:aboutView];
    aboutView.backgroundColor = COLORWHITE;
    float abuotViewHeight = (137*(SCREEN_WIDTH-15))/345;
    [aboutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(abuotViewHeight);
        make.top.mas_equalTo(quanYiView.mas_bottom).offset(10);
    }];
    aboutView.layer.cornerRadius = 8;
    
    UILabel *aboutLab = [[UILabel alloc] init];
    aboutLab.text = @"关于我们";
    aboutLab.font = [UIFont systemFontOfSize:16];
    aboutLab.textColor = Color000;
    [aboutView addSubview:aboutLab];
    [aboutLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(16);
        make.top.mas_equalTo(12);
    }];
    UIView *aboutline = [[UIView alloc]init];
    aboutline.backgroundColor = ColorBackground_Line;
    [aboutView addSubview:aboutline];
    [aboutline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.height.mas_equalTo(0.5);
        make.left.right.mas_equalTo(0);
    }];
    
    float aboutHeight = 150*81/((SCREEN_WIDTH - 75)/2);
    float aboutWidth = (SCREEN_WIDTH - 75)/2;
    
    UIView *viewOne = [[UIView alloc] initWithFrame:CGRectMake(15, 55, aboutWidth, aboutHeight)];
    viewOne.backgroundColor = ColorBackground_Line;
    viewOne.layer.cornerRadius = 6;
    [aboutView addSubview:viewOne];
    
    UIImageView *iconImg = [[UIImageView alloc] init];
    iconImg.image = [UIImage imageNamed:@"xindai_jingli"];
    [viewOne addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(viewOne);
        make.left.mas_equalTo(14);
        make.height.width.mas_equalTo(27);
    }];
    UILabel *peopleNum = [[UILabel alloc] init];
    peopleNum.textColor = ColorBlack222;
    peopleNum.font = [UIFont systemFontOfSize:18];
    peopleNum.text = @"10万+";
    [viewOne addSubview:peopleNum];
    [peopleNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImg.mas_right).offset(9);
        make.top.height.mas_equalTo(HeightScale(18));
    }];
    UILabel *labRZ = [[UILabel alloc] init];
    labRZ.textColor = ColorBlack999;
    labRZ.font = [UIFont systemFontOfSize:11];
    labRZ.text = [NSString stringWithFormat:@"信%@经理入驻(人)",[DENGFANGSingletonTime shareInstance].name[1]];
    [viewOne addSubview:labRZ];
    [labRZ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImg.mas_right).offset(9);
        make.top.mas_equalTo(peopleNum.mas_bottom).offset(4);
        make.height.mas_equalTo(HeightScale(11));
    }];
    
    UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectMake(aboutWidth + 30, 55, aboutWidth, aboutHeight)];
    viewTwo.backgroundColor = ColorBackground_Line;
    viewTwo.layer.cornerRadius = 6;
    viewTwo.tag = 100002;
    [aboutView addSubview:viewTwo];
    
    UIImageView *iconImgB = [[UIImageView alloc] init];
    iconImgB.image = [UIImage imageNamed:@"jinrong_jigou"];
    [viewTwo addSubview:iconImgB];
    [iconImgB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(viewTwo);
        make.left.mas_equalTo(14);
        make.height.width.mas_equalTo(27);
    }];
    UILabel *peopleNumB = [[UILabel alloc] init];
    peopleNumB.textColor = ColorBlack222;
    peopleNumB.font = [UIFont systemFontOfSize:18];
    peopleNumB.text = @"3千+";
    [viewTwo addSubview:peopleNumB];
    [peopleNumB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImgB.mas_right).offset(9);
        make.top.height.mas_equalTo(HeightScale(18));
    }];
    UILabel *labRZB = [[UILabel alloc] init];
    labRZB.textColor = ColorBlack999;
    labRZB.font = [UIFont systemFontOfSize:11];
    labRZB.text = @"金融合作机构(家)";
    [viewTwo addSubview:labRZB];
    [labRZB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iconImgB.mas_right).offset(9);
        make.top.mas_equalTo(peopleNumB.mas_bottom).offset(4);
        make.height.mas_equalTo(HeightScale(11));
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baozhang"]];
    [footView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(aboutView.mas_bottom).offset(30);
        make.centerX.mas_equalTo(footView);
    }];
    
}

- (void)buttonOneAndTwoDidSelection:(UIButton *)sender {
    if (sender.tag == 1000) {
        [MobClick event:@"home-package"];
        NSString *token = [DENGFANGSingletonTime shareInstance].tokenString;
        if ([token isEqualToString:@""] || token == nil) {
            SSH_YanZhengMaDengLuController *verVC = [[SSH_YanZhengMaDengLuController alloc] init];
            verVC.isShowTiaoGuo = 0;
            SSQ_HiddenNavigationViewController *naviVC = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:verVC];
            [self presentViewController:naviVC animated:YES completion:nil];
        } else {
            SSH_MemberViewController *huiyuan = [[SSH_MemberViewController alloc] init];
            huiyuan.type = 1;
            huiyuan.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:huiyuan animated:YES];
        }
        
    } else if (sender.tag == 1001) {
        //若用户是vip可以进入 用户不是vip提示用户不是vip
        [MobClick event:@"home-sheet"];
        NSString *token = [DENGFANGSingletonTime shareInstance].tokenString;
        if ([token isEqualToString:@""] || token == nil) {
            SSH_YanZhengMaDengLuController *verVC = [[SSH_YanZhengMaDengLuController alloc] init];
            verVC.isShowTiaoGuo = 0;
            SSQ_HiddenNavigationViewController *naviVC = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:verVC];
            [self presentViewController:naviVC animated:YES completion:nil];
        } else {
            [self joinQdwy];
        }
    } else if (sender.tag == 1002) {
        [MobClick event:@"home- instuments"];
        SSH_CreditToolViewController *credit = [[SSH_CreditToolViewController alloc]init];
        credit.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:credit animated:YES];
    } else if (sender.tag == 2000) {
        //推广赚钱
        [MobClick event:@"home-making"];
        NSString *token = [DENGFANGSingletonTime shareInstance].tokenString;
        if ([token isEqualToString:@""] || token == nil) {
            SSH_YanZhengMaDengLuController *verVC = [[SSH_YanZhengMaDengLuController alloc] init];
            verVC.isShowTiaoGuo = 0;
            SSQ_HiddenNavigationViewController *naviVC = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:verVC];
            [self presentViewController:naviVC animated:YES completion:nil];
        } else {
            if (isShowFX) {
                SSH_FenXiaoViewController *vc = [[SSH_FenXiaoViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [MBProgressHUD showError:@"此功能暂未上线，敬请期待。"];
            }
        }
    } else if (sender.tag == 2001) {
        //立即抢单
        [MobClick event:@"home-immediately"];
        NSString *token = [DENGFANGSingletonTime shareInstance].tokenString;
        if ([token isEqualToString:@""] || token == nil) {
            SSH_YanZhengMaDengLuController *verVC = [[SSH_YanZhengMaDengLuController alloc] init];
            verVC.isShowTiaoGuo = 0;
            SSQ_HiddenNavigationViewController *naviVC = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:verVC];
            [self presentViewController:naviVC animated:YES completion:nil];
        } else {
            self.tabBarController.selectedIndex = 1;
        }
    } else if (sender.tag == 2002) {
        [MobClick event:@"home-Exhibiton tool"];
        NSString *token = [DENGFANGSingletonTime shareInstance].tokenString;
        if ([token isEqualToString:@""] || token == nil) {
            SSH_YanZhengMaDengLuController *verVC = [[SSH_YanZhengMaDengLuController alloc] init];
            verVC.isShowTiaoGuo = 0;
            SSQ_HiddenNavigationViewController *naviVC = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:verVC];
            [self presentViewController:naviVC animated:YES completion:nil];
        } else {
            SSH_ZYViewController *zhanYe = [[SSH_ZYViewController alloc] init];
            zhanYe.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:zhanYe animated:YES];
        }
    }
}

-(void)joinQdwy{
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]};
    [[DENGFANGRequest shareInstance] getWithUrlString:[DENGFANGRequest shareInstance].DENGFANGUserInfoURL parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"获取用户信息 数据 %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            self.infoModel = [[SSH_GeRenXinXiModel alloc]init];
            if ([diction[@"data"] isKindOfClass:NSDictionary.class]) {
                [self.infoModel setValuesForKeysWithDictionary:diction[@"data"]];
            }
            
            //（0：未认证  1：已认证   2:认证中   3:认证失败）
            self->isVip = [self.infoModel.isVip boolValue];
            if (self->isVip) {
                if ([self.infoModel.isAuth intValue] == 1 && [self.infoModel.isFaceCheck intValue] == 1) { //已认证
                    SSH_ZDQDViewController *zdqd = [[SSH_ZDQDViewController alloc] init];
                    zdqd.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:zdqd animated:YES];
                } else {
                    SSH_New_RZViewController *rz = [[SSH_New_RZViewController alloc] init];
                    rz.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:rz animated:YES];
                }
            } else {
                [MBProgressHUD showError:@"此功能仅限VIP用户使用，请开通VIP。"];
            }
            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];
}

//刷新按钮的点击事件
- (void)refreshHomePageAction{
    
    NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.danTableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pageNum = 1;
        [self getCreditinfoListData];
    });
    
    
}
//
//第一次打开app的时候，执行这个方法，后期完善这个内容
- (void)firstOpenAppToLogin:(BOOL)isShowTiaoGuo{
    SSH_YanZhengMaDengLuController *verVC = [[SSH_YanZhengMaDengLuController alloc] init];
    
    verVC.isDidDiss = ^(BOOL isYes) {
        if (isYes) {
            if (self.isDingWeiSuccess) { //第一次定位且成功
                [self setupChangeCity];
            }
            //后台关闭了banner显示
            if (!self.isShowPopView) [self getPopView];
        }
    };
    self.yanZhengMaVC = verVC;
    verVC.isShowTiaoGuo = isShowTiaoGuo;
    SSQ_HiddenNavigationViewController *naviVC = [[SSQ_HiddenNavigationViewController alloc] initWithRootViewController:verVC];
    [self presentViewController:naviVC animated:NO completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取是否l打开分销入口
- (void)getOpenFenXiao {
    NSDictionary * dic = @{
                           @"timestamp":[NSString yf_getNowTimestamp],
                           @"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:nil],
                           @"sysTemCode":@"DISTRIBUTION"};
    
    NSString *url = @"sys/getSysTemInfo";
    
    [[DENGFANGRequest shareInstance] postWithUrlString:url parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            NSDictionary *dic = diction[@"data"];
            if ([dic isKindOfClass:NSNull.class] || [dic[@"isOpen"] isEqualToString:@"1"]) {
                self->isShowFX = NO;
            } else {
                self->isShowFX = YES;
            }
        }
    } fail:^(NSError *error) {
    }];
}

#pragma mark 定位界面传过来的值
- (void)sl_cityListSelectedCity:(NSString *)selectedCity Id:(NSInteger)Id displayCity:(NSString *)displayCity cityArray:(NSArray *)cityArray CityArrayString:(NSString *)cityArrayString{
    
    [SSH_TOOL_GongJuLei saveSelectCityName:cityArrayString];
    self.pageNum = 1;
    self.displayLabel.text = displayCity;
    if ([self.displayLabel.text isEqualToString:@"全国"]) {
        [MobClick event:@"home-location"];
    }
    self.cityID = Id;
    CGFloat textW1 = [self getWidthWithTitle:displayCity font:UIFONTTOOL15];
    self.cityBtn.frame = CGRectMake(5, getStatusHeight, textW1+70, getRectNavHight);
    
    [DENGFANGSingletonTime shareInstance].mapCity = cityArrayString;
    [[NSUserDefaults standardUserDefaults] setValue:cityArrayString forKey:SelectedCityName];
    [[NSUserDefaults standardUserDefaults] setValue:displayCity forKey:@"displayCity"];
    [[NSUserDefaults standardUserDefaults] setInteger:Id forKey:SelectedCityIDName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self getCreditinfoListData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SelectedCityAction object:nil];
    if ([DENGFANGSingletonTime shareInstance].tokenString == nil || [[DENGFANGSingletonTime shareInstance].tokenString isEqualToString:@""]) {
        
        return;
    }else{
        if (![selectedCity isEqualToString:@"全国"]) {
            //            [self getDENGFANGUpdateUserAreaData]; //不传登入城市
        }
    }
    
}

-(void)showNewInformationCount:(NSUInteger)count{
    // 1.创建label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithRed:230/255.0 green:60/255.0 blue:63/255.0 alpha:0.8];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = UIFONTTOOL12;
    label.textColor = COLORWHITE;
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.y = 0;
    label.text = [NSString stringWithFormat:@"成功为您推荐%ld条最新发布的消息",count];
    [self.normalBackView addSubview:label];
    
    CGFloat duration = 0.5; // 动画的时间
    [UIView animateWithDuration:duration animations:^{
        label.height = 25;
        
    } completion:^(BOOL finished) {
        CGFloat delay = 0.5; // 延迟1s
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
            label.height = 0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    
}

@end
