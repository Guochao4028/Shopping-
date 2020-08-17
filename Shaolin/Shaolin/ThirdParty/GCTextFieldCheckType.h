//
//  GCTextFieldCheckType.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#ifndef GCTextFieldCheckType_h
#define GCTextFieldCheckType_h

/// 输入内容校验，通过checkState属性取出校验结果
typedef NS_ENUM(NSInteger, CCCheckType){
    CCCheckNone = -1,       // 不做校验
    CCCheckTel  = 10,       // 座机(校验格式: "xxx-xxxxxxx"、"xxxx-xxxxxxxx"、"xxx-xxxxxxx"、"xxx-xxxxxxxx"、"xxxxxxx"、"xxxxxxxx")
    CCCheckDate,            // 日期(校验格式: "xxxx-xx-xx"、"xxxx-x-x")
    CCCheckEmail,           // 邮箱
    CCCheckPhone,           // 手机号
    CCCheckMoney,           // 金额(校验格式: "10000.0"、"10,000.0"、"10000"、"10,000")
    CCCheckFloat,           // 浮点数(校验格式: "10"、"10.0")
    CCCheckDomain,          // 域名
    CCCheckIDCard,          // 身份证(18位)
    CCCheckAccount,         // 帐号(字母开头，允许字母、数字、下划线，长度在6个以上)
    CCCheckeNumber,         // 数字
    CCCheckZipCode,         // 邮编
    CCCheckPassword,        // 密码(以字母开头，只能包含字母、数字和下划线，长度在6个以上)
    CCCheckStrongPassword,  // 强密码(必须包含大小写字母和数字的组合，不能使用特殊字符，长度在6个以上)
    
    CCCheckStrongTypeWinXin,
};

/// 内容校验结果
typedef NS_ENUM(NSInteger, CCCheckState){
    CCTextStateEmpty,       /// 输入内容为空
    CCTextStateNormal,      /// 输入合法
    CCTextStateNotInLimit,  /// 输入不在字数限制范围内
    CCTextStateNotRegular,  /// 正则校验不合法
};

#endif /* GCTextFieldCheckType_h */
