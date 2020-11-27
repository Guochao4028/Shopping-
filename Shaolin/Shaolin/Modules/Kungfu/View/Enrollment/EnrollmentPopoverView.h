//
//  EnrollmentPopoverView.h
//  Shaolin
//
//  Created by 郭超 on 2020/9/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^EnrollmentPopoverViewSubmitBlock)(NSString *selectType);

@interface EnrollmentPopoverView : UIView

///报名费是否可以点击
@property(nonatomic, assign)BOOL isApplySelect;

@property(nonatomic, strong)NSDictionary *pricePackage;

@property(nonatomic, copy)EnrollmentPopoverViewSubmitBlock submitBlock;

@end

NS_ASSUME_NONNULL_END
