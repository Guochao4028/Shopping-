//
//  SLDateRangeView.h
//  Shaolin
//
//  Created by ws on 2020/7/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLDateRangeView : UIView

- (void)showWithPickerOrigin:(CGPoint)origin
                  startYear:(NSString *)startYear
                 startMonth:(NSString *)startMonth
                    endYear:(NSString *)endYear
                   endMonth:(NSString *)endMonth;
- (void)dismiss;

@property (nonatomic, copy) NSString * startYear;
@property (nonatomic, copy) NSString * startMonth;
@property (nonatomic, copy) NSString * endYear;
@property (nonatomic, copy) NSString * endMonth;

@property (nonatomic, strong) NSArray *startYears;
@property (nonatomic, strong) NSArray *endYears;

@property (nonatomic, copy) void (^ finishBlock)(NSString * startYear, NSString * startMonth, NSString * endYear, NSString * endMonth);

//@property (nonatomic, copy) void (^ changeBlock)(NSString * startYear, NSString * startMonth, NSString * endYear, NSString * endMonth);


@end

NS_ASSUME_NONNULL_END
