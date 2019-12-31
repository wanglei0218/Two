//
//  SSH_ShouyeChanpingXiangQingModel.h
//  DENGFANGSC
//
//  Created by huang on 2018/10/31.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//DENGFANGShouyeChanpingXiangQingModel
@interface SSH_ShouyeChanpingXiangQingModel : NSObject
@property (nonatomic, strong) NSString *mobile;//手机号
@property (nonatomic, strong) NSString *qqNo;//QQ号
@property (nonatomic, strong) NSString *sex;//性别 0：男 1：女
@property (nonatomic, strong) NSString *age;//年龄
@property (nonatomic, strong) NSString *education;//学历（0：无学历  1：高中及以下  2：大专  3：本科 ：4：研究生 5：博士及以上）
@property(nonatomic,strong) NSString *multiPoint; //近一个月网贷借款次数
@property (nonatomic, strong) NSString *householdCity;//户籍所在地
@property (nonatomic, strong) NSString *mobileCity;//手机归属地
@property(nonatomic,strong) NSString *mobileRealName; //手机实名（0：未实名 1：实名六月以下  2：实名六月以上）
@property (nonatomic, strong) NSString *city;//所在城市
@property (nonatomic, strong) NSString *idCard;//身份证号
@property (nonatomic, strong) NSString *companyName;//单位名称
@property (nonatomic, strong) NSString *workYears;//工作年限

@property (nonatomic, strong) NSString *isFund;// 是否有公积金（0：无公积金 1：3个月以下 2：连续3个月  3：连续1年及以上）
@property (nonatomic, strong) NSString *isSecurity;// 是否有社保（0：无社保  1：3个月以下 2：连续3个月 3：连续1年及以上）
@property (nonatomic, strong) NSString *isWeiliD;// 是否有微粒（1：有  0：没有）
@property (nonatomic, strong) NSString *isInsurance;// 是否有个人保险
@property (nonatomic, strong) NSString * creditCardLimit;//  信用卡额度 ---- 
@property (nonatomic, strong) NSString * sesameCredit;// 芝麻信用( 0 ：无、1： 350~600、2 ：600~700、3 ：700以上)
@property (nonatomic, strong) NSString * sesameCreditF;//芝麻分
@property (nonatomic, strong) NSString * endSesameCredit; //芝麻信用结束值
@property (nonatomic, strong) NSString * isCollection;// 是否收藏  1：收藏
@property (nonatomic, strong) NSString * enterprise;// 企业名称（企业主）
@property (nonatomic, strong) NSString * isLicense;// 是否有营业执照（1：有  0：没有）
@property (nonatomic, strong) NSString * operationYears;// 经营年限
@property (nonatomic, strong) NSString * liabilities;// 负债记录(0：无 1：有)
@property (nonatomic, strong) NSString * creditHistory;// 信用记录 (1：无记录 2：良好 3：少数逾期 4：多次逾期)
@property (nonatomic, strong) NSString * cion;//  资源价值    金币数 ----



@property (nonatomic, strong) NSString *creditinfoId; //资源id
@property (nonatomic, strong) NSString *name; //姓名
@property (nonatomic, strong) NSString *isWorryMoney;//是否急用钱（1：是  0：否）
@property (nonatomic, strong) NSString *isInterest;//是否接受高息1：接受  0：不接受
@property (nonatomic, strong) NSString *loanStartLimit;//开始金额
@property (nonatomic, strong) NSString *loanStartLimitF;//开始金额
@property (nonatomic, strong) NSString *loanEndLimit;//结束金额
@property (nonatomic, strong) NSString *loanTerm;//期限
@property (nonatomic, strong) NSString *property;//房产
@property (nonatomic, strong) NSString *carProduction;//车产
@property (nonatomic, strong) NSString *createTime;//创建时间
@property (nonatomic, strong) NSString *identityType;//身份类型（0：上班族 1：公务员 2：企业主  3：自有职业者  4：学生）
@property (nonatomic, strong) NSString *income;//月收入
@property (nonatomic, strong) NSString *incomeF;//月收入开始值
@property (nonatomic, strong) NSString *endIncome;//月收入结束值
@property (nonatomic, strong) NSString *amount;// 年流水开始值
@property (nonatomic, strong) NSString *amountF;// 年流水开始值
@property (nonatomic, strong) NSString *endAmount;// 年流水结束值
@property (nonatomic, strong) NSString *loanPurpose;//目的
@property (nonatomic, strong) NSString *isCreditCard;//信用卡
@property (nonatomic, strong) NSString *status;//资源状态  2：待抢  3：已抢
@property (nonatomic, strong) NSString *isRecommend;//是否推荐 1 推荐 0 未推荐

@property (nonatomic, strong) NSString *orderStatus;//订单详情接口-订单状态（1：支付中 2：成功   0:失败）
@property (nonatomic, strong) NSString *orderNo;//订单详情接口-订单号

@property (nonatomic, strong) NSString *isMortgageCar;//车产是否接受抵押（1：接受  0：不接受）
@property (nonatomic, strong) NSString *isMortgageHouse;//房产是否接受抵押（1：接受  0：不接受）
@property (nonatomic, strong) NSString *mark;//金额备注说明 -----
@property (nonatomic, strong) NSString *businessLifeF;//自由职业者工资发放形式

@property (nonatomic, strong) NSString *businessLife;//工资发放方式（0：银行代发  1：现金发放  2：转账打卡 3：部分打卡部分现金）

@property (nonatomic, strong) NSString *weiliDLimit;//微粒开始额度
@property (nonatomic, strong) NSString *weiliDLimitF;//微粒开始额度
@property (nonatomic, strong) NSString *endWeiliDLimit;//微粒结束额度
@property (nonatomic, strong) NSString *propertyType;//房产类型
@property (nonatomic, strong) NSString *carProductionType;//车产类型
@property (nonatomic, strong) NSString *insuranceCompany;//投保公司名称
@property (nonatomic, strong) NSString *insuranceVal;//保单估值

@property(nonatomic,strong) NSString *additionCondition; //补充信息
@property(nonatomic,strong)NSString *onlineView;     //浏览人数
@property (nonatomic, strong) NSString *isRealName;//实isRealName
@property(nonatomic,strong)NSString *isDiscount; //0:非折扣资源  1：折扣资源

@property (nonatomic, strong) NSString *singleNote;//退单备注
@property (nonatomic, strong) NSString *singleState;//退单状态  (0:正常  1:申请中  2:申请中-申诉 3:已通过   4:未通过)  ---是否显示退单可根据此判断
@property (nonatomic, strong) NSString *isRefund;//1不符合退单    0符合退单

@end

NS_ASSUME_NONNULL_END
