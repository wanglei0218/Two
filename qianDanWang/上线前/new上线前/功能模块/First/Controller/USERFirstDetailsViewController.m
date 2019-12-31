//
//  USERFirstDetailsViewController.m
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/19.
//  Copyright © 2019 ***. All rights reserved.
//

#import "USERFirstDetailsViewController.h"
#import "USERAddressViewController.h"

@interface USERFirstDetailsViewController ()<UITextViewDelegate>
{
    NSString *_name;
    NSString *_phoneNum;
}

@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) IBOutlet UIScrollView *bgscrollView;
@property (strong, nonatomic) IBOutlet UITextField *typeText;
@property (strong, nonatomic) IBOutlet UITextView *miaoshuText;
@property (strong, nonatomic) IBOutlet UITextField *shangjinText;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UIButton *fabuBtn;
@property (strong, nonatomic) IBOutlet UIView *xinxiView;
@property (strong, nonatomic) IBOutlet UILabel *xianzhi;

@end

@implementation USERFirstDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bgImage.sd_layout.topSpaceToView(self.view, -getStatusHeight);
    
    self.miaoshuText.delegate = self;
    
    [self.xinxiView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xinxiViewClick:)]];
    
    if (self.typeName.length != 0) {
        self.typeText.text = self.typeName;
    }
}

- (void)xinxiViewClick:(UITapGestureRecognizer *)tap{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:TOKEN];
    
    if (token.length == 0) {
        
        [self myLoginAction];
        return;
    }
    
    USERAddressViewController *addressVC = [[USERAddressViewController alloc] init];
    [self.navigationController pushViewController:addressVC animated:YES];
    addressVC.dataBlock = ^(NSInteger addID) {
        NSArray *array = [[USERAddress shareUSERAddress] getAllDatas];
        for (int i=0; i<array.count; i++) {
            USERAdd *model = array[i];
            if (model.addID == addID) {
                self.address.text = [NSString stringWithFormat:@"%@%@",model.addCity,model.addxiangxi];
                self->_name = model.addName;
                self->_phoneNum = model.addPhone;
            }
        }
    };
}


- (IBAction)faBuBtnClick:(UIButton *)sender {
    
    if (self.typeText.text.length==0) {
        [self.view showMBHudWithMessage:@"请输入你需要求助的类型" hide:1.5];
        return;
    }
    
    if (self.miaoshuText.text.length==0 || [self.miaoshuText.text isEqualToString:@"说说具体的求助信息，清楚明确的描述才能获得帮助"]) {
        [self.view showMBHudWithMessage:@"请输入你需要求助信息描述" hide:1.5];
        return;
    }
    
    if (self.shangjinText.text.length==0) {
        [self.view showMBHudWithMessage:@"请输入您的赏金" hide:1.5];
        return;
    }
    
    if (self.address.text.length == 0 || [self.address.text isEqualToString:@"输入需要帮助的地点"]) {
        [self.view showMBHudWithMessage:@"请输入你需要帮助的地点" hide:1.5];
        return;
    }
    
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:TOKEN];
    
    if (token.length == 0) {
        
        [self myLoginAction];
        return;
    }
    
    USERModel *model = [[USERModel alloc] init];
    model.title = self.typeText.text;
    model.subTle = self.miaoshuText.text;
    model.price = [NSString stringWithFormat:@"¥%@",self.shangjinText.text];
    model.address = self.address.text;
    model.name = _name;
    model.phoneNum = _phoneNum;
    [[USERDataHandle sharedDataHandle] addOneData:model];
    [[USERAllQiuZhuData sharedAllDataHandle] addOneData:model];
    
    [SVProgressHUD showSuccessWithStatus:@"发布成功"];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    if (self.miaoshuText.text.length==0 || [self.miaoshuText.text isEqualToString:@"说说具体的求助信息，清楚明确的描述才能获得帮助"]) {
        self.xianzhi.text = @"可输入100个字";
    }else{
        NSString *str = textView.text;
        self.xianzhi.text = [NSString stringWithFormat:@"%lu/100",(unsigned long)str.length];
    }
    
    if(textView.text.length >= 100){
        [self.view showMBHudWithMessage:@"您最多可输入100字" hide:1.5];
    }
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length < 1) {
        textView.text = @"说说具体的求助信息，清楚明确的描述才能获得帮助";
    }
}

//点击文本输入框  清空文本
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"说说具体的求助信息，清楚明确的描述才能获得帮助"]) {
        textView.text = @"";
        textView.textColor = TEXTMAINCOLOR;
    }
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
