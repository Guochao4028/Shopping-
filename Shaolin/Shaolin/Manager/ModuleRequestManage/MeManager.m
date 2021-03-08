
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
#import "NSString+Tool.h"

#import "NSString+LGFHash.h"

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
//- (void)getUserBalanceSuccess:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString * _Nullable errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
//    [SLRequest postHttpRequestWithApi:Me_GetUserBalance parameters:@{} success:success failure:failure finish:finish];
//}
/*
 *  获取用户交易明细
 */
- (void)getUserConsumerDetails:(NSDictionary *)params success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString * _Nullable errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
//    [SLRequest postHttpRequestWithApi:Me_ConsumerDetails parameters:params success:success failure:failure finish:finish];
    
    [ SLRequest getRequestWithApi:Me_ConsumerDetails parameters:params success:success failure:failure finish:finish];
    
}
/*
 *  查询支付密码设置的状态
 */
//- (void)queryPayPassWordStatusSuccess:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish{
//    [SLRequest postHttpRequestWithApi:Me_QueryPayPassword parameters:@{} success:success failure:failure finish:finish];
//}

/*
 *  个人资料
 */
- (void)changeUserDataHeaderUrl:(NSString *)headerStr NickName:(NSString *)nickNameStr Sex:(NSString *)sexStr Birthday:(NSString *)birthdayStr Email:(NSString *)emailStr SigName:(NSString *)sigName Phone:(NSString *)phoneStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"nickName":nickNameStr,
        @"headUrl":headerStr,
        @"gender":sexStr,
        @"birthTime":birthdayStr,
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
//    NSDictionary *params = @{
//        @"password":passWordOld,
//        @"newpassword":newPassWord,
//
//    };
    
//    NSDictionary *params = [NSString dataEncryption:@{
//        @"password":passWordOld,
//        @"newPassword":newPassWord,
//    }];
    
//    NSDictionary *params = @{
//        @"password":passWordOld,
//        @"newPassword":newPassWord,
//    };
    
    ///旧密码和密钥 生成新的短语
    NSString *passWordOldStr = [NSString stringWithFormat:@"%@%@", passWordOld, ENCRYPTION_MD5_KEY];
    ///新密码和密钥 生成新的短语
    NSString *newPassWordStr = [NSString stringWithFormat:@"%@%@", newPassWord, ENCRYPTION_MD5_KEY];
    
    
    NSDictionary *params;
    
//    if (IsEncryption) {
//        params = @{
//            @"password":[passWordOldStr lgf_Md5String],
//            @"newPassword":[newPassWordStr lgf_Md5String],
//            @"clearPassword":passWordOld
//        };
//    }else{
//        params = [NSString dataEncryption:@{
//            @"password":[passWordOldStr lgf_Md5String],
//            @"newPassword":[newPassWordStr lgf_Md5String],
//            @"clearPassword":passWordOld
//        }];
//    }
    
    params = [NSString encryptRSA:@{
        @"password":[passWordOldStr lgf_Md5String],
        @"newPassword":[newPassWordStr lgf_Md5String],
    }];
    
    
    [SLRequest postHttpRequestWithApi:Me_ChangePassword parameters:params success:success failure:failure finish:finish];
}
/*
 *  找回密码
 */
- (void)postBackPassWord:(NSString *)newPassWord Phone:(NSString *)phoneStr Code:(NSString *)codeStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
//    NSDictionary *params = @{
//        @"newPassword":newPassWord,
//        @"phoneNumber":phoneStr,
//        @"code":codeStr,
//        @"codeType":@"4"
//    };
    
    ///密码和密钥 生成新的短语
    NSString *newPassWordStr = [NSString stringWithFormat:@"%@%@", newPassWord, ENCRYPTION_MD5_KEY];
    
    NSString *md5 = [newPassWordStr lgf_Md5String];
    
    NSDictionary *params = @{
        @"newPassword":md5,
        @"phoneNumber":phoneStr,
        @"code":codeStr,
        @"codeType":@"4"
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
//- (void)postOutLoginSuccess:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
//    [SLRequest getRequestWithApi:Me_OutLogin parameters:@{} success:success failure:failure finish:finish];
//}


/*
 *  获取 发文管理 列表
 */
- (void)getWebNewsinformationListState:(NSString *)state PageNum:(NSString *)page PageSize:(NSString *)pageSize success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish
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
//    [SLRequest postHttpRequestWithApi:Me_Get_ActivityList parameters:params success:nil failure:nil finish:finish];
    
    [SLRequest getRequestWithApi:Me_Get_ActivityList parameters:params success:nil failure:nil finish:finish];
}


- (void)postMeClassList:(NSString *)url params:(NSDictionary *)params finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    if ([url isEqualToString:Me_POST_CourseReadHistory]) {
        [SLRequest getRequestWithApi:Me_POST_CourseReadHistory parameters:params success:nil failure:nil finish:finish];
    } else {
        [SLRequest getRequestWithApi:Me_POST_CourseBuyHistory parameters:params success:nil failure:nil finish:finish];
    }
}

/**
 *  段品制考试凭证
 */
//- (void)postExamProof:(NSDictionary *)params finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish{
//    [SLRequest postHttpRequestWithApi:Me_POST_ExamProof parameters:params success:nil failure:nil finish:finish];
//}
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
//    [SLRequest postHttpRequestWithApi:Me_StoreInfo_OpenInformation parameters:@{} success:success failure:failure finish:finish];
    
    [SLRequest postJsonRequestWithApi:Me_StoreInfo_OpenInformation parameters:@{}  success:success failure:failure finish:finish];
}
/*
 *  店铺入驻----营业执照 第一步
 */
- (void)postStoreLicenseType:(NSString *)licenseType CompanyName:(NSString *)companyNameStr LicenseNum:(NSString *)licenseNum LicenseCity:(NSString *)licenseCity LicenseDetailsAddress:(NSString *)licenseDetailsAddress CreatDate:(NSString *)creatStr StartDate:(NSString *)startStr EndDate:(NSString *)endStr LongTime:(NSString *)longTimeStr Capital:(NSString *)capitalStr ScopeBusiness:(NSString *)scopeBusiness CompanyAddress:(NSString *)companyAddress CompanyDetailsAddress:(NSString *)companyDetailsAddress CompanyPhone:(NSString *)companyPhone PersonName:(NSString *)personName PersonPhone:(NSString *)phonePerson LicensePhoto:(NSString *)licensePhoto BankLicense:(NSString *)bankLicense success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish
{
    
    NSDictionary *params = @{
        @"step":@"1",
        @"businessLicenseImg":licensePhoto,//营业执照图片
        @"businessLicenseType":licenseType,//营业执照类型
        @"businessName":companyNameStr,//公司名称
        @"businessLicenseNumber":licenseNum,//营业执照号
        @"businessAddress":licenseDetailsAddress,//营业执照详细地址
        @"businessLocation":licenseCity,//营业执照所在地
        @"businessRange":scopeBusiness,//营业范围
        @"companyAddress":companyAddress,//公司地址
        @"companyPhone":companyPhone,//公司电话
        @"urgentName":personName,//紧急联系人
        @"urgentPhone":phonePerson,//紧急联系电话
        @"bankLicense":bankLicense,//银行开户许可
        @"startTime":creatStr,//成立日期
        @"businessStartTime":startStr,//营业开始时间
        @"businessTimeLong":longTimeStr,//营业执照是否长期
        @"registeredCapital":capitalStr,//注册资本
        @"companyAddressInfo":companyDetailsAddress//公司详细地址
    };
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:params];
    
    if (NotNilAndNull(endStr) && endStr.length) {
        [dic setObject:endStr forKey:@"businessEndTime"];
    }
    
    NSLog(@"%@",dic);
    [SLRequest postJsonRequestWithApi:Me_StoreInfo_LegalPerson parameters:dic success:success failure:failure finish:finish];
}
/*
 *  店铺入驻----法人信息 第二步
 */
- (void)postStoreLegalPersonCardType:(NSString *)cardType CardImage:(NSString *)cardImg IdCardNum:(NSString *)idCardNum CardStartTime:(NSString *)startTime CardEndTime:(NSString *)endTime CardTimeLong:(NSString *)timeLong Name:(NSString *)nameStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish
{
    
    
//    NSDictionary *params = @{
//        @"step":@"2",
//        @"cardType":cardType, //证件类型
//        @"cardImg":cardImg, //证件照片
//        @"idcard":idCardNum, //身份证号
//        @"cardStartTime":startTime,//证件生效时间
//        @"cardEndTime":endTime,//证件失效时间
//        @"cardTimeLong":timeLong,//证件是否长期
//
//        @"legalPerson":nameStr,//法人姓名
//    };
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"2" forKey:@"step"];
    //证件类型
    [params setValue:cardType forKey:@"cardType"];
    //证件照片
    [params setValue:cardImg forKey:@"cardImg"];
    //身份证号
    [params setValue:idCardNum forKey:@"idcard"];
    //证件生效时间
    [params setValue:startTime forKey:@"cardStartTime"];
    if (NotNilAndNull(endTime) && endTime.length) {
        //证件失效时间
        [params setValue:endTime forKey:@"cardEndTime"];
    }
    //证件是否长期
    [params setValue:timeLong forKey:@"cardTimeLong"];
    //法人姓名
    [params setValue:nameStr forKey:@"legalPerson"];


//    [SLRequest postHttpRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
    
    [SLRequest postJsonRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
}
/*
 *  店铺入驻----组织机构代码证 第三步
 */
- (void)postInstitutionNum:(NSString *)numStr StartStr:(NSString *)startStr EndStr:(NSString *)endStr LongTimeStr:(NSString *)longStr PhotoStr:(NSString *)photoStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
//    NSDictionary *params = @{
//        @"step":@"3",
//        @"organizationNumber":numStr, //组织机构代码
//        @"organizationStartTime":startStr,//组织机构代码有效期开始时间
//        @"organizationEndTime":endStr,//组织机构代码有效结束时间
//        @"organizationLong":longStr,//组织机构代码是否长期
//        @"organizationImg":photoStr//组织机构代码电子版
//    };
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"3" forKey:@"step"];
    //组织机构代码
    [params setValue:numStr forKey:@"organizationNumber"];
    //组织机构代码有效期开始时间
    [params setValue:startStr forKey:@"organizationStartTime"];
    if (NotNilAndNull(endStr) && endStr.length) {
        //组织机构代码有效结束时间
        [params setValue:endStr forKey:@"organizationEndTime"];
    }
    
    //组织机构代码是否长期
    [params setValue:longStr forKey:@"organizationLong"];
 
    //组织机构代码电子版
    [params setValue:photoStr forKey:@"organizationImg"];
    
    [SLRequest postJsonRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
    
    
//    [SLRequest postHttpRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
}
/*
 *  店铺入驻----税务登记证 第四步
 */
- (void)postTaxInformationTaxTypeStr:(NSString *)taxTypeStr taxNumber:(NSString *)taxNumber TaxTypeNumber:(NSString *)number TaxRegisterImg:(NSString *)taxImgStr TaxQualificationsImg:(NSString *)qualificationImg success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"step":@"4",
        @"taxType":taxTypeStr,//1.一般 2 .小规模 3.非增值税
        @"taxNumber":taxNumber,//纳税人识别号
        @"taxTypeNumber":number,//纳税类型税吗
        @"taxRegisterImg":taxImgStr,//税务登记电子版
        @"taxQualificationsImg":qualificationImg//一般纳税资格
        
    };
//    [SLRequest postHttpRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
    
    [SLRequest postJsonRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
}
/*
 *  店铺入驻----姓名和邮箱 第五步
 */
- (void)postFiveName:(NSString *)nameStr Email:(NSString *)emailStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"step":@"5",
        @"trueName":nameStr,//联系人姓名
        @"email":emailStr//邮箱
    };
//    [SLRequest postHttpRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
    [SLRequest postJsonRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
}
/*
 *  店铺入驻----结算信息 第六步
 */
- (void)postBankName:(NSString *)bankNameStr BankNumber:(NSString *)bankNumber BankType:(NSString *)bankType BankTypeNumber:(NSString *)bankTypeNumber Wechat:(NSString *)wechatStr Alipay:(NSString *)alipay success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"step":@"6",
        @"bankName":bankNameStr,//开户名称
        @"bankNo":bankNumber,//开户账号
        @"bank":bankType,//银行名称
        @"bankUnionName":bankTypeNumber//开户行联行号
    };
//    [SLRequest postHttpRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
    [SLRequest postJsonRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
}
/*
 *  店铺入驻----店铺信息 第七步
 */
- (void)postStoreName:(NSString *)storeName StroeIntro:(NSString *)storeIntro StoreClubAddress:(NSString *)address StoreLogo:(NSString *)storeLogo StoreClubInfo:(NSString *)storeClubInfo Phone:(NSString *)phoneStr Code:(NSString *)codeStr success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"step":@"7",
        @"name":storeName,//店铺名称
        @"intro":storeIntro,//简介
        @"clubAddress":address,//商户地址
        @"logo":storeLogo,
        @"clubInfo":storeClubInfo,//店铺介绍
        @"phone":phoneStr,//店铺联系电话
        @"code":codeStr//短信验证码
    };
//    [SLRequest postHttpRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
//
    [SLRequest postJsonRequestWithApi:Me_StoreInfo_LegalPerson parameters:params success:success failure:failure finish:finish];
}
/*
 *  阅读历史
 */
- (void)getHistory:(NSDictionary *)params success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest getRequestWithApi:Me_Readhistory parameters:params success:success failure:failure finish:finish];
}
/*
 *  我的收藏
 */
- (void)getCollection:(NSDictionary *)params success:(void (^_Nullable)(id responseObject))success failure:(void (^_Nullable)(NSString *errorReason))failure finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
//    [SLRequest getRequestWithApi:Me_Collection parameters:params success:success failure:failure finish:finish];
    NSString *kind = params[@"kind"];
    
    if (kind == nil) {
        [SLRequest getRequestWithApi:Me_Collection parameters:params success:success failure:failure finish:finish];
    }else{
        [SLRequest getRequestWithApi:Me_Collection_List parameters:params success:success failure:failure finish:finish];
    }
    
   
}

/**
 *  我的收藏 - 教程
 */
- (void)postMyCollectCourse:(NSDictionary *)params finish:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
//    [SLRequest postJsonRequestWithApi:URL_POST_SHOPAPI_COMMON_COLLECT_MYCOLLECT parameters:params success:nil failure:nil finish:finish];
    [SLRequest getRequestWithApi:URL_POST_SHOPAPI_COMMON_COLLECT_MYCOLLECT parameters:params success:nil failure:nil finish:finish];
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

//- (void)postIAPCheckWithReceipt:(NSString *)receipt payCode:(NSString *)payCode thirdOrderCode:(NSString *) thirdOrderCode callback:(void (^) (BOOL result))call {
//    NSDictionary *params = @{
//           @"userId":[SLAppInfoModel sharedInstance].id,
//           @"receipt":receipt,
//           @"chooseEnv":@(IapCheckEnv),
//           @"payCode":payCode,
//           @"thirdOrderCode":thirdOrderCode
//       };
//    [SLRequest postHttpRequestWithApi:Me_ApplePayCheck parameters:params success:^(NSDictionary * _Nullable resultDic) {
//        call([resultDic[@"data"] boolValue]);
//    } failure:^(NSString * _Nullable errorReason) {
//        call(NO);
//    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
//        NSLog(@"%@,%@", resultDic, errorReason);
//    }];
//}
- (void)postIAPCheckWithReceipt:(NSString *)receipt ordercode:(NSString *)ordercode callback:(void (^) (NSString * code, BOOL result))call {
    NSDictionary *params = @{
           @"receipt":receipt,
           @"chooseEnv":@(IapCheckEnv),
           @"orderCarId":ordercode
       };
    
    [SLRequest postJsonRequestWithApi:Me_ApplePayCheck parameters:params success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSLog(@"%@,%@", resultDic, errorReason);
        if (IsNilOrNull(resultDic)) {
            call(nil,NO);
            return;
        }
        NSDictionary * dataDic = resultDic[@"data"];
        if (IsNilOrNull(dataDic)) {
            call(nil,NO);
            return;
        }
                                  
        NSString * codeStr = resultDic[@"code"];
        BOOL result = [dataDic[@"data"] boolValue];
        
        call(codeStr,result);
    }];
}

/*
 获取物流列表
 */
- (void)postLogisticsListBlock:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {    
    [SLRequest getRequestWithApi:Me_LogisticsList parameters:@{} success:nil failure:nil finish:finish];
}


- (void)postShareAppDetailAndBlock:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    [SLRequest getRequestWithApi:Me_ShareAppDetail parameters:@{} success:nil failure:nil finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        if (finish) finish(resultDic, nil);
    }];
}

//- (void)postIAPListAndBlock:(void (^)(NSArray * _Nonnull))block {
//    [SLRequest postHttpRequestWithApi:Me_ApplePayProductList parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
//        NSArray *arr = [resultDic objectForKey:DATAS];
//        NSArray *dataList = [WSIAPModel mj_objectArrayWithKeyValuesArray:arr];
//        if (block) block(dataList);
//    } failure:^(NSString * _Nullable errorReason) {
//        block(@[]);
//    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
//
//    }];
//}


- (void)checkAppVersion:(void (^_Nullable)(id responseObject, NSString *errorReason))finish {
    NSDictionary *params = @{
        @"logicalVersion" : BUILD_STR,//VERSION_STR,BUILD_STR
        @"systemType" : @"1",//1:苹果 2:安卓
    };
    [SLRequest postHttpRequestWithApi:Me_CheckAppVersion parameters:params success:nil failure:nil finish:finish];
}
@end
