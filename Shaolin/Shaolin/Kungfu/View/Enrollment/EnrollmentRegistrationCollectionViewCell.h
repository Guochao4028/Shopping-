//
//  EnrollmentRegistrationCollectionViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EnrollmentAddressModel, AddressInfoModel, DegreeNationalDataModel;

@interface EnrollmentRegistrationCollectionViewCell : UICollectionViewCell


@property(nonatomic, copy)NSString *titleStr;

@property(nonatomic, strong)NSDictionary *dataModel;

@property(nonatomic, strong)EnrollmentAddressModel *addressModel;

@property(nonatomic, strong)AddressInfoModel *addressInfoModel;

@property(nonatomic, strong)DegreeNationalDataModel *dataInfoModel;



@end

NS_ASSUME_NONNULL_END
