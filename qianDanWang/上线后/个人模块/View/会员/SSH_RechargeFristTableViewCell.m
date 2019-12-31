//
//  SSH_RechargeFristTableViewCell.m
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import "SSH_RechargeFristTableViewCell.h"

@implementation SSH_RechargeFristTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        self.indexArr = [NSMutableArray array];
        [self addSubview:self.rechargeFristerCollect];
    }
    
    return self;
    
}

- (void)setCollectData:(NSArray *)collectData{
    _collectData = collectData;
    
    [self.rechargeFristerCollect reloadData];
    
}

- (UICollectionView *)rechargeFristerCollect{
    if(!_rechargeFristerCollect){
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.itemSize = CGSizeMake(WidthScale(165), WidthScale(70));
        flow.minimumInteritemSpacing = 0;
        flow.minimumLineSpacing = 10;
        flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _rechargeFristerCollect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WidthScale(175)) collectionViewLayout:flow];
        _rechargeFristerCollect.delegate = self;
        _rechargeFristerCollect.dataSource = self;
        _rechargeFristerCollect.backgroundColor = [UIColor whiteColor];
        [_rechargeFristerCollect registerNib:[UINib nibWithNibName:@"RechargeFristerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"rechargeFristerCollectCell"];
        
    }
    return _rechargeFristerCollect;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.indexArr addObject:indexPath];
    
    RechargeFristerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rechargeFristerCollectCell" forIndexPath:indexPath];
    
    /*
     @property (weak, nonatomic) IBOutlet UIButton *back;
     @property (weak, nonatomic) IBOutlet UILabel *topLabel;
     @property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
     @property (weak, nonatomic) IBOutlet UILabel *rightLabel;
     */
    
    /*
     @"name":@"普通会员30天",
     @"after":@"现价：268",
     @"before":@"原价：700"
     */
//    cell.backgroundColor = [UIColor redColor];
    SSH_MemberModel *model = self.collectData[indexPath.row];
//    cell.back.backgroundColor = [UIColor blackColor];
    cell.back.image = [UIImage imageNamed:model.vipName];
    cell.topLabel.text = [NSString stringWithFormat:@"%@%@天",model.vipName,model.vipDays];
    cell.moneyLabel.text = [NSString stringWithFormat:@"现价:%@",model.vipAmounts];
    NSString *beforMoney = [NSString stringWithFormat:@"原价:%@",model.vipMaxAmount];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:beforMoney];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, beforMoney.length)];
    cell.rightLabel.attributedText = newPrice;
    
    if(indexPath.row == self.type){
        cell.back.image = [UIImage imageNamed:[NSString stringWithFormat:@"S%@",model.vipName]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SSH_MemberModel *otherModel = self.collectData[indexPath.row];
    
    for (NSIndexPath *index in self.indexArr) {
        
        SSH_MemberModel *model = self.collectData[index.row];
        
        RechargeFristerCollectionViewCell *cell = (RechargeFristerCollectionViewCell *)[self.rechargeFristerCollect cellForItemAtIndexPath:index];
        
        if(index.row == indexPath.row){
            cell.back.image = [UIImage imageNamed:[NSString stringWithFormat:@"S%@",model.vipName]];
        }else{
            cell.back.image = [UIImage imageNamed:model.vipName];
        }
        
    }
    
    if([self.delegate respondsToSelector:@selector(didSelecteTheRechargeItemWithModel:)]){
        [self.delegate didSelecteTheRechargeItemWithModel:otherModel];
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
