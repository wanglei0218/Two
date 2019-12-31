//
//  TYDLocationCityModel.h
//  TYDSC
//
//  Created by huang on 2018/10/25.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TYDLocationCity;
@class TYDLocationCityList;

NS_ASSUME_NONNULL_BEGIN

@interface ShangChengLocationCityModel : NSObject

/** 热门城市 */
@property (strong, nonatomic) NSArray<TYDLocationCity *> *hotCity;
/** 城市列表 */
@property (strong, nonatomic) NSArray<TYDLocationCityList *> *list;

/** 选中城市 */
@property (strong, nonatomic) NSString *selectedCity;

/** 选中城市ID */
@property (assign, nonatomic) NSInteger selectedCityId;

/** 高度 */
@property (assign, nonatomic) CGFloat hotCellH;

@end





@interface TYDLocationCityList : NSObject

/** 城市数组 */
@property (strong, nonatomic) NSArray<TYDLocationCity *> *citys;

/** 首字母 */
@property (strong, nonatomic) NSString *initial;

@end




@interface TYDLocationCity : NSObject

/** 城市 */
@property (strong, nonatomic) NSString *name;
/** ID */
@property (assign, nonatomic) NSInteger Id;

/** 是否被选中 */
@property (assign, nonatomic, getter=isSelected) BOOL selected;


@end

NS_ASSUME_NONNULL_END
