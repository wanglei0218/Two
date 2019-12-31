
//
//  SSH_ZYAddViewController.m
//  qianDanWang
//
//  Created by AN94 on 9/17/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_ZYAddViewController.h"
#import "SSH_ZYAddTableViewCell.h"

@interface SSH_ZYAddViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *addTable;
@property (nonatomic,strong)NSArray *tableData;
@property (nonatomic,strong)UIButton *enterBtn;
@property (nonatomic,strong)NSMutableArray *indexArr;
@property (nonatomic,strong)NSString *intore;
@property (nonatomic,strong)NSString *phone;

@end

@implementation SSH_ZYAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabelNavi.text = @"编辑名片";
    self.tableData = @[@"tianxie_xinxi",@"shoujihao"];
    self.indexArr = [[NSMutableArray alloc]init];
    [self addTable];
    [self enterBtn];
}

- (UIButton *)enterBtn{
    if(!_enterBtn){
        _enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(WidthScale(15), WidthScale(150), WidthScale(345), WidthScale(44))];
        NSAttributedString *attr = [[NSAttributedString alloc]initWithString:@"提交" attributes:@{
                                                            NSFontAttributeName:[UIFont systemFontOfSize:15],
                                                            NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                                                }];
        [_enterBtn setAttributedTitle:attr forState:UIControlStateNormal];
        [_enterBtn setBackgroundColor:COLOR_With_Hex(0x0063ff)];
        _enterBtn.layer.cornerRadius = 5;
        _enterBtn.layer.masksToBounds = YES;
        [_enterBtn addTarget:self action:@selector(didSelecteTheEditViewEnterBtn) forControlEvents:UIControlEventTouchUpInside];
        [_addTable addSubview:_enterBtn];
    }
    return _enterBtn;
}

- (UITableView *)addTable {
    if(!_addTable){
        _addTable = [[UITableView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHightOnew, SCREEN_WIDTH, ScreenHeight - getRectNavAndStatusHightOnew - SafeAreaBottomHEIGHT) style:UITableViewStyleGrouped];
        _addTable.delegate = self;
        _addTable.dataSource = self;
        [_addTable registerNib:[UINib nibWithNibName:@"SSH_ZYAddTableViewCell" bundle:nil] forCellReuseIdentifier:@"addTableCell"];
        [self.view addSubview:_addTable];
    }
    return _addTable;
}

#pragma mark =====================按钮点击方法================
- (void)didSelecteTheEditViewEnterBtn{
    [MobClick event:@"editsave"];
    NSString *intro = @"";
    NSString *phone = @"";
    
    for (NSIndexPath *index in self.indexArr) {
        SSH_ZYAddTableViewCell *cell = [self.addTable cellForRowAtIndexPath:index];
        
        if(index.row == 0){
            intro = cell.rightInput.text;
            self.intore = intro;
        }else{
            phone = cell.rightInput.text;
            self.phone = phone;
        }
        
    }
    
    if([self.delegate respondsToSelector:@selector(didEnterTheEditContentWithIntro:phone:)]){
        [self.delegate didEnterTheEditContentWithIntro:intro phone:phone];
    }
    
    [self upLoadPosterData];
    
}

#pragma mark =====================网格数据源================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.indexArr addObject:indexPath];
    
    SSH_ZYAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addTableCell"];
    
    if(!cell){
        cell = [[SSH_ZYAddTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addTableCell"];
    }
    
    cell.leftImage.image = [UIImage imageNamed:self.tableData[indexPath.row]];
    if (indexPath.row == 0){
        cell.rightInput.placeholder = @"请填写信息（字数在二十字以内）";
    }else{
        cell.rightInput.keyboardType = UIKeyboardTypeNamePhonePad;
        cell.rightInput.text = self.phoneNum;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WidthScale(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return WidthScale(10);
}

#pragma mark =================上传海报信息===============
- (void)upLoadPosterData{
    
    NSString *userId = [NSString stringWithFormat:@"%@",[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString]];
    
    NSDictionary *params = @{
                             @"shareName":self.intore,
                             @"shareMobile":self.phone,
                             @"userId":userId,
                             @"timestamp":[NSString yf_getNowTimestamp],
                             @"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:userId]
                             };
    
    [[DENGFANGRequest shareInstance] postWithUrlString:@"vip/posterTool/savePostersShare" parameters:params success:^(id responsObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        
        if([[dic objectForKey:@"code"] isEqualToString:@"200"]){
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"保存成功"];
        } else {
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"保存不成功，请重新提交"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
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
