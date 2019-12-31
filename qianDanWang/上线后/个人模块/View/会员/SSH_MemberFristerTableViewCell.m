//
//  SSH_MemberTableViewCell.m
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_MemberFristerTableViewCell.h"

@implementation SSH_MemberFristerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        [self addSubview:self.fristCollect];
    }
    
    return self;
}

- (void)setCollectData:(NSArray *)collectData{
    _collectData = collectData;
    
    [self.fristCollect reloadData];
    
}

- (UICollectionView *)fristCollect{
    if(!_fristCollect){
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.itemSize = CGSizeMake(SCREEN_WIDTH / 4, SCREEN_WIDTH / 4);
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;
        flow.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
        
        _fristCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WidthScale(230)) collectionViewLayout:flow];
        _fristCollect.delegate = self;
        _fristCollect.dataSource = self;
        _fristCollect.backgroundColor = [UIColor whiteColor];
        [_fristCollect registerNib:[UINib nibWithNibName:@"SSH_MemeberFristerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"fristerCell"];
        
    }
    return _fristCollect;
}

#pragma mark =======================网格数据源=================
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SSH_MemeberFristerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fristerCell" forIndexPath:indexPath];
    
    NSDictionary *dic = self.collectData[indexPath.row];
    cell.topImage.image = [UIImage imageNamed:[dic objectForKey:@"name"]];
    cell.bottomLabel.text = [dic objectForKey:@"content"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(didSelecteTheFristerCellWithTarget:)]){
        [self.delegate didSelecteTheFristerCellWithTarget:indexPath.row];
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
