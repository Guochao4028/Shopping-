//
//  KungfuInstitutionCell.h
//  Shaolin
//
//  Created by edz on 2020/4/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class InstitutionModel;
@interface KungfuInstitutionCell : UITableViewCell
@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) UILabel *addressLabel;
@property(nonatomic,strong) UILabel *phoneLabel;
@property(nonatomic,strong) InstitutionModel *model;
@end

NS_ASSUME_NONNULL_END
