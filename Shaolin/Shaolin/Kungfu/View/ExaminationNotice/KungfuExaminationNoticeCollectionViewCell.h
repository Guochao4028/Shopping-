//
//  KungfuExaminationNoticeCollectionViewCell.h
//  Shaolin
//
//  Created by 王精明 on 2020/6/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ExaminationNoticeModel;
@interface KungfuExaminationNoticeCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) ExaminationNoticeModel *model;
@property (nonatomic, strong) UIView *lineView;

- (void)testUI;
@end

NS_ASSUME_NONNULL_END
