//
//  SSH_CategoryItemView.m
//  ZXPageScrollView
//
//  Created by zhaoxu on 2017/3/29.
//  Copyright © 2017年 zhaoxu. All rights reserved.
//

#import "SSH_CategoryItemView.h"

extern NSString *const RESETCOLORNOTIFICATION;

@interface SSH_CategoryItemView()

@end

@implementation SSH_CategoryItemView

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetColor:) name:RESETCOLORNOTIFICATION object:@"color"];
    
}

- (void)resetColor:(NSNotification *)notification
{
    if (self.index == [[notification.userInfo objectForKey:@"index"]integerValue]) {
        return;
    }
    self.contentLabel.textColor = [notification.userInfo objectForKey:@"color"];
}

- (void)setItemContent:(NSString *)itemContent
{
    _itemContent = itemContent;
    self.contentLabel.text = itemContent;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
