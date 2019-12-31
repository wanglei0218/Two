//
//  SSH_TuiSongDatePickerView.h
//  jiaogeqian
//
//  Created by 河神 on 2019/3/1.
//  Copyright © 2019 zdtc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SSH_TuiSongDataPickerViewDelegate <NSObject>

- (void)pickerView:(UIView *)pickerView result1:(NSString *)string1 result2:(NSString *)string2;
- (void)cancelBtnClick:(UIView *)pickerView;

@end
//DENGFANGTuiSongDatePickerView
@interface SSH_TuiSongDatePickerView : UIView

@property (nonatomic,strong)NSArray * letter1;

@property (nonatomic,strong)NSArray * letter2;

@property(nonatomic,weak)id<SSH_TuiSongDataPickerViewDelegate>delegate;



@end

NS_ASSUME_NONNULL_END
