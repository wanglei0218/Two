//
//  UITableView+UITableView_XYFEmptyData.h
//  XYFFinancialNews
//
//  Created by 糖豆 on 2018/4/18.
//  Copyright © 2018年 糖豆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (XYFEmptyData)
/**
 *  无数据时显示一个标签显示暂无数据
 **/
- (void)tableViewWitingMsg:(NSString *) message forRowCount:(NSUInteger) rowCount;
/**
 *   无数据时显示一个图片
 **/
- (void)tableViewWitingImageName:(NSString *)imageName forRowCount:(NSUInteger) rowCount;


- (void)tableViewWithYourSelfView:(UIView *)noDataView forRowCount:(NSUInteger)rowCount;

@end
