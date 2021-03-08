//
//  AddressListTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/2.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AddressListModel,AddressListTableViewCell;

@protocol AddressListTableViewCellDelegate <NSObject>

- (void)addressListCell:(AddressListTableViewCell *)cell tap:(AddressListModel *)model;

@end

@interface AddressListTableViewCell : UITableViewCell

@property(nonatomic, strong)AddressListModel *model;

@property(nonatomic, strong)id<AddressListTableViewCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
