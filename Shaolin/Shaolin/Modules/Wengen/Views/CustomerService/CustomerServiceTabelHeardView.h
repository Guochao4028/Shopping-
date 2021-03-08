//
//  CustomerServiceTabelHeardView.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/23.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CustomerServiceTabelHeardView, CustomerServieListModel;

@protocol CustomerServiceTabelHeardViewDelegate <NSObject>

- (void)customerServiceTabelHeardView:(CustomerServiceTabelHeardView *)heardView tapCell:(CustomerServieListModel *)model;

@end

@interface CustomerServiceTabelHeardView : UIView

@property(nonatomic, strong)NSArray *dataArray;

@property(nonatomic, weak)id<CustomerServiceTabelHeardViewDelegate>delegate;

@end



NS_ASSUME_NONNULL_END
