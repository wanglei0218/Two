//
//  SSH_QuanBuBannerCell.m
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/18.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_QuanBuBannerCell.h"



@implementation SSH_QuanBuBannerCell

+ (id)cellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    NSString *className = NSStringFromClass([self class]);
    [tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:className];
    
    return [tableView dequeueReusableCellWithIdentifier:className forIndexPath:indexPath];
}

-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    if (_dataArray.count==0) return;
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    //轮播图
    self.cycleScrollView = [DCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, (SCREEN_WIDTH-30)*84/345) shouldInfiniteLoop:YES];//84
    self.cycleScrollView.itemWidth = SCREEN_WIDTH-30;
    self.cycleScrollView.itemSpace = 8;
    self.cycleScrollView.imgCornerRadius = 4;
    self.cycleScrollView.cellPlaceholderImage = [UIImage imageNamed:@"banner-690x168"];
    [self addSubview:self.cycleScrollView];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for (SSH_BannersModel *m in _dataArray) {
        [arr addObject:m.bannerImgUrl];
    }
    
    self.cycleScrollView.imgArr = arr;//@[@"https://we-mall.oss-cn-shanghai.aliyuncs.com/beadwalletmallImg/upload/cms/2019-03-05/9bbc8cd229544b3b9a960bf102b93bf5.png",@"https://we-mall.oss-cn-shanghai.aliyuncs.com/beadwalletmallImg/upload/cms/2019-02-21/ff353a11896243ef9132ef11f9036bca.png"];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.closeButton];
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"banner_close"] forState:UIControlStateNormal];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
