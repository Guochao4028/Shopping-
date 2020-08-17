//
//  KungfuHomeCompilationCell.h
//  Shaolin
//
//  Created by ws on 2020/5/11.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KungfuHomeCompilationCell : UITableViewCell

@property (nonatomic, strong) NSArray * classList;
@property (nonatomic, copy) void(^ selectHandle)(NSString * classId);
@property (nonatomic, copy) void(^ moreHandle)(NSString * filterType);
- (void) updateCellUI;

@end

NS_ASSUME_NONNULL_END
