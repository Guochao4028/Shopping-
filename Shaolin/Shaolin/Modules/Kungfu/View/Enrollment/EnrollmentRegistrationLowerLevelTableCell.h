//
//  EnrollmentRegistrationLowerLevelTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/1.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EnrollmentRegistrationLowerLevelTableCell;
@protocol EnrollmentRegistrationLowerLevelTableCellDelegate <NSObject>

-(void)enrollmentRegistrationLowerLevelTableCell:(EnrollmentRegistrationLowerLevelTableCell *)cell didSelectItemAtIndexPath:(NSIndexPath *)indexPath currentData:(NSDictionary *)dic;

@end

@interface EnrollmentRegistrationLowerLevelTableCell : UITableViewCell

@property(nonatomic, strong)NSDictionary *model;

@property(nonatomic, weak)id<EnrollmentRegistrationLowerLevelTableCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
