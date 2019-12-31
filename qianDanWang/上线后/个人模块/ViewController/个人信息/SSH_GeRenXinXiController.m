//
//  SSH_GeRenXinXiController.m
//  DENGFANGSC
//
//  Created by huang on 2018/11/2.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "SSH_GeRenXinXiController.h"
#import "SSH_ShenFenRenZhengZhuLieBiaoCell.h"
#import "SSH_TouXiangXuanZeButton.h"
#import "SSH_ShenFenRenZhengZhuController.h" //身份认证主界面
#import "SSH_ShenFenZhengRenZhengViewController.h" //新身份认证主界面
#import "SSH_New_RZViewController.h"

@interface SSH_GeRenXinXiController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * infoTableView;
@property (nonatomic,strong) UIImageView * headImg;
@property(nonatomic,strong)SSH_TouXiangXuanZeButton *iconBtn;
@property (nonatomic,strong) NSString * imgUrlStr;

@end

@implementation SSH_GeRenXinXiController
#pragma mark 修改用户信息 DENGFANGUpdateEuserURL
-(void)getDENGFANGUpdateEuserData{
    NSDictionary * dic = @{@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]],@"userId":[NSNumber numberWithInt:[DENGFANGSingletonTime shareInstance].useridString],@"isPush":@"0",@"photoUrl":self.imgUrlStr};
    
    [[DENGFANGRequest shareInstance] postWithUrlString:[DENGFANGRequest shareInstance].DENGFANGUpdateEuserURL parameters:dic success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"修改用户信息 数据 %@",diction);
        
        if ([diction[@"code"] isEqualToString:@"200"]) {
            
            NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imgUrlStr]];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            [self.iconBtn setBackgroundImage:image forState:0];
            
            [[NSUserDefaults standardUserDefaults] setValue:self.imgUrlStr forKey:DENGFANGHeadImgUrlKey];

            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [DENGFANGSingletonTime shareInstance].headImgUrlString = [[NSUserDefaults standardUserDefaults] valueForKey:DENGFANGHeadImgUrlKey];

            
        }else{
            [SSH_TOOL_GongJuLei showAlter:self.view WithMessage:diction[@"msg"]];
        }
    } fail:^(NSError *error) {

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabelNavi.text = @"个人信息";
    self.view.backgroundColor = ColorBackground_Line;
    
    self.imgUrlStr = self.headUrl;

    UIView * line = [[UIView alloc]init];
    line.frame = CGRectMake(0, getRectNavAndStatusHight-0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = GrayLineColor;
    [self.view addSubview:line];
    
    [self createInfoTableView];
}
#pragma mark 创建tableView
-(void)createInfoTableView{
    self.infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREENH_HEIGHT-getRectNavAndStatusHight)];
    [self.view addSubview:self.infoTableView];
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.infoTableView.backgroundColor = ColorBackground_Line;
    self.infoTableView.scrollEnabled = NO;
}
#pragma mark 头像点击事件
-(void)headImgTap{
    
}
#pragma mark - tableView 代理的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SSH_ShenFenRenZhengZhuLieBiaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    if (!cell) {
        cell = [[SSH_ShenFenRenZhengZhuLieBiaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
    }

    cell.selectionStyle = 0;
    cell.lineView.hidden = YES;
    cell.leftLabel.text = @"身份认证";
    cell.leftLabel.textColor = ColorBlack222;
    cell.arrowImageView.hidden = NO;
    cell.myTextField.enabled = NO;
    
    cell.myImageView.hidden = NO;
    //            0：未认证  1：已认证   2:认证中   3:认证失败
    if(self.isAuth == 1 && self.isFaceCheck == 1){
        cell.myImageView.image = [UIImage imageNamed:@"shenfen-yirenzheng"];
    }else if(self.isAuth == 2){
        cell.myImageView.image = [UIImage imageNamed:@"shenfen-zhong"];
    }else if(self.isAuth == 3){
        cell.myImageView.image = [UIImage imageNamed:@"shenfen-shibai"];
    }else{
        cell.myImageView.hidden = YES;
        cell.leftLabel.text = @"身份认证（通过认证后才可以抢单哦!）";
        cell.leftLabel.frame = CGRectMake(15, 0.5, SCREEN_WIDTH-60, 54.5);
        [self configAttributeString:cell.leftLabel.text rangeString:@"（通过认证后才可以抢单哦!）" withLabel:cell.leftLabel];
    }

   
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SSH_New_RZViewController *rz = [[SSH_New_RZViewController alloc] init];
    rz.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:rz animated:YES];
    
//    SSH_ShenFenZhengRenZhengViewController * idVC = [[SSH_ShenFenZhengRenZhengViewController alloc]init];
//    idVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:idVC animated:YES];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footView = [[UIView alloc]init];
    footView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.1f);
    return footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [[UIView alloc]init];
    headerView.backgroundColor = ColorBackground_Line;
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 89);
    
   [headerView borderForColor:GrayLineColor borderWidth:0.5 borderType:UIBorderSideTypeBottom];
    
    UIView * myBg = [[UIView alloc]init];
    myBg.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:myBg];
    [myBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    
    UILabel * leftLabel = [[UILabel alloc]init];
    leftLabel.text = @"头像";
    leftLabel.font = UIFONTTOOL15;
    leftLabel.textColor = ColorBlack222;
    [myBg addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
    
    
    __weak typeof(self) weakSelf = self;
    self.iconBtn = [SSH_TouXiangXuanZeButton iconWithFrame:CGRectMake(SCREEN_WIDTH - 60, 10, 50, 50) cornerRadius:25 image:self.imgUrlStr placeholderImage:@"头像" completion:^(UIImage *icon,NSData *data) {
        
        //回调选择的照片
        //[weakSelf.iconBtn setBackgroundImage:icon forState:0];
        [weakSelf getImageUrlStr:data];
    }];
    [myBg addSubview:self.iconBtn];
    
    
    
    
//
//    self.headImg = [[UIImageView alloc]init];
//    self.headImg.layer.cornerRadius = 25;
//    self.headImg.clipsToBounds = YES;
//    self.headImg.image = [UIImage imageNamed:@"wodetouxiang"];
//    [myBg addSubview:self.headImg];
//    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-15);
//        make.width.height.mas_equalTo(50);
//        make.centerY.mas_equalTo(myBg);
//    }];
//
//    self.headImg.userInteractionEnabled = YES;
//    UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImgTap)];
//    [self.headImg addGestureRecognizer:tapGes];
    
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 89;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 55;
}
- (void)configAttributeString:(NSString *)configString rangeString:(NSString *)rangeString withLabel:(UILabel *)label{
    
    NSString *jineString = configString;
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] initWithString:jineString];
    NSRange range = [jineString rangeOfString:rangeString];
    [mutableAttString addAttributes:@{NSFontAttributeName:UIFONTTOOL13,NSForegroundColorAttributeName:ColorBlack999} range:range];
    [mutableAttString beginEditing];
    label.attributedText = mutableAttString;
}
#pragma mark 获取头像图片链接
-(void)getImageUrlStr:(NSData *)data
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *timestamp = [NSString yf_getNowTimestamp];
    NSString *signs = [DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:@"" timesTamp:timestamp];
    [param setValue:timestamp forKey:@"timestamp"];
    [param setValue:signs forKey:@"signs"];
    
    
    [DENGFANGRequest uploadImageWithURLString:UploadImgUrl parameters:param uploadDatas:data progress:^(float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    } success:^(id reponse) {
        
        NSMutableDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingMutableLeaves error:nil];
        
        
        if ([dictionary[@"result"] integerValue] == 200) {
            self.imgUrlStr = dictionary[@"url"][0];
            [self getDENGFANGUpdateEuserData];
        }else{
            
        }
        
    } failure:^(NSError *failure) {
        
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
