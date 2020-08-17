//
//  WengenBannerTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WengenBannerModel;

@protocol WengenBannerTableCellDelegate <NSObject>

-(void)pushToOtherViewControllerwithHomeItem:(WengenBannerModel *)item;

@end

@interface WengenBannerTableCell : UITableViewCell

@property (nonatomic,strong)NSArray <WengenBannerModel *> *dataSource;

@property (nonatomic,assign) id<WengenBannerTableCellDelegate>delegate;


@end

NS_ASSUME_NONNULL_END
