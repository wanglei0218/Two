//
//  USERAddressTableViewCell.h
//  USERPRODUCT
//
//  Created by 畅轻 on 2019/6/19.
//  Copyright © 2019 ***. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface USERAddressTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;

@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) IBOutlet UIButton *editBtn;

@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic,strong)void(^editBtnBlock)(void);

@property (nonatomic,strong)void(^deleteBtnBlock)(void);


@end

NS_ASSUME_NONNULL_END
