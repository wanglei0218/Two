//
//  SSH_XTXXViewController.m
//  qianDanWang
//
//  Created by 畅轻 on 2019/9/24.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_XTXXViewController.h"
#import "SSH_XTXXCell.h"
#import "SSH_MyMeessageModel.h"
#import "SSH_XTXXImageCell.h"

static NSString *cellID = @"SSH_XTXXCell.h";
static NSString *cellImgID = @"SSH_XTXXImageCell.h";
@interface SSH_XTXXViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *modelArr;
    NSInteger _page;
}
@property (nonatomic, strong)UITableView *tabView;

@end

@implementation SSH_XTXXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabelNavi.text = @"消息通知";
    
    UIView * line = [[UIView alloc]init];
    line.backgroundColor = ColorBackground_Line;
    [self.navigationView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.navigationView.mas_bottom);
        make.height.mas_equalTo(0.5);
        make.left.right.mas_equalTo(0);
    }];
    [self.normalBackView addSubview:self.tabView];
    _page = 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getSystemMsgData];
    
}

- (UITableView *)tabView {
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - getRectNavAndStatusHightOnew - SafeAreaBottomHEIGHT) style:UITableViewStylePlain];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.backgroundColor = COLOR_WITH_HEX(0xf9f9f9);
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tabView registerNib:[UINib nibWithNibName:@"SSH_XTXXCell" bundle:nil] forCellReuseIdentifier:cellID];
        [_tabView registerNib:[UINib nibWithNibName:@"SSH_XTXXImageCell" bundle:nil] forCellReuseIdentifier:cellImgID];
        _tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self->_page = 1;
            [self getSystemMsgData];
        }];
        
        _tabView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            self->_page = self->_page + 1;
            [self getSystemMsgData];
        }];
    }
    return _tabView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SSH_MyMeessageModel *cotentModel =  modelArr[indexPath.row];
    if (cotentModel.actiUrl.length == 0) {
        SSH_XTXXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.model = cotentModel;
        cell.cellHeightReload = ^{
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:self->modelArr];
            SSH_MyMeessageModel *model = mArr[indexPath.row];
            model.cellIsShow = !model.cellIsShow;
            [mArr replaceObjectAtIndex:indexPath.row withObject:model];
            self->modelArr = mArr;
            [self.tabView reloadData];
        };
        
        return cell;
    } else {
        SSH_XTXXImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellImgID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.model = cotentModel;
        cell.cellHeightReload = ^{
            NSMutableArray *mArr = [NSMutableArray arrayWithArray:self->modelArr];
            SSH_MyMeessageModel *model = mArr[indexPath.row];
            model.cellIsShow = !model.cellIsShow;
            [mArr replaceObjectAtIndex:indexPath.row withObject:model];
            self->modelArr = mArr;
            [self.tabView reloadData];
        };
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SSH_MyMeessageModel *model = modelArr[indexPath.row];
    
    if (model.cellIsShow == YES) {
        if (model.actiUrl.length == 0) {
            return model.cellRowHeight + 140;
        } else {
            SSH_XTXXImageCell *cell = (SSH_XTXXImageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return model.cellRowHeight + 160 + [self CountImageHeightWithOldSize:cell.contentImg.image.size];
        }
    }
    if ([model.msgType isEqualToString:@"1"]) {
        return 165;
    } else {
        return 210;
    }
    
}

- (float)CountImageHeightWithOldSize:(CGSize)size {
    float w = size.width;
    float h = size.height;
    return (h / w) * (ScreenWidth - 64);
}

#pragma mark ---------------------- 获取系统消息
//vip/systemMsg/querySystemMsgs
- (void)getSystemMsgData {
    [[DENGFANGRequest shareInstance] postWithUrlString:@"vip/systemMsg/querySystemMsgs" parameters:@{@"rows":@"10",@"page":@(_page),@"userId":[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString],@"timestamp":[NSString yf_getNowTimestamp],@"signs":[DENGFANGEncryptToolClass md5EncryptWithFormulaFromString:[NSString stringWithFormat:@"%d",[DENGFANGSingletonTime shareInstance].useridString]]} success:^(id responsObject) {
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:responsObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",diction);
        if ([diction[@"code"] isEqualToString:@"200"]) {
            NSArray *dataArr = diction[@"data"];
            if (self->_page == 1) {
                self->modelArr = [SSH_MyMeessageModel getDataPushToModel:dataArr];
                [self.tabView.mj_header endRefreshing];
                [self.tabView reloadData];
            } else {
                if (dataArr.count == 0) {
                    [self.tabView.mj_footer endRefreshingWithNoMoreData];
                    return;
                }
                NSMutableArray *mArr = [NSMutableArray arrayWithArray:self->modelArr];
                [mArr addObjectsFromArray:[SSH_MyMeessageModel getDataPushToModel:dataArr]];
                self->modelArr = [mArr copy];
                [self.tabView.mj_footer endRefreshing];
                [self.tabView reloadData];
            }
            
        } else {
            
        }
    } fail:^(NSError *error) {
        
    }];
}

@end
