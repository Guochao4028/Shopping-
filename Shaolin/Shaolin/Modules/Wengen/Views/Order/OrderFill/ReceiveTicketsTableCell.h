//
//  ReceiveTicketsTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AddressListModel;

@interface ReceiveTicketsTableCell : UITableViewCell

@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *phone;
@property(nonatomic, copy)NSString *address;

@property(nonatomic, strong)AddressListModel *model;

@end

NS_ASSUME_NONNULL_END
