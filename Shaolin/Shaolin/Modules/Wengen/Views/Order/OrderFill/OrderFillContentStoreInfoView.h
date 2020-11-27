//
//  OrderFillContentStoreInfoView.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/9.
//  Copyright © 2020 syqaxldy. All rights reserved.
//  填写地址 店铺信息

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsStoreInfoModel;

@interface OrderFillContentStoreInfoView : UIView

@property(nonatomic, strong)GoodsStoreInfoModel *infoModel;

@end

NS_ASSUME_NONNULL_END
