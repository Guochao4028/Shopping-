//
//  KungfuExaminationInstitutionCell.h
//  Shaolin
//
//  Created by edz on 2020/4/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class InstitutionModel;
@interface KungfuExaminationInstitutionCell : UICollectionViewCell
@property(nonatomic,strong) UIImageView *imageIcon;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UILabel *addressLabel;
@property(nonatomic,strong) InstitutionModel *model;
@end

NS_ASSUME_NONNULL_END
