//
//  BillingDetailsPopupView.h
//  Shaolin
//
//  Created by 郭超 on 2020/7/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//计算时间类型
typedef NS_ENUM(NSUInteger, PopupViewType){
    PopupViewChooseTimeType = 10,
    PopupViewChooseClassificationType = 20,
};

@interface BillingDetailsPopupView : UIView

@property(nonatomic, copy)NSString *titleStr;
@property(nonatomic, copy)NSString *selectStr;
@property(nonatomic, assign)PopupViewType popType;

@property(nonatomic, copy) void (^billingDetailsSelectStrBlick)(NSString *string);

- (void)disappear;
@end

NS_ASSUME_NONNULL_END
