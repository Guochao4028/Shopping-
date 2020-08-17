//
//  KfClassContainerCell.h
//  Shaolin
//
//  Created by ws on 2020/5/19.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassDetailModel;
@class ClassGoodsModel;
NS_ASSUME_NONNULL_BEGIN

@interface KfClassContainerCell : UITableViewCell

@property (nonatomic, assign) NSInteger currentClassIndex;
@property (nonatomic, strong) ClassDetailModel *model;
@property (nonatomic, copy) void(^ cellSelectBlock)(ClassGoodsModel * classGoodModel,NSInteger indexRow);

@end

NS_ASSUME_NONNULL_END
