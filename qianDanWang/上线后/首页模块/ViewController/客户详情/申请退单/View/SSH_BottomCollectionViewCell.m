//
//  SSH_BottomCollectionViewCell.m
//  DENGFANGSC
//
//  Created by 河神 on 2019/5/11.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import "SSH_BottomCollectionViewCell.h"

@implementation SSH_BottomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.deleteBtn];
    }
    return self;
}

- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WidthScale(100), WidthScale(100))];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIButton *)deleteBtn{
    if(!_deleteBtn){
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.width-21, 0, 21, 21)];
        [_deleteBtn setImage:[UIImage imageNamed:@"退单_删照片"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(didSelecteTheDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (void)didSelecteTheDeleteBtn{
    if(self.deleteBtnTarget){
        self.deleteBtnTarget();
    }
}

@end
