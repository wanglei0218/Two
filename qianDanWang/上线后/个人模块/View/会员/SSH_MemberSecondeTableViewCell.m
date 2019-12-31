//
//  SSH_MemberSecondeTableViewCell.m
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_MemberSecondeTableViewCell.h"

@implementation SSH_MemberSecondeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        [self addSubview:self.imageV];
        [self addSubview:self.secondeCollect];
    }
    
    return self;
    
}

- (void)setCollectData:(NSArray *)collectData{
    _collectData = collectData;
    [self.secondeCollect reloadData];
}

- (UIImageView *)imageV{
    if(!_imageV){
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - WidthScale(282)) / 2, WidthScale(30), WidthScale(282), WidthScale(17))];
        _imageV.image = [UIImage imageNamed:@"title2"];
    }
    return _imageV;
}

- (UICollectionView *)secondeCollect{
    if(!_secondeCollect){
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        
        if(!IS_PhoneXAll){
            flow.itemSize = CGSizeMake(WidthScale(100), HeightScale(160));
        }else{
            flow.itemSize = CGSizeMake(WidthScale(100), WidthScale(150));
        }
        
        flow.minimumInteritemSpacing = 0;
        flow.minimumLineSpacing = 8;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow.sectionInset = UIEdgeInsetsMake(15, 21, 20, 21);
        
        _secondeCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageV.frame), SCREEN_WIDTH, WidthScale(230)) collectionViewLayout:flow];
        _secondeCollect.delegate = self;
        _secondeCollect.dataSource = self;
        _secondeCollect.backgroundColor = RGB(245, 245, 245);
        [_secondeCollect registerNib:[UINib nibWithNibName:@"SSH_MemeberSecondeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"memberSecondeCell"];
        
    }
    return _secondeCollect;
}

#pragma mark ===================网格数据源================
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SSH_MemeberSecondeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"memberSecondeCell" forIndexPath:indexPath];
    
    SSH_MemberModel *model = self.collectData[indexPath.row];
    [cell setSSH_MemberSecondeControlContentWithModel:model];
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(didSelecteTheSecondeItemWithTarget:)]){
        [self.delegate didSelecteTheSecondeItemWithTarget:indexPath.row];
    }
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
