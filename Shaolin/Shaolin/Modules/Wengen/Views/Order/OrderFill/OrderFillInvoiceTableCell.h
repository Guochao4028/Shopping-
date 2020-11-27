//
//  OrderFillInvoiceTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderFillInvoiceTableCell : UITableViewCell

@property(nonatomic, assign)BOOL isPersonal;

@property(nonatomic, strong)UITableView *tabelView;

@property(nonatomic, copy, readonly)NSString *personalStr;
@property(nonatomic, copy, readonly)NSString *unitNameStr;
@property(nonatomic, copy, readonly)NSString *unitNumberStr;

@end

NS_ASSUME_NONNULL_END
