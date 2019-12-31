//
//  SSH_LocationCityModel.h
//  DENGFANGSC
//
//  Created by huang on 2018/10/25.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DENGFANGLocationCity;
@class DENGFANGLocationCityList;

NS_ASSUME_NONNULL_BEGIN

//DENGFANGLocationCityModel
@interface SSH_LocationCityModel : NSObject

/** 最多选五个 */
@property (strong, nonatomic) NSArray<DENGFANGLocationCity *> *zuiDuoCity;

/** 热门城市 */
@property (strong, nonatomic) NSArray<DENGFANGLocationCity *> *hotCity;
/** 城市列表 */
@property (strong, nonatomic) NSArray<DENGFANGLocationCityList *> *list;

/** 选中城市 */
@property (strong, nonatomic) NSString *selectedCity;

/** 选中城市ID */
@property (assign, nonatomic) NSInteger selectedCityId;

/** 高度 */
@property (assign, nonatomic) CGFloat hotCellH;
/** 高度 */
@property (assign, nonatomic) CGFloat zuiDuoCellH;

@end


@interface DENGFANGLocationCityList : NSObject

/** 城市数组 */
@property (strong, nonatomic) NSArray<DENGFANGLocationCity *> *citys;

/** 首字母 */
@property (strong, nonatomic) NSString *initial;

@end

@interface DENGFANGLocationCity : NSObject

/** 城市 */
@property (strong, nonatomic) NSString *name;
/** ID */
@property (assign, nonatomic) NSInteger Id;

/** 是否被选中 */
@property (assign, nonatomic, getter=isSelected) BOOL selected;

@end

NS_ASSUME_NONNULL_END
