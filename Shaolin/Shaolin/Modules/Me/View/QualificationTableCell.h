//
//  QualificationTableCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/6/10.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class InvoiceQualificationsModel;

@interface QualificationTableCell : UITableViewCell

@property(nonatomic, strong)NSDictionary *model;

@property(nonatomic, strong)InvoiceQualificationsModel *qualificationsModel;

//是否可以编辑
@property(nonatomic, assign)BOOL isCanEditor;

@end

NS_ASSUME_NONNULL_END
