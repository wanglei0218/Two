//
//  SSH_New_QYViewController.m
//  qianDanWang
//
//  Created by 小锦鲤 on 2019/8/20.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_New_QYViewController.h"
#import "ZHFAddTitleAddressView.h"
//高德定位
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SSH_New_QYViewController ()<ZHFAddTitleAddressViewDelegate>
{
    NSString *mapString;
}
@property (nonatomic, strong) AMapLocationManager *locationManager; //定位
@property(nonatomic,strong)ZHFAddTitleAddressView * addTitleAddressView;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UIButton *submitBut;

@end

@implementation SSH_New_QYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *xibView = [[NSBundle mainBundle] loadNibNamed:@"New_QYView" owner:self options:nil].lastObject;
    xibView.frame = self.normalBackView.frame;
    [self.normalBackView addSubview:xibView];
    
    self.titleLabelNavi.text = @"个人位置";
    
    mapString = @"";
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.submitBut.userInteractionEnabled = NO;
    [self setupMap];
}

-(void)cancelBtnClick:(NSString *)titleAddress titleID:(NSString *)titleID{
    self.cityLab.text = titleAddress;
    mapString = titleAddress;
}

- (IBAction)submitUpMap:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:mapString forKey:@"upMap"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 定位
- (void)setupMap{
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
    }];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        self.submitBut.userInteractionEnabled = YES;
        if (error){
            NSLog(@"222");
            if (error.code == AMapLocationErrorLocateFailed){
                [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"获取您位置失败请手动选择"];
                self.addTitleAddressView = [[ZHFAddTitleAddressView alloc]init];
                self.addTitleAddressView.title = @"选择地址";
                self.addTitleAddressView.delegate1 = self;
                self.addTitleAddressView.defaultHeight = 350;
                self.addTitleAddressView.titleScrollViewH = 37;
                self.addTitleAddressView.fileName = @"address";
                [self.view addSubview:[self.addTitleAddressView initAddressView]];
                [self.addTitleAddressView addAnimate];
                return;
            }
        }else{
            NSLog(@"333");
            if (regeocode.POIName.length == 0) {
                self->mapString = [NSString stringWithFormat:@"%@%@%@%@",regeocode.province,regeocode.city,regeocode.district,regeocode.street];
            } else {
                self->mapString = [NSString stringWithFormat:@"%@%@%@%@%@",regeocode.province,regeocode.city,regeocode.district,regeocode.street,regeocode.POIName];
            }
            
            self.cityLab.text = self->mapString;
        }
    }];
}

@end
