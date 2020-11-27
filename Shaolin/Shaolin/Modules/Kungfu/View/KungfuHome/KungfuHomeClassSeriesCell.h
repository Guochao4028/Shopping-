//
//  KungfuHomeClassSeriesCell.h
//  Shaolin
//
//  Created by 王精明 on 2020/11/4.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ClassListModel;
@interface KungfuHomeClassSeriesCell : UICollectionViewCell
@property (nonatomic, strong) ClassListModel * cellModel;

- (void)setCellModel:(ClassListModel *)cellModel tagString:(NSString *)tagString;
@end

NS_ASSUME_NONNULL_END
