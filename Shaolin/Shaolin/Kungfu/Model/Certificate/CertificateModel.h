//
//  CertificateModel.h
//  Shaolin
//
//  Created by ws on 2020/5/22.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CertificateModel : NSObject

@property (nonatomic, copy) NSString * certificateId;
@property (nonatomic, copy) NSString * activityId;
@property (nonatomic, copy) NSString * certificateCode;
@property (nonatomic, copy) NSString * certificateUrl;
@property (nonatomic, copy) NSString * createtime;
@property (nonatomic, copy) NSString * levelId;
@property (nonatomic, copy) NSString * levelName;
@property (nonatomic, copy) NSString * memberId;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * useraccount;

@end

NS_ASSUME_NONNULL_END
