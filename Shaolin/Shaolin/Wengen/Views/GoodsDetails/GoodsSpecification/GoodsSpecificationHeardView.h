//
//  GoodsSpecificationHeardView.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsInfoModel,GoodsSpecificationModel;

@interface GoodsSpecificationHeardView : UIView

@property(nonatomic, strong)GoodsInfoModel *model;

@property(nonatomic, copy) NSString *picUrlStr;



@property(nonatomic, strong) GoodsSpecificationModel *specificationModel;

@property(nonatomic, copy) NSString *stockStr;


@property(nonatomic, copy)void(^goodsSpecificationHeardBclok)(void);


@end

NS_ASSUME_NONNULL_END
