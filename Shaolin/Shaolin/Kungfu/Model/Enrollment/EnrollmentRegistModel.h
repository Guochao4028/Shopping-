//
//  EnrollmentRegistModel.h
//  Shaolin
//
//  Created by ws on 2020/5/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnrollmentRegistModel : NSObject

@property(nonatomic, copy)NSString * realname;      // 姓名
@property(nonatomic, copy)NSString * beforeName;      // 曾用名
@property(nonatomic, copy)NSString * nationality;   // 国籍
@property(nonatomic, copy)NSString * photosUrl;         // 照片url
@property(nonatomic, copy)NSString * idCard;        // 身份证号
@property(nonatomic, copy)NSString * gender;        // 性别
@property(nonatomic, copy)NSString * bormtime;      // 出生年月
@property(nonatomic, copy)NSString * nation;        // 民族
@property(nonatomic, copy)NSString * education;     // 学历
@property(nonatomic, copy)NSString * title;         // 职称
@property(nonatomic, copy)NSString * post;          // 职务
@property(nonatomic, copy)NSString * levelId;       // 申请段品阶 段位ID
@property(nonatomic, copy)NSString * mechanismCode;     //举办机构
@property(nonatomic, copy)NSString * activityAddressCode; // 考试地点
@property(nonatomic, copy)NSString * examAddress;       // 考试地址
@property(nonatomic, copy)NSString * wechat;        // 微信
@property(nonatomic, copy)NSString * mailbox;       // 邮箱
@property(nonatomic, copy)NSString * telephone;     // 电话
@property(nonatomic, copy)NSString * mailingAddress;    // 通讯地址
@property(nonatomic, copy)NSString * passportNumber;    // 护照号
@property(nonatomic, copy)NSString * activityCode;  // 活动编号


@property(nonatomic, copy)NSString * height;    // 身高
@property(nonatomic, copy)NSString * shoeSize;    // 鞋码
@property(nonatomic, copy)NSString * martialArtsYears;  // 练武年限

@property(nonatomic, copy)NSString * weight;  //体重
//valueType 姓名 传1 曾名或法名 传 2
@property(nonatomic, copy)NSString * valueType;



@end

NS_ASSUME_NONNULL_END
