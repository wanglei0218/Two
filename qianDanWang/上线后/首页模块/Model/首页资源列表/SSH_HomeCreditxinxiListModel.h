//
//  SSH_HomeCreditxinxiListModel.h
//  DENGFANGSC
//
//  Created by huang on 2018/10/26.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//DENGFANGHomeCreditxinxiListModel
@interface SSH_HomeCreditxinxiListModel : NSObject
@property (nonatomic, strong) NSString *creditinfoId; //资源id
@property (nonatomic, strong) NSString *name; //姓名
@property (nonatomic, strong) NSString *isWorryMoney;//是否急用钱（1：是  0：否）
@property (nonatomic, strong) NSString *isInterest;//是否接受高息1：接受  0：不接受
@property (nonatomic, strong) NSString *loanStartLimit;//开始金额
@property (nonatomic, strong) NSString *loanStartLimitF;
@property (nonatomic, strong) NSString *loanEndLimit;//结束金额
@property (nonatomic, strong) NSString *loanTerm;//期限
@property (nonatomic, strong) NSString *property;//房产
@property (nonatomic, strong) NSString *carProduction;//车产
@property (nonatomic, strong) NSString *createTime;//创建时间
@property (nonatomic, strong) NSString *identityType;//身份类型（0：上班族 1：公务员 2：企业主  3：自有职业者  4：学生）
@property (nonatomic, strong) NSString *businessLife;//工资发放方式（0：银行代发  1：现金发放  2：转账打卡）
@property (nonatomic, strong) NSString *businessLifeF;//自由职业者工资发放形式
@property (nonatomic, strong) NSString *income;//月收入
@property (nonatomic, strong) NSString *incomeF;//月收入
@property (nonatomic, strong) NSString *endIncome;//月收入
@property (nonatomic, strong) NSString *amount;// 年流水开始
@property (nonatomic, strong) NSString *amountF;// 年流水开始
@property (nonatomic, strong) NSString *endAmount;// 年流水结束
@property (nonatomic, strong) NSString *loanPurpose;//目的
@property (nonatomic, strong) NSString *isCreditCard;//信用卡
@property (nonatomic, strong) NSString *status;//资源状态1：未上线   2：待抢  3：以抢
@property (nonatomic, strong) NSString *isRecommend;//是否推荐 1 推荐 0 未推荐
@property (nonatomic, strong) NSString *updateTime;//更新时间
@property (nonatomic, strong) NSString *mobile;//手机号
@property (nonatomic, assign) int isLowPrice;//是否为低价淘单，0:否，1:是
/* 列表标签：公积金，社保，实名，微粒贷 */
@property (nonatomic, strong) NSString *isFund;//公
@property (nonatomic, strong) NSString *isSecurity;//社
@property (nonatomic, strong) NSString *isRealName;//实isRealName
@property (nonatomic, strong) NSString *isWeiliD;//微
@property(nonatomic,strong) NSString *isDiscount;//是否折扣  0：非折扣  1：折扣

@property (nonatomic, strong) NSString *blacklistReview;//是否审核

@property (nonatomic, strong) NSString *city;//所在城市
@property (nonatomic, strong) NSString * sesameCredit;// 芝麻信用( 0 ：无、1： 350~600、2 ：600~700、3 ：700以上)
@property (nonatomic, strong) NSString * sesameCreditF;
@property (nonatomic, strong) NSString * endSesameCredit;
@property(nonatomic,strong)NSString *onlineView;

@end

NS_ASSUME_NONNULL_END
