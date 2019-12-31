//
//  SSH_CreditDetailsViewController.m
//  qianDanWang
//
//  Created by AN94 on 9/24/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_CreditDetailsViewController.h"
#import "SSH_CreditDetailsFristerTableViewCell.h"
#import "SSH_CreditDetailsBottomView.h"
#import "SSH_AgingView.h"

@interface SSH_CreditDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,SSH_CreditDetailsBottomViewDelegate,SSH_AgingViewDelegate>

@property (nonatomic,strong)UITableView *creditDetails;
@property (nonatomic,strong)NSArray *detailFristerData;
@property (nonatomic,strong)NSMutableArray *detailSecondeData;
@property (nonatomic,strong)SSH_AgingView *agingView;
@property (nonatomic,strong)XPBackView *backView;
@property (nonatomic,strong)NSArray *agingData;
@property (nonatomic,strong)NSMutableArray *indexArr;
@property (nonatomic,strong)NSString *principal;                    ///<本金
@property (nonatomic,strong)NSString *Staging;                      ///<期数
@property (nonatomic,strong)NSString *interest;                     ///<利率
@property (nonatomic,assign)double backMoney;                       ///<已归还

@end

@implementation SSH_CreditDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabelNavi.text = self.type;
    
    self.indexArr = [NSMutableArray array];
    self.detailSecondeData = [NSMutableArray array];
    self.detailFristerData = @[@"贷款金额:",@"贷款期限:",@"综合月利率:",@"请输入金额",@"请选择期限",@"请输入利率"];
    self.agingData = @[@"3个月",@"6个月",@"12个月",@"18个月",@"2年",@"3年",@"5年",@"10年",@"15年",@"20年",@"25年",@"30年"];
    [self creditDetails];
    [self agingView];
}

- (UITableView *)creditDetails{
    if(!_creditDetails){
        _creditDetails = [[UITableView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHightOnew, SCREEN_WIDTH, SCREENH_HEIGHT - getRectNavAndStatusHightOnew - SafeAreaBottomHEIGHT) style:UITableViewStyleGrouped];
        _creditDetails.delegate = self;
        _creditDetails.dataSource = self;
        [_creditDetails registerNib:[UINib nibWithNibName:@"SSH_CreditDetailsFristerTableViewCell" bundle:nil] forCellReuseIdentifier:@"creditDetailsCell"];
        [self.view addSubview:_creditDetails];
    }
    return _creditDetails;
}

- (SSH_AgingView *)agingView{
    if(!_agingView){
        _agingView = [[SSH_AgingView alloc]initWithFrame:CGRectMake(0, SCREENH_HEIGHT / 2, SCREEN_WIDTH, SCREENH_HEIGHT / 2)];
        _agingView.agingData = self.agingData;
        _agingView.delegate = self;
    }
    return _agingView;
}

#pragma mark ===================表格代理=================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return self.detailFristerData.count / 2;
    }else{
        return self.detailSecondeData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        self.indexArr.removeAllObjects;
//    });
    
    if(indexPath.section == 0){
        
        [self.indexArr addObject:indexPath];
        
        SSH_CreditDetailsFristerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"creditDetailsCell"];
        
        if(!cell){
            cell = [[SSH_CreditDetailsFristerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"creditDetailsCell"];
        }
        
        cell.leftLabel.text = self.detailFristerData[indexPath.row];
        cell.rightTextTF.placeholder = self.detailFristerData[indexPath.row];
        
        if(indexPath.row == 0){
            
            cell.rightTextTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            
            UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - WidthScale(70), 0, WidthScale(35), WidthScale(45))];
            rightLabel.font = [UIFont systemFontOfSize:13];
            rightLabel.textColor = COLOR_WITH_HEX(0x333333);
            rightLabel.textAlignment = NSTextAlignmentRight;
            rightLabel.text = @"万元";
            [cell addSubview:rightLabel];
        }else if(indexPath.row == 1){
            cell.rightTextTF.userInteractionEnabled = NO;
            UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - WidthScale(56), WidthScale(18), WidthScale(21), WidthScale(10))];
            [rightBtn setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
            [rightBtn addTarget:self action:@selector(didSelecteTheRightBtn) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:rightBtn];
            
        }else{
            
            cell.rightTextTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            
            UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - WidthScale(50), 0 , WidthScale(15), WidthScale(45))];
            rightLabel.font = [UIFont systemFontOfSize:13];
            rightLabel.textColor = COLOR_WITH_HEX(0x333333);
            rightLabel.text = @"%";
            [cell addSubview:rightLabel];
        }
        
        return cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"creditDetailsSecondeCell"];
        
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"creditDetailsSecondeCell"];
        }
        
        cell.backgroundColor = RGB(246, 246, 246);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = COLOR_WITH_HEX(0x333333);
        NSDictionary *dic = self.detailSecondeData[indexPath.row];
        
        cell.textLabel.text = dic.allKeys[0];
        
        NSString *detail = [NSString stringWithFormat:@"%@元",[dic objectForKey:dic.allKeys[0]]];
        
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc]initWithString:detail attributes:@{
                                                                            NSFontAttributeName:[UIFont systemFontOfSize:14],
                                                                            NSForegroundColorAttributeName:COLOR_WITH_HEX(0xff0200)
                                                                                                                }];
        NSRange range = [detail rangeOfString:@"元"];
        [mAttr addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0x333333) range:range];
        
        cell.detailTextLabel.attributedText = mAttr;
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        SSH_CreditDetailsBottomView *footerView = [[SSH_CreditDetailsBottomView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WidthScale(145))];
        
        footerView.delegate = self;
        
        if([self.type isEqualToString:@"等额本息"]){
            
            footerView.topLabel.text = @"每月还款额相同";
            
        }else if ([self.type isEqualToString:@"等额本金"]){
            
            footerView.topLabel.text = @"月还本金相同，月还总额逐渐递减";
            
        }else if ([self.type isEqualToString:@"先息后本"]){
            
            footerView.topLabel.text = @"先还利息，最后还本金";
            
        }else{
            
            footerView.topLabel.text = @"一次性把本金和利息全部还完";
            
        }
        
        return footerView;
    }else{
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return WidthScale(145);
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark ==================自定义代理================
- (void)didSelecteTheBtnWithTarget:(NSInteger)tag{
    [self.detailSecondeData removeAllObjects];
    for (NSIndexPath *index in self.indexArr) {
        
        SSH_CreditDetailsFristerTableViewCell *cell = [self.creditDetails cellForRowAtIndexPath:index];
        
        if([cell.rightTextTF.text isEqualToString:@""] || cell.rightTextTF.text == nil){
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:@"请输入完整的信息"];
            return;
        }
        
        if(index.row == 0){
            self.principal = [NSString stringWithFormat:@"%.2lf",cell.rightTextTF.text.floatValue * 10000];
        }else if (index.row == 1){
            
            NSScanner *scanner = [NSScanner scannerWithString:cell.rightTextTF.text];
            
            [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
            
            
            
            int number;
            
            [scanner scanInt:&number];
            
            if([cell.rightTextTF.text containsString:@"年"]){
                number = number * 12;
            }
            
            NSString *num = [NSString stringWithFormat:@"%d",number];
            
            self.Staging = num;
        }else{
            self.interest = [NSString stringWithFormat:@"%lf",cell.rightTextTF.text.floatValue / 100];
        }
        
    }
        
    if (tag == 0) {
            
            if([self.type isEqualToString:@"等额本息"]){
                
                double everyMonth = 0.0;                ///<每月还款金额
                double allInterest = 0.0;               ///<总还利息
                double allMoney = 0.0;                  ///<总还金额
                //等额本息每月还款金额 = 〔贷款本金×月利率×(1+月利率)^还款月数〕÷〔(1+月利率)^还款月数-1〕
                
                
                everyMonth = (self.principal.doubleValue * self.interest.doubleValue * pow(1 + self.interest.floatValue, self.Staging.integerValue)) / (pow(1 + self.interest.doubleValue , self.Staging.intValue) - 1);
                
                allMoney = everyMonth * self.Staging.intValue;
                
                allInterest = allMoney - self.principal.doubleValue;
                
                NSDictionary *dic1 = @{@"每月还款":[NSString stringWithFormat:@"%.2f",everyMonth]};
                NSDictionary *dic2 = @{@"总支付利息":[NSString stringWithFormat:@"%.2f",allInterest]};
                NSDictionary *dic3 = @{@"本息总和":[NSString stringWithFormat:@"%.2f",allMoney]};
                
                [self.detailSecondeData addObject:dic1];
                [self.detailSecondeData addObject:dic2];
                [self.detailSecondeData addObject:dic3];
                
            }else if([self.type isEqualToString:@"等额本金"]){
                
                //每月月供额
                double monthMoney = (self.principal.doubleValue / self.Staging.intValue) + (self.principal.doubleValue - self.backMoney) * self.interest.doubleValue;
                //每月应还本金
                double yPrincipal = self.principal.doubleValue / self.Staging.intValue;
                //每月应还利息
                double yInterest = (self.principal.doubleValue - self.backMoney) * self.interest.doubleValue;
                //每月月供递减额
                double dJian = yPrincipal * self.interest.doubleValue;
                //总利息=〔(总贷款额÷还款月数+总贷款额×月利率)+总贷款额÷还款月数×(1+月利率)〕÷2×还款月数-总贷款额
                double allL = ((self.principal.doubleValue / self.Staging.intValue + self.principal.doubleValue * self.interest.doubleValue) + self.principal.doubleValue / self.Staging.intValue * (1 + self.interest.doubleValue) ) / 2 * self.Staging.intValue - self.principal.doubleValue;
                
                NSDictionary *dic1 = @{@"每月还款":[NSString stringWithFormat:@"%.2f",monthMoney]};
                NSDictionary *dic2 = @{@"每月递减":[NSString stringWithFormat:@"%.2f",dJian]};
                NSDictionary *dic3 = @{@"总支付利息":[NSString stringWithFormat:@"%.2f",allL]};
                NSDictionary *dic4 = @{@"本息总和":[NSString stringWithFormat:@"%.2f",allL + self.principal.doubleValue]};
                
                [self.detailSecondeData addObject:dic1];
                [self.detailSecondeData addObject:dic2];
                [self.detailSecondeData addObject:dic3];
                [self.detailSecondeData addObject:dic4];
                
            }else if([self.type isEqualToString:@"先息后本"]){
                
                //每月应还
                double monthMoney = self.principal.doubleValue * self.interest.doubleValue;
                //最后一个月还款
                double lastMonth = monthMoney + self.principal.doubleValue;
                //总支付利息
                double allLi = monthMoney * self.Staging.intValue - self.principal.doubleValue;
                //本息总和
                double allMoney = allLi + self.principal.doubleValue;
                
                NSDictionary *dic1 = @{@"每月还款":[NSString stringWithFormat:@"%.2f",monthMoney]};
                NSDictionary *dic2 = @{@"最后一月还款":[NSString stringWithFormat:@"%.2f",lastMonth]};
                NSDictionary *dic3 = @{@"总支付利息":[NSString stringWithFormat:@"%.2f",lastMonth - self.principal.doubleValue]};
                NSDictionary *dic4 = @{@"本息总和":[NSString stringWithFormat:@"%.2f",lastMonth]};
                
                [self.detailSecondeData addObject:dic1];
                [self.detailSecondeData addObject:dic2];
                [self.detailSecondeData addObject:dic3];
                [self.detailSecondeData addObject:dic4];
                
            }else{
                //每月利息
                double monthLi = self.principal.doubleValue * self.interest.doubleValue;
                //总利息
                double allLi = monthLi * self.Staging.intValue;
                //还款总额
                double allMoney = self.principal.doubleValue + allLi;
                
                NSDictionary *dic1 = @{@"每月还款":@"0.00"};
                NSDictionary *dic2 = @{@"最后一月还款":[NSString stringWithFormat:@"%.2f",allMoney]};
                NSDictionary *dic3 = @{@"总支付利息":[NSString stringWithFormat:@"%.2f",allLi]};
                NSDictionary *dic4 = @{@"本息总和":[NSString stringWithFormat:@"%.2f",allMoney]};
                
                [self.detailSecondeData addObject:dic1];
                [self.detailSecondeData addObject:dic2];
                [self.detailSecondeData addObject:dic3];
                [self.detailSecondeData addObject:dic4];
            }
        
    }else{
        
        NSArray *arr = [[NSArray alloc]initWithArray:self.indexArr];
        
        for (int i = 0 ; i < arr.count; i++) {
            SSH_CreditDetailsFristerTableViewCell *cell = [self.creditDetails cellForRowAtIndexPath:arr[i]];
            
            cell.rightTextTF.text = @"";
            
            [self.detailSecondeData removeAllObjects];
            
            [self.indexArr removeAllObjects];
            
            [self.creditDetails reloadData];
            
        }
        
//        for (NSIndexPath *index in self.indexArr) {
//
//            SSH_CreditDetailsFristerTableViewCell *cell = [self.creditDetails cellForRowAtIndexPath:index];
//
//            cell.rightTextTF.text = @"";
//
//            [self.detailSecondeData removeAllObjects];
//
//            [self.creditDetails reloadData];
//
//        }
    }
    
    [self.creditDetails reloadData];
    
}

- (void)didSelecteTheBottomRightBtn{
    [self.backView block:^{
        
    }];
}

- (void)didSelecteTheTableRowWithTitle:(NSString *)title{
    
    [self.backView block:^{
        
    }];
    
    for (NSIndexPath *index in self.indexArr) {
        if(index.row == 1){
            SSH_CreditDetailsFristerTableViewCell *cell = [self.creditDetails cellForRowAtIndexPath:index];
            
            cell.rightTextTF.text = title;
            
        }
    }
}

#pragma mark ==================按钮点击方法================
- (void)didSelecteTheRightBtn{
    self.backView = [XPBackView makeViewWithMask:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT) andView:self.agingView];
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
