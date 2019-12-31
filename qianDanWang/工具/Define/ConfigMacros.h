//
//  ConfigMacros.h
//  TaoYouDan
//
//  Created by LY on 2018/10/22.
//  Copyright © 2018年 LY. All rights reserved.
//

#ifndef ConfigMacros_h
#define ConfigMacros_h

//正式key
//#define AMapKey @"71cd763a302a0a27a5a7ee502827107c"
#define AMapKey @"186feb8beab4f303f5c860c5da067c69"//测试\
bundleID :com.xiguaqiangdan.brand

//新建摩羯
#define MOXAPP_ID @"31b43167156b4bb3a82867e60d9f7774"

//#define UploadImgUrl @"http://192.168.0.155:8083/tyd/imageUploads" //上传图片的地址
#define UploadImgUrl [NSString stringWithFormat:@"http://%@/tyd/imageUploads",[DENGFANGSingletonTime shareInstance].lianJieArr[2]]
//#define UploadImgUrl @"192.168.0.186:8085/tyd/imageUploads" //测试上传图片的地址


#define HomeRows 10  //请求的行数

//筛选
#define  ShaiXuan_Customer_Status       @"CUSTOMER_STATUS" //客户状态
#define  ShaiXuan_Mortgage_Type         @"MORTGAGE_TYPE" //资产抵押类型
#define  ShaiXuan_IDentity_Type         @"IDENTITY_TYPE" //身份类型
#define  ShaiXuan_Loan_Limit            @"LOAN_LIMIT" //贷款金额
#define  ShaiXuan_Qualification         @"QUALIFICATION" //资质信息

#define  FenLei_QuanBu         @"ALL" //首页  分类全部

//淘单大全 - 筛选 状态保存
#define Big_CustomerStatus     @"BigCustomerStatus" //客户状态 - code
#define Big_MortgageType       @"BigMortgageType" //资产抵押类型 - code
#define Big_IDEntityType       @"BigIDEntityType" //身份类型 - code
#define Big_LoanLimit          @"BigLoanLimit" //贷款金额 -id值
#define Big_LoanStartLimit     @"BigLoanStartLimit" //贷款金额 -开始金额
#define Big_LoanEndLimit       @"BigLoanEndLimit" //贷款金额 -结束金额
#define Big_Qualification      @"BigQualification" //资质信息


//客户管理 - 筛选 状态保存
#define Manager_CustomerStatus     @"ManagerCustomerStatus" //客户状态 - code
#define Manager_MortgageType       @"ManagerMortgageType" //资产抵押类型 - code
#define Manager_IDEntityType       @"ManagerIDEntityType" //身份类型 - code
#define Manager_LoanLimit          @"ManagerLoanLimit" //贷款金额 -id值
#define Manager_LoanStartLimit     @"ManagerLoanStartLimit" //贷款金额 -开始金额
#define Manager_LoanEndLimit       @"ManagerLoanEndLimit" //贷款金额 -结束金额
#define Manager_Qualification      @"ManagerQualification" //资质信息

//存储 电话 拨打状态
#define Manager_PhoneStatus      @"ManagerPhoneStatus" 

//用户认证信息
#define DENGFANGRealNameKey                  @"DENGFANGRealNameKey" //真实姓名
#define DENGFANGIdCardKey                    @"DENGFANGIdCardKey" //身份证号
#define DENGFANGEnterpriseNameKey            @"DENGFANGEnterpriseNameKey" //单位名称
#define DENGFANGEnterpriseAddressKey         @"DENGFANGEnterpriseAddressKey" //单位地址
#define DENGFANGIdCardFaceUrlKey             @"DENGFANGIdCardFaceUrlKey" //身份证正面照地址
#define DENGFANGIdCardBackUrlKey             @"DENGFANGIdCardBackUrlKey" //身份证背面照地址
#define DENGFANGIdCardPhotoUrlKey            @"DENGFANGIdCardPhotoUrlKey" //身份证合照
#define DENGFANGRenTiPhotoUrlKey             @"DENGFANGRenTiPhotoUrlKey" //人体检测照片地址
#define DENGFANGWorkCardUrlKey               @"DENGFANGWorkCardUrlKey" //工牌照
#define DENGFANGBusinessCardUrlKey           @"DENGFANGBusinessCardUrlKey" //名片地址

#define DENGFANGLoginDataKey           @"DENGFANGLoginDataKey"
#define DENGFANGHeadImgUrlKey          @"DENGFANGHeadImgUrlKey" //头像地址
#define DENGFANGPhoneKey               @"DENGFANGPhoneKey"
#define DENGFANGShowPhoneKey           @"DENGFANGShowPhoneKey"
#define DENGFANGTokenKey               @"DENGFANGTokenKey"
#define DENGFANGUserIDKey              @"DENGFANGUserIDKey"
#define DENGFANGIs_First_Launch        @"DENGFANGIs_First_Launch"//用户第一次打开app的key
#define DENGFANGIsPayPwd               @"isPayPwd"//用户是否设置了支付密码


#define DENGFANGPayFinishName @"DENGFANGPayFinishName"
#define DENGFANGLogOutObserverName @"DENGFANGLogOutObserverName"
#define SelectedCityName @"SelectedCityName"
#define SelectedCityIDName @"SelectedCityIDName"

#define RefreshDetailKey @"RefreshDetailKey"
//选择城市key
#define SelectedCityKey @"SelectedCityKey"
#define SelectedCityAction @"SelectedCityAction"


#define ContentYS @"taoyoudanYS"
#define ContentColor @"tydcolor"
#define ContentWebUrl @"tydurl"



#ifdef DEBUG
// do sth
#define UMKey @"5d900a86570df38ae3000851"//测试
#define JPushAppKey @"10eb5887b1315fa60d67c108"//测试
#define APPName @"小象抢单"

#else
// do sth
#define UMKey @"5d900a86570df38ae3000851"//测试
#define JPushAppKey @"10eb5887b1315fa60d67c108"//测试
#define APPName @"小象抢单"

#endif


#define KAPPID @"1470560866"

#define HWNewfeatureImageCount 3


//#define ContentUrl @"http://api.chedaiqianbao.com/wankun/taoyoudanuserInfo3"

#define ContentUrl @"http://news.chedaiqianbao.cn/gzls/xiguaqiangdanwl"

#define ChaXunKeyJianTing @"ChaXunKeyJianTing"
#define ChePaiHaoKey @"ChePaiHaoKey"
#define WeiZhangShuKey @"WeiZhangShuKey"
#define KouFenShuKey @"KouFenShuKey"
#define haveSearchKey @"haveSearch"
#define HeiSeZiTi COLOR_With_Hex(0x222222)


#endif /* ConfigMacros_h */
