//
//  GoodsSpecificationTypeView.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/27.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JYEqualCellSpaceFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN

@class GoodsAttrBasisModel, GoodsSpecificationTypeView;

@protocol GoodsSpecificationTypeViewDelegate <NSObject>

-(void)goodsSpecificationTypeView:(GoodsSpecificationTypeView *)view selectedModel:(GoodsAttrBasisModel *)model allDataArray:(NSArray *)dataArray;


@end

@interface GoodsSpecificationTypeView : UIView

@property(nonatomic, copy)NSString *titleStr;

@property(nonatomic, strong)NSArray *dataArray;

@property(nonatomic, assign, readonly)CGFloat height;

@property(nonatomic, assign)NSInteger seletIndex;

@property(nonatomic, weak)id<GoodsSpecificationTypeViewDelegate>delegate;

@property(nonatomic, copy)void(^typeViewSelectedBlcok)(GoodsSpecificationTypeView *view, NSInteger tag);

+(instancetype)goodsSpecificationTypeViewInit;

///刷新数据
-(void)reloadData;

@end

NS_ASSUME_NONNULL_END
