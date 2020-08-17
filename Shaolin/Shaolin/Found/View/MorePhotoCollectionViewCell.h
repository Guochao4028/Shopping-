//
//  MorePhotoCollectionViewCell.h
//  Shaolin
//
//  Created by edz on 2020/3/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MorePhotoCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) UILabel *numLabel;
@property(nonatomic,strong) UILabel *addLabel;
- (void)configCellUrl:(NSArray *)urlArray indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
