//
//  ChooseVideoCollectionCell.h
//  Shaolin
//
//  Created by edz on 2020/3/16.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseVideoModel.h"
#import "SLAssetModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChooseVideoCollectionCell : UICollectionViewCell

@property(nonatomic,strong) UIImageView *localIcon;
@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UIView *selectView;

@property (nonatomic, copy) NSString *representedAssetIdentifier;

@property (nonatomic, strong) SLAssetModel * assetModel;

@end

NS_ASSUME_NONNULL_END
