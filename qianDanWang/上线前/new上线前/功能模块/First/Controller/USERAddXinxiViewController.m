//
//  USERAddXinxiViewController.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/20.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERAddXinxiViewController.h"
#import "ShangChengDingWeiViewController.h"

@interface USERAddXinxiViewController ()<TYDLocationViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UILabel *cityText;
@property (strong, nonatomic) IBOutlet UITextField *addressTF;

@end

@implementation USERAddXinxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    self.rootNaviBaseImg.backgroundColor = [UIColor whiteColor];
}


- (IBAction)addressCity:(UITapGestureRecognizer *)sender {
    
    ShangChengDingWeiViewController *cityVC = [[ShangChengDingWeiViewController alloc] init];
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (IBAction)queRen:(UIButton *)sender {
    
    if (self.nameTF.text.length == 0) {
        [self.view showMBHudWithMessage:@"请输入姓名" hide:1.5];
        return;
    }
    
    if (self.phoneTF.text.length == 0) {
        [self.view showMBHudWithMessage:@"请输入手机号" hide:1.5];
        return;
    }
    
    if (![USERCheckClass checkTelNumber:self.phoneTF.text]) {
        [self.view showMBHudWithMessage:@"请输入正确的手机号码" hide:1.5];
        return;
    }
    
    if (self.cityText.text.length == 0) {
        [self.view showMBHudWithMessage:@"请选择所在城市" hide:1.5];
        return;
    }
    
    if (self.addressTF.text.length == 0) {
        [self.view showMBHudWithMessage:@"请输入详细地址" hide:1.5];
    }
    
    USERAdd *model = [[USERAdd alloc] init];
    model.addName = self.nameTF.text;
    model.addPhone = self.phoneTF.text;
    model.addCity = self.cityText.text;
    model.addxiangxi = self.addressTF.text;
    
    [[USERAddress shareUSERAddress] addOneData:model];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 定位界面传过来的值
- (void)sl_cityListSelectedCity:(NSString *)selectedCity Id:(NSInteger)Id {
    
    self.cityText.text = selectedCity;
//    [[NSUserDefaults standardUserDefaults] setValue:selectedCity forKey:SelectedCityName];
    
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
