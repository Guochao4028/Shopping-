//
//  AfterSalesTypeView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderDetailsModel;


@protocol AfterSalesTypeViewDelegate;

@interface AfterSalesTypeView : UIView

@property(nonatomic, strong)OrderDetailsModel *model;

@property(nonatomic, weak)id<AfterSalesTypeViewDelegate> delegate;


@end

@protocol AfterSalesTypeViewDelegate <NSObject>

-(void)afterSalesTypeView:(AfterSalesTypeView *)view jumpAfterSalesDetailsModel:(OrderDetailsModel *)model afterSalesType:(AfterSalesDetailsType)type;

@end

NS_ASSUME_NONNULL_END
