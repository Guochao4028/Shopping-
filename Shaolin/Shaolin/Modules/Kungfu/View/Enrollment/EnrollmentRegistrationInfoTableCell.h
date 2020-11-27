//
//  EnrollmentRegistrationInfoTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/5/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class EnrollmentRegistModel;

@interface EnrollmentRegistrationInfoTableCell : UITableViewCell

@property(nonatomic, strong) NSDictionary *model;
@property(nonatomic, strong) EnrollmentRegistModel * registModel;

@property(nonatomic, copy)NSString *mechanismName;

+(instancetype)xibRegistrationCell;

@end


NS_ASSUME_NONNULL_END
