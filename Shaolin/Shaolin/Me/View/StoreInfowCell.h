//
//  StoreInfowCell.h
//  Shaolin
//
//  Created by edz on 2020/4/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface StoreInfowCell : UITableViewCell
@property(nonatomic,strong) StoreInfoModel *model;
@property(nonatomic,strong) UILabel *titleLabe;
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UIImageView *imageV;
@end

NS_ASSUME_NONNULL_END
