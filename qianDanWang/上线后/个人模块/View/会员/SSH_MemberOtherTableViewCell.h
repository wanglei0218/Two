//
//  SSH_MemberOtherTableViewCell.h
//  qianDanWang
//
//  Created by AN94 on 9/18/19.
//  Copyright © 2019 智胜. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSH_MemberOtherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImage;                ///<图片
@property (weak, nonatomic) IBOutlet UILabel *topLabel;                     ///<标题
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;                  ///<内容
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;                   ///<按钮

- (void)setCellContentWithData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
