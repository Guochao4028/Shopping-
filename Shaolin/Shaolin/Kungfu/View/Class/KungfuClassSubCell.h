//
//  KungfuClassSubCell.h
//  Shaolin
//
//  Created by ws on 2020/5/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ClassGoodsModel,ClassDetailModel;
@interface KungfuClassSubCell : UITableViewCell

@property (nonatomic, strong) ClassDetailModel *detailModel;
@property (nonatomic, strong) ClassGoodsModel *model;
@property (nonatomic, assign) BOOL isPlaying;

@end

NS_ASSUME_NONNULL_END
