//
//  UITableView+UITableView_XYFEmptyData.m
//  XYFFinancialNews
//
//  Created by 糖豆 on 2018/4/18.
//  Copyright © 2018年 糖豆. All rights reserved.
//

#import "UITableView+XYFEmptyData.h"


@implementation UITableView (XYFEmptyData)

- (void)tableViewWitingMsg:(NSString *)message forRowCount:(NSUInteger)rowCount {
    UILabel *label = nil;
    if (![self.backgroundView isKindOfClass:[UILabel class]]) {
         label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y*0.4, self.frame.size.width, 40)];
         label.text = message;
         label.textAlignment = NSTextAlignmentCenter;
         label.font = [UIFont systemFontOfSize:30];
         self.backgroundView = label;
    }
    if (rowCount == 0) {
        label.hidden = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else {
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        label.hidden = YES;
    }
}
- (void)tableViewWitingImageName:(NSString *)imageName forRowCount:(NSUInteger)rowCount {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y*0.5, self.frame.size.width*0.3, self.frame.size.height*0.3)];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeCenter;
    if (rowCount == 0) {
        imageView.hidden = NO;
        self.backgroundView = imageView;
    }else {
        imageView.hidden = YES;
        self.backgroundView = nil;
    }
}

- (void)tableViewWithYourSelfView:(UIView *)noDataView forRowCount:(NSUInteger)rowCount {
    noDataView.frame = [UIScreen mainScreen].bounds;
    if (rowCount == 0) {
        self.backgroundView = noDataView;
    }else {
        self.backgroundView = nil;
    }
}

@end
