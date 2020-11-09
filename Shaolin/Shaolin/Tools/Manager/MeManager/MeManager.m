
//
//  MeManager.m
//  Shaolin
//
//  Created by edz on 2020/4/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MeManager.h"

#import "MeActivityModel.h"
#import "WSIAPModel.h"
#import "DefinedHost.h"
#import "DefinedURLs.h"

@implementation MeManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static MeManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
/*
 *  获取用户信息
 */
- (void)getUserDataSuccess:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString * _Nullable errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish{
    [SLRequest getRequestWithApi:Me_UserData parameters:@{} success:success failure:failure finish:finish];
}



/*
 *  获取用户余额
 */
- (void)getUserBalanceSuccess:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString * _Nullable errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest postHttpRequestWithApi:Me_GetUserBalance parameters:@{} success:success failure:failure finish:finish];
}
/*
 *  获取用户交易明细
 */
- (void)getUserConsumerDetails:(NSDictionary *)params success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString * _Nullable errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest postHttpRequestWithApi:Me_ConsumerDetails parameters:params success:success failure:failure finish:finish];
    
}
/*
 *  查询支付密码设置的状态
 */
- (void)queryPayPassWordStatusSuccess:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish{
    [SLRequest postHttpRequestWithApi:Me_QueryPayPassword parameters:@{} success:success failure:failure finish:finish];
}

/*
 *  个人资料
 */
- (void)changeUserDataHeaderUrl:(NSString *)headerStr NickName:(NSString *)nickNameStr Sex:(NSString *)sexStr Birthday:(NSString *)birthdayStr Email:(NSString *)emailStr SigName:(NSString *)sigName Phone:(NSString *)phoneStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"nickname":nickNameStr,
        @"headurl":headerStr,
        @"gender":sexStr,
        @"birthtime":birthdayStr,
        @"email":emailStr,
        @"autograph":sigName
        
    };
    [SLRequest postHttpRequestWithApi:Me_UserChangeDate parameters:params success:success failure:failure finish:finish];
}

/*
 *  修改手机号码
 */
- (void)changeUserPhoneNumber:(NSString *)userPhoneNumber code:(NSString *)code success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"newPhoneNumber":userPhoneNumber,
        @"code":code,
    };

    [SLRequest postHttpRequestWithApi:Me_UserChangePhoneNumber parameters:params success:success failure:failure finish:finish];
}
/*
 *  修改密码
 */
- (void)postPassWordOld:(NSString *)passWordOld NewPassWord:(NSString *)newPassWord success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"password":passWordOld,
        @"newpassword":newPassWord,
        
    };
    [SLRequest postHttpRequestWithApi:Me_ChangePassword parameters:params success:success failure:failure finish:finish];
}
/*
 *  找回密码
 */
- (void)postBackPassWord:(NSString *)newPassWord Phone:(NSString *)phoneStr Code:(NSString *)codeStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"newpassword":newPassWord,
        @"phoneNumber":phoneStr,
        @"code":codeStr,
        @"codetype":@"4"
    };
    [SLRequest postHttpRequestWithApi:Me_BackPassword parameters:params success:success failure:failure finish:finish];
}
/*
 *  实名认证
 */
- (void)postRealName:(NSString *)nameStr SexStr:(NSString *)sexStr IDCard:(NSString *)idCard Address:(NSString *)addressStr Positive:(NSString *)positiveStr Counter:(NSString *)counterStr Hands:(NSString *)handsStr Personal:(NSString *)personalStr Type:(NSString *)type birthTime:(NSString *)birthTime finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"name":nameStr ? nameStr : @"",
        @"gender":sexStr ? sexStr : @"",
        @"idNum":idCard ? idCard : @"",
        @"account":addressStr ? addressStr : @"",
        @"positive":positiveStr ? positiveStr : @"",
        @"counter":counterStr ? counterStr : @"",
        @"hands":handsStr ? handsStr : @"",
        @"personal":personalStr ? personalStr : @"",
        @"type":type ? type : @"",
        @"birthTime":birthTime ? birthTime : @"",
    };
    [SLRequest postJsonRequestWithApi:Me_RealNameIdCard parameters:params success:nil failure:nil finish:finish];
    
}
/*
 获取实名认证 拒绝原因
 */
- (void)getIdcardReasonBlock:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest getRequestWithApi:Me_IdcardReason parameters:@{} success:nil failure:nil finish:finish];
}

//获取阿里实人认证token信息
- (void)getPersonAuthenticationToken:(NSDictionary *)params finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest getRequestWithApi:Me_PersonAuthenticationToken parameters:params success:nil failure:nil finish:finish];
}

//获取阿里实人认证结果
- (void)getPersonAuthenticationResult:(NSDictionary *)params finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest postHttpRequestWithApi:Me_PersonAuthenticationResult parameters:params success:nil failure:nil finish:finish];
}
/*
 *  退出登录
 */
- (void)postOutLoginSuccess:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest getRequestWithApi:Me_OutLogin parameters:@{} success:success failure:failure finish:finish];
}


/*
 *  获取 发文管理 列表
 */
-(void)getWebNewsinformationListState:(NSString *)state PageNum:(NSString *)page PageSize:(NSString *)pageSize success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish
{
    NSDictionary *params = @{
        @"state":state,
        @"pageNum":page,
        @"pageSize":pageSize,
        @"type":@"1"
    };
    NSLog(@"参数--%@",params);
    [SLRequest getRequestWithApi:Me_Get_DispatchList parameters:params success:success failure:failure finish:finish];
}
/**
 *  我的活动列表
 */
- (void)postMeActivityList:(NSDictionary *)params finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish{
    [SLRequest postHttpRequestWithApi:Me_Get_ActivityList parameters:params success:nil failure:nil finish:finish];
}

- (void)postMeClassList:(NSString *)url params:(NSDictionary *)params finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest postHttpRequestWithApi:url parameters:params success:nil failure:nil finish:finish];
}

/**
 *  段品制考试凭证
 */
- (void)postExamProof:(NSDictionary *)params finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish{
    [SLRequest postHttpRequestWithApi:Me_POST_ExamProof parameters:params success:nil failure:nil finish:finish];
}
/**
 *  草稿箱列表
 */
- (void)getDraftboxListState:(NSString *)state PageNum:(NSString *)page PageSize:(NSString *)pageSize success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    
    NSDictionary *params = @{
        @"state":state,
        @"pageNum":page,
        @"pageSize":pageSize,
        @"type":@"1"
    };
    NSLog(@"参数--%@",params);
    [SLRequest getRequestWithApi:Me_Get_DraftboxList parameters:params success:success failure:failure finish:finish];
}
/*
 *  删除 发文管理文章丶草稿箱文章
 */
- (void)postDeleteText:(NSMutableArray *)arr finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish
{
    [SLRequest postJsonRequestWithApi:Me_POST_DeleteText parameters:(id)arr success:nil failure:nil finish:finish];
}
/*
 *  删除 阅读历史丶
 */
- (void)postDeleteHistory:(NSMutableArray *)arr finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest postJsonRequestWithApi:Me_DeleteHistory parameters:arr success:nil failure:nil finish:finish];
}
/*
 *  查看被拒原因
 */
- (void)getLookRefusedTextID:(NSString *)textId success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{@"id":textId};
    [SLRequest getRequestWithApi:Me_LookTextRefused parameters:params success:success failure:failure finish:finish];
}
/*
 *  店铺入驻----获取填写信息详情
 */
- (void)postUserStoreInformationSuccess:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest postHttpRequestWithApi:Me_StoreInfo_OpenInformation parameters:@{} success:success failure:failure finish:finish];
}
/*
 *  店铺入驻----营业执照 第一步
 */
- (void)postStoreLicenseType:(NSString *)licenseType CompanyName:(NSString *)companyNameStr LicenseNum:(NSString *)licenseNum LicenseCity:(NSString *)licenseCity LicenseDetailsAddress:(NSString *)licenseDetailsAddress CreatDate:(NSString *)creatStr StartDate:(NSString *)startStr EndDate:(NSString *)endStr LongTime:(NSString *)longTimeStr Capital:(NSString *)capitalStr ScopeBusiness:(NSString *)scopeBusiness CompanyAddress:(NSString *)companyAddress CompanyDetailsAddress:(NSString *)companyDetailsAddress CompanyPhone:(NSString *)companyPhone PersonName:(NSString *)personName PersonPhone:(NSString *)phonePerson LicensePhoto:(NSString *)licensePhoto BankLicense:(NSString *)bankLicense success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish
{
    NSDictionary *params = @{
        @"step":@"1",
        @"business_license_type":licenseType,
        @"business_name":companyNameStr,
        @"business_license_number":licenseNum,
        @"business_location":licenseCity,
        @"business_address":licenseDetailsAddress,
        @"start_time":creatStr,
        @"business_start_time":startStr,
        @"business_end_time":endStr,
        @"business_time_long":longTimeStr,
        @"registered_capital":capitalStr,
        @"business_range":scopeBusiness,
        @"company_address":companyAddress,
        @"company_phone":companyPhone,
        @"urgent_name":personName,
        @"urgent_phone":phonePerson,
        @"business_license_img":licensePhoto,
        @"bank_license":bankLicense,
        @"company_address_info":companyDetailsAddress
    };
    NSLog(@"%@",params);
    [SLRequest postHttpRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
}
/*
 *  店铺入驻----法人信息 第二步
 */
- (void)postStoreLegalPersonCardType:(NSString *)cardType CardImage:(NSString *)cardImg IdCardNum:(NSString *)idCardNum CardStartTime:(NSString *)startTime CardEndTime:(NSString *)endTime CardTimeLong:(NSString *)timeLong Name:(NSString *)nameStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish
{
    NSDictionary *params = @{
        @"step":@"2",
        @"legal_person":nameStr,
        @"card_type":cardType,
        @"card_img":cardImg,
        @"idcard":idCardNum,
        @"card_start_time":startTime,
        @"card_end_time":endTime,
        @"card_time_long":timeLong
    };
    [SLRequest postHttpRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
}
/*
 *  店铺入驻----组织机构代码证 第三步
 */
- (void)postInstitutionNum:(NSString *)numStr StartStr:(NSString *)startStr EndStr:(NSString *)endStr LongTimeStr:(NSString *)longStr PhotoStr:(NSString *)photoStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"step":@"3",
        @"organization_number":numStr,
        @"organization_start_time":startStr,
        @"organization_end_time":endStr,
        @"organization_long":longStr,
        @"organization_img":photoStr
    };
    [SLRequest postHttpRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
}
/*
 *  店铺入驻----税务登记证 第四步
 */
- (void)postTaxInformationTaxTypeStr:(NSString *)taxTypeStr taxNumber:(NSString *)taxNumber TaxTypeNumber:(NSString *)number TaxRegisterImg:(NSString *)taxImgStr TaxQualificationsImg:(NSString *)qualificationImg success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"step":@"4",
        @"tax_type":taxTypeStr,
        @"tax_number":taxNumber,
        @"tax_type_number":number,
        @"tax_register_img":taxImgStr,
        @"tax_qualifications_img":qualificationImg
        
    };
    [SLRequest postHttpRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
}
/*
 *  店铺入驻----姓名和邮箱 第五步
 */
- (void)postFiveName:(NSString *)nameStr Email:(NSString *)emailStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"step":@"5",
        @"true_name":nameStr,
        @"email":emailStr
    };
    [SLRequest postHttpRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
}
/*
 *  店铺入驻----结算信息 第六步
 */
- (void)postBankName:(NSString *)bankNameStr BankNumber:(NSString *)bankNumber BankType:(NSString *)bankType BankTypeNumber:(NSString *)bankTypeNumber Wechat:(NSString *)wechatStr Alipay:(NSString *)alipay success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"step":@"6",
        @"bank_name":bankNameStr,
        @"bank_no":bankNumber,
        @"bank":bankType,
        @"bank_union_name":bankTypeNumber
    };
    [SLRequest postHttpRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
}
/*
 *  店铺入驻----店铺信息 第七步
 */
- (void)postStoreName:(NSString *)storeName StroeIntro:(NSString *)storeIntro StoreClubAddress:(NSString *)address StoreLogo:(NSString *)storeLogo StoreClubInfo:(NSString *)storeClubInfo Phone:(NSString *)phoneStr Code:(NSString *)codeStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"step":@"7",
        @"name":storeName,
        @"intro":storeIntro,
        @"club_address":address,
        @"logo":storeLogo,
        @"club_info":storeClubInfo,
        @"phone":phoneStr,
        @"code":codeStr
    };
    [SLRequest postHttpRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
}
/*
 *  阅读历史
 */
- (void)getHistory:(NSDictionary *)params success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest getRequestWithApi:Me_ReadHistory parameters:params success:success failure:failure finish:finish];
}
/*
 *  我的收藏
 */
- (void)getCollection:(NSDictionary *)params success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest getRequestWithApi:Me_Collection parameters:params success:success failure:failure finish:finish];
}

/**
 *  我的收藏 - 教程
 */
- (void)postMyCollectCourse:(NSDictionary *)params finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_COLLECT_MYCOLLECT parameters:params success:nil failure:nil finish:finish];
}

- (void)getMyCollectRite:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    [SLRequest getRequestWithApi:Me_Collection_Rite parameters:params success:success failure:failure finish:finish];
}
/*
 设置支付密码
 */
- (void)postPayPasswordSetting:(NSString *)payPassword phoneCode:(NSString *)phoneCode finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"payPassword":payPassword,
        @"phoneCode":phoneCode,
    };
    [SLRequest postJsonRequestWithApi:URL_POST_USER_PAYPASSWORDSETTING parameters:params success:nil failure:nil finish:finish];
}

/*
 修改支付密码
 */
- (void)postPayPasswordModifyWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"oldPayPassword":oldPassword,
        @"payPassword":newPassword,
    };
    [SLRequest postJsonRequestWithApi:URL_POST_USER_PAYPASSWORDMODIFY parameters:params success:nil failure:nil finish:finish];
}


/*
 忘记支付密码-验证码校验
 */
- (void)getPINCheckWithPinCode:(NSString *)pinCode success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish
{
    NSDictionary *params = @{
        @"phoneNumber":[SLAppInfoModel sharedInstance].phoneNumber,
        @"codeType":@"6",
        @"code":pinCode
    };
    [SLRequest getRequestWithApi:URL_GET_USER_PAY_CODECHECK parameters:params success:success failure:failure finish:finish];
}

/*
 忘记支付密码-设置支付密码
 */
- (void)postPayPasswordForgetWithPayPassword:(NSString *)payPassword phoneCode:(NSString *)phoneCode finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish
{
    NSDictionary *params = @{
        @"payPassword":payPassword,
        @"phoneCode":phoneCode,
    };
    [SLRequest postJsonRequestWithApi:URL_GET_USER_PAY_PASSWORDFORGET parameters:params success:nil failure:nil finish:finish];
}

-(void)postIAPCheckWithReceipt:(NSString *)receipt payCode:(NSString *)payCode thirdOrderCode:(NSString *) thirdOrderCode callback:(void (^) (BOOL result))call {
    NSDictionary *params = @{
           @"userId":[SLAppInfoModel sharedInstance].id,
           @"receipt":receipt,
           @"chooseEnv":@(IapCheckEnv),
           @"payCode":payCode,
           @"thirdOrderCode":thirdOrderCode
       };
    [SLRequest postHttpRequestWithApi:Me_ApplePayCheck parameters:params success:^(NSDictionary * _Nullable resultDic) {
        call([resultDic[@"data"] boolValue]);
    } failure:^(NSString * _Nullable errorReason) {
        call(NO);
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSLog(@"%@,%@", resultDic, errorReason);
    }];
}

/*
 获取物流列表
 */
- (void)postLogisticsListBlock:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {    
    [SLRequest postJsonRequestWithApi:Me_LogisticsList parameters:@{} success:nil failure:nil finish:finish];
}


-(void)postShareAppDetailAndBlock:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest getRequestWithApi:Me_ShareAppDetail parameters:@{} success:nil failure:nil finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        if (finish) finish(resultDic, nil);
    }];
}

-(void)postIAPListAndBlock:(void (^)(NSArray * _Nonnull))block {
    [SLRequest postHttpRequestWithApi:Me_ApplePayProductList parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
        NSArray *arr = [resultDic objectForKey:DATAS];
        NSArray *dataList = [WSIAPModel mj_objectArrayWithKeyValuesArray:arr];
        if (block) block(dataList);
    } failure:^(NSString * _Nullable errorReason) {
        block(@[]);
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
}


- (void)checkAppVersion:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"logicalVersion" : BUILD_STR,//VERSION_STR,BUILD_STR
        @"systemType" : @"1",//1:苹果 2:安卓
    };
    [SLRequest postHttpRequestWithApi:Me_CheckAppVersion parameters:params success:nil failure:nil finish:finish];
}
@end
