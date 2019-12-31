//
//  SSH_ZiZhiXinXiHeaderCollectionView.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/15.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_ZiZhiXinXiHeaderCollectionView.h"
#import "SSH_ZiZhiXinXiListView.h"

@interface SSH_ZiZhiXinXiHeaderCollectionView()


@end

@implementation SSH_ZiZhiXinXiHeaderCollectionView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
//        [self creatView];
    }
    return self;
}


-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    

    self.bgView = [[UIView alloc] init];
    self.bgView.frame = CGRectMake(0, 0, self.mj_w, self.mj_h);
    self.bgView.backgroundColor = COLORWHITE;
    [self addSubview:self.bgView];

    //标题
    self.smallLabel = [[UILabel alloc]init];
    [self.bgView addSubview:self.smallLabel];
    self.smallLabel.textColor = ColorBlack222;
    self.smallLabel.font = UIFONTTOOL13;
    [self.smallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(self.mj_w-10);
        make.height.mas_equalTo(29);
    }];
    
    for (int i=0; i<_dataArray.count; i++) {
        
        SSH_ShaiXuanModel *m = _dataArray[i];
        SSH_ZiZhiXinXiListView *listView = [[SSH_ZiZhiXinXiListView alloc] init];
//        NSLog(@"conditionName == %@",m.conditionName);
        listView.shaiXuanM = m;
        listView.inputButton.tag = i;
        [listView.inputButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:listView];
        if (i == 0) { //设置默认值
            [listView.inputButton setTitle:self.xinYongKaNameString forState:UIControlStateNormal];
        }else if (i == 1){
            [listView.inputButton setTitle:self.zhiMaFenNameString forState:UIControlStateNormal];
        }else{
            [listView.inputButton setTitle:self.shouRuNameString forState:UIControlStateNormal];
        }
        [listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(i*39+29);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(39);
            make.width.mas_equalTo(self.mj_w);
        }];
    }
}

-(void)clickButton:(UIButton *)btn{
    
    self.MyBlock(btn);
    
}
-(void)layoutSubviews{
    [super layoutSubviews];

    
    
}
@end
