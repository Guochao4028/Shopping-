//
//  EnrollmentTableViewCell.h
//  Shaolin
//
//  Created by EDZ on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EnrollmentListModel;

@protocol EnrollmentTableViewCellDelegate;

@interface EnrollmentTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *activityImage;

@property (strong, nonatomic) IBOutlet UILabel *labelTitle;


@property (strong, nonatomic) IBOutlet UILabel *labelAddress;

@property (strong, nonatomic) IBOutlet UILabel *labelPin;

@property (strong, nonatomic) IBOutlet UILabel *labelHuoDong;

/// 立即报名
@property (strong, nonatomic) IBOutlet UIButton *btnState;

/// 更多
@property (strong, nonatomic) IBOutlet UIButton *btnMore;

@property(nonatomic, strong)EnrollmentListModel *listModel;

@property(nonatomic, weak)id<EnrollmentTableViewCellDelegate> delegate;


@end

@protocol EnrollmentTableViewCellDelegate <NSObject>

-(void)enrollmentTableViewCell:(EnrollmentTableViewCell *)cell tapMore:(EnrollmentListModel *)model;

-(void)enrollmentTableViewCell:(EnrollmentTableViewCell *)cell tapSignUp:(EnrollmentListModel *)model;

@end

NS_ASSUME_NONNULL_END
