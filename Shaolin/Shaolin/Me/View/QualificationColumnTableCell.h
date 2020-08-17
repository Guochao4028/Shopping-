//
//  QualificationColumnTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/10.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ColumnTableCellConfirmationBlock)(void);

@interface QualificationColumnTableCell : UITableViewCell

@property(nonatomic, strong)NSDictionary *model;

@property(nonatomic, copy)ColumnTableCellConfirmationBlock confirmationBlock;



@end

NS_ASSUME_NONNULL_END
