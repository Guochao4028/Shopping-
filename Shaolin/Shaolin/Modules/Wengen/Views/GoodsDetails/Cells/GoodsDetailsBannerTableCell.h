//
//  GoodsDetailsBannerTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GoodsInfoModel;

@interface GoodsDetailsBannerTableCell : UITableViewCell
@property (nonatomic, strong) void (^PlayVideoOptBlock)(BOOL isOK);

@property (nonatomic, strong) void (^scrollOptBlock)(NSInteger index);

@property(nonatomic, strong)GoodsInfoModel *model;

@end

NS_ASSUME_NONNULL_END
