//
//  UIImage+DENGFANGCompressImage.h
//  TaoYouDan
//
//  Created by 锦鳞附体^_^ on 2018/11/27.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DENGFANGCompressImage)

/*
 ** 图片等比例压缩（可以优化方法）
 ** @param sourceImage 资源图片
 ** @param size 压缩的大小  例如（图片宽高*0.5）
 */
-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
