//
//  SSH_TDSubmitImgView.m
//  DENGFANGSC
//
//  Created by 河神 on 2019/5/11.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_TDSubmitImgView.h"

@implementation SSH_TDSubmitImgView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLORWHITE;
        [self addSubview:self.collShowLab];
        [self addSubview:self.imageCollection];
        [self addSubview:self.textShowLab];
        [self addSubview:self.textShowView];
        [self.textShowView addSubview:self.textView];

    }
    return self;
}

- (void)setImageArr:(NSMutableArray *)imageArr{
    _imageArr = imageArr;
    [self.imageCollection reloadData];
}

- (UILabel *)collShowLab{
    if (!_collShowLab) {
        _collShowLab = [[UILabel alloc] initWithFrame:CGRectMake(WidthScale(15), 0, self.width-WidthScale(30), WidthScale(15))];
        _collShowLab.text = @"请提供证明图片（最多3张）";
        _collShowLab.textColor = ColorBlack222;
        _collShowLab.font = [UIFont systemFontOfSize:WidthScale(15)];
    }
    return _collShowLab;
}

- (UICollectionView *)imageCollection{
    if(!_imageCollection){
        CGFloat dis = WidthScale(22.5);
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.itemSize = CGSizeMake(WidthScale(100), WidthScale(100));
        flow.minimumInteritemSpacing = dis;
        _imageCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(WidthScale(15), self.collShowLab.bottom+WidthScale(15), ScreenWidth-WidthScale(30), WidthScale(100)) collectionViewLayout:flow];
        _imageCollection.backgroundColor = COLORWHITE;
        _imageCollection.delegate = self;
        _imageCollection.dataSource = self;
        [_imageCollection registerClass:[SSH_BottomCollectionViewCell class] forCellWithReuseIdentifier:@"bottomCell"];
        [self addSubview:_imageCollection];
    }
    return _imageCollection;
}

- (UILabel *)textShowLab{
    if (!_textShowLab) {
        _textShowLab = [[UILabel alloc] initWithFrame:CGRectMake(WidthScale(15), self.imageCollection.bottom+WidthScale(17.5), self.width-WidthScale(30), WidthScale(15))];
        _textShowLab.text = @"退款补充说明";
        _textShowLab.textColor = ColorBlack222;
        _textShowLab.font = [UIFont systemFontOfSize:WidthScale(15)];
    }
    return _textShowLab;
}

- (UIView *)textShowView{
    if (!_textShowView) {
        _textShowView = [[UIView alloc] initWithFrame:CGRectMake(WidthScale(15), self.textShowLab.bottom+WidthScale(15), self.width-WidthScale(30), WidthScale(130))];
        _textShowView.layer.borderColor = ColorBlack999.CGColor;
        _textShowView.layer.borderWidth = WidthScale(1);
        _textShowView.layer.cornerRadius = WidthScale(25/2);
        _textShowView.layer.masksToBounds = YES;
        
    }
    return _textShowView;
}

- (SSH_XPTextView *)textView{
    if(!_textView){
        _textView = [[SSH_XPTextView alloc]initWithFrame:CGRectMake(WidthScale(15), WidthScale(8), self.textShowView.width-WidthScale(25), WidthScale(100))];
        _textView.delegate = self;
        _textView.placeholder = @"请输入退款补充说明";
        _textView.placeholderColor = ColorBlack999;
        _textView.layer.borderColor = [UIColor whiteColor].CGColor;
        _textView.layer.borderWidth = WidthScale(1);
        _textView.font = [UIFont systemFontOfSize:WidthScale(12)];
        _textView.textColor = ColorBlack222;
        _textView.showsVerticalScrollIndicator = NO;
        
        self.WordContLab = [[UILabel alloc] initWithFrame:CGRectMake(self.textShowView.width-WidthScale(110), self.textView.bottom, WidthScale(100), WidthScale(15))];
        self.WordContLab.font = [UIFont systemFontOfSize:WidthScale(12)];
        self.WordContLab.text = @"0/500";
        self.WordContLab.textColor = ColorBlack999;
        self.WordContLab.textAlignment = NSTextAlignmentRight;
        [self.textShowView addSubview:self.WordContLab];
        
    }
    return _textView;
}


#pragma mark ==================textViewd代理方法==============
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.markedTextRange == nil && textView.text.length > 500) {
        //提示语
        [SSH_TOOL_GongJuLei showAlter:self WithMessage:@"输入限制500个字符以内"];
        
        //截取
        textView.text = [textView.text substringToIndex:500];
    }
    
    self.WordContLab.text = [NSString stringWithFormat:@"%ld/500",textView.text.length];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if(self.bottomTextViewText){
        self.bottomTextViewText(textView.text);
    }
}

#pragma mark ==================网格代理===============
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if(self.imageArr.count <= 3){
        return self.imageArr.count;
    }else{
        return self.imageArr.count - 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SSH_BottomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bottomCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 25/2;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = ColorBlack999.CGColor;
    
    cell.imageView.image = self.imageArr[indexPath.row];

    __weak typeof(self) weakSelf = self;
    cell.deleteBtnTarget = ^{
        [weakSelf.imageArr removeObjectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.imageCollection reloadData];
        });
    };
    
    if(self.imageArr.count <= 4){
        if(indexPath.row == self.imageArr.count-1){
            cell.deleteBtn.hidden = YES;
        }else{
            cell.deleteBtn.hidden = NO;
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if(self.imageArr.count <= 4){
        if(indexPath.row == self.imageArr.count - 1){
            if(self.didSelectTheAddImageBtn){
                self.didSelectTheAddImageBtn();
            }
        }
    }
}


//// 两行cell之间的间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 1.0f;
//}

// 两列cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return WidthScale(22.5f);
}


@end
