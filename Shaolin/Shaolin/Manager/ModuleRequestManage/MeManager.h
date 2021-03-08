//
//  MeManager.h
//  Shaolin
//
//  Created by edz on 2020/4/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLNetworking.h"
/**
 url文件，所有的url都在里面
 */
//#import "DefinedURLs.h"
NS_ASSUME_NONNULL_BEGIN

@interface MeManager : NSObject
+ (instancetype)sharedInstance;
// 获取个人信息
- (void)getUserDataSuccess:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;

// 获取用户交易明细
- (void)getUserConsumerDetails:(NSDictionary *)params success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString * _Nullable errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
//获取用户余额
//- (void)getUserBalanceSuccess:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
//查询用户是否设置支付密码
//- (void)queryPayPassWordStatusSuccess:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 修改个人资料
- (void)changeUserDataHeaderUrl:(NSString *)headerStr NickName:(NSString *)nickNameStr Sex:(NSString *)sexStr Birthday:(NSString *)birthdayStr Email:(NSString *)emailStr SigName:(NSString *)sigName Phone:(NSString *)phoneStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 修改手机号码
- (void)changeUserPhoneNumber:(NSString *)userPhoneNumber code:(NSString *)code success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 修改密码
- (void)postPassWordOld:(NSString *)passWordOld NewPassWord:(NSString *)newPassWord success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 找回密码
- (void)postBackPassWord:(NSString *)newPassWord Phone:(NSString *)phoneStr Code:(NSString *)codeStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 实名认证
- (void)postRealName:(NSString *)nameStr SexStr:(NSString *)sexStr IDCard:(NSString *)idCard Address:(NSString *)addressStr Positive:(NSString *)positiveStr Counter:(NSString *)counterStr Hands:(NSString *)handsStr Personal:(NSString *)personalStr Type:(NSString *)type birthTime:(NSString *)birthTime finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
//实名失败原因
- (void)getIdcardReasonBlock:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;

/**获取阿里实人认证token信息*/
- (void)getPersonAuthenticationToken:(NSDictionary *)params finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
/**获取阿里实人认证结果*/ 
- (void)getPersonAuthenticationResult:(NSDictionary *)params finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;

// 退出登录
//- (void)postOutLoginSuccess:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 获取我的活动
- (void)postMeActivityList:(NSDictionary *)params finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 我的教程
- (void)postMeClassList:(NSString *)url params:(NSDictionary *)params finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 我的 考试凭证
//- (void)postExamProof:(NSDictionary *)params finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 获取发文管理列表
- (void)getWebNewsinformationListState:(NSString *)state PageNum:(NSString *)page PageSize:(NSString *)pageSize success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 获取草稿箱列表
- (void)getDraftboxListState:(NSString *)state PageNum:(NSString *)page PageSize:(NSString *)pageSize success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 查看被拒原因
- (void)getLookRefusedTextID:(NSString *)textId success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 删除文章
- (void)postDeleteText:(NSMutableArray *)arr finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 获取用户店铺入驻详情
- (void)postUserStoreInformationSuccess:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 营业执照
- (void)postStoreLicenseType:(NSString *)licenseType CompanyName:(NSString *)companyNameStr LicenseNum:(NSString *)licenseNum LicenseCity:(NSString *)licenseCity LicenseDetailsAddress:(NSString *)licenseDetailsAddress CreatDate:(NSString *)creatStr StartDate:(NSString *)startStr EndDate:(NSString *)endStr LongTime:(NSString *)longTimeStr Capital:(NSString *)capitalStr ScopeBusiness:(NSString *)scopeBusiness CompanyAddress:(NSString *)companyAddress CompanyDetailsAddress:(NSString *)companyDetailsAddress CompanyPhone:(NSString *)companyPhone PersonName:(NSString *)personName PersonPhone:(NSString *)phonePerson LicensePhoto:(NSString *)licensePhoto BankLicense:(NSString *)bankLicense success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 法人信息
- (void)postStoreLegalPersonCardType:(NSString *)cardType CardImage:(NSString *)cardImg IdCardNum:(NSString *)idCardNum CardStartTime:(NSString *)startTime CardEndTime:(NSString *)endTime CardTimeLong:(NSString *)timeLong Name:(NSString *)nameStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 组织机构代码证
- (void)postInstitutionNum:(NSString *)numStr StartStr:(NSString *)startStr EndStr:(NSString *)endStr LongTimeStr:(NSString *)longStr PhotoStr:(NSString *)photoStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;

// 税务登记证
- (void)postTaxInformationTaxTypeStr:(NSString *)taxTypeStr taxNumber:(NSString *)taxNumber TaxTypeNumber:(NSString *)number TaxRegisterImg:(NSString *)taxImgStr TaxQualificationsImg:(NSString *)qualificationImg success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 姓名和邮箱
- (void)postFiveName:(NSString *)nameStr Email:(NSString *)emailStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;

// 结算信息
- (void)postBankName:(NSString *)bankNameStr BankNumber:(NSString *)bankNumber BankType:(NSString *)bankType BankTypeNumber:(NSString *)bankTypeNumber Wechat:(NSString *)wechatStr Alipay:(NSString *)alipay success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 店铺信息
- (void)postStoreName:(NSString *)storeName StroeIntro:(NSString *)storeIntro StoreClubAddress:(NSString *)address StoreLogo:(NSString *)storeLogo StoreClubInfo:(NSString *)storeClubInfo Phone:(NSString *)phoneStr Code:(NSString *)codeStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 阅读历史
- (void)getHistory:(NSDictionary *)params success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 我的收藏
- (void)getCollection:(NSDictionary *)params success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 我的收藏 - 教程
- (void)postMyCollectCourse:(NSDictionary *)params finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
// 我的收藏 - 法会
- (void)getMyCollectRite:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish;
// 删除阅读历史
- (void)postDeleteHistory:(NSMutableArray *)arr finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;

// 设置支付密码
- (void)postPayPasswordSetting:(NSString *)payPassword phoneCode:(NSString *)phoneCode finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;

// 修改支付密码
- (void)postPayPasswordModifyWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;

// 忘记支付密码-验证码校验
- (void)getPINCheckWithPinCode:(NSString *)pinCode success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;

// 忘记支付密码
- (void)postPayPasswordForgetWithPayPassword:(NSString *)payPassword phoneCode:(NSString *)phoneCode finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;

// 获取物流列表
- (void)postLogisticsListBlock:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;

// 苹果内购验证
//- (void)postIAPCheckWithReceipt:(NSString *)receipt payCode:(NSString *)payCode thirdOrderCode:(NSString *) thirdOrderCode callback:(void (^) (BOOL result))call;
- (void)postIAPCheckWithReceipt:(NSString *)receipt ordercode:(NSString *)ordercode callback:(void (^) (NSString * code, BOOL result))call;

// 苹果充值档位获取
//- (void)postIAPListAndBlock:(void(^)(NSArray * list))block;

// 实名认证回显
- (void)postShareAppDetailAndBlock:(void (^_Nullable)(id responseObject, NSString *errorReason))finis;

// 苹果充值档位获取
- (void)postIAPListAndBlock:(void(^)(NSArray * list))block;


// 检查版本更新
- (void)checkAppVersion:(void (^_Nullable)(id responseObject, NSString *errorReason))finish;
@end

NS_ASSUME_NONNULL_END
