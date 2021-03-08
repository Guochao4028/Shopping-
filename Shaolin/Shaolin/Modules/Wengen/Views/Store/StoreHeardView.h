//
//  StoreHeardView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsStoreInfoModel;

@interface StoreHeardView : UIView

@property(nonatomic, strong)GoodsStoreInfoModel *storeInfoModel;

- (void)focusTarget:(nullable id)target action:(SEL)action;

@end



NS_ASSUME_NONNULL_END
