//
//  GoodsAddressListTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/3.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AddressListModel;

@interface GoodsAddressListTableCell : UITableViewCell

@property(nonatomic, strong)AddressListModel *model;

@end

NS_ASSUME_NONNULL_END
