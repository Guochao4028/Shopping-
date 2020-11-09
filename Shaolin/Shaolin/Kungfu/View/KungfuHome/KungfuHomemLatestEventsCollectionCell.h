//
//  KungfuHomemLatestEventsCollectionCell.h
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class EnrollmentListModel;
@interface KungfuHomemLatestEventsCollectionCell : UICollectionViewCell

@property (nonatomic, strong) EnrollmentListModel * cellModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgLeftCon;

@end

NS_ASSUME_NONNULL_END
