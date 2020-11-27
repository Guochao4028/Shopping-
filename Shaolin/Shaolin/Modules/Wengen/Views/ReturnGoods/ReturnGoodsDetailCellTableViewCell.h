//
//  ReturnGoodsDetailCellTableViewCell.h
//  Shaolin
//
//  Created by ws on 2020/5/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class GoodsStoreInfoModel;

@interface ReturnGoodsDetailCellTableViewCell : UITableViewCell

@property(nonatomic, strong)GoodsStoreInfoModel *storeInfoModel;

@property (nonatomic, copy) void(^ unDoHandle)(void);
@property (nonatomic, copy) void(^ inputHandle)(void);

@end

NS_ASSUME_NONNULL_END
