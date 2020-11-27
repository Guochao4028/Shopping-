//
//  AddressListView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AddressListModel;

@protocol AddressListViewDelegate;

@interface AddressListView : UIView

@property(nonatomic, strong)NSArray *dataArray;

@property(nonatomic, weak)id<AddressListViewDelegate> delegate;

@end

@protocol AddressListViewDelegate <NSObject>
-(void)addressListView:(AddressListView *)view tap:(BOOL)istap;
-(void)addressListView:(AddressListView *)view isModify:(AddressListModel *)model;
-(void)addressListView:(AddressListView *)view isTap:(AddressListModel *)model;

@end

NS_ASSUME_NONNULL_END
