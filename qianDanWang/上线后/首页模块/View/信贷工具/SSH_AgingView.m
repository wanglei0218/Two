//
//  SSH_ AgingView.m
//  qianDanWang
//
//  Created by AN94 on 9/25/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_AgingView.h"

@implementation SSH_AgingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.topLabel];
        [self addSubview:self.rightBtn];
        [self addSubview:self.agingTable];
        
    }
    return self;
}

- (UILabel *)topLabel{
    if(!_topLabel){
        _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WidthScale(40))];
        _topLabel.text = @"分期方式";
        _topLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topLabel;
}

- (UIButton *)rightBtn{
    if(!_rightBtn){
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - WidthScale(56), WidthScale(15), WidthScale(21), WidthScale(10))];
        [_rightBtn setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(didSelecteTheRightBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UITableView *)agingTable{
    if(!_agingTable){
        _agingTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topLabel.frame), SCREEN_WIDTH, SCREENH_HEIGHT / 2 - CGRectGetMaxY(self.topLabel.frame)) style:UITableViewStyleGrouped];
        _agingTable.delegate = self;
        _agingTable.dataSource = self;
        [_agingTable registerNib:[UINib nibWithNibName:@"SSH_AgingTableViewCell" bundle:nil] forCellReuseIdentifier:@"agingView"];
    }
    return _agingTable;
}

- (void)setAgingData:(NSArray *)agingData{
    _agingData = agingData;
    [self.agingTable reloadData];
}

#pragma mark =======================表格数据源======================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.agingData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SSH_AgingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"agingView"];
    
    if(!cell){
        cell = [[SSH_AgingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"agingView"];
    }
    
    cell.titleLabel.text = self.agingData[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WidthScale(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *title = self.agingData[indexPath.row];
    
    if([self.delegate respondsToSelector:@selector(didSelecteTheTableRowWithTitle:)]){
        [self.delegate didSelecteTheTableRowWithTitle:title];
    }
    
}

#pragma mark ====================按钮点击方法===================
- (void)didSelecteTheRightBtn{
    if([self.delegate respondsToSelector:@selector(didSelecteTheBottomRightBtn)]){
        [self.delegate didSelecteTheBottomRightBtn];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
