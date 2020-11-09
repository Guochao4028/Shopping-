//
//  EnrollmentHeaderView.h
//  Shaolin
//
//  Created by EDZ on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^EnrollmentHeaderViewScreeningBack) (BOOL isTap);

@interface EnrollmentHeaderView : UIView

/// 状态
@property (strong, nonatomic) IBOutlet UIView *statusBarView;

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic, strong) NSObjectCallBack blockObject;

@property (nonatomic, strong) EnrollmentHeaderViewScreeningBack screenBlock;

@property(nonatomic, copy) NSString *curTitle;

- (void)selectTitle:(NSString *)title;
//筛选颜色开关
//yes 红色
//no 黑色
@property(nonatomic, assign)BOOL isViewRed;

@end

NS_ASSUME_NONNULL_END
