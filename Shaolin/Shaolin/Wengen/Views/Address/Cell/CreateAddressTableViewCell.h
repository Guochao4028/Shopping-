//
//  CreateAddressTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AddressInfoModel;

@protocol CreateAddressTableViewCellDelegate;

@interface CreateAddressTableViewCell : UITableViewCell

@property(nonatomic, strong)NSDictionary *dataDic;

@property(nonatomic, strong)id<CreateAddressTableViewCellDelegate>delegate;

@property(nonatomic, strong)AddressInfoModel *model;

@property(nonatomic, copy)NSString *addressStr;

@end


@protocol CreateAddressTableViewCellDelegate <NSObject>

-(void)createAddressCell:(CreateAddressTableViewCell *)cell tap:(BOOL)istap;

@end

NS_ASSUME_NONNULL_END
