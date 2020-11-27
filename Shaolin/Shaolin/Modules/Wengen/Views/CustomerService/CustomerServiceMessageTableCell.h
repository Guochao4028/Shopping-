//
//  CustomerServiceMessageTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/24.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CustomerServieItemMessageModel, CustomerServiceMessageTableCell, CustomerServieListModel;

@protocol CustomerServiceMessageTableCellDelegate <NSObject>

-(void)customerServiceMessageTableCell:(CustomerServiceMessageTableCell *)cell tapCell:(CustomerServieListModel *)model;

-(void)customerServiceMessageTableCell:(CustomerServiceMessageTableCell *)cell tapContactArtificial:(BOOL)isTap;

@end

@interface CustomerServiceMessageTableCell : UITableViewCell

@property(nonatomic, strong)CustomerServieItemMessageModel *model;

@property(nonatomic, weak)id<CustomerServiceMessageTableCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
