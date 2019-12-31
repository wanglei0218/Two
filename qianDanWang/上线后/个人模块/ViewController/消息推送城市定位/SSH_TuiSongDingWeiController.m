//
//  SSH_TuiSongDingWeiController.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/30.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_TuiSongDingWeiController.h"
#import "SSH_CurrentLocationView.h" //显示当前定位的view
#import "SSH_ZuiDuoCell.h"
#import "SSH_HotCityListCell.h"
#import "SSH_CityListCell.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#define kTimeInterval 1


@interface SSH_TuiSongDingWeiController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIView * searchBgView;//搜索的背景view
@property (nonatomic,strong) SSH_CurrentLocationView * locaView;//上方定位的背景view

@property (nonatomic,strong) UITableView * locaTableView;

/** 头数组 */
@property (strong, nonatomic) NSMutableArray *sectionArray;
/** 分区中心动画label */
@property (strong, nonatomic) UILabel *sectionTitle;
/** 是否开始拖拽 */
@property (assign, nonatomic, getter=isBegainDrag) BOOL begainDrag;
/** 定位城市ID */
@property (assign, nonatomic) NSInteger Id;
/**是否是search状态 */
@property(nonatomic, assign) BOOL isSearch;
/*搜索结果*/
@property (nonatomic, strong) NSMutableArray * searchCities;

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIImageView * leftImg;

@property (nonatomic, strong) UIView *noSearchView;//没有搜到结果的view
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, assign) BOOL isSearchKong;//搜索了空

@property(nonatomic,strong)NSMutableArray *zuiDuoCityArray;
//@property(nonatomic,assign)BOOL isDeleteCity;

@end

@implementation SSH_TuiSongDingWeiController

#pragma mark 懒加载
-(NSMutableArray *)zuiDuoCityArray{
    if (!_zuiDuoCityArray) {
        _zuiDuoCityArray = [NSMutableArray array];
    }
    return _zuiDuoCityArray;
}

//搜索背景
-(UIView *)searchBgView{
    if (!_searchBgView) {
        _searchBgView = [[UIView alloc]init];
        _searchBgView.frame = CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, 60);
        _searchBgView.backgroundColor = ColorBackground_Line;
    }
    return _searchBgView;
}
-(UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc]init];
        _searchTextField.frame = CGRectMake(15, 15, SCREEN_WIDTH-30, 30);
        _searchTextField.backgroundColor = COLORWHITE;
        _searchTextField.layer.cornerRadius = 15;
        _searchTextField.layer.masksToBounds = YES;
//        _searchTextField.placeholder  = @"请输入城市名称";
        _searchTextField.textAlignment = NSTextAlignmentCenter;
//        [_searchTextField setValue:UIFONTTOOL13 forKeyPath:@"_placeholderLabel.font"];
//        [_searchTextField setValue:ColorBlack999 forKeyPath:@"_placeholderLabel.textColor"];
        _searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入城市名称" attributes:@{NSFontAttributeName:UIFONTTOOL13,NSForegroundColorAttributeName:ColorBlack999}];
        _searchTextField.font = UIFONTTOOL13;
        _searchTextField.textColor = ColorBlack222;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.delegate = self;
        _searchTextField.returnKeyType = UIReturnKeySearch;//变为搜索按钮
        _searchTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        
        
        CGFloat textW = [self getWidthWithTitle:@"请输入城市名称" font:UIFONTTOOL13];
        self.leftImg = [[UIImageView alloc]init];
        self.leftImg.frame = CGRectMake(0, 0, 12, 12);
        self.leftImg.image = [UIImage imageNamed:@"h_dingwei_sousuo"];
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-30)/2-textW/2-10, 0, self.searchTextField.mj_h, self.searchTextField.mj_h)];
        self.leftImg.center =  self.leftView.center;
        [ self.leftView addSubview:self.leftImg];
        
        _searchTextField.leftView =   self.leftView;
        
        
    }
    return _searchTextField;
}
- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

-(NSMutableArray *)searchCities{
    if (!_searchCities) {
        _searchCities = [[NSMutableArray alloc]init];
    }
    return _searchCities;
}
-(UIView *)noSearchView{
    if (!_noSearchView) {
        _noSearchView = [[UIView alloc]init];
        _noSearchView.frame = CGRectMake(0, 220, SCREEN_WIDTH, 200);
        
        UILabel * label1 = [[UILabel alloc]init];
        label1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        label1.text = @"~没有找到~";
        label1.textColor = ColorBlack222;
        label1.font = UIFONTTOOL15;
        label1.textAlignment = NSTextAlignmentCenter;
        [_noSearchView addSubview:label1];
        
        UIView * line1 = [[UIView alloc]init];
        line1.frame = CGRectMake(30, 60, SCREEN_WIDTH-60, 0.5);
        line1.backgroundColor = GrayLineColor;
        [_noSearchView addSubview:line1];
        
        UILabel * label2 = [[UILabel alloc]init];
        label2.frame = CGRectMake(30, 75, SCREEN_WIDTH-60, 25);
        label2.text = @"1：请检查您的输入是否有误！";
        label2.textColor = ColorBlack222;
        label2.font = UIFONTTOOL12;
        [_noSearchView addSubview:label2];
        
        UILabel * label3 = [[UILabel alloc]init];
        label3.frame = CGRectMake(30, 75+25, SCREEN_WIDTH-60, 25);
        label3.text = @"2：目前不支持定位到县级及以下的市区！";
        label3.textColor = ColorBlack222;
        label3.font = UIFONTTOOL12;
        [_noSearchView addSubview:label3];
        
        UIView * line2 = [[UIView alloc]init];
        line2.frame = CGRectMake(30, 75+25*2+15, SCREEN_WIDTH-60, 0.5);
        line2.backgroundColor = GrayLineColor;
        [_noSearchView addSubview:line2];
        
    }
    return _noSearchView;
}
//显示当前定位的view
-(SSH_CurrentLocationView *)locaView{
    if (!_locaView) {
        _locaView = [[SSH_CurrentLocationView alloc]initWithFrame:CGRectMake(0, self.searchBgView.mj_h+self.searchBgView.mj_y, SCREEN_WIDTH, 45)];
        _locaView.backgroundColor = COLORWHITE;
    }
    return _locaView;
}
-(UITableView *)locaTableView{
    if (!_locaTableView) {
        _locaTableView = [[UITableView alloc]init];
        _locaTableView.frame = CGRectMake(0, self.locaView.mj_h+self.locaView.mj_y, SCREEN_WIDTH, SCREENH_HEIGHT-(self.locaView.mj_h+self.locaView.mj_y));
        _locaTableView.delegate = self;
        _locaTableView.dataSource = self;
        _locaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _locaTableView.backgroundColor = ColorBackground_Line;
        _locaTableView.sectionIndexColor = GrayColor666;
        
        
    }
    return _locaTableView;
}
// 区头数组
- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray new];
        for (DENGFANGLocationCityList *cityList in self.cityModel.list) {
            [_sectionArray addObject:cityList.initial];
        }
        [_sectionArray insertObject:@"热门" atIndex:0];
        [_sectionArray insertObject:@"最多" atIndex:0];
    }
    return _sectionArray;
}
- (SSH_LocationCityModel *)cityModel {
    if (!_cityModel) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CityData.plist" ofType:nil];
        NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
        
        _cityModel = [SSH_LocationCityModel mj_objectWithKeyValues:data];
        
    }
    return _cityModel;
}
// 分区动画标题
- (UILabel *)sectionTitle {
    if (!_sectionTitle) {
        _sectionTitle = [[UILabel alloc]init];
        _sectionTitle.backgroundColor = ColorZhuTiHongSe;
        _sectionTitle.textColor = [UIColor whiteColor];
        _sectionTitle.layer.cornerRadius = 50 / 2.0;
        _sectionTitle.layer.masksToBounds = YES;
        _sectionTitle.alpha = 0;
        _sectionTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _sectionTitle;
}

#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //选择的城市数组
//    self.citysString = nil;
    NSArray *array = [self.citysString componentsSeparatedByString:@","];
    for (int i=0; i<array.count; i++) {
        DENGFANGLocationCity *cityM = [[DENGFANGLocationCity alloc] init];
        cityM.name = array[i];
        [self.zuiDuoCityArray addObject:cityM];
    }
    
    //设置导航栏
    [self setNav];
    
    [self setupMap:NO];
    self.titleLabelNavi.text = @"选择城市";
    self.isSearch = NO;
    self.isSearchKong = YES;
    
    //显示选中（cell右侧出现红勾）
    //    [self selectdeCity];
    
    [self.view addSubview:self.searchBgView];
    [self.searchBgView addSubview:self.searchTextField];
    
    [self.view addSubview:self.locaView];
    [self.locaView.reLoctionBtn addTarget:self action:@selector(reloadBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.locaTableView];
    
    //    self.locaView.nowLoctionLabel.text = self.cityModel.selectedCity;
    
    // 动画
    [self sectionAnimationView];
    
    //    [SHAREDAPP.window addSubview:self.noSearchView];
    [self.view addSubview:self.noSearchView];
    self.noSearchView.hidden = YES;
    
}

-(void)setNav{
    
    UIButton *queDingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [queDingBtn setTitle:@"确定" forState:UIControlStateNormal];
    [queDingBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [queDingBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.navigationView addSubview:queDingBtn];
    [queDingBtn addTarget:self action:@selector(clickQueDingButton) forControlEvents:UIControlEventTouchUpInside];
    [queDingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(40.5);
        make.height.mas_equalTo(44);
    }];
    
}

//重新定位
-(void)reloadBtn{
    NSLog(@"重新定位");
    
    [self setupMap:YES];
    
}
- (void)setupMap:(BOOL)isPop{
    [AMapServices sharedServices].apiKey =AMapKey;
    self.locationManager = [[AMapLocationManager alloc] init];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            //            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                self.locaView.nowLoctionLabel.text = @"定位失败";
                return;
            }
        }else{
            self.locaView.nowLoctionLabel.text = regeocode.city;
            if (isPop) {
                //                if (self->_delegate && [self->_delegate respondsToSelector:@selector(sl_cityListSelectedCity:Id:)]) {
                //
                //                    [self->_delegate sl_cityListSelectedCity:self.locaView.nowLoctionLabel.text Id:0];
                //                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    }];
}
#pragma mark 选择的城市
-(void)selectdeCity{
    // 遍历选择
    for (DENGFANGLocationCityList *cityList in self.cityModel.list) {
        for (DENGFANGLocationCity *city in cityList.citys) {
            
            if ([city.name isEqualToString:self.cityModel.selectedCity]) {
                city.selected = YES;
            }else{
                city.selected = NO;
            }
            
        }
    }
}
#pragma mark -- tableView 的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(self.isSearch){
        return 1;
    }
    
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearch) {
        return self.searchCities.count;
    }
    return  section>1? self.cityModel.list[section - 1-1].citys.count:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.isSearch){
        SSH_CityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searCityCell"];
        if (!cell) {
            cell = [[SSH_CityListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searCityCells"];
        }
        cell.selectionStyle = 0;
        cell.city = self.searchCities[indexPath.row];
        
        return cell;
    }
    
    if (indexPath.section == 0) {
        static NSString *ID = @"CellID";
        SSH_ZuiDuoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            cell = [[SSH_ZuiDuoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        }
        
        cell.selectionStyle = 0;
        //从本地获取选择的城市
        self.cityModel.zuiDuoCity = self.zuiDuoCityArray;
        
        cell.cityModel = self.cityModel;
        __weak typeof(self) weakSelf = self;
        cell.delectedCityBlock = ^(NSString * selectedCity, NSInteger Id) {
            
            for (int i = 0; i<weakSelf.zuiDuoCityArray.count; i++) {
                DENGFANGLocationCity *city = weakSelf.zuiDuoCityArray[i];
                if (Id == city.Id) {
                    [weakSelf.zuiDuoCityArray removeObject:city];
                    break;
                }
            }
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [weakSelf.locaTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
        };
        return cell;
    }
    
    if (indexPath.section == 1) {
        SSH_HotCityListCell *hotCell = [tableView dequeueReusableCellWithIdentifier:@"hotCityCell"];
        if (!hotCell) {
            hotCell = [[SSH_HotCityListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCityCell"];
        }
        hotCell.selectionStyle = 0;
        hotCell.num = 1;
        hotCell.cityModel = self.cityModel;
        __weak typeof(self) weakSelf = self;
        hotCell.selectedCityBlock = ^(NSString *selectedCity, NSInteger Id) {
            
            DENGFANGLocationCity *city = [[DENGFANGLocationCity alloc] init];
            city.name = selectedCity;
            city.Id = Id;
            
            //选择城市
            [weakSelf chooseSelectedCitys:city];
        };
        
        return hotCell;
    }
    
    
    SSH_CityListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCityCell"];
    if (!cell) {
        cell = [[SSH_CityListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"listCityCell"];
    }
    cell.selectionStyle = 0;
    cell.city = self.cityModel.list[indexPath.section - 1-1].citys[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearch) {
        return 45;
    }
    
    if (indexPath.section == 0) {
        return self.cityModel.zuiDuoCellH;
    }else if (indexPath.section == 1){
        return self.cityModel.hotCellH;
    }else{
        return 45;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isSearch) {
        return 40;
    }
    return section>1? 40: 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    headerView.backgroundColor = ColorBackground_Line;
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake(15, 0, SCREEN_WIDTH-15, 40);
    if (self.isSearch) {
        label.text = @"搜索结果";
    }else{
        label.text = self.sectionArray[section];
    }
    label.font = UIFONTTOOL14;
    label.textColor = ColorBlack999;
    [headerView addSubview:label];
    
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.isSearch){
        
        DENGFANGLocationCity *city = self.searchCities[indexPath.row];
        
        //选择城市
        [self chooseSelectedCitys:city];
        
        //切换tableView
        self.noSearchView.hidden = YES;
        self.isSearch = NO;
        self.isSearchKong = YES;
        [self.locaTableView reloadData];
        
        return;
    }
    
    if (indexPath.section <= 1) return;
    
    DENGFANGLocationCity *city = self.cityModel.list[indexPath.section - 1-1].citys[indexPath.row];
    //选择了城市
    [self chooseSelectedCitys:city];
}

-(void)chooseSelectedCitys:(DENGFANGLocationCity *)city
{
    //选了全国就不能选其他城市
    DENGFANGLocationCity *firstCity = [self.zuiDuoCityArray firstObject];
    if (([city.name isEqualToString:@"全国"]&&self.zuiDuoCityArray.count>0) || (self.zuiDuoCityArray.count==1&&[firstCity.name isEqualToString:@"全国"])) {
        [MBProgressHUD showSuccess:@"选择了全国则不能选择其他城市"];
    }else{
        if (self.zuiDuoCityArray.count >= 5) {
            [MBProgressHUD showSuccess:@"最多只能选择5个城市"];
        }else{
            //判断有没有重选
            BOOL flag = NO;
            for (int i=0; i<self.zuiDuoCityArray.count; i++) {
                DENGFANGLocationCity *c = self.zuiDuoCityArray[i];
                if ([c.name isEqualToString:city.name]) {
                    flag = YES;
                    break;
                }
            }
            if (flag) {
                [MBProgressHUD showSuccess:@"已经选过"];
            }else{
                //加入数组
                [self.zuiDuoCityArray addObject:city];
            }
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [self.locaTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (self.isSearch) {
        return nil;
    }
    
    return self.sectionArray;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    
    // 结束拖拽
    self.begainDrag = NO;
    
    [UIView animateWithDuration:kTimeInterval animations:^{
        self.sectionTitle.alpha = 1.0;
        [self.sectionTitle.layer removeAllAnimations];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kTimeInterval animations:^{
            self.sectionTitle.alpha = 0.;
        }];
    }];
    
    return index;
    
}

#pragma mark -- 分区中心动画视图添加
- (void)sectionAnimationView {
    [self.locaView.superview addSubview:self.sectionTitle];
    [self.sectionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.locaView.superview);
        make.width.height.mas_equalTo(50);
    }];
}
#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    UITableView *tableView = (UITableView *)scrollView;
    NSArray *array = [tableView indexPathsForRowsInRect:CGRectMake(0, tableView.contentOffset.y, SCREEN_WIDTH, 20)];
    NSIndexPath *indexPath = [NSIndexPath new];
    indexPath = array.count? array[0]: [NSIndexPath indexPathForRow:0 inSection:0];
    
    self.sectionTitle.text = self.sectionArray[indexPath.section];
    
    // 是否开始拖拽
    if (self.isBegainDrag && !self.isSearch) {
        [UIView animateWithDuration:kTimeInterval animations:^{
            self.sectionTitle.alpha = 1.0;
        }];
    }
    
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.begainDrag = YES;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [UIView animateWithDuration:kTimeInterval animations:^{
        self.sectionTitle.alpha = 0.;
    }];
    
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    self.begainDrag = NO;
    if (!velocity.y) {
        [UIView animateWithDuration:kTimeInterval animations:^{
            self.sectionTitle.alpha = 0.;
        }];
    }
}

#pragma mark textField代理
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.searchTextField.textAlignment = NSTextAlignmentLeft;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.leftView.frame = CGRectMake(0, 0, self.searchTextField.mj_h, self.searchTextField.mj_h);
    self.leftImg.center =  self.leftView.center;
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.text.length == 0) {
        [self cancelKeyboard];
        self.noSearchView.hidden = YES;
        
    }
    
}
//搜索虚拟键盘响应

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    self.noSearchView.hidden = YES;
    NSLog(@"点击了搜索");
    [self.searchTextField resignFirstResponder];
    [self.searchCities removeAllObjects];
    
    if (textField.text.length == 0) {
        self.isSearch = NO;
        self.isSearchKong = YES;
    }else{
        self.isSearch = YES;
        self.isSearchKong = NO;
        
        for (DENGFANGLocationCityList * list in self.cityModel.list) {
            for (DENGFANGLocationCity *city in list.citys){
                NSRange chinese = [city.name rangeOfString:textField.text options:NSCaseInsensitiveSearch];
                
                
                if (chinese.location != NSNotFound ) {
                    [self.searchCities addObject:city];
                }
            }
        }
        
        
    }
    
    if (self.searchCities.count == 0) {
        if (self.isSearchKong == YES) {
            self.noSearchView.hidden = YES;
            
        }else{
            self.noSearchView.hidden = NO;
        }
        
    }else{
        self.noSearchView.hidden = YES;
        
    }
    [self.locaTableView reloadData];
    return YES;
    
}
-(void)cancelKeyboard{
    self.searchTextField.textAlignment = NSTextAlignmentCenter;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    CGFloat textW = [self getWidthWithTitle:@"请输入城市名称" font:UIFONTTOOL13];
    
    self.leftView.frame = CGRectMake((SCREEN_WIDTH-30)/2-textW/2-10, 0, self.searchTextField.mj_h, self.searchTextField.mj_h);
    self.leftImg.center =  self.leftView.center;
    
    self.searchTextField.text=@"";
    [self.searchTextField resignFirstResponder];
    self.isSearch = NO;
    [self.locaTableView reloadData];
}

-(void)clickQueDingButton{
    
    if (self.zuiDuoCityArray.count == 0) {
        [MBProgressHUD showSuccess:@"城市选择不能为空"];
        return;
    }
    
    //选择的城市拼接成字符串
    NSMutableArray *arr = [NSMutableArray array];
    for ( DENGFANGLocationCity *citys in self.zuiDuoCityArray) {
        [arr addObject:citys.name];
    }
    NSString *string = [arr componentsJoinedByString:@","];
    
    [self.delegate chooseCityString:string];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
