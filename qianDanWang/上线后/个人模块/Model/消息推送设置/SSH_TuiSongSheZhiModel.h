//
//  SSH_TuiSongSheZhiModel.h
//  DENGFANGSC
//
//  Created by 新民 on 2019/3/19.
//  Copyright © 2019 DENGFANG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//DENGFANGTuiSongSheZhiModel
@interface SSH_TuiSongSheZhiModel : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger userId;
/** 推送城市 */
@property (nonatomic, strong) NSString *pushCity;
/** 推送开始 */
@property (nonatomic, strong) NSString *pushStartTime;
/** 推送开始 */
@property (nonatomic, strong) NSString *pushEndTime;
/** 贷款金额 2000-5000 */
@property (nonatomic, strong) NSString *loanMoney;
/** 房产情况 （0:无 1:有，不接受抵押  2:有,接受抵押）*/
@property (nonatomic, strong) NSString *estateType;
/** 车产情况 （0:无 1:有，不接受抵押  2:有,接受抵押）*/
@property (nonatomic, strong) NSString *carProductionType;
/** 社保状况 0：无 1:有 */
@property (nonatomic, strong) NSString *isSecurity;
/** 公积金 0：无 1:有 */
@property (nonatomic, strong) NSString *isFund;
/** 是否有微粒贷 0：无 1:有 */
@property (nonatomic, strong) NSString *isWeiliD;
/** 芝麻信用 0:无 1:550以下  2:550-600 3:600以上 */
@property (nonatomic, strong) NSString *sesameCredit;
/**  */
@property (nonatomic, strong) NSString *crediteTime;
/**  */
@property (nonatomic, strong) NSString *updateTime;
/** 开关 0:否  1:是 */
@property (nonatomic, strong) NSString *isOpen;

@end

NS_ASSUME_NONNULL_END
