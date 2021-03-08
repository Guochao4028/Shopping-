//
//  GoodsAddressListView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/3.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GoodsAddressListViewDelegate <NSObject>
- (void)tapAddress:(NSInteger)row;
@end

@interface GoodsAddressListView : UIView

@property(nonatomic, strong)NSArray *dataArray;

@property(nonatomic, weak)id<GoodsAddressListViewDelegate>delegate;

- (void)closeTarget:(nullable id)target action:(SEL)action;

- (void)createAddressTarget:(nullable id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
