//
//  SSH_DingYueHaoModel.h
//  DENGFANGSC
//
//  Created by LY on 2018/11/6.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define <#macro#>
//DENGFANGDingYueHaoModel
@interface SSH_DingYueHaoModel : NSObject

@property (nonatomic, strong) NSString *systemImgUrl;//二维码图片
@property (nonatomic, strong) NSString *systemName;//公众号名称
@property(nonatomic,strong) NSString *systemMsg;

//标题
@property (nonatomic, strong) NSString *titleText;

//方案一
@property (nonatomic, strong) NSString *contentText1;

//方案二
@property (nonatomic, strong) NSString *contentText2;

@property(nonatomic,assign)CGFloat titleH;
@property(nonatomic,assign)CGSize contentText1Size;
@property(nonatomic,assign)CGSize contentText2Size;

@end
