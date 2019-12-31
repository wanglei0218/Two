//
//  SSH_TuiSongDatePickerView.m
//  jiaogeqian
//
//  Created by 河神 on 2019/3/1.
//  Copyright © 2019 zdtc. All rights reserved.
//

#import "SSH_TuiSongDatePickerView.h"

#define KFont [UIFont systemFontOfSize:15]


@interface SSH_TuiSongDatePickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
//遵循协议
@property (nonatomic,strong)UIPickerView * pickerView;//自定义pickerview


@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *completeBtn;

@property(nonatomic,strong)UIView *line;
@property(nonatomic,strong)NSString *letStr1;

@property(nonatomic,strong)NSString *letStr2;

@end


@implementation SSH_TuiSongDatePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}


- (void)initUI{
    
    // 初始化pickerView
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 240)];
    [self addSubview:self.pickerView];
    
    //指定数据源和委托
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    //取消
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(44);
        
    }];
    self.cancelBtn.titleLabel.font = KFont;
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setTitleColor:COLOR_WITH_HEX(0x999999) forState:UIControlStateNormal];
    //完成
    self.completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.completeBtn];
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(44);
        
    }];
    self.completeBtn.titleLabel.font = KFont;
    [self.completeBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.completeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.completeBtn setTitleColor:COLOR_WITH_HEX(0xe63c3f) forState:UIControlStateNormal];
    
    
    self.line = [[UIView alloc]init];
    
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.cancelBtn.mas_bottom).offset(0);
        make.left.right.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(0.5);
        
    }];
    self.line.backgroundColor = RGB(224, 224, 224);
    
//    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
//    titleLab.center = CGPointMake(SCREEN_WIDTH/2, 22);
//    titleLab.text = @"期限";
//    titleLab.textAlignment = NSTextAlignmentCenter;
//    titleLab.textColor = [UIColor blackColor];
//    titleLab.font = [UIFont systemFontOfSize:17];
//    [self addSubview:titleLab];
}


#pragma mark UIPickerView DataSource Method 数据源方法

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.letter1.count;
    }else{
        return self.letter2.count;
        
    }
}

#pragma mark UIPickerView Delegate Method 代理方法
//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.letter1[row];
    }else{
        return self.letter2[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.letStr1 = self.letter1[row];
        NSInteger twoRow = [pickerView selectedRowInComponent:1];
        if (row >= twoRow) {
            [pickerView selectRow:twoRow inComponent:0 animated:YES];
            [pickerView reloadComponent:0];
            self.letStr1 = self.letter1[twoRow];
        }
    }else{
        self.letStr2 = self.letter2[row];
        NSInteger oneRow = [pickerView selectedRowInComponent:0];
        if (oneRow >= row) {
            [pickerView selectRow:oneRow inComponent:1 animated:YES];
            [pickerView reloadComponent:1];
            self.letStr2 = self.letter2[oneRow];
        }
    }
}
//component宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 150;
}
//row高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}

#pragma mark Click
- (void)cancelBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(cancelBtnClick:)]) {
        [self.delegate cancelBtnClick:self];
    }
}

-(void)completeBtnClick{
    

    if (self.letStr1 == nil) {
        self.letStr1 = self.letter1[0];
    }
    if (self.letStr2 == nil) {
        self.letStr2 = self.letter2[0];
    }
    
    
    if (self.delegate && [_delegate respondsToSelector:@selector(pickerView:result1:result2:)]) {
        [self.delegate pickerView:self result1:self.letStr1 result2:self.letStr2];
    }
    
}


@end
