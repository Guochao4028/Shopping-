//
//  KungfuHomeModuleCollectionCell.h
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KungfuHomeModuleCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageIcon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIView *bgView;


@property (nonatomic, copy) NSString * messageNum;

@end

NS_ASSUME_NONNULL_END
