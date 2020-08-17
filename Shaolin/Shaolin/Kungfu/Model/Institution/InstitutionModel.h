//
//  InstitutionModel.h
//  Shaolin
//
//  Created by 王精明 on 2020/5/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InstitutionModel : NSObject
@property (nonatomic, strong) NSString *contactDetails;
@property (nonatomic, strong) NSString *contactPerson;
@property (nonatomic, strong) NSString *mechanismCity;
@property (nonatomic, strong) NSString *mechanismCode;
@property (nonatomic, strong) NSString *mechanismImage;
@property (nonatomic, strong) NSString *mechanismName;
/*
 "contactDetails": "15608926603",
 "contactPerson": "555",
 "mechanismCity": "中国江苏无锡南长区",
 "mechanismCode": "2005190947012629",
 "mechanismImage": "https://static.oss.cdn.oss.gaoshier.cn/image/0191a789-7e42-4785-9d21-9557f9a8fadc.jpg",
 "mechanismName": "55"
 */
@end

NS_ASSUME_NONNULL_END
