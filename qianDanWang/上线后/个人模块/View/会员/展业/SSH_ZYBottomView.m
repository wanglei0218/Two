//
//  SSH_ZYBottomView.m
//  qianDanWang
//
//  Created by AN94 on 9/17/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_ZYBottomView.h"

@implementation SSH_ZYBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collect];
    }
    return self;
}

- (void)setCollectionData:(NSArray *)collectionData{
    _collectionData = collectionData;
    
    [self.collect reloadData];
    
}

- (UICollectionView *)collect{
    if(!_collect){
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.itemSize = CGSizeMake(SCREEN_WIDTH / 3, 75);
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, WidthScale(10), SCREEN_WIDTH, HeightScale(75)) collectionViewLayout:flow];
        _collect.delegate = self;
        _collect.dataSource = self;
        _collect.backgroundColor = [UIColor whiteColor];
        [_collect registerNib:[UINib nibWithNibName:@"SSH_ZYBottomViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bottomViewCollectionCell"];
        
    }
    return _collect;
}

#pragma mark ===============网格数据源=============
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.collectionData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SSH_ZYBottomViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bottomViewCollectionCell" forIndexPath:indexPath];
    
    NSString *str = self.collectionData[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:str];
    cell.bottomLabel.text = str;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delagte respondsToSelector:@selector(didSelecteTheCollectItemWithTarget:)]){
        [self.delagte didSelecteTheCollectItemWithTarget:indexPath.row];
    }
}

- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
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
