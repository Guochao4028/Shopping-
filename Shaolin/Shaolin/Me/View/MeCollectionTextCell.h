//
//  MeCollectionTextCell.h
//  Shaolin
//
//  Created by edz on 2020/4/28.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoundModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MeCollectionTextCell : UITableViewCell
@property(nonatomic,strong) FoundModel *model;
@property(nonatomic,strong) UILabelLeftTopAlign *titleL;
@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) UILabelLeftTopAlign *abstractsLabel;
@property(nonatomic,strong) UIButton *priseBtn;
@end

NS_ASSUME_NONNULL_END
