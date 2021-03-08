//
//  StoreInformationModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/17.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreInformationModel : NSObject
@property (nonatomic, copy) NSString *bank;//银行名称
@property (nonatomic, copy) NSString *bankLicense;//银行开户许可
@property (nonatomic, copy) NSString *bankName;//开户名称
@property (nonatomic, copy) NSString *bankNo;//开户账号
@property (nonatomic, copy) NSString *bankUnionName;//开户行联行号
@property (nonatomic, copy) NSString *businessAddress;//营业执照详细地址
@property (nonatomic, copy) NSString *businessEndTime;//营业截止时间
@property (nonatomic, copy) NSString *businessLicenseImg;//营业执照图片
@property (nonatomic, copy) NSString *businessLicenseNumber;//营业执照号
@property (nonatomic, copy) NSString *businessLicenseType;//营业执照类型
@property (nonatomic, copy) NSString *businessLocation;//营业执照所在地
@property (nonatomic, copy) NSString *businessName;//公司名称
@property (nonatomic, copy) NSString *businessRange;//营业范围
@property (nonatomic, copy) NSString *businessStartTime;//营业开始时间
@property (nonatomic, copy) NSString *businessTimeLong;//营业执照是否长期
@property (nonatomic, copy) NSString *cardEndTime;//证件失效时间
@property (nonatomic, copy) NSString *cardImg;//证件照片
@property (nonatomic, copy) NSString *cardStartTime;//证件生效时间
@property (nonatomic, copy) NSString *cardTimeLong;//证件是否长期
@property (nonatomic, copy) NSString *cardType;//证件类型
@property (nonatomic, copy) NSString *checkMessage;
@property (nonatomic, copy) NSString *clubAddress;//商户地址
@property (nonatomic, copy) NSString *clubInfo;//店铺介绍
@property (nonatomic, copy) NSString *companyAddress;//公司地址
@property (nonatomic, copy) NSString *companyAddressInfo;//公司详细地址
@property (nonatomic, copy) NSString *companyPhone;//公司电话
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *email;//邮箱
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *idcard;//身份证号
@property (nonatomic, copy) NSString *legalPerson;//法人姓名
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *name;//店铺名称
@property (nonatomic, copy) NSString *intro;//店铺简称

@property (nonatomic, copy) NSString *organizationEndTime;//组织机构代码有效结束时间
@property (nonatomic, copy) NSString *organizationImg;//组织机构代码电子版
@property (nonatomic, copy) NSString *organizationLong;//组织机构代码是否长期
@property (nonatomic, copy) NSString *organizationNumber;//组织机构代码
@property (nonatomic, copy) NSString *organizationStartTime;//组织机构代码有效期开始时间
@property (nonatomic, copy) NSString *phone;//店铺联系电话
@property (nonatomic, copy) NSString *registeredCapital;//注册资本
@property (nonatomic, copy) NSString *startTime;//成立日期
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *step;//步骤
@property (nonatomic, copy) NSString *taxNumber;//纳税人识别号
@property (nonatomic, copy) NSString *taxQualificationsImg;//一般纳税资格
@property (nonatomic, copy) NSString *taxRegisterImg;//税务登记电子版
@property (nonatomic, copy) NSString *taxType;//1.一般 2 .小规模 3.非增值税
@property (nonatomic, copy) NSString *taxTypeNumber;//纳税类型税吗
@property (nonatomic, copy) NSString *trueName;//联系人姓名

@property (nonatomic, copy) NSString *urgentName;//紧急联系人
@property (nonatomic, copy) NSString *urgentPhone;//紧急联系电话
@property (nonatomic, copy) NSString *userId;


//@property (nonatomic, copy) NSString *walletInfo;
//@property (nonatomic, copy) NSString *collect;
//@property (nonatomic, copy) NSString *countCollet;
//@property (nonatomic, copy) NSString *countGoods;
//@property (nonatomic, copy) NSString *imgData;
//@property (nonatomic, copy) NSString *intro;//简介

@end
/*
 bank = "";
 "bank_license" = "https://static.oss.cdn.oss.gaoshier.cn/image/61824495-dffb-4ac4-a97d-2d9648ee040b.jpg";
 "bank_name" = "";
 "bank_no" = "";
 "bank_union_name" = "";
 "business_address" = "";
 "business_end_time" = 1594915200;
 "business_license_img" = "https://static.oss.cdn.oss.gaoshier.cn/image/a83e4461-5c6e-4c29-a52a-46bce8a8ec63.jpg";
 "business_license_number" = 12345678901234567890;
 "business_license_type" = 2;
 "business_location" = 1231231;
 "business_name" = Aaa;
 "business_range" = 124124;
 "business_start_time" = 1531756800;
 "business_time_long" = 0;
 "card_end_time" = 0;
 "card_img" = "";
 "card_start_time" = 0;
 "card_time_long" = 1;
 "card_type" = 1;
 "check_message" = "";
 "club_address" = "";
 "club_info" = "";
 collect = 0;
 "company_address" = 23rrqafsaa;
 "company_address_info" = Asfafa;
 "company_phone" = 13124111111;
 countCollet = 0;
 countGoods = 0;
 "create_time" = "";
 email = "";
 id = 37;
 idcard = "";
 "img_data" = "";
 intro = "";
 "legal_person" = "";
 logo = "";
 name = "";
 "organization_end_time" = "";
 "organization_img" = "";
 "organization_long" = 0;
 "organization_number" = "";
 "organization_start_time" = "";
 phone = 0;
 "registered_capital" = "10.00";
 star = 0;
 "start_time" = 1563292800;
 status = 0;
 step = 4;
 "tax_number" = "";
 "tax_qualifications_img" = "https://static.oss.cdn.oss.gaoshier.cn/image/7191f63b-c114-4666-86ca-0b23c8336a13.jpg";
 "tax_register_img" = "";
 "tax_type" = 4;
 "tax_type_number" = 3;
 "true_name" = "";
 "urgent_name" = "Asgard\U2019s";
 "urgent_phone" = 16612413512;
 "user_id" = 15;
 "wallet_info" = "";
 */
NS_ASSUME_NONNULL_END
